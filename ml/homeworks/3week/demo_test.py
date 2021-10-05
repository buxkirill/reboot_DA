import streamlit as st
import pandas as pd
import numpy as np
from sklearn.metrics import mean_absolute_error
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split

st.title('Homework 3')
range_for_streamlit = np.round(np.arange(0.1, 0.351, 0.05), 2)
option = st.sidebar.selectbox('Выбери testsize', range_for_streamlit)

df = pd.read_csv('housing.csv')
X_train, X_test, y_train, y_test = train_test_split(df.drop('MEDV', axis=1),
                                                    df.MEDV,
                                                    random_state=42,
                                                    test_size=option)
model = LinearRegression()
model.fit(X_train, y_train)
st.write(f'Модель обучена с MAE: {np.round(mean_absolute_error(y_test, model.predict(X_test)), 2)}')

if st.button('Показать результаты'):
    st.dataframe(pd.DataFrame({'y_test': y_test, 'preds': model.predict(X_test)}))
