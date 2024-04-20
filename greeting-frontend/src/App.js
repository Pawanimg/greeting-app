// import logo from './logo.svg';
import './App.css';

import React, { useState } from 'react';

const BASE_URL = '/choreo-apis/greeting/ballerina-backend/greeting-service-46b/v1.0';

function fetchWithToken(url, options) {
  const token = localStorage.getItem("access");
  if (token) {
    options.headers = {
      ...options.headers,
      Authorization: `Bearer ${token}`
    };
  }
  return fetch(url, options);
}

function App() {
  const [name, setName] = useState('');
  const [message, setMessage] = useState('');
  const [sentence, setSentence] = useState('');
  const [fact, setFact] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const sendRequest = () => {
    setIsLoading(true);
    fetchWithToken(`${BASE_URL}/sayHello`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ name: name })
    })
    .then(response => response.json())
    .then(data => {
      setMessage(data.message);
      setSentence(data.sentence);
      setFact(data.fact);
      setIsLoading(false);
    })
    .catch(error => {
      console.error('Error:', error);
      setIsLoading(false); // Set loading state to false in case of error
    });
  };

  return (
    <div>
      <h1>Simple Full Stack App with React</h1>
      <input
        type="text"
        value={name}
        onChange={e => setName(e.target.value)}
        placeholder="Enter your name"
      />
      <button onClick={sendRequest} className="btn">
          {isLoading ? 'Loading...' : 'Say Hello'}
        </button>
      {message && (
        <div className="response-container">
          <div className="response-item">{message}</div>
          <div className="response-item">{sentence}</div>
          <div className="response-item">Fact: {fact}</div>
        </div>
      )}
    </div>
  );
}

export default App;
