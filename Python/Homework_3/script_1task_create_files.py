from price_wwp_homework_python_reboot_da import *

if __name__ == '__main__':
    dbc = pd.read_excel('cur_oil.xlsx')

    PRODUCTION_COST = 400  # (EUR)
    BARRELS_TO_ONE_TON = 16
    EU_LOGISTIC_COST_EUR = 30
    CN_LOGISTIC_COST_USD = 130

    try:
        os.mkdir('Task1')
    except:
        pass
    clients_list = ['Monty', 'Triangle', 'Stone', 'Poly']
    filepath = os.path.join('Task1', 'DDP_price.xlsx')
    with pd.ExcelWriter(filepath) as writer:
        for client in clients_list:
            dbc[f'DDP_price_{client}'] = dbc.apply(lambda x:
                                                   get_price_with_discounts(date=x.Date,
                                                                            oil_price=x.OIL,
                                                                            eurusd_rate=x['EURUSD=X'],
                                                                            client=client,
                                                                            discount_on_price_a=True,
                                                                            discount_from_volume=True,
                                                                            add_logistic_cost=True,
                                                                            barrels_to_one_ton=BARRELS_TO_ONE_TON,
                                                                            production_cost=PRODUCTION_COST,
                                                                            cn_logistic_cost_usd=CN_LOGISTIC_COST_USD,
                                                                            eu_logistic_cost_eur=EU_LOGISTIC_COST_EUR),
                                                   axis=1)

            dbc.loc[:, ['Date', 'EURUSD=X', 'OIL', f'DDP_price_{client}']].to_excel(writer, sheet_name=client)

    try:
        os.mkdir(os.path.join('Task1', 'Clients'))
    except:
        pass

    for client in clients_list:
        filepath = os.path.join('Task1', 'Clients', f'{client}.xlsx')
        with pd.ExcelWriter(filepath) as writer:
            dbc.loc[:, ['Date', 'EURUSD=X', 'OIL', f'DDP_price_{client}']].to_excel(writer, sheet_name='DDP_price')
