from flask_app.main import app


def test_root_route():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.data == b"Hello World of DevOps!"
