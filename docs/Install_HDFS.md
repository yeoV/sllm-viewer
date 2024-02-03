## HDFS 설치

- 공식docs
<https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Execution>

### 설치 가이드

```
hdfs namenode -format
```

# 0203 일 hdfs Single Node local설치

### 주의 사항

- jdk 버전 1.8 -> 11 이상 시, 컴파일 오류
- JAVA_HOME 지정 필수

### 1)  Hadoop 과 Spark 다운로드

- hadoop-3.3.6.tar.gz

### 2) PATH 설정

- `vim ~/.zshrc`

```
#JAVA_HOME

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home
export PATH=$PATH:$JAVA_HOME/bin

# HADOOP

export HADOOP_HOME=/Users/lsy/workspace/Hadoop/hadoop-3.3.4
export PATH=$PATH:$HADOOP_HOME/bin
```

### 3) HDFS 환경변수 세팅

- etc/hadoop/core-site.xml : 하둡 시스템 설정 파일로, 로그파일, 네트워크 튜닝, I/O튜닝, 파일시스템튜닝, 압축 등 시스템 설정

```
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

- - etc/hadoop/hdfs-site.xml

```
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///$HADOOP_HOME/namenode
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///$HADOOP_HOME/datanode
    </property>
    <property>
```

- ++ webHDFS setting

```
<property> 
    <name>dfs.webhdfs.enabled</name> 
    <value>true</value> 
</property> 
<property> 
    <name>dfs.namenode.http-address</name> 
    <value>0.0.0.0:50070</value> 
</property>
```

- hadoop-env.sh
  - **여기에 JAVA_HOME 명시 안해줄 경우 에러가 발생했음 ㅠ**

```
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home
```

### 4) NameNode, DataNode format

- NameNode format

```
bin/hdfs namenode -format
```

- Can't create namenode/current 에러
- 하둡이 처음 format하는 것과 권한이 다른 느낌..?

```
chmod -R 777 $HADOOP_HOME/namenode
```

### ++ 비고) 권한문제 -> WebUI 에서 파일생성 안되는 경우

- 기본 user : dr.who
- hadoop.http 에 사용자 권한 줘야함

```
<property>
 <name>hadoop.http.staticuser.user</name>
 <value>your-hadoop-user-name</value>
</property>
```
