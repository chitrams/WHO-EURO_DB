# Set path to home directory
my_cwd = os.getcwd() # Returns a string representing the current working directory
who_folder = Path(my_cwd)

# Set index file
df_vars = pd.read_excel(who_folder / 'indata_index' / 'List_of_Datasets_2019.xls')