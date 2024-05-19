// api.js

export const fetchNearbyCinemas = async (latitude, longitude) => {
  const url = `https://nominatim.openstreetmap.org/reverse?lat=${latitude}&lon=${longitude}&format=json`;

  try {
      const res = await fetch(url);
      const data = await res.json();

      if (data.display_name) {
          return {
              lat: parseFloat(data.lat),
              lon: parseFloat(data.lon),
              displayName: data.display_name
          };
      } else {
          return null;
      }
  } catch (error) {
      console.error('Error fetching nearby cinemas:', error);
      throw error;
  }
};
