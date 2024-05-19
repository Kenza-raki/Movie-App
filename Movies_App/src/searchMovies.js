// SearchMovies.js

import React, { useState } from "react";
import MovieCard from "./movieCard";
import MovieOptionsModal from "./options"; // Assuming you renamed this file
import NearbyCinemasModal from "./NearbyCinema";
import { fetchNearbyCinemas } from "./api";
import Modal from "./Modal";


export default function SearchMovies() {
    const [query, setQuery] = useState('');
    const [movies, setMovies] = useState([]);
    const [selectedMovie, setSelectedMovie] = useState(null);
    const [showOptionsModal, setShowOptionsModal] = useState(false);
    const [showTrailerModal, setShowTrailerModal] = useState(false);
    const [nearbyCinemas, setNearbyCinemas] = useState(null);

    const apiKey = '720fa6c11b82de2ff84c5a8588a005e5';

    const searchMovies = async (e) => {
        e.preventDefault();
        const url = `https://api.themoviedb.org/3/search/movie?api_key=${apiKey}&language=en-US&query=${query}&page=1&include_adult=false`;

        try {
            const res = await fetch(url);
            const data = await res.json();
            setMovies(data.results);
        } catch (err) {
            console.error(err);
        }
    }

    const handleMovieClick = (movie) => {
        setSelectedMovie(movie);
        setShowOptionsModal(true);
    }

    const handleFindCinemas = async () => {
        if (!navigator.geolocation) {
            console.error('Geolocation is not supported by your browser.');
            return;
        }

        navigator.geolocation.getCurrentPosition(async (position) => {
            const { latitude, longitude } = position.coords;
            try {
                const cinemasData = await fetchNearbyCinemas(latitude, longitude);
                setNearbyCinemas(cinemasData);
                setShowOptionsModal(false); // Close movie options modal
            } catch (error) {
                console.error('Error fetching nearby cinemas:', error);
            }
        }, (error) => {
            console.error('Error getting user location:', error);
        });
    }

    const handleWatchTrailer = () => {
        setShowOptionsModal(false);
        setShowTrailerModal(true);
    }

    const closeModal = () => {
        setSelectedMovie(null);
        setShowOptionsModal(false);
        setShowTrailerModal(false);
    }

    return (
        <>
            <form className="form" onSubmit={searchMovies}>
                <label className="label" htmlFor="query">Movie Name</label>
                <input
                    className="input"
                    type="text"
                    name="query"
                    placeholder="i.e. Jurassic Park"
                    value={query}
                    onChange={(e) => setQuery(e.target.value)}
                />
                <button className="button" type="submit">Search</button>
            </form>

            <div className="card-list">
                {movies.filter(movie => movie.poster_path).map(movie => (
                    <div
                        className="movie-card"
                        key={movie.id}
                        onClick={() => handleMovieClick(movie)}
                    >
                        <MovieCard movie={movie} />
                    </div>
                ))}
            </div>

            {selectedMovie && showOptionsModal && (
                <MovieOptionsModal
                    onClose={closeModal}
                    onWatchTrailer={handleWatchTrailer}
                    onFindCinemas={handleFindCinemas}
                />
            )}

            {nearbyCinemas && !showOptionsModal && (
                <NearbyCinemasModal
                    onClose={closeModal}
                    nearbyCinemas={nearbyCinemas}
                />
            )}

            {selectedMovie && showTrailerModal && (
                <Modal
                    onClose={closeModal}
                    movieId={selectedMovie.id}
                    apiKey={apiKey}
                />
            )}
        </>
    );
}
