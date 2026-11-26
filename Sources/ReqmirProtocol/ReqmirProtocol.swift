/// The wire protocol shared by ReqmirKit and the Reqmir app.
public enum ReqmirProtocol {
    /// Bumped whenever the messages change in a way the other side cannot read.
    public static let version = 1
}
// TEMP: deliberately longer than the 100-column limit so that SwiftLint line_length fails on CI. Revert.
