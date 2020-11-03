# Wikimovie
A simple movie listing application powered by themoviedb.org


App contains that;

Movie List page (ViewController)
- Lists populer movies from api.themoviedb.org
- There are two display mode switch option (List/Grid View)
- Movies fetches page by page with "load more" button.
- User can search with search bar from fetched movies.

Movie Detail Page (DetailTableViewController)
- This contains Movie Poster, Name, Description, Vote Count, and a star button.
- When user clicks the Star button on detail page, movie will be added to (or removed from) the favorite list.
- The favorite list is stored locally on the device.
