import React, { useState, useEffect } from "react";
import './Modal.css'; // Assuming you have CSS for styling the modal

const Modal = ({ onClose, movieId, apiKey }) => {
    const [trailerUrl, setTrailerUrl] = useState(null);

    useEffect(() => {
        const fetchTrailer = async () => {
            const apiUrl = `https://api.themoviedb.org/3/movie/${movieId}/videos?api_key=${apiKey}`;
            try {
                const response = await fetch(apiUrl);
                const data = await response.json();
                if (data.results.length > 0) {
                    const trailerKey = data.results[0].key;
                    const newTrailerUrl = `https://www.youtube.com/embed/${trailerKey}`;
                    setTrailerUrl(newTrailerUrl);
                } else {
                    console.log('No trailer available for this movie.');
                }
            } catch (error) {
                console.error('Error fetching trailer:', error);
            }
        };

        if (movieId) {
            fetchTrailer();
        }
    }, [movieId, apiKey]);

    return (
        <div className="modal-overlay" onClick={onClose}>
            <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                {trailerUrl ? (
                    <iframe
                        title="Movie Trailer"
                        width="560"
                        height="315"
                        src={trailerUrl}
                        frameBorder="0"
                        allowFullScreen
                    ></iframe>
                ) : (
                    <p>Loading trailer...</p>
                )}
                <button className="modal-close-button" onClick={onClose}>Close</button>
            </div>
        </div>
    );
};

export default Modal;
