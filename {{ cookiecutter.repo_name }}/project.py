import questionary
from cookiecutter.main import cookiecutter


base_choices = [
    questionary.Choice("Add a general python submodule", value=0),
    questionary.Choice("Add a general R submodule", value=1),
    questionary.Choice("Set up GCP infrastructure (VPC, storage, VM)", value=2),
]

base_selection = questionary.select(
    "What do you want to do?", choices=base_choices
).ask()

if base_selection == 0:
    cookiecutter(
        "git@github.com:lizard-bio/cookiecutter-analytical-project.git",
        checkout="feature/switch_to_functional_setup",
        directory="block/python_general",
    )
elif base_selection == 1:
    cookiecutter(
        "git@github.com:lizard-bio/cookiecutter-analytical-project.git",
        checkout="feature/switch_to_functional_setup",
        directory="block/r_general",
    )
elif base_selection == 2:
    layer_choices = questionary.checkbox(
        "Which infrastructure layers do you want to set up?",
        choices=[
            questionary.Choice("VPC (network)", value="vpc", checked=True),
            questionary.Choice("Buckets (data storage)", value="buckets"),
            questionary.Choice(
                "Compute (VM with JupyterHub + RStudio)", value="compute", checked=True
            ),
        ],
    ).ask()

    deploy_now = questionary.confirm(
        "Run terraform apply automatically after generating files?", default=False
    ).ask()

    cookiecutter(
        "git@github.com:lizard-bio/biolizard-cloud-vm-provisioning.git",
        extra_context={
            "deploy_vpc": "y" if "vpc" in layer_choices else "n",
            "deploy_buckets": "y" if "buckets" in layer_choices else "n",
            "deploy_compute": "y" if "compute" in layer_choices else "n",
            "deploy_now": "y" if deploy_now else "n",
        },
    )
