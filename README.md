# T3rn-Executor

##Node T3rn
Siapkan Private key EVM isi faucet

| Site | Wakwaw |
| ------ | ------ |
| Website | https://t3rn.io |
| Faucet | https://faucet.brn.t3rn.io |


minimal 0.1 untuk jalankan



### Auto Install 

```
bash <(curl -s https://raw.githubusercontent.com/zamzasalim/T3rn-Executor/main/T3rn.sh)
```



##### Command lainnya
Log
```
sudo journalctl -u executor -f
```
Restart
```
sudo systemctl restart executor
```
Start
```
sudo systemctl start executor
```
Stop
```
sudo systemctl Stop executor
```

Role kirim screenshot log nodenya kirim ke

https://discord.gg/9D428mKe


hapus

sudo systemctl stop executor && sudo systemctl disable executor && sudo rm /etc/systemd/system/executor.service && sudo systemctl daemon-reload && rm -rf executor-linux-v0.20.0.tar.gz executor && systemctl status executor
