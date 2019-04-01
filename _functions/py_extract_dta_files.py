def construct_destination_paths(source_filepath, country, survey, year, who_folder):
  dataset_path = Path(source_filepath)
  dataset_folder = dataset_path.parent
  dataset_filename = dataset_path.stem
  new_filename = f'{country.upper()}_{survey}_{year}.dta'
  destination_path = who_folder / '1_dta' / new_filename
  return str(destination_path)

def copy_file(source, destination, verbose=True, skip_if_existing=True):
  if skip_if_existing:
    if os.path.isfile(destination): return  # Skip the copy
  try: 
    shutil.copyfile(source, destination)
  except Exception as e:
    print('Failed to move ', source, ' to ', destination)
    if verbose: print(e)
  if verbose: print(f'From {source.split("/")[-1]} to {destination.split("/")[-1]}')