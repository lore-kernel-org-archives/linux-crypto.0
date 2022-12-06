Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D094CC3A5A7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 19:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLFTUs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 14:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiLFTUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 14:20:45 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3853641990
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 11:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670354441; bh=f9WWL0ZIKMD+NKnDzl903S+l3tToc5izqiOcKL+3HcU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LwV1T7u6KVoUhDAgLSfGZ19lnpLo3Wh6Es3czVCO2RHN8/yv/VybdsJsy8WAu9t70
         ERcoOInRD3cXNHqlsoknqmAEVhsFmh80w/s1tRClTXFBbXdu1GKIb/ZDBlU9fJRbgR
         hjP+XvZsa52KT+czX1WYFZIsWWk6jn3M7huLR3PSq2S+jXP03Xn6JhNyNRKkHrqQGz
         vaEhckGAAbKihGYSZbOKQXR4bAR6/nkWPn4CFdSo0PMkPpUNKZ6AVqadU6bHXYz4AH
         oTwH/dHW4ek+yMzgK7jBbiOKdn5v5sek9+knhuI29C5dF7bjMiE0MPRZ7ildUh+5Ox
         ew3N3N94pSY/Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.87.22]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MhU9Z-1oWrFa1kzT-00ed5y; Tue, 06
 Dec 2022 20:20:41 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v2 5/6] crypto/realtek: enable module
Date:   Tue,  6 Dec 2022 20:20:36 +0100
Message-Id: <20221206192037.608808-6-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206192037.608808-1-markus.stockhausen@gmx.de>
References: <20221206192037.608808-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:o4VE5jya59gO1oVlc7LTFfX3/1dQFWYti3MZ09wjp1NjDy8YMgp
 qTBYBAPYWSzxESVWtlgIPDpdHXDDsUchjdflDcDJeY5zlnaI0kH51PHWsSBd7CLkUrm6EBN
 5eYRDENteV/sHaRUdElkyYsuFuxg4v3P1gv5KKadDiUjxUBo+12yMNqXf8rochQNi67XiPX
 03HKmEh1o99jI4JTgAvRw==
UI-OutboundReport: notjunk:1;M01:P0:wkg6hHHot/Y=;bx26l6Ur3oA8p7+EVzCua9qBEsl
 ePnyex1x/X4iMbBOo3stXYMPLkGa4I1Q7A07IUQMurHLU5PmJfyfesFCbCz7dUkuiMU/aflu+
 KbJ3s/C1G2BR+bfXacn6yMtxOhq2WZQUeQeMJEQ6O3bTDRPIT9xHLlO0mqMbPEiGSTbntdVOF
 U3JbdYTzf/90hNj+DHui2o9v8IoKrTnGqiN/FvYyvPUTnH4QYen/NKB8AAcdn4tZ8XsK0TTfT
 NTHVzZ1WRUagOrfypoN6yxMBZx9iuA74W7l2+LN7fUdfALJOxCNpesZ27k/fv4NNRpf3PocHb
 eJ8of9rH1zSVX7pz4Wj0QAcDfsPR+oaF6hlEmXywyBwBtGKeTaZot3mRsnzblEswo/ZiPZZL8
 jF+KyTxMEHa+DsvX7/UObZXSUGg78BuLvUTYvNSOqLAnrq9FbaDKuPetJPYgmSFR2O5i0GKTU
 8N09YA1QmLKJsj2eLpjYOifJzSsIV9pu3x8mYgErwXTPxcBrz46TDvnDjsrshe7+c9tz+RSEl
 VmJGi5PwZ+coU2ab9Aoz/CVVOwpBkOrOnNv0TnUX2Dqy+5X03nFY9SMC7ooALiYDnV9CJIYTT
 pmfwa0+esxiHnHaiVa9wZXml4Ya46eQdzY+ASmrXE8wBedUR/6stCbac9MZcI5Gi8LxI5R3SL
 fFQFFTH1gaLiNPDADtxXAFI7bN81yHCeWsawZEirf79hYIS5W/vPDEglS5QDqdgWuhEugDjtM
 k4QmlSXJf9XRQeE44S8WU+yKHul+MgibP5bkL//X/1iMu2o/eV4MfriMawrHj3+HE57j9Rzs/
 MdENYp3LPuxwrspYUkYQOlsKuSrtolMj0ciVjqbv5jprBmE8FoNMcQGA7irFN4+R1ztoxComU
 +te3VGqsCJWtYUYMMV+LWnLusqgv2n/O7Imh7gl1vvz4iubcKv7h9BcV6rKUUcBw7e3vh4C9s
 BwDU5a+Lj2Lp2YdtzqbPOryTFT0=
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

