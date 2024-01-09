#include <iostream>
#include <fstream>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <boost/filesystem.hpp>
#include <unordered_set>
#include <mutex>

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/json.hpp>
#include <bsoncxx/oid.hpp>

#include <mongocxx/client.hpp>
#include <mongocxx/stdx.hpp>
#include <mongocxx/uri.hpp>
#include <mongocxx/instance.hpp>

using bsoncxx::builder::stream::close_array;
using bsoncxx::builder::stream::close_document;
using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;
using bsoncxx::builder::stream::open_array;
using bsoncxx::builder::stream::open_document;
using bsoncxx::builder::basic::kvp;
using bsoncxx::builder::basic::make_document;
using mongocxx::cursor;


#include "crow_all.h"
using namespace std;
using namespace crow;
using namespace crow::mustache;


void getView(response &res,const string &filename, context &x) {
    res.set_header("Content-Type", "text/html");
    auto page=load_unsafe("../public/" + filename + ".html").render(x);
    res.write(page.body_);
    res.end();
}

//crow::mustache::rendered_template getView(const string &filename, context &x) {
//    auto page=load_unsafe("../public/" + filename + ".html");
//    return page.render(x);
//}

//
//string getView(const string &filename, context &x) {
//    boost::filesystem::path current_path = boost::filesystem::current_path();
//    string filename1 = filename + ".html";
//    cout<< "curretn path ----->" << current_path << endl;
//    cout<< "into getview----- " <<  filename1 << endl;
//    // Load the Mustache template
//    return  load_unsafe(filename1).render_string(x);
////    cout<< "into getview----- " <<  filename << endl;
////    template_t tmpt = load_unsafe("../public/" + filename + ".html");
////    cout<< tmpt.render_string(x) << endl;
////    return load_unsafe("../public/" + filename + ".html").render_string(x);
//}

void sendFile(response &res, string filename, string contentType){
    ifstream in("../public/"+ filename, ifstream::in);
    if(in){
        ostringstream contents;
        contents << in.rdbuf();
        in.close();
        res.set_header("Content-Type", contentType);
        res.write(contents.str());
    } else {
        res.code = 404;
        res.write("Not find page");
    }
    res.end();
}

void sendHtml(response &res, string filename){
    sendFile(res, filename + ".html", "text/html");
}

void sendScript(response &res, string filename){
    sendFile(res, "scripts/" + filename, "text/javascript");
}


void sendImage(response &res, string filename){
    sendFile(res, "images/" + filename, "image/jpeg");
}

void sendStyle(response &res, string filename){
    sendFile(res, "styles/" + filename, "text/css");
}

void notFound(response &res, const string &message){
    res.code=404;
    res.write(message+": Not Found");
    res.end();
}

int main(int argc, char* argv[]) {
    std::mutex mtx;
    std::unordered_set<crow::websocket::connection *> users;
    crow::SimpleApp app;

    mongocxx::instance inst{};
    string mongoConnect = std::string(getenv("MONGODB_URI"));
    cout << mongoConnect << endl;
    mongocxx::client conn{mongocxx::uri{mongoConnect}};
    auto collection = conn["myfirstdb"]["contact"];

    CROW_ROUTE(app, "/ws")
    .websocket()
    .onopen([&](crow::websocket::connection &conn){
        std::lock_guard<std::mutex> _(mtx);
        users.insert(&conn);
    })
    .onclose([&](crow::websocket::connection &conn, const string &reason){
        std::lock_guard<std::mutex> _(mtx);
        users.erase(&conn);
    })
    .onmessage([&](crow::websocket::connection &/*conn*/, const string &data, bool is_binary){
        std::lock_guard<std::mutex> _(mtx);
        for(auto user :users){
            if(is_binary){
                user->send_binary(data);
            }else{
                user->send_text(data);
            }
        }
    });

    CROW_ROUTE(app, "/chat")
            ([](const request &req, response &res){
                sendHtml(res, "chat");
            });


    CROW_ROUTE(app, "/styles/<string>")
            ([](const request &req, response &res, string filename){
                sendStyle(res, filename);
            });
    CROW_ROUTE(app, "/scripts/<string>")
            ([](const request &req, response &res, string filename){
                sendScript(res, filename);
            });
    CROW_ROUTE(app, "/images/<string>")
            ([](const request &req, response &res, string filename){
                sendImage(res, filename);
            });


    CROW_ROUTE(app, "/rest_test").methods(HTTPMethod::Post, HTTPMethod::Get)
            ([](const request &req, response &res){
                string method = method_name(req.method);
                res.set_header("Content-Type", "text/plain");
                res.write(method+" rest_test");
                res.end();
            });

    CROW_ROUTE(app, "/")
    ([](const request &req, response &res){
        sendHtml(res, "index");
            });

    CROW_ROUTE(app, "/about")
            ([](const request &req, response &res){
                sendHtml(res, "about");
            });

    CROW_ROUTE(app, "/contact/<string>")
            ([&collection](const request &req, response &res,string email){
                set_base(".");
                auto doc = collection.find_one(make_document(kvp("email", email)));
                crow::json::wvalue dto;
                dto["contact"] = json::load(bsoncxx::to_json(doc.value().view()));
                getView(res, "contact", dto);
            });

    CROW_ROUTE(app, "/contact/<string>/<string>")
            ([&collection](const request &req, response &res, string firstname, string lastname){
                set_base(".");
                auto doc = collection.find_one(
                        make_document(kvp("firstName", firstname), kvp("lastName", lastname)));
                if(!doc){
                    return notFound(res, "Contact");
                }

                crow::json::wvalue dto;
                dto["contact"] = json::load(bsoncxx::to_json(doc.value().view()));
                getView(res, "contact", dto);
            });
    CROW_ROUTE(app, "/contacts")
            ([&collection](const request &req, response &res){
                set_base(".");
                mongocxx::options::find opts;
                opts.skip(9);
                opts.limit(10);
                auto docs = collection.find({}, opts);
                crow::json::wvalue dto;
                vector<crow::json::rvalue> contacts;
                contacts.reserve(10);

                for(auto doc : docs){
                    contacts.push_back(json::load(bsoncxx::to_json(doc)));
                }
                dto["contacts"] = contacts;
                getView(res, "contacts", dto);
            });

    CROW_ROUTE(app, "/api/contacts")
            ([&collection](const request &req){
                set_base(".");
                auto skipVal = req.url_params.get("skip");
                auto limitVal = req.url_params.get("limit");
                int skip = skipVal? stoi(skipVal):0;
                int limit = limitVal? stoi(limitVal): 10;
                mongocxx::options::find opts;
                opts.skip(skip);
                opts.limit(limit);
                auto docs = collection.find({}, opts);
                vector<crow::json::rvalue> contacts;
                contacts.reserve(10);

                for(auto doc : docs){
                    contacts.push_back(json::load(bsoncxx::to_json(doc)));
                }
                crow::json::wvalue dto;
                dto["contacts"] = contacts;
                return crow::response{dto};
            });

    CROW_ROUTE(app, "/contact/<int>/<int>")
            ([&collection](const request &req, response &res, int a, int b){
                set_base(".");
                res.set_header("Content-Type", "text/plain");
                ostringstream os;
                os << "Integer: " << a << " + " << b << " = " << a+b << "/n";
                res.write(os.str());
                res.end();
            });
    char* port = getenv("PORT");
    uint16_t iPort = static_cast<uint16_t>(port != NULL? stoi(port): 18080);
    cout << "PORT = " << iPort << "\n";
    app.port(iPort).multithreaded().run();
    return 0;
}
