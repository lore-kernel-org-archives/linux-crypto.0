Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78889C4167B
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 16:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiLaQZd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 11:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLaQZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 11:25:32 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9A5630E
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 08:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672503929; bh=FSGTNdyza7Lhril4xYuFuSIrueTYcTx7avu6zSO8+74=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=C117GTNVCZpU2jzUD+mui92Q4HgPB31Fr8muuc6LtkzPbz/m3FANhMSxaB9Vtgg4H
         zcuVLSjOJg6kyxnYxlRjsm2EvxSxxHu2y0tRTU1+ZwC/v0YVy0g72JDCwO2JRAXoCk
         QeFfIZxBruz2ifQ7PU03hv3jp/9heKRuUkB4aZWEjaeWa6zspeKsHiOo5+/Aer5DaN
         BC7+4q5fOkJdN3PA2ru/JTizr4YKPWTv14/J0pBwgb/vgc6bWx0isO5PeAUgP4eVju
         Y13+AKad2qcOhIjMOgRC7ACs/G8t4eWTgvFu1vZk5Xs0mkLFbQCyIwyIbE7gVjf9Sh
         oJsEKzfNUAU0Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MGhyc-1oyzDG41Lu-00Dpef; Sat, 31
 Dec 2022 17:25:29 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v3 0/6] crypto/realtek: add new driver
Date:   Sat, 31 Dec 2022 17:25:19 +0100
Message-Id: <20221231162525.416709-1-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KyGj4LnOWSlJ9Cve61wGQkFvAuAfITocCE3KKvU6JnHGNN27CQF
 ntc+WWe6J+pxsPX8bXyfnzk0qgpGWHFofTGqXwOc/UciGeQ/wGk5TR5j4nfEG9806Lpseui
 IOuysFQe/ckUtrBC+CbMz0EI0ACQ1ACpZ/gsIaRzzSmNxMVIB5FAC+rQWv1Yg4kXuRNy5Cl
 IuFn737zDXoUYBfz4M2pA==
UI-OutboundReport: notjunk:1;M01:P0:GmeYEiQJLZI=;QKThs0THxmX111lm09MDD8XC3OK
 6/wtFw3eAcRXSB1APZKWy5Ni+1vlcbCwjsG9bBe/ZiKRsM4oslTA9XffA491NXoaRzIbWWn/b
 yKHCqy5WNrdvlBQy1dUyamoFBNeNYb0suMnIUq024aY5VXJu6c2yH1kvXrb0osEg6h8TublSz
 pwjrm1Llcgjxbh4X5qix31++ILWJEgSO7cPwFGqk6FXH50kht/NQWQkTB5NquRPuiIGUIVr5r
 p0RkhKsYx8bJQ/8bglua6Y/RrvNGEBm24uV35OhSR+lg/TSixXsh3kh2uRweNL57csmmolDL8
 gRPjIZ1/8T5TOB3OKg0nDGK8gSOPiquNfP8vHILXGYak8xIVztDiwWwFDchoR4ICV1jsVXV74
 CHoOZ81z904gVrWWVnnpdiiQ7aPbKCrPOgsc9QLW9LrPyYtPOR4PKJPje9r00UPJdzicPDEeg
 lRfzYeuhWKSzy6oTh7Mh3//gdAJ+2rHYMO07OVg536UtbFYDehpaPqW4bcyOun1aiy6Kji6rN
 JrX1IvNZ6Q8cX22GKHGStHk2DvyyaQlNCo4y5W2mA9oCoLXJfUdNsJfMocVI1EVLFb4LW61MU
 dKaGIVTB2MOAdEN/3/2+OTmREGnbf3lIaV4h3q/ZnYhQkfKSO21bBypE9HDp5nbUF4m+zH1Z1
 2ZWZZYIRLLzbjYMpQ2hXGN9vUGxbJJAr5M8+BsPtjPs136Ha0kkYkbRZ6kjeIfvbGZ/UXePxe
 hxvKso1rJ4agluSpeGOPbxOIomVHCPlAGhm2+k0mPYrBnYpnufMyeJUQ95aKIKCyjiYtZZS7K
 CgzEKs1avpIRzkC7+HLEYofxuRdFg6CtbRaeyhqzSglvlqkggIPwdAWDK/2SwYVoWm0gewcRP
 FFWXbWyqcKLjrGgpxQwZL1e/fnZKAuHe3P+/XkHsEhX97JVmR+Tefb3/yVr8dkazqaQhn05yi
 6nlcFA==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This driver adds support for the Realtek crypto engine. It provides hardwa=
re
accelerated AES, SHA1 & MD5 algorithms. It is included in SoCs of the RTL8=
38x
series, such as RTL8380, RTL8381, RTL8382, as well as SoCs from the RTL930=
x
series, such as RTL9301, RTL9302 and RTL9303. Some little endian and ARM b=
ased
Realtek SoCs seem to have this engine too. Nevertheless this patch was onl=
y
developed and verified on MIPS big endian devices.

Changes since v2:
- Use dma_map_single() & dma_unmap_single() calls
- Add missing dma_unmap_sg() calls
- Use dma_sync_single_for_device() only for mapped regions

Changes since v1:
- use macros to allow unaligned access during hash state import/export

Module has been successfully tested with
- lots of module loads/unloads with crypto manager extra tests enabled.
- openssl devcrypto benchmarking
- tcrypt.ko benchmarking

Benchmarks from tcrypt.ko mode=3D600, 402, 403 sec=3D5 on a 800 MHz RTL930=
1 SoC can
be summed up as follows:
- with smallest block sizes the engine is 8-10 times slower than software
- sweet spot (harware speed =3D software speed) starts at 256 byte blocks
- With large blocks the engine is round about 2 times faster than software
- md5 performance is always worse than software

op/s with default software algorithms:
                              16 B    64 B   256 B  1024 B  1472 B  8192 B
ecb(aes) 128 bit encrypt    513593  165651   44233   11264    7846    1411
ecb(aes) 128 bit decrypt    514819  165792   44259   11268    7851    1411
ecb(aes) 192 bit encrypt    455136  142680   37761    9579    6673    1198
ecb(aes) 192 bit decrypt    456524  142836   37790    9584    6675    1200
ecb(aes) 256 bit encrypt    412102  125771   33038    8361    5825    1048
ecb(aes) 256 bit decrypt    412321  125800   33056    8368    5827    1048
                              16 B    64 B   256 B  1024 B  1472 B  8192 B
cbc(aes) 128 bit encrypt    476081  154228   41307   10520    7331    1318
cbc(aes) 128 bit decrypt    462068  152934   41228   10516    7326    1315
cbc(aes) 192 bit encrypt    426126  133894   35598    9041    6297    1132
cbc(aes) 192 bit decrypt    416446  133116   35542    9040    6296    1131
cbc(aes) 256 bit encrypt    386841  118950   31382    7953    5539     996
cbc(aes) 256 bit decrypt    379032  118209   31324    7952    5537     995
                              16 B    64 B   256 B  1024 B  1472 B  8192 B
ctr(aes) 128 bit encrypt    475435  152852   40825   10372    7225    1299
ctr(aes) 128 bit decrypt    475804  152852   40862   10374    7227    1299
ctr(aes) 192 bit encrypt    426900  133025   35230    8940    6228    1120
ctr(aes) 192 bit decrypt    427377  133030   35235    8942    6228    1120
ctr(aes) 256 bit encrypt    388872  118259   31086    7875    5484     985
ctr(aes) 256 bit decrypt    388862  118260   31100    7875    5483     985
                      16 B    64 B   256 B  1024 B  2048 B  4096 B  8192 B
md5                 600185  365210  166293   52399   27389   14011    7068
sha1                230154  124734   52979   16055    8322    4237    2137

op/s with module and hardware offloading enabled:
                              16 B    64 B   256 B  1024 B  1472 B  8192 B
ecb(aes) 128 bit encrypt     65062   58964   41380   19433   14884    2712
ecb(aes) 128 bit decrypt     65288   58507   40417   18854   14400    2627
ecb(aes) 192 bit encrypt     65233   57798   39236   17849   13534    2468
ecb(aes) 192 bit decrypt     65377   57100   38444   17336   13147    2406
ecb(aes) 256 bit encrypt     65064   56928   37400   16496   12432    2270
ecb(aes) 256 bit decrypt     64932   56115   36833   16064   12097    2219
                              16 B    64 B   256 B  1024 B  1472 B  8192 B
cbc(aes) 128 bit encrypt     64246   58073   40720   19361   14878    2718
cbc(aes) 128 bit decrypt     60969   55128   38904   18630   14184    2614
cbc(aes) 192 bit encrypt     64211   56854   38787   17793   13571    2468
cbc(aes) 192 bit decrypt     60948   53947   37209   17097   12955    2390
cbc(aes) 256 bit encrypt     63920   55889   37128   16502   12430    2267
cbc(aes) 256 bit decrypt     60680   53174   35787   15819   11961    2200
                              16 B    64 B   256 B  1024 B  1472 B  8192 B
ctr(aes) 128 bit encrypt     64452   58387   40897   19401   14921    2710
ctr(aes) 128 bit decrypt     64425   58244   41016   19433   14747    2710
ctr(aes) 192 bit encrypt     64513   57115   38884   17860   13547    2468
ctr(aes) 192 bit decrypt     64531   57116   39088   17785   13510    2468
ctr(aes) 256 bit encrypt     64284   56094   37254   16524   12411    2267
ctr(aes) 256 bit decrypt     64272   56321   37296   16436   12411    2265
                      16 B    64 B   256 B  1024 B  2048 B  4096 B  8192 B
md5                  47224   44513   39175   25264   17199   10548    5874
sha1                 46389   43578   36878   22501   14890    8796    4835

Markus Stockhausen (6)
  crypto/realtek: header definitions
  crypto/realtek: core functions
  crypto/realtek: hash algorithms
  crypto/realtek: skcipher algorithms
  crypto/realtek: enable module
  crypto/realtek: add devicetree documentation

/devicetree/bindings/crypto/realtek,realtek-crypto.yaml|   51 +
drivers/crypto/Kconfig                                 |   13
drivers/crypto/Makefile                                |    1
drivers/crypto/realtek/Makefile                        |    5
drivers/crypto/realtek/realtek_crypto.c                |  475 ++++++++++
drivers/crypto/realtek/realtek_crypto.h                |  328 ++++++
drivers/crypto/realtek/realtek_crypto_ahash.c          |  412 ++++++++
drivers/crypto/realtek/realtek_crypto_skcipher.c       |  376 +++++++
8 files changed, 1661 insertions(+)



