import React from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import './CinemaModal.css';

const MovieOptionsModal = ({ onClose, onWatchTrailer, onFindCinemas, nearbyCinemas }) => {
    return (
        <div className="modal-overlay">
            <div className="modal-content">
                <span className="close" onClick={onClose}>&times;</span>
                <h2>Movie Options</h2>
                <button onClick={onWatchTrailer}>Watch Trailer</button>
                <button onClick={onFindCinemas}>Find Nearby Cinemas</button>
                
                {nearbyCinemas && (
                    <div className="map-container">
                        <MapContainer
                            center={[nearbyCinemas.lat, nearbyCinemas.lon]}
                            zoom={13}
                            style={{ width: '100%', height: '400px' }} // Set width and height of the map container
                        >
                            <TileLayer
                                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                            />
                            <Marker position={[nearbyCinemas.lat, nearbyCinemas.lon]}>
                                <Popup>{nearbyCinemas.displayName}</Popup>
                            </Marker>
                        </MapContainer>
                    </div>
                )}
            </div>
        </div>
    );
};

export default MovieOptionsModal;
