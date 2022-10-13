Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACA3C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 19:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJMTEf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 15:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJMTEe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 15:04:34 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149376C972
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 12:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665687871;
        bh=Y2JBzG+FoZxfNRR8+s09rv4jB/A3dAvwAkDsLeqOgms=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=N042xNcqcURMvpl+e+I4jmAAiL8TZJYLiN46FowFgJ3vd9rlVlyCU/W8nSljiXyz1
         Z0K6nt93HXqPgOV20G44ZGOwC0xNO4llP/3+rBdq6tqRinVdo/A+esiTXiDwHOiImW
         iaZ5pRRAqC/h3CZH0pbxEIwA2UpguTzvWfohNWMI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fedora.willemsstb.de ([94.31.86.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MTiPl-1oZNyd0li9-00U2dk; Thu, 13
 Oct 2022 20:40:30 +0200
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH 5/6] crypto/realtek: enable module
Date:   Thu, 13 Oct 2022 20:40:25 +0200
Message-Id: <20221013184026.63826-6-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221013184026.63826-1-markus.stockhausen@gmx.de>
References: <20221013184026.63826-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:StCpxZYBVEfcY9BedQFryRbvxqHbML0ZqYphr9M5/UK1E50rbrG
 HyOB8B8PSV4u1BRFNpW+TsrkZFXrsuKkt2Dqv6NVbwMw8AKQQ4MWhEeLlvZfawwAhYBhxDw
 5zrlr6etniPwOQJRIDh9l9ikB7xbD3DuWEGnZ057iYU5MHD5rJQyRzsuBlbund4nqY04uV9
 IZj3EtMhYgKocChgdUXIQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9pCr4hhvU0k=:S0Bu+Lb6qUsxUtwYH3DM7+
 V3wUwMi5wo0pTJ2XyotqxxO7Pta8nJS2DwnZpRTWI21kmc4dH3c7bk5H/qCSK9a/KaQr1NUe1
 +I5iFvuYhCJMOci1khp35DgAsmWuyE6H5C9NHPA0XdCm4eSRd4iqjNjfENwyyiBeSGW9wwPIL
 nCDfQlgpTBD7+W1PZClmKIC9UFPUb4moq6JeMpfTbX8/+/ItIkcQ2yMOuXGiYUgv9fBgNboZe
 IAHBaInzhMldX2guUFhZTyLhIYRZkpeHyT/HYUE2UYnoO07bkfyQBkBL4xiIznZ1hKzqRKNxN
 DwAMmzDNW1j91UI509wB3g6yW+PkfjohAIhwAZigH1KHCwVzrdRwWBO1gkQ5K0uA86/03/AOZ
 oynLuZ6EMFncJNn8EBtaeIqPI6aTbZNmqlxFqTevV45DCLOg+kYfkXNSlPHbsC8UyO1TfvF2/
 8P1zFOiDYGGKpSwKGF9RjZMK+yn5lUViRR374sDi+uCZHMZISZqjqr7FfM01v2nkpSdBDCEoj
 B8RmL55+lN3Vz7ZukmtLvD+/lWi76fA8Vn3TkJNwny0h+Jk1SD2Ioz9azOqxMvkqLzI2GH02+
 3F6Oix2sgeTumKmhHF6s1OeqqGC3bUCMp2ggpbG2v9IVTgTaoigyaX7bRE8rjSjmO0vuavhcj
 DTS+9L1Uczm/rJJ19wV029GWIiikwBwiiwsCOqr+8JVRnv35YnQJbU0CgHyErn/jrpATzcKEV
 AfDmQMbrCOGHRbiYlblyE9qchaQCG5AFpgMfEodqmW0XHFp3SDPUeonI+UbZPwizBchcQr5rh
 QAFmkLy8ZBdx+NH/E/HAavNuew/RZzjbZMwDCO1diGfLGsoU9M9Ig9maO7I8VDho6cpesmGe0
 HlhzA3aBcdEN1zW/P/jCZCIqIEBNrocgaTEVRQoOvVtMPg1qMOA4Qcl6H/RyoLSyeAeh7rH/u
 eD+jo6ISl2bE40Yoe7hsXBEc2WgKdrskB5iY4B5T0x2uMPnmfHz7Y9b3+giLA8Qjmq0iiSjzN
 MW0cii+jMqExAb8DKspsxaPiWc5dM/PKhPMMZmuG6J1uvmBkbkGSwFskbVCA5TKhWpfP99jS8
 VRIpvWncJYjUSgwNPz+YJcyjkJYdGxxUP6ceG+ImnEMNY8ZO+4TEka8VwgawFp1VdT8r8ol9t
 GQ2pEI0/3URaMYMCXDH8/sxIy2p3xkAYfoh7AwO7bEQ8kQk91I4m6YercyldCUDPAWE3gnwCi
 9TTVW07/Qg5Z0kqwul24RfrB32JTAANE3mBs4bRX2y3JuIy15J2wL9vko8Gppc6P9eYEWzvCe
 WQAxF5nFSW8LFExKYTWIbmNH6pasJurVbej66exkdsWyL09+7gMfV4j6lxdJ784CfoypGTazN
 Az8fIFHkhoPAySUemMlAGZFJkmk5b58cDPAK0p57dts96rN/8lgEpcMZJ9oBctjdKjiSMIXnI
 8Luerj0+8eAXT3WCXUh48bsEVqH9VpjrerZLCagExu/38f3+jhmHlYNfPumO8cC8vMlqBZoZe
 GLNTP6F+WCblHh5RqFzrWIg0VXsvfepA3Gsr5XHR81uk8
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
2.37.3

