from peewee import *

database = PostgresqlDatabase('postgres', user='postgres', password='postgres', host='localhost', port=5432)

class BaseModel(Model):
    class Meta:
        database = database
        
        
class Courtrooms(BaseModel):
    room_no = AutoField(column_name='room_no')
    floor = IntegerField()
    capacity = IntegerField()

    class Meta:
        table_name = 'courtrooms'
        schema = 'court'
        
        
class Cases(BaseModel):
    case_id = AutoField(column_name='case_id')
    article = IntegerField()
    status = TextField(null=True)
    start_date = DateField()

    class Meta:
        table_name = 'cases'
        schema = 'court'
        

class Meetings(BaseModel):
    meeting_no = AutoField(column_name='meeting_no')
    room_no = ForeignKeyField(column_name='room_no', field='room_no', model=Courtrooms)
    case_id = ForeignKeyField(column_name='case_id', field='case_id', model=Cases)
    meeting_date = DateField()
    meeting_time = TimeField()
    court_decision = TextField()

    class Meta:
        table_name = 'meetings'
        schema = 'court' 
      
      
class People(BaseModel):
    taxpayer_id = AutoField(column_name='taxpayer_id')
    first_name  = TextField()
    last_name = TextField()
    passport_series  = DecimalField()
    passport_number = DecimalField()
    birth_date  = DateField()
    phone_number = TextField(null=True)
    home_address = TextField(null=True)

    class Meta:
        table_name = 'people'
        schema = 'court' 
        
          
class Companies(BaseModel):
    taxpayer_id = AutoField(column_name='taxpayer_id')
    name_of_comp  = TextField()
    email  = TextField()
    legal_address = TextField()

    class Meta:
        table_name = 'companies'
        schema = 'court'
        

class Roles(BaseModel):
    taxpayer_id = DecimalField()
    case_id  = ForeignKeyField(column_name='case_id', field='case_id', model=Cases)
    role = TextField()
    from_date  = DateField()
    to_date = DateField(null=True)

    class Meta:
        table_name = 'roles'
        schema = 'court'
        primary_key = CompositeKey('taxpayer_id', 'case_id', 'from_date')
    
 
class Docs(BaseModel):
    doc_id = AutoField(column_name='doc_id')
    case_id = ForeignKeyField(column_name='case_id', field='case_id', model=Cases)
    date = DateField(null=True)
    type = TextField()

    class Meta:
        table_name = 'docs'
        schema = 'court'
        

# CRUD к Companies:

Companies.insert(taxpayer_id='4440004441', name_of_comp='ООО Пивозавры', email='pivokruto123@email.com', legal_address = 'г. Санкт-Петербург, ул. Кантемировская д.1').execute()

for company in Companies.select():
    print(company.name_of_comp)
    
Companies.update(legal_address = 'г. Краснодар, ул. Красная д.2').where(Companies.name_of_comp =='ООО Пивозавры').execute()
    
Companies.delete().where(Companies.name_of_comp =='ООО Пивозавры').execute()


# Имя, Фамилия и количество дел в качестве адвоката для каждого, кто был адвокатом

for lawyer in (
    People.select(People.first_name, People.last_name , fn.count(People.taxpayer_id).alias('cases_amount'))
    .join(Roles, on=(People.taxpayer_id == Roles.taxpayer_id))
    .where((Roles.role == 'Адвокат истца') | (Roles.role == 'Адвокат подсудимого'))
    .group_by(People.taxpayer_id)
    .order_by(fn.count(People.taxpayer_id).desc())
):
    print(lawyer.first_name, lawyer.last_name, lawyer.cases_amount)
