document.addEventListener('DOMContentLoaded', function () {
    const STORAGE_USERS = 'users';
    const STORAGE_SELECTED = 'selectedUser';

    function getDefaultUsers() {
        return [
            { username: 'test1', email: 'test1@gmail.com', password: '123456' },
            { username: 'test2', email: 'test2@gmail.com', password: '123456' },
            { username: 'test3', email: 'test3@gmail.com', password: '123456' }
        ];
    }

    function getUsers() {
        const savedUsers = localStorage.getItem(STORAGE_USERS);
        if (savedUsers) {
            return JSON.parse(savedUsers);
        }

        const defaults = getDefaultUsers();
        localStorage.setItem(STORAGE_USERS, JSON.stringify(defaults));
        return defaults;
    }

    function saveUsers(users) {
        localStorage.setItem(STORAGE_USERS, JSON.stringify(users));
    }

    function findUser(username) {
        return getUsers().find(function (user) {
            return user.username === username;
        });
    }

    function setSelectedUser(username) {
        localStorage.setItem(STORAGE_SELECTED, username);
    }

    function getSelectedUser() {
        return localStorage.getItem(STORAGE_SELECTED);
    }

    function renderUsers() {
        const userList = document.getElementById('userList');
        if (!userList) {
            return;
        }

        const users = getUsers();
        userList.innerHTML = users.map(function (user, index) {
            return `
                <tr>
                    <td>${index + 1}</td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>
                        <a href="view.html" class="view-btn" data-username="${user.username}">Xem</a>
                        |
                        <a href="update.html" class="edit-link" data-username="${user.username}">Sửa</a>
                        |
                        <a href="#" class="delete-btn" data-username="${user.username}">Xóa</a>
                    </td>
                </tr>
            `;
        }).join('');

        const currentUser = localStorage.getItem('currentUser');
        const title = document.querySelector('h2');
        if (title && currentUser) {
            title.innerText = 'Danh sách user - Chào ' + currentUser;
        }
    }

    function fillViewPage() {
        const usernameElement = document.getElementById('viewUsername');
        const emailElement = document.getElementById('viewEmail');

        if (!usernameElement || !emailElement) {
            return;
        }

        const selectedUsername = getSelectedUser() || localStorage.getItem('currentUser') || 'test1';
        const user = findUser(selectedUsername) || getUsers()[0];

        if (!user) {
            return;
        }

        usernameElement.innerText = user.username;
        emailElement.innerText = user.email;
    }

    function fillUpdatePage() {
        const updateForm = document.getElementById('updateForm');
        if (!updateForm) {
            return;
        }

        const selectedUsername = getSelectedUser() || localStorage.getItem('currentUser');
        const user = findUser(selectedUsername);

        if (!user) {
            return;
        }

        document.getElementById('username').value = user.username;
        document.getElementById('email').value = user.email;
        document.getElementById('password').value = user.password || '';
        document.getElementById('re-password').value = user.password || '';
    }

    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const user = findUser(username);

            if (!user || user.password !== password) {
                alert('Sai tài khoản hoặc mật khẩu!');
                return;
            }

            localStorage.setItem('currentUser', user.username);
            localStorage.setItem('currentEmail', user.email);
            setSelectedUser(user.username);

            alert('Đăng nhập thành công!');
            window.location.href = 'list.html';
        });
    }

    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const user = document.getElementById('reg-username').value.trim();
            const email = document.getElementById('email').value.trim();
            const pass = document.getElementById('reg-password').value;
            const rePass = document.getElementById('re-password').value;
            const users = getUsers();

            if (pass !== rePass) {
                alert('Mật khẩu nhập lại không chính xác!');
                return;
            }

            if (users.some(function (item) { return item.username === user; })) {
                alert('Username đã tồn tại!');
                return;
            }

            users.push({
                username: user,
                email: email,
                password: pass
            });

            saveUsers(users);
            localStorage.setItem('currentUser', user);
            localStorage.setItem('currentEmail', email);
            setSelectedUser(user);

            alert('Đăng ký thành công!');
            window.location.href = 'login.html';
        });
    }

    const userList = document.getElementById('userList');
    if (userList) {
        renderUsers();

        userList.addEventListener('click', function (e) {
            const target = e.target;
            const username = target.dataset.username;

            if (target.classList.contains('view-btn') || target.classList.contains('edit-link')) {
                setSelectedUser(username);
                return;
            }

            if (target.classList.contains('delete-btn')) {
                e.preventDefault();

                if (!confirm('Bạn có chắc muốn xóa user: ' + username + '?')) {
                    return;
                }

                const users = getUsers().filter(function (user) {
                    return user.username !== username;
                });

                saveUsers(users);

                if (getSelectedUser() === username) {
                    localStorage.removeItem(STORAGE_SELECTED);
                }

                renderUsers();
            }
        });
    }

    const updateForm = document.getElementById('updateForm');
    if (updateForm) {
        fillUpdatePage();

        updateForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const originalUsername = getSelectedUser();
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const rePassword = document.getElementById('re-password').value;
            const email = document.getElementById('email').value.trim();
            const users = getUsers();
            const userIndex = users.findIndex(function (user) {
                return user.username === originalUsername;
            });

            if (password !== rePassword) {
                alert('Mật khẩu nhập lại không chính xác!');
                return;
            }

            if (userIndex === -1) {
                alert('Không tìm thấy user để cập nhật!');
                return;
            }

            const duplicateUser = users.find(function (user, index) {
                return user.username === username && index !== userIndex;
            });

            if (duplicateUser) {
                alert('Username đã tồn tại!');
                return;
            }

            users[userIndex] = {
                username: username,
                email: email,
                password: password
            };

            saveUsers(users);
            localStorage.setItem('currentUser', username);
            localStorage.setItem('currentEmail', email);
            setSelectedUser(username);

            alert('Cập nhật thông tin thành công!');
            window.location.href = 'view.html';
        });
    }

    const editBtn = document.getElementById('editBtn');
    if (editBtn) {
        editBtn.addEventListener('click', function () {
            window.location.href = 'update.html';
        });
    }

    fillViewPage();

    document.querySelectorAll('.pagination button').forEach(function (btn) {
        btn.addEventListener('click', function () {
            if (!this.disabled && !isNaN(this.innerText)) {
                const activeBtn = document.querySelector('.pagination button.active');
                if (activeBtn) {
                    activeBtn.classList.remove('active');
                }

                this.classList.add('active');
            }
        });
    });
});