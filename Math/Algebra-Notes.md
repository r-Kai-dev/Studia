# Algebra Notes

## Resources
- [x] [Youtube - Essence of Linear Algebra](https://youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab)
- [x] [Youtube - SEE Matrix](https://youtube.com/playlist?list=PLWhu9osGd2dB9uMG5gKBARmk73oHUUQZS)
- [ ] [Book - Immersive Linear Algebra](https://immersivemath.com/ila/)
- [ ] [Youtube - SVD](https://youtube.com/playlist?list=PLMrJAkhIeNNSVjnsviglFoY2nXildDCcv)
- [ ] [Youtube - Linear Algebra](https://youtube.com/playlist?list=PLBh2i93oe2quLc5zaxD0WHzQTGrXMwAI6)
- [ ] [Youtube - Abstract Linear Algebra](https://youtube.com/playlist?list=PLBh2i93oe2qvyrgm_lchujtMbEdXFAHEQ)
- [ ] [Youtube - Algebra](https://youtube.com/playlist?list=PLBh2i93oe2qsv5x-tD7GpfS9xFrLVS_b4)

- - -

# Linear Algebra

## Vector
- An n-dimensional vector can be represented by a list of n numbers (scalars).
- Vectors can be added or multiplied by a scalar.
- Adding two vectors is "travel by vector 1" and then "travel by vector 2 starting from the end of vector 1".
- Multiplying a scalar with a vector is "scaling the vector by the scalar". If the scalar is negative, the direction is reversed (flipped by 180°).
- Operations using scalar multiplications and vector additions are called linear combinations.
- Vectors are linearly dependent if some can be represented as a linear combination of the others. Examples: two 2-D vectors on the same straight line; three 3-D vectors on a plane.
- The span of a set of vectors is the space they can form. Example: the span of two 3-D vectors not on the same line is a plane.
- When a set of linearly independent vectors forms a span, they are called a basis for the span (space).
- All vectors in a linear space can be represented as linear combinations of the basis.

## Matrix
- A linear transformation is a transformation that preserves the linear properties of the original space and its vectors. In other words, the transformed vectors are still evenly spaced and parallel if the original ones are. $aL(v) = L(av)$ and $L(v+w) = L(v) + L(w)$
- Since all vectors are linear combinations of basis, tracking the transformed vectors only requires tracking the transformed basis (unit vectors in original space).
- If $i$ and $j$ are transformed into a new basis $v_1$ and $v_2$, writing the new vectors as columns makes a 2-by-2 matrix representing that linear transformation.
- By definition, the column vectors of a matrix are the transformed versions of the original basis.
- Rank of a matrix: the number of linearly independent column vectors.
- Full-rank m-by-n matrix: rank equals $\min(m, n)$
- An m-by-n matrix transforms vectors of n dimensions into vectors of m dimensions.
- A matrix is invertible if there is an inverse matrix (transformation) that transforms the vectors back to their original state (before applying the matrix).
- By definition, only square matrices can be invertible. A non-square matrix is a lossy transformation that can not be mapped back uniquely.
- A square matrix is invertible if and only if its rank is full.
- Matrix A multiplied by matrix B is defined as applying linear transformation B and then A. Order matters.

## Determinant
- The absolute value of a matrix's determinant is the ratio of the hyper-volume (in full dimension, e.g., area in 2-D and volume in 3-D) between after and before the transformation. For example, if a unit square is transformed into a parallelogram of area 2, then the absolute value of determinant is 2.
- A positive determinant means no reflection (no flipping, only rotations and stretches).
- A negative determinant means the space is reflected (flipped) across an (n-1)-dimensional hyperplane. 
- Determinants are only defined for square matrices. A similar geometric interpretation would give zero for non-square matrices.
- $\det(AB) = \det(A)\det(B)$ given the determinant is a multiplier in nature

## Dot Product & Cross Product

### Dot Product of 2 vectors
- The output of a dot product is a scalar.
- Dot product of two vectors is defined as the sum of element-wise products of both vectors.
- Dot product equals the product of the lengths of both vectors and $\cos(\theta)$.
- Dot product equals the product of the length of one vector and the length of the projection of the other vector on the first vector.
- A positive dot product means the angle between the two vectors is less than 90°. A zero dot product means perpendicular. A negative dot product means the angle is greater than 90°.
- The cosine of the angle can be used as a similarity metric between two vectors.

### Cross Product of 2 vectors
- The output of a cross product is a vector.
- Magnitude of cross product is the determinant of the matrix with the 2 vectors as the column vectors.
- Direction of the cross product is determined by right hand rule: first vector on index finger, second vector on ring finger, and thumb is the direction of the output vector.
- The cross product is perpendicular to both input vectors (in 3D only).

## Change of Basis
- When a vector $v$ is transformed by $A$, i.e. $Av$, the result is the transformed vector, still expressed in the original coordinate system.
- A different view: if $A$'s columns are a new basis, then $v$ is expressed in the new basis and $Av$ gives the coordinates in the original basis ($i$ and $j$).
- Reversing the basis: if $w$ is a vector in the original basis, $A^{-1}w$ gives the coordinates in the transformed (by $A$) basis.
- Application: $A^{-1}BA$ changes the basis from the $A$-defined one to the original, applies the $B$ transformation, and transforms back to the $A$-defined basis.
- In this view, a matrix represents a change of coordinates, not a transformation.
- Intuitive proof: given matrix $A$, and vector $w$ in the basis of $A$'s column vectors, given numerics in the $A$ itself and the column vectors are in original basis, the linear combination of $w$ and column vectors of $A$ is naturally the coordinates of the same vector but in original basis.

## Eigenvectors & Eigenvalues
- If some vectors do not leave their original lower-dimensional span under a transformation $A$, then those vectors are called the eigenvectors of $A$.
- Transformation $A$ can still scale eigenvectors by $\lambda$, called the eigenvalues.
- Eigenvalues can be positive and negative (opposite direction)
- Solve $\det(A - \lambda I) = 0$ for $\lambda$, then substitute each $\lambda$ into the definition equation to find the corresponding eigenvectors.
- If eigenvectors can form a new basis, then they are called the eigenbasis.

## Row, Column, and Null Space (Kernel)
- Null space: the space of all vectors $v$ with $Av=0$, also called the kernel
- Rank-Nullity Theorem: rank + nullity = number of columns
- The result of $Av$ is a vector of row-space components; all vectors $v$ in the null space are perpendicular to the row space.
- While the column space is the space spanned by the transformed basis, the row space is where the basis is used to measure (via dot product) the to-be-transformed vector

## Singular Value Decomposition (SVD)

### Special Case: Spectral Decomposition
- The Spectral Theorem says that a symmetric matrix has a complete eigenbasis. Proof sketch: eigenvectors from distinct eigenvalues are orthogonal to each other, which can be shown by subtracting the two eigenvalue equations. (This does not fully cover the case of repeated eigenvalues, which requires a more careful argument.)
- Spectral decomposition: a symmetric matrix $A$ can be decomposed into $Q\Sigma Q^T$, where $Q$ is the matrix of eigenvectors as columns and $\Sigma$ is the diagonal matrix.
    - $Q^T$ transforms the orthogonal eigenvectors to the standard basis (inner products are either 1 or 0).
    - $\Sigma$ scales each dimension in the standard space
    - $Q$ transforms the standard basis into the eigenbasis again.
- A symmetric matrix scales along its eigenvectors. The spectral decomposition first rotates the coordinate system to align with the eigenbasis, so the diagonal matrix can express the eigenvalues in the standard basis, and finally rotates back. In other words, the natural axes of a symmetric matrix transformation are the eigenvectors.
- Application: PCA (Principal Component Analysis). For a dataset of $m \times n$ dimension, the covariance matrix (values are pairwise covariances between $n$ features) is an $n \times n$ symmetric matrix. Using Spectral Decomposition, the top eigenvectors can serve as new features; projecting data points onto them reduces the dataset's dimensions.

### SVD
- For any matrix $M$, $MM^T$ and $M^TM$ are both symmetric (square) matrices.
- $M$ can be composed as $U\Sigma V^T$, where $U$ is the matrix of eigenvectors of $MM^T$ as columns, $V$ is the matrix of eigenvectors of $M^TM$ as columns, and $\Sigma$ is the diagonal matrix with $\sqrt{\lambda}$ for the common top eigenvalues $\lambda$ from both $MM^T$ and $M^TM$, then expanded to the correct $m \times n$ dimensions with 0s.
- Interpretation of SVD: any linear transformation $M$ of $m \times n$ can be decomposed into 3 transformations. 1. $V^T$: rotate to a set of eigenbasis within the $n$ dimensional space; 2. $\Sigma$: scale and map to $m$ dimensional space; 3. $U$: rotate again to a set of eigenbasis in the $m$ dimensional space.

## Special types of linear transformations

### Rotations & Reflections
- Without stretching, $\det(\text{rotation}) = 1$, $\det(\text{reflection}) = -1$
- Rotations correspond to orthogonal (orthonormal) matrices.
- Rotations with angles other than multiples of $\pi$ do NOT have eigenvalues and eigenvectors, since all vectors are rotated to different directions. (In 2D this is always true. In 3D, however, the rotation axis itself is an eigenvector with eigenvalue 1, since it is not rotated.)
- The inverse of an orthonormal matrix equals its transpose: reflecting across $x=y$ swaps the axes, which is the transpose operation.
- Reflections must be around a hyperplane of $n-1$ dimensions. All vectors on that hyperplane are its eigenvectors with eigenvalue 1. Vectors perpendicular to the hyperplane are also eigenvectors but with eigenvalue -1 (they get flipped).
- All rotations are equivalent to a series of reflections.
- Reflecting across same or different hyperplanes even number of times always has determinant of 1, odd number of times -1.

- - -

# Abstract Linear Algebra

- - -

# Abstract Algebra
