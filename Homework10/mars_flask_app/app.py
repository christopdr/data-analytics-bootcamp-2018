# import necessary libraries


from flask import Flask, jsonify, render_template
import methods.scrape_mars as sp
app = Flask(__name__)


# create route that renders index.html template
@app.route("/")
def home():
    return render_template("index.html")

# Create database classes
#@app.before_first_request
#def setup():
    # Recreate database each time for demo
    # db.drop_all()
#    global
    print(dictionary)

# Query the database and return the jsonified results
@app.route("/scrape")
def scrape():
    # @TODO: YOUR CODE HERE
    dictionary = sp.scrape_data()
    return render_template('scrap.html',tweet_size= len(dictionary['tweets']) , news_size=len(dictionary['news']['title']), mars_data = dictionary)


if __name__ == "__main__":
    app.run(debug=True)
