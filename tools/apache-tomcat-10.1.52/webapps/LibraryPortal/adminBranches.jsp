<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("login.jsp?role=admin&error=Please login first");
        return;
    }
    String msg = request.getParameter("msg");
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_portal", "root", "");
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM branches ORDER BY id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Archive Co. | Branch Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="includes/adminSidebar.jsp"><jsp:param name="page" value="branches"/></jsp:include>

    <div class="main-content">
        <jsp:include page="includes/adminTopbar.jsp"/>

        <div class="page-content">
            <% if (msg != null) { %>
                <div class="alert alert-success"><%= msg %></div>
            <% } %>

            <!-- Tabs -->
            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:24px;">
                <div class="tab-buttons">
                    <button class="tab-btn active" data-tab-group="branches" data-tab-target="branchesPanel">Branches</button>
                    <button class="tab-btn" data-tab-group="branches" data-tab-target="branchLogPanel">Deletion Log</button>
                </div>
                <div class="search-box">
                    <span class="search-icon"><img src="img/icon-search.svg" alt="Search" style="width:16px;height:16px"></span>
                    <input type="text" class="search-input" data-table="branchesTable" placeholder="Search by Name">
                </div>
            </div>

            <!-- Branches Tab -->
            <div class="tab-panel" id="branchesPanel" data-tab-group="branches">
                <div class="page-header">
                    <h1>Branch Management</h1>
                    <div class="page-header-actions">
                        <button class="btn-add" onclick="openModal('addBranchModal')">
                            <span class="icon"><img src="img/icon-add.svg" alt="Add" style="width:14px;height:14px;vertical-align:middle;filter:invert(1)"></span> Add Branch
                        </button>
                    </div>
                </div>

                <div class="data-table-wrapper">
                    <table class="data-table" id="branchesTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Contact No</th>
                                <th>Location</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% while (rs.next()) {
                            int bid = rs.getInt("id");
                            String bname = rs.getString("name");
                            String bcontact = rs.getString("contact_no") != null ? rs.getString("contact_no") : "";
                            String blocation = rs.getString("location") != null ? rs.getString("location") : "";
                        %>
                            <tr>
                                <td><%= bid %></td>
                                <td><%= bname %></td>
                                <td><%= bcontact %></td>
                                <td><%= blocation %></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit-btn" onclick="populateEditForm('editBranchModal', {id:'<%= bid %>', name:'<%= bname.replace("'","\\'") %>', contact_no:'<%= bcontact.replace("'","\\'") %>', location:'<%= blocation.replace("'","\\'") %>'})" title="Edit"><img src="img/icon-edit.svg" alt="Edit" style="width:14px;height:14px"></button>
                                        <button class="action-btn delete-btn" onclick="openDeleteBranchStep1(<%= bid %>, '<%= bname.replace("'","\\'") %>')" title="Delete"><img src="img/icon-delete.svg" alt="Delete" style="width:14px;height:14px"></button>
                                        <button class="action-btn view-btn" onclick="openModal('viewBranchModal-<%= bid %>')" title="View"><img src="img/icon-view.svg" alt="View" style="width:14px;height:14px"></button>
                                    </div>
                                </td>
                            </tr>

                            <!-- View Branch Modal -->
                            <div class="modal-overlay" id="viewBranchModal-<%= bid %>">
                                <div class="modal">
                                    <div class="modal-header">
                                        <h2><span class="modal-icon"><img src="img/icon-branches.svg" alt="Branch" style="width:20px;height:20px;vertical-align:middle"></span> View Branch</h2>
                                        <button class="modal-close">&times;</button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="view-meta">
                                            <div class="view-details">
                                                <div class="detail-row"><span class="detail-label">Branch ID :</span><span class="detail-value"><%= bid %></span></div>
                                                <div class="detail-row"><span class="detail-label">Name :</span><span class="detail-value"><%= bname %></span></div>
                                                <div class="detail-row"><span class="detail-label">Contact No :</span><span class="detail-value"><%= bcontact %></span></div>
                                                <div class="detail-row"><span class="detail-label">Location :</span><span class="detail-value"><%= blocation %></span></div>
                                            </div>
                                            <div class="view-saved-by">
                                                Listed by :<br>
                                                <strong><%= session.getAttribute("adminName") %></strong>
                                                (Admin)
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn-confirm" onclick="closeModal('viewBranchModal-<%= bid %>')">CLOSE</button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Deletion Log Tab -->
            <div class="tab-panel hidden" id="branchLogPanel" data-tab-group="branches">
                <div class="page-header">
                    <h1>Branch Deletion Log</h1>
                    <p style="color:#666;margin:0">Audit trail of deleted branches, visible to all admins.</p>
                </div>
                <div class="data-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Branch ID</th>
                                <th>Name</th>
                                <th>Location</th>
                                <th>Reason</th>
                                <th>Deleted By</th>
                                <th>Deleted At</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            Statement stLog = conn.createStatement();
                            ResultSet rsLog = stLog.executeQuery(
                                "SELECT branch_id, name, location, reason, deleted_by_admin_name, deleted_at FROM deleted_branches ORDER BY deleted_at DESC");
                            boolean hasLog = false;
                            while (rsLog.next()) {
                                hasLog = true;
                        %>
                            <tr>
                                <td><%= rsLog.getInt("branch_id") %></td>
                                <td><%= rsLog.getString("name") != null ? rsLog.getString("name") : "-" %></td>
                                <td><%= rsLog.getString("location") != null ? rsLog.getString("location") : "-" %></td>
                                <td style="max-width:280px;white-space:normal"><%= rsLog.getString("reason") %></td>
                                <td><%= rsLog.getString("deleted_by_admin_name") != null ? rsLog.getString("deleted_by_admin_name") : "-" %></td>
                                <td><%= rsLog.getTimestamp("deleted_at") %></td>
                            </tr>
                        <% }
                            if (!hasLog) { %>
                            <tr><td colspan="6" class="text-center" style="padding:40px;color:#999;">No deletions recorded yet</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Branch Modal -->
<div class="modal-overlay" id="addBranchModal">
    <div class="modal">
        <div class="modal-header">
            <h2><span class="modal-icon"><img src="img/icon-branches.svg" alt="Branch" style="width:20px;height:20px;vertical-align:middle"></span> Add Branch</h2>
            <button class="modal-close">&times;</button>
        </div>
        <form action="AddBranchServlet" method="post">
            <div class="modal-body">
                <div class="form-group"><input type="text" name="name" placeholder="Name" required></div>
                <div class="form-group"><input type="text" name="contact_no" placeholder="Contact No"></div>
                <div class="form-group"><input type="text" name="location" placeholder="Location"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel">CANCEL</button>
                <button type="submit" class="btn-confirm">ADD</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Branch Modal -->
<div class="modal-overlay" id="editBranchModal">
    <div class="modal">
        <div class="modal-header">
            <h2><span class="modal-icon"><img src="img/icon-branches.svg" alt="Branch" style="width:20px;height:20px;vertical-align:middle"></span> Update Branch</h2>
            <button class="modal-close">&times;</button>
        </div>
        <form action="UpdateBranchServlet" method="post">
            <input type="hidden" name="id">
            <div class="modal-body">
                <div class="form-group"><input type="text" name="name" placeholder="Name" required></div>
                <div class="form-group"><input type="text" name="contact_no" placeholder="Contact No"></div>
                <div class="form-group"><input type="text" name="location" placeholder="Location"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel">CANCEL</button>
                <button type="submit" class="btn-confirm">UPDATE</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Branch - Step 1: warning + reason -->
<div class="modal-overlay delete-modal" id="deleteBranchStep1Modal">
    <div class="modal">
        <div class="modal-header">
            <h2><span class="modal-icon"><img src="img/icon-delete.svg" alt="Delete" style="width:20px;height:20px;vertical-align:middle"></span> Delete Branch - Step 1 of 2</h2>
            <button class="modal-close">&times;</button>
        </div>
        <div class="modal-body">
            <p>You are about to permanently delete the branch <strong id="delBranchName1"></strong>.</p>
            <p style="color:#b00;font-size:13px">This action cannot be undone. A reason is mandatory and will be visible to all admins.</p>
            <div class="form-group" style="margin-top:12px">
                <label>Reason for deletion</label>
                <textarea id="delBranchReason" required minlength="5" rows="3" style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;resize:vertical" placeholder="e.g., Branch permanently closed, merged with main, relocated..."></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel">CANCEL</button>
            <button type="button" class="btn-confirm" onclick="goToDeleteBranchStep2()">NEXT</button>
        </div>
    </div>
</div>

<!-- Delete Branch - Step 2: type-to-confirm -->
<div class="modal-overlay delete-modal" id="deleteBranchStep2Modal">
    <div class="modal">
        <div class="modal-header">
            <h2><span class="modal-icon"><img src="img/icon-delete.svg" alt="Delete" style="width:20px;height:20px;vertical-align:middle"></span> Delete Branch - Step 2 of 2</h2>
            <button class="modal-close">&times;</button>
        </div>
        <form action="DeleteBranchServlet" method="post" id="deleteBranchForm">
            <input type="hidden" name="id" id="delBranchId">
            <input type="hidden" name="reason" id="delBranchReasonHidden">
            <div class="modal-body">
                <p>To confirm deletion, type the branch name <strong id="delBranchName2"></strong> exactly below:</p>
                <div class="form-group" style="margin-top:12px">
                    <input type="text" name="confirmName" id="delBranchConfirmInput" required autocomplete="off" style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px" placeholder="Type the branch name">
                </div>
                <p id="delBranchMismatch" style="color:#b00;font-size:12px;display:none;margin-top:8px">Name does not match.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="backToDeleteBranchStep1()">BACK</button>
                <button type="submit" class="btn-confirm" id="delBranchFinalBtn" disabled>DELETE BRANCH</button>
            </div>
        </form>
    </div>
</div>

<!-- Change Credentials Modal -->
<div class="modal-overlay" id="credentialsModal">
    <div class="modal">
        <div class="modal-header">
            <h2><span class="modal-icon"><img src="img/icon-gear.svg" alt="Settings" style="width:20px;height:20px;vertical-align:middle"></span> Change Credentials</h2>
            <button class="modal-close">&times;</button>
        </div>
        <form action="ChangeCredentialsServlet" method="post">
            <input type="hidden" name="role" value="admin">
            <div class="modal-body">
                <div class="form-group"><label>Enter Current Password</label><input type="password" name="currentPassword" required></div>
                <div class="form-group"><label>Enter New Password</label><input type="password" name="newPassword" required></div>
                <div class="form-group"><label>Confirm New Password</label><input type="password" name="confirmPassword" required></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel">CANCEL</button>
                <button type="submit" class="btn-confirm">CONFIRM</button>
            </div>
        </form>
    </div>
</div>

<script src="js/main.js"></script>
<script>
var pendingBranchName = '';

function openDeleteBranchStep1(id, name) {
    pendingBranchName = name;
    document.getElementById('delBranchId').value = id;
    document.getElementById('delBranchName1').textContent = name;
    document.getElementById('delBranchName2').textContent = name;
    document.getElementById('delBranchReason').value = '';
    document.getElementById('delBranchConfirmInput').value = '';
    document.getElementById('delBranchFinalBtn').disabled = true;
    document.getElementById('delBranchMismatch').style.display = 'none';
    openModal('deleteBranchStep1Modal');
}

function goToDeleteBranchStep2() {
    var reason = document.getElementById('delBranchReason').value.trim();
    if (reason.length < 5) {
        alert('Please provide a reason (min 5 characters).');
        return;
    }
    document.getElementById('delBranchReasonHidden').value = reason;
    closeModal('deleteBranchStep1Modal');
    openModal('deleteBranchStep2Modal');
    setTimeout(function(){ document.getElementById('delBranchConfirmInput').focus(); }, 100);
}

function backToDeleteBranchStep1() {
    closeModal('deleteBranchStep2Modal');
    openModal('deleteBranchStep1Modal');
}

document.addEventListener('DOMContentLoaded', function() {
    var input = document.getElementById('delBranchConfirmInput');
    var btn = document.getElementById('delBranchFinalBtn');
    var mismatch = document.getElementById('delBranchMismatch');
    if (input) {
        input.addEventListener('input', function() {
            var match = this.value === pendingBranchName;
            btn.disabled = !match;
            mismatch.style.display = (this.value.length > 0 && !match) ? 'block' : 'none';
        });
    }
});
</script>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
