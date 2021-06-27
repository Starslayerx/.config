- [jupyterlab-toc](https://github.com/jupyterlab/jupyterlab-toc): 目录结构
```shell
jupyter labextension install @jupyterlab/toc
```

- [jupyterlab-drawio](https://github.com/QuantStack/jupyterlab-drawio): 流程图
```shell
mamba install -c conda-forge jupyterlab-drawio
conda install -c conda-forge jupyterlab-drawio
pip install jupyterlab-drawio
```

- [jupyterlab-execute-time](https://github.com/deshaw/jupyterlab-execute-time)：执行时间
```python
conda install -c conda-forge jupyterlab_execute_time
pip install jupyterlab_execute_time
```

- [jupyterlab-spreadsheet](https://github.com/quigleyj97/jupyterlab-spreadsheet): 表格
```python
jupyter labextension install jupyterlab-spreadsheet
```

- [ipympl](https://github.com/matplotlib/ipympl): 交互式绘图
```python
conda install -c conda-forge ipympl
pip install ipympl
```
> %matplotlib widget

- [plotly](https://github.com/gnestor/jupyterlab_plotly): 交互式绘图
```python
pip install jupyterlab_plotly
# For JupyterLab
jupyter labextension install --symlink --py --sys-prefix jupyterlab_plotly
jupyter labextension enable --py --sys-prefix jupyterlab_plotly
# For Notebook
jupyter nbextension install --symlink --py --sys-prefix jupyterlab_plotly
jupyter nbextension enable --py --sys-prefix jupyterlab_plotly
```
