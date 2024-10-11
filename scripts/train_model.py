import logging
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import joblib

# Set up logging
logging.basicConfig(filename='/var/jenkins_home/scripts/train_model.log', level=logging.INFO)

try:
    # Load data
    data_path = "/var/jenkins_home/data/pollution_data.csv"
    data = pd.read_csv(data_path)
    
    # Preprocess data
    data['datetime'] = pd.to_datetime(data['datetime'], errors='coerce')
    data = data.dropna(subset=['datetime'])  # Drop rows with invalid datetime values
    
    # Extract useful features from 'datetime' column
    data['year'] = data['datetime'].dt.year
    data['month'] = data['datetime'].dt.month
    data['day'] = data['datetime'].dt.day
    data['hour'] = data['datetime'].dt.hour
    
    # Define features and target
    X = data[['year', 'month', 'day', 'hour', 'pm10', 'no2', 'so2', 'co', 'no', 'o3', 'nh3']]
    y = data['pm2_5']  # Target variable
    
    # Split data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Initialize and train the model
    model = LinearRegression()
    model.fit(X_train, y_train)
    
    # Predict and evaluate
    y_pred = model.predict(X_test)
    mse = mean_squared_error(y_test, y_pred)
    
    logging.info(f"Mean Squared Error: {mse}")
    
    # Save the model
    joblib.dump(model, '/var/jenkins_home/tmp/trained_model.joblib')
    logging.info("Model saved as 'trained_model.joblib'")

except Exception as e:
    logging.error(f"Error occurred: {str(e)}")