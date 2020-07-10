import pip #needed to use the pip functions
          for i in pip.get_installed_distributions(local_only=True):
          print(i)