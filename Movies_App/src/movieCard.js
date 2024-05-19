import React from "react";

export default function MovieCard({ movie }) {
    return (
        <div className="card">
            <img
                className="card--image"
                src={`https://image.tmdb.org/t/p/w342/${movie.poster_path}`}
                alt={movie.title + ' poster'}
            />
            <div className="card--content">
                <h3 className="card--title">{movie.title}</h3>
                <p className="card--info">
                    <strong>Release Date:</strong> {movie.release_date}
                </p>
                <p className="card--info">
                    <strong>Rating:</strong> {movie.vote_average}
                </p>
                <p className="card-desc">{movie.overview}</p>
            </div>
        </div>
    );
}
