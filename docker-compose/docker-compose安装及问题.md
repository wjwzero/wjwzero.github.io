
```
    yum -y install epel-release
    yum -y install python-pip
    pip install --upgrade pip
    pip install docker-compose
    //国内原加速
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple docker-compose
    
    docker-compose --version
```
问题:

    ERROR: Command errored out with exit status 1:
     command: /usr/bin/python2 -c 'import sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-CHr4dj/pycparser/setup.py'"'"'; __file__='"'"'/tmp/pip-install-CHr4dj/pycparser/setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/pip-install-CHr4dj/pycparser/pip-egg-info
         cwd: /tmp/pip-install-CHr4dj/pycparser/
    Complete output (17 lines):
    Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/tmp/pip-install-CHr4dj/pycparser/setup.py", line 65, in <module>
        cmdclass={'install': install, 'sdist': sdist},
      File "/usr/lib64/python2.7/distutils/core.py", line 112, in setup
        _setup_distribution = dist = klass(attrs)
      File "/usr/lib/python2.7/site-packages/setuptools/dist.py", line 269, in __init__
        _Distribution.__init__(self,attrs)
      File "/usr/lib64/python2.7/distutils/dist.py", line 287, in __init__
        self.finalize_options()
      File "/usr/lib/python2.7/site-packages/setuptools/dist.py", line 302, in finalize_options
        ep.load()(self, ep.name, value)
      File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2341, in load
        return self.resolve()
      File "/usr/lib/python2.7/site-packages/pkg_resources/__init__.py", line 2351, in resolve
        raise ImportError(str(exc))
    ImportError: 'module' object has no attribute 'check_specifier'
    ----------------------------------------
ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.    


> sudo pip install --upgrade pip
> sudo pip install --upgrade setuptools

参考：
> https://www.cnblogs.com/liubiaos/p/9444485.html
    