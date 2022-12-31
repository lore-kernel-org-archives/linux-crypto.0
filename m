Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA18C3DA7D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 16:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiLaQZg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 11:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiLaQZd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 11:25:33 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC12630E
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 08:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672503930; bh=f9WWL0ZIKMD+NKnDzl903S+l3tToc5izqiOcKL+3HcU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OAlnRzjOcFhT0HsiPCLFfdEdX+y0PPvnY2ZbHfW/k3i8NoVOZ6+3J6G9k2cavbCOG
         tu85d+GQTcwNhmsqI9mWIPY1mr9iIlzh7l/UaUYdDAMxf5QexA3Oy3Z095RYFR/l5S
         aVEsjZdcMvbf2vwKPpSJFWTbyw9SLwk4Hj/WRqeaGex2Zb7NAdqoYJ9BGw7+EYPHMU
         wZCZwsnOkE6zphBzQuhZ9aXb7hZf5Z3cZLk/b8mWtDMcNrjr/91zji+ZsqDDps5QcI
         yRzj68wXxvq61zp39Db4ArtCPe5gK65wNZBMSTVKxbwBRWbrw7sq/9WBIAl7L1au5r
         IA5obbnVTDJnQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MmUHp-1oU2Nn1oG1-00iVdW; Sat, 31
 Dec 2022 17:25:30 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v3 5/6] crypto/realtek: enable module
Date:   Sat, 31 Dec 2022 17:25:24 +0100
Message-Id: <20221231162525.416709-6-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221231162525.416709-1-markus.stockhausen@gmx.de>
References: <20221231162525.416709-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QQuAgnK0oGMeEdysipYWnJ3A8WIT1VcVoplF5s3FVGDRu1KnkSb
 zchEVCmdfvUNBJ2YaUFLX1MiA+OLw5hOLHEQdBDUdCXnE9oj4somH2veWNzVgm/YdPUd1Wh
 5jGv4VwQ9nMytxKmPplIszLcczDYHizYJmoDuZaBwxmolmwtL4UyuWTjdLS75t6omnpAdjD
 rJ2zi0vXdOjxlEAy3/0dg==
UI-OutboundReport: notjunk:1;M01:P0:eSF56rc4TIA=;yJpxfafePR5kT1tKbDVmR8LRHUu
 kEntpEOEx+oOP4+gTA3C4FOq1Vhp/tcrtFbX6if99ebWxZ+tCskWv/tWVCa7Tcbh6wEKBf3fC
 5tBPV6s6vGdynY0GTNdjIp6Pv1aYdysbBVkk12dc5meNeLhc8YmwDlht9OrCgptm3Png7deOS
 3gnt68OwQEIXSJ7qHXZB8abyShSaQ3Iif6ixF4vS8WeNFNvzNiG5+z8jlYFa0R64fUwaj4hBX
 vykUkjpwIe3PxTigKVqiSGSuPxnmz9lyhy3snruW/7vo9ovYq2vPA8jtQzFb45NffnBE75aYo
 c+Hwi8XTWeHBXAmC2lJojHxIlPhVT7krwB57T3Jb+T+p/1q1cYi4ijWnGCKbxC0zrOSWMgApm
 NFgRanmQzG8Zn4k9HTKQfNa+U4WKE3HWl7It+9SsvkNaWQ94MI4YfEyzytqI1bwe7/gbigYPM
 hbXpKMucqWPiBlM4dfcxgH03jo3YvmH69PQqfIRawEX+7xIsg7Y+mi48mhbOnxBVUanoBdU8L
 ZiG2lUKHnc5ifna7N8Z2AT0cJnTHQYOXIxbxHYYrQda5RAmW4xlEVmiEzvZH8+QMzAPtlrvFT
 6RR0TXpuuQO35fQZWpFat1Vd3CO/d/pCwqSi9ZGFSUfY+ArvNZ0a0fnLHILMoKXzuPBzBVwQO
 w9yp+QhC/ucO6UVQ9/PV1AHlAEryvt7c6A4io+fDiBZvcup+jyPi8TSyQUsquJnMOQYz07hKl
 0caGWiMoJey6lmAY1dcmyw46kUQuIeDtF0av+b6+F6unrEkzk4ghkzWmFEP44K9+5hJ/Phheu
 f+kxvfCBujbgnLOE0NNx4/KJewbmi4aEbUDcQsiu3Im6pf0KdUeOZ0hs6+vVgtgajy96mEEhh
 ++RwYnZBcW+7z/MGkkH25G06u6eSZ6YXDc9i/4b9HY2aGF5HH4WinT1pYYrx9Kx1Bc/91QSDM
 PHUeYqTdp5wGLuc+hnX6U4LzAwA=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new Realtek crypto device to the kernel configuration.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 drivers/crypto/Kconfig          | 13 +++++++++++++
 drivers/crypto/Makefile         |  1 +
 drivers/crypto/realtek/Makefile |  5 +++++
 3 files changed, 19 insertions(+)
 create mode 100644 drivers/crypto/realtek/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 55e75fbb658e..990a74f7ad97 100644
=2D-- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -666,6 +666,19 @@ config CRYPTO_DEV_IMGTEC_HASH
 	  hardware hash accelerator. Supporting MD5/SHA1/SHA224/SHA256
 	  hashing algorithms.

+config CRYPTO_DEV_REALTEK
+	tristate "Realtek's Cryptographic Engine driver"
+	depends on OF && MIPS && CPU_BIG_ENDIAN
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_AES
+	help
+	  This driver adds support for the Realtek crypto engine. It provides
+	  hardware accelerated AES, SHA1 & MD5 algorithms. It is included in
+	  SoCs of the RTL838x series, such as RTL8380, RTL8381, RTL8382, as
+	  well as SoCs from the RTL930x series, such as RTL9301, RTL9302 and
+	  RTL9303.
+
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 116de173a66c..df4b4b7d7302 100644
=2D-- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_CRYPTO_DEV_PPC4XX) +=3D amcc/
 obj-$(CONFIG_CRYPTO_DEV_QAT) +=3D qat/
 obj-$(CONFIG_CRYPTO_DEV_QCE) +=3D qce/
 obj-$(CONFIG_CRYPTO_DEV_QCOM_RNG) +=3D qcom-rng.o
+obj-$(CONFIG_CRYPTO_DEV_REALTEK) +=3D realtek/
 obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) +=3D rockchip/
 obj-$(CONFIG_CRYPTO_DEV_S5P) +=3D s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SA2UL) +=3D sa2ul.o
diff --git a/drivers/crypto/realtek/Makefile b/drivers/crypto/realtek/Make=
file
new file mode 100644
index 000000000000..8d973bf1d520
=2D-- /dev/null
+++ b/drivers/crypto/realtek/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_REALTEK) +=3D rtl_crypto.o
+rtl_crypto-objs :=3D realtek_crypto.o \
+		  realtek_crypto_skcipher.o \
+		  realtek_crypto_ahash.o
=2D-
2.38.1

