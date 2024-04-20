import ballerina/http;
import ballerina/log;
import ballerina/random;

const PORT = 9099;

listener http:Listener greetingListner = new (
    PORT
);

// The service-level CORS config applies globally to each `resource`.
@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: false,
        maxAge: 84900999
    }
}
service / on greetingListner {

    function init() returns error? {
        log:printInfo("Listener started", port = PORT.toString());
    }

    isolated resource function post sayHello(@http:Payload Name payload) returns json {
        log:printInfo("Request received ", name = payload.name);
        string[] greetings = ["Hi", "Hello", "Good day", "Hey", "Greetings", "What's up", "Salutations", "Howdy", "Hola", "Bonjour"];
        string[] sentences = ["How are you?", "How's your day?", "What's new?", "Nice to meet you", "How's it going?", "How's everything?", "What's happening?", "How have you been?", "How's life?", "How's work?"];
        string[] facts = ["The Earth is spherical, not flat", "The universe is vast and ever-expanding", "The human body is made up of billions of cells", "Water covers about 71% of the Earth's surface", "The Great Wall of China is the longest man-made structure on Earth", "The speed of light is approximately 299,792 kilometers per second", "The mitochondria is the powerhouse of the cell", "The human brain has about 86 billion neurons", "The tallest mountain on Earth is Mount Everest", "The Amazon Rainforest produces about 20% of the world's oxygen"];

        // Randomly select a greeting, sentence, and fact
        int|random:Error randomInteger1 = random:createIntInRange(0, greetings.length() - 1);
        int|random:Error randomInteger2 = random:createIntInRange(0, sentences.length() - 1);
        int|random:Error randomInteger3 = random:createIntInRange(0, facts.length() - 1);
        if randomInteger1 is int && randomInteger2 is int && randomInteger3 is int {
            string greeting = greetings[randomInteger1];
            string sentence = sentences[randomInteger2];
            string fact = facts[randomInteger3];
            string message = "Hello " + payload.name + "!, " + greeting;
            // Construct the response JSON
            json response = {
                "message": message,
                "sentence": sentence,
                "fact": fact
            };
            return response;
        }
        string message = "Hello " + payload.name + "!, ";
        // Construct the response JSON
        json response = {
            "message": message,
            "sentence": "",
            "fact": ""
        };
        return response;
    }

    isolated resource function get sayHello(@http:Query readonly & string name) returns json {
        string message = "Hello " + name;
        json response = {"message": message};
        return response;
    }

}
