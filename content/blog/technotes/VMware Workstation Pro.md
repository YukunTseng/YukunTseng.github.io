---
date: '2026-05-12T16:30:29+09:00'
draft: true
title: "安裝「VMware Workstation Pro」並簡單建置VM"
authors:
    - name: Tseng 
      pageRef: /aboutme
---
本文記錄了從取得VMware Workstation Pro Installer檔，到實際安裝、建置VM的過程。
<!--more-->

### 前言
筆者搭建VM測試環境時向來都是選擇VirtualBox，原因不外乎就是它開源免費、搭建快速與輕量方便，對於只是想要一個簡單VM的人來說相當友善。而商用VMware產品「Workstation」與「Fusion」等由於license因素，通常不會是個人使用或學習者面向的選擇。

不過相信很多人都已得知—
>*VMware Fusion and Workstation are Now Free for All Users*

VMware官方於2024年11月宣布旗下虛擬化桌面軟體「Workstation 」與「Fusion」正式開放免費使用。

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/d79882df-77a6-4c8d-8475-12a4115194db.png)

*[VMware Fusion and Workstation are Now Free for All Users](https://blogs.vmware.com/cloud-foundation/2024/11/11/vmware-fusion-and-workstation-are-now-free-for-all-users/)*

相比VirtualBox，VMware擁有較好的CPU和記憶體負載管理，我想最直觀的感受上，就是同時運行數個VM時，VMware的反應給人更加靈敏，UI lag程度較低，使用體驗當然更佳。

而現在能夠免費使用這套擁有豐富業績與商用市占率的軟體，想想還滿令人意外的。因此個人往後也在考慮使用VMware來代替VirtualBox做為自己的測試機與lab。

這次就來試試看在個人Windows電腦上安裝VMware Workstation Pro，並且簡單搭建VM。以下為從取得Installer開始的過程，流程上並不困難，只是稍微有些繁瑣，供大家參考參考。

---

### 1. 取得VMware Workstation Pro Installer

#### 1.1. 前往產品列表頁面

首先前往VMware官方網站: [VMware by Broadcom - Cloud Computing for the Enterprise](https://www.vmware.com/)

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/58921f36-d216-4be6-9603-23fed08c819d.png  "點擊進去後的畫面↑")

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/c88c748c-468c-429b-bc4d-20cdfe9cc185.png "接著展開上方「Products」列表，會看到下方有個「SEE DESKTOP HYPERVISORS」，然後點擊它")

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/cf0ba1c1-619d-4107-b7f5-0d815e1ce64c.png "出現Fusion and Workstation畫面，選擇「DOWNLOAD NOW」")


#### 1.2. 註冊Broadcom帳號(尚未註冊者)

接著會遷移至Broadcom的註冊畫面(由於VMware已被Broadcom收購，相關產品的存取動作需透過其官網)

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/796d3f6f-c4d1-4536-acb7-228e8a6dad8a.png "如果你先前已註冊過Broadcom的話則直接輸入Username，若無的話則依序點選右上角 LOGIN > REGISTER 來進行註冊")

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/5f3c7e43-bda1-4554-b07a-7456baaa3a5d.png "註冊畫面會出現，在這裡使用信箱註冊")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/064fc789-670b-42c9-bd01-908c03d3e5c2.png "依照指示完成收取認證碼進行驗證")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/adeb77bd-a0c9-4ce2-add5-29085df9b483.png "接著輸入姓名、國家、密碼等資訊，輸入完成後點擊「Create Account」按鈕")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/1fe8192b-875c-4e7e-bac1-6a8d62fe664c.png "這樣帳號註冊基本上已完成，系統會詢問是否要透過完成建立profile來解鎖更多服務，這裡我是跳過，直接選下方的「I'll do it later」")

#### 1.3. 登入Broadcom帳號並取得Instller

畫面接著會跳轉回到Broadcom官網
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/4faef7ab-34e9-4327-9492-214913c2c2b5.png "點選右上方「Login」鈕")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/b4c10e14-a1d9-47a1-8e56-e22cc57e39a0.png "回到先前登入畫面了，在此輸入剛剛註冊的帳號密碼來登入。另外，Username欄請輸入你剛剛註冊的信箱")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/607f32fa-d202-4d49-8279-27bce798bcf2.png "登入成功後，點選畫面右上方icon當中任一個選項")

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/48c3f601-a6d2-4ddf-b910-948a78961a76.png "這樣畫面就會遷移到「My Dashboard」，然後展開左方選單")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/6b04b823-9179-490e-9578-37dc7aa00a44.png "進入「My Downloads」頁面，再點選「Free Software Downloads available HERE」")


※Mac使用者想使用Fusion的話在此列表裡也找得到↓
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/1f1ef5c8-a2bc-4cb9-a27c-f3efc57afe83.png "接著會出現產品列表，找到我們要找的VMware Workstation Pro並點選它")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/e513f45a-a489-4bd5-b759-e66f61393f37.png "這次我選擇「VMware Workstation Pro 25H2 for Windows」，並選擇發行版「25H2u1」")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/d9b34939-893f-47e4-815b-442de892816d.png "展開使用條款後，勾選「I agree to the Terms and Conditions」")

![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/0c4565f5-f808-4d72-bfeb-d83eca1e7529.png "右下方下載按鈕即可點選")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/81c5ee60-2257-417a-b1cd-44369f80d7f5.png "出現「Prior to downloading this file, additional verification is required. Proceed?」(下載此檔案之前須完成追加認證資訊。是否繼續?)，點選「Yes」")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/a634dfec-8b0b-4524-8f16-09545b505522.png "接著要填寫英文地址等資訊，大概填寫之後，點擊下方「Sumit」按鈕")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/88502803-de9a-410c-b9d6-fe9bfecbf5ae.png "畫面又將返回剛剛的下載頁面，再次點選右下角的下載icon按鈕，Installer下載就開始了")


---

### 2.開始操作VMware Workstation Pro

#### 2.1.安裝VMware Workstation Pro
點擊Installer開始安裝。基本上只須照著Wizard指示一步一步進行即可
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/d3e6c89b-33e6-49f0-9984-baad4ec0d499.png "筆者OS語言設定為日文所以Wizard畫面預設為日文")


![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/4bfc4cbe-0289-4307-8258-2137bddb36f7.png "安裝完成，軟體啟動後畫面如上")

接著來就用我手邊現有的RockyLinux 10.1 minimal iso檔來快速試試搭建。搭建流程與VirtaulBox大同小異。或許是VirtaulBox用習慣了，Workstation主控畫面給人較簡潔洗練的感覺。點擊紅框處的建置新虛擬機器
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/454e6ddd-6a19-464c-97a3-79cbb65a4312.png)

#### 2.2.安裝VMware Workstation Pro

接著VM建置精靈視窗就會啟動了。接下來的VM資源配置步驟跟其他虛擬化軟體如VirtualBox等都差不多。這裡我選擇第一個標準搭建模式，然後點擊下一步
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/73cf9281-8fe3-4fe7-af4e-61ca24023c1a.png)

這裡我將手邊現有的iso檔插入，精靈視窗就會自動偵測出OS。然後選擇下一步
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/f1863065-100e-41e6-99ad-f2936f27533d.png)

在這裡輸入虛擬機名稱，點擊下一步
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/87a0ad3c-6c0b-43e1-b1ac-94ad622e14f6.png)

接著分配Disk容量，受限於我筆電容量，這裡我先給一個很小的容量，之後有需要可再回頭擴充。分配好了之後選擇下一步
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/76e0448e-385b-4e40-9894-7ecc40c10bf1.png)

接著馬上來到總覽畫面，標準快速搭建至此基本上完成，如果需要自定義更多硬體資源細節，選擇自定義硬體
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/ee3d94e5-5089-4c46-be1d-f3cd2830a709.png)

自定義視窗就會打開，在這可以依需求配置記憶體、CPU、網路模式等硬體資源
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/459d56dc-e228-4c44-8571-c79c69c5336f.png)

這裡順帶提一下，標準搭建的預設網路模式是NAT，這裡我想讓VM跟Host機在同一個LAN，所以我選擇橋接(Bridge)模式。如果你有需要再另行追加像是network interface等硬體資源的話，可點擊左下方的追加按鈕
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/b7b2295d-bd80-4001-8e1e-1cd4490a50f5.png)

就會出現硬體資源追加畫面，再依照個人需求進行調整，好了之後選擇完成
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/85368dd8-b9ea-4d52-b7e0-e0a244a06eac.png)

回到總覽畫面，確定好後點擊完成，系統就會依照剛剛的配置來搭建VM了
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/1ffe34b9-aef8-469d-ba77-e12ca4fa00c5.png)

搭建好後，VM預設power on。並且Workstation主控畫面左欄的VM一覽，可以看到搭建好的VM了。接著就可以自由使用了
![圖片.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4427513/9c7b6709-3e7f-4e99-a2e2-3bff2166af8d.png)

-------------------------------------------------------------------

### 最後
本文記錄了從一開始取得VMware Workstation Pro Installer檔，到實際安裝、建置VM的過程。除了一開始取得Installer步驟較繁瑣，其餘安裝之後的VM建置流程概念跟其他虛擬化軟體是一樣的。
相較長時間使用的VirtualBox，VMware Workstation Pro體感使用上最大的覺察，應該是主控畫面UI質感提升了一個檔次，使用起來簡潔直觀舒適，能感受到一定的商用質感。
下載安裝VMware Workstation的教學與文章很多，感謝您選擇此篇並且閱讀到最後。
