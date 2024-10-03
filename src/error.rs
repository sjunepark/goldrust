#[derive(thiserror::Error, Debug)]
pub enum GoldrustError {
    #[cfg(feature = "image")]
    #[error("Image error: {0}")]
    Image(#[from] image::ImageError),
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("SerdeJson error: {0}")]
    SerdeJson(#[from] serde_json::Error),
}
