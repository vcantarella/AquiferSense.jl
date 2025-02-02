# Delaunay Triangulation of a Cross-Section

This approach correctly calculates the Delaunay Triangulation of a Cross-Secion
A Cross Section here is defined by straight lateral boundaries: (x=0) and (x=L) and two vertical boundaries.
The bottom vertical boundary is again straight, but in the horizontal (z=BOT), while the top boundary is the topography, defined as a set of points (x,z) representing nodes of a line.

The Delaunay Triangulation works by iteratively adding new points that belong to a triangle.
