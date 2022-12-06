Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E359FC3A5A7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 19:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiLFTUp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 14:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLFTUo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 14:20:44 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D884198A
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 11:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670354440; bh=fozIFMZ4GJnO58X4QcmgwMManFljlwVdtdz6QBky50g=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=qp8997Hk9xiYJAOB/JeWlcTyhf65wCRJHxgSTKiJ3Yx6c+Occ7+Vmszv/1YIg4t8N
         WTQ6eK8m2Wvu/47b9F6fi+JhdW2D+pUDTE+EymGDDCuO7adbvuW1kKQ+oW28X5EdNx
         JO2mPp6rRDTrAkTBJ8YIJ3YNym+LOayPRsCEe3QE8JpUNL2G5KCIbfyEyKgKpMPQci
         +rA/DVd23J2sB6zcbHm3ezDY118LGZfDuWVuxlkhPOBYc/nARt35BJkEXR7IyYW6q+
         IW44c1G02BTnTz2BigyCVcxnyw8mDfT6e8Uox+b10vy3DIeA1QSdmdCkA0+bEa36Zn
         tvwxjePsDKoHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.87.22]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mof9P-1oe3KD28Az-00p7ky; Tue, 06
 Dec 2022 20:20:40 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v2 0/6] crypto/realtek: add new driver
Date:   Tue,  6 Dec 2022 20:20:31 +0100
Message-Id: <20221206192037.608808-1-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:T1aFadbkNPuKyObUy3J/pG5foTAD8HG3USJT+Zx85cxqpVojTLD
 RkLBDisIcyKy9xyUjeRrKv6YqzgBiJ/Cxz5TywyImEaCqWxD5DKtY+v4znjEUjV2tRLFkr3
 4zd74sMP9PfIEV+oeSsoqqDKaiOwBIecqDLx2FQWXxNYNsGj1SvEmEVbLQbzjeeRKf+cnIb
 NnKJHin/JeIXGCSO7tYbQ==
UI-OutboundReport: notjunk:1;M01:P0:5tbUTzDlYHM=;IncVjNlVxh2pC1tyjJDOa26ONVQ
 ec4t+d2N78j0d3R+pmzBMAIOVcpPwCLCDYlVufUeE8PMhqFFHkJ6HPzXkIOaxo6vG11JyhSuA
 KblzQWmpRFzR40ytCblQ0q6AbUB0JN02O4nEMyYF/D0jNkiIvCt08D8wzZCu22UbqhuPv6ycj
 j99XB9t0ySPUGJRLkoAhzsbpy1Np5MSDG49SfRXOiG0NF2EJmOJH2dAl3jkDYREhZUo7bYVTF
 FvOXJNndccpk4IsJehYMKrfzx54XLki78YVi/M5QJr2nQe3n4JkexrlNVvDksEwEDuZEy2w91
 /5V2EAWa5czhbkHl2ut6mn5WCtVLNOmzMMhiUI4lyCCYNhbT1PGiN9pZNO/G00q6jr5W9e16u
 TtB6w5F0euH2srPD/NOV48GfFMhKINNCL5k8EYELes8lbTF36H5Z8mP1FUTzYVb+8oBVwmFRH
 JcaFix4d1h4EKqQDC1GlPgXS1z/MGWkgFZonacQNshfd1x+sGPsHbhTT9i2kJ2AUyNSJuAhCr
 Uhx/xKLccpuevt9IWo/SnFRPAYRn1FLblU7nxhFoGxvY1Tangyyp5a7TSiyUCYBL9hNOw56WW
 wSZMh93yXayV/x+nkZHgRgmF1A6c01k11ByfmiKV+LaHNBrLqN9B2eCjmMCmBojKvxCu0rbRa
 2R1xLukBxTQgahGRDqRWzTpjhrXYQqmgJqONX5R2ZF+PM7ndgPPFJfUqnTr7g9c3v68gaHxNy
 tK0H+04cKskLNtR8t7uJrOQpaPSK3KQtFJLCJSKq5/LSKM3kxjw60b2YeZmkmAJUlWWzdd5ON
 ipfj9Jix4V3588zt02QrMG3Sv0tQ9DabrbZYxLwtk4r4edfd06639K/y1PIWm+2aZD9Y9pbE6
 xfghe60LXzqrNnjl/pD6gN4KKlIRgNKm+KS2SRIqWqWEWfzQPnpl32Dj5DO9F0d4oD2C/chzt
 Wv43ScPhV6ZftImpGAWI4SQqAY4=
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
drivers/crypto/realtek/realtek_crypto.c                |  472 ++++++++++
drivers/crypto/realtek/realtek_crypto.h                |  325 ++++++
drivers/crypto/realtek/realtek_crypto_ahash.c          |  406 ++++++++
drivers/crypto/realtek/realtek_crypto_skcipher.c       |  361 +++++++
8 files changed, 1634 insertions(+)



