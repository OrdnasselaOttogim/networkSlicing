from flask import Flask, render_template, request, redirect, url_for
import subprocess

app = Flask(__name__)

# Mapping slice IDs to slice names
slices = {
    0: "production",
    1: "management",
    2: "development"
}

slice_states = [False for _ in range(3)]

def activate_slice(slice_id, action):
    # Logic to activate or deactivate slice based on action
    slice_name = slices.get(slice_id)
    if slice_name:
        # Example: print a message indicating the slice activation
        if action == 'activate':
            print(f"{slice_name} slice activated")
        else:
            print(f"{slice_name} slice deactivated")

@app.route('/')
def index():
    return render_template('index.html', slice_states=slice_states)

@app.route('/activate/<int:slice_id>', methods=['POST'])
def activate_slice_route(slice_id):
    action = request.form['action']
    activate_slice(slice_id, action)
    if action == 'activate':
        subprocess.call(f"./scripts/{slices[slice_id]}_slice.sh")
        slice_states[slice_id] = True
    else:
        subprocess.call(f'./scripts/deactivate_{slices[slice_id]}_slice.sh')
        slice_states[slice_id] = False
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
