Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F874C43219
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 18:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJMSoE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiJMSn1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 14:43:27 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D18917D865
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665686429;
        bh=pa627hHCH4XvoenmN7b1ozZmVDCAJga7SwCgpoWlv7c=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=YAmP1HSaEzIWQFWuu7RcMQuXBQgpqhudxhFTWxW9GGLPBX64hN4WCelXq9YEmBpn9
         OM/sBYYBeKOuSt8+UfjufkxJ64k2mb0bflVZGa1W5SI0CAPd3vGo++Gpj2etXJhw7q
         b5jJG3YFdg2uunk4Zmkaf3VpVxbT7tOj/zlMRsjU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fedora.willemsstb.de ([94.31.86.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MXp9Y-1odUht19US-00YBVB; Thu, 13
 Oct 2022 20:40:29 +0200
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH 0/6] crypto/realtek: add new driver
Date:   Thu, 13 Oct 2022 20:40:20 +0200
Message-Id: <20221013184026.63826-1-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BKV//vM0ihh2fNBpCq1bi2j6EphNZzKvCBccyyQQptlz3v3peoM
 mQdjKK9OdcWstkVbqQJe3ijKOHlQk+k7XNpZmsZcPnVWcnRoGXa1DNGGUIEQtXCJ3Ogo/JT
 zzWhZcgXe6ZYTnzm7SoTK7FqlOFrYIOUBPGWIcxNMOSizSc5rnDbw3GWSEl6MuJd1cjzLUe
 LEfxNG8hwvgx6r+EcD9oA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tQT6JSGZccs=:28uyKNMgVB/+qMt+okoZ+t
 M2FQyTzG9+hfqLnyoZFOiiphc/X1+a0gNNMzEiA4Rq22lKNaEePrwWcp4cHh41C10pW79uc5z
 /diLXjxaYmN1UiNYTd2kv+AYEeQpU6Qo4uSct9buGIwnDH5x1t4bwoVZb0wMFVMnRD/Yakv/z
 BbrAJZCKjy4SqAeYPJA+HCE1eCyMnOZqJ92fv9oP4ZuM3o5ZUstMlN5fAUjvnVnTQFsfrWUp/
 6fsBqGZXByTKP2KZf51gLJChIpH2TJTrN81dzaSu/5uh4tyJwtx+wNSXWpCuhX2awaIwvJ9f0
 oYeGxQ5xebpjGWnJUK4djjT3Un9zw0g74h/0ikD6RFW2DTg1XLPbR9BoIH7gixQDvVXIQdsMa
 0ldULOA07vgLijHA/f2NNyxG+dREbg94y6FkedKCqHFUol1giPVZ2tTQm+Ittys6qfmo8oci+
 Jga+dAsVdoyVLq39mn/CN7pKT4kQbA1Tu9DR7a4zjsoQ3T6F9aOY7tbEAoCL8mHp2ogSwSvza
 erN6S0yuMNlY48u+lbDPAf4Pej89AYurMpZg93mGQIFGa9Uw2DxS/KI+4murjFVKRpK0EgKTx
 /1hSu1uEd3FV2MjZJD6nmzrl+JwBJIy842hWfLqkoyMP/0z2+5fy/y8d7O1jR42ev2j8GS16K
 a6NDqFoxAm2HsrSJCPyPfJqcT2Rrw0WrrERwO9TBXTPvA1aVHOxxLLhHJG1z8lGFqfraV7fxh
 HN663OUX3AMQxvr49THfcxbIZ01a9F2Wf9n1BcdDRMc4hzLpERMwfT5C9iWatqr7zznYTuIz+
 U6pROGVsK3MbaYzUDq44TlyKhnkOOzwmDa5xfTMDUTS08ecIIi87xnQr/V4nc9Ti+7+F1hB+1
 8sTOSAxTCQtvQzxfIbrkucy7TSWaqXoA54q9eGCKowR/4TiU6L4rduZ0XIe3wds923C/Zk9BC
 eD3Fv/pnamH4d13FHiQH5/de6wOe3F1nwWgLJzs/bdq8/9OA9ngRNorHGyhuDETCI3/MZbw+F
 teBf6tDwr5fn8UJ3x6UsATmLRbBYG9fETI4oEfNVWL2bg6WzcCmTFT/ZvxsW32MWx66ZqTisu
 iWWKhO30m33UkCGvpzcYNQhD9phRcYPmO0Xx3ZelZuBuB8fSSfCLFpn7I8aWuyQLxKnNQn6LC
 KpWCSfTfC6NBKSK3xgMqx3TcOGcv9aUqdTsTtvG1yoXBXmltH2s7P9jz8TQX3zD6uLSW8p9fz
 8uPiHoRTKkhCmwJtcfa0PuZnqZyk1vQf5THOKcxZxzU+RK1WRgIWXg7RYCtkHXZlQUH5Pj2dP
 uLlJNpQam7k4MIy8QOZsXCIhKTAa6V3ag6VUj93Dwm4Gf+9OrNv72apPfm4oO5+tPz5i4Rozy
 DEJN9PnRRtDD1ZoHy/ujvNGZCL0cXpBHRLnK8FSrf7g4C9xfxfslShpER+L/WcTn22nV9zcTJ
 Y8HJiiPMwAR0WJH+SfCfvqie+zQPQC5r0HAdY5hEUTpHdFXeRKhTQEN8A4Xd7R5BN8seQNE1H
 IxQNS/s3uC3SRzFrQTeUS9cQbePnXmKAhbqAXaOVcnAaw
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
drivers/crypto/realtek/realtek_crypto.c                |  472 ++++++++++
drivers/crypto/realtek/realtek_crypto.h                |  325 ++++++
drivers/crypto/realtek/realtek_crypto_ahash.c          |  406 ++++++++
drivers/crypto/realtek/realtek_crypto_skcipher.c       |  361 +++++++
8 files changed, 1634 insertions(+)



