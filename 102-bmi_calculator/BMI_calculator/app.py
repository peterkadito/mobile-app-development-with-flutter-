from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/calculate_bmi', methods=['POST'])
def calculate_bmi():
    try:
        weight = float(request.form['weight'])
        height = float(request.form['height'])
        bmi = weight / (height ** 2)
        remark = get_bmi_remark(bmi)
        return jsonify({'bmi': bmi, 'remark': remark})
    except ValueError:
        return jsonify({'error': 'Invalid input'}), 400

def get_bmi_remark(bmi):
    if 18.5 <= bmi < 25:
        return "Normal weight"
    elif 25 <= bmi < 30:
        return "Overweight"
    elif bmi >= 30:
        return "Obese"
    else:
        return "Underweight"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

