Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6176C49ED7
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33E82067B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfISOJt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:09:49 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:57389 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfISOJt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 10:09:49 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mrfgi-1hpxqe1rC0-00ndmR; Thu, 19 Sep 2019 16:09:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Mao Wenan <maowenan@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [v2] crypto: hisilicon - allow compile-testing on x86
Date:   Thu, 19 Sep 2019 16:09:06 +0200
Message-Id: <20190919140917.1290556-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190919140650.1289963-2-arnd@arndb.de>
References: <20190919140650.1289963-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:U629Hd3cGnU8BwGfZLZmPjR9EqhyF7LggzzKaHMqmPXJG5SOoaG
 56qWhLWW1tp3/1dhLgYLQaT2/VQYhnegAH24c+wTg/NKoqMW/uChNHZvLu2bF93uuiDxa0M
 /tmHdUwK7VHvYB3oyEYu66CoaWEUwJ179MbitGhoXO7b5Fm3B3L5rC8KbrGxvlCIKNJKdyT
 8nDarTIeVn1ho1o4uQHxg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:EkShJhDQDqY=:qIOWDGVLQmjV8bKEgwt4Ov
 3uj4+TxUABsXndAQ/dtvDmhlYgngeGssU3jdIGXldoJhuzhZvfBlYQ3r9lPXgff/T4NX5bszl
 I0aCwXe8pqFOPlB3ZXC2XxwNhfkVGJ6jt53i3YVrOsZ0HL0R3dMLDVAVPJ+H22NWJEXAEj9i3
 0qLdhFGlhYVgmkpjMsMmG3FTXHAgN1mymMd9DKXfLtz0USx7gEHLr3cIRk/R5X/gudfzr38hj
 FA+xWPNWez8ryGCwqx5V7H0J8UfNbBnG0sA7qnRL8i1EXnCCJJXrdjMN/5S2aULq3XJH2J8q8
 bwP71nD/OLFCRsAzRomZMcHmncdhTAAOY1QByrJJhYI/gnF+mELnXKuCAH7UnQoPqCelOopbW
 jUpCcXNw+BVlm3riZgiU7LWaXAHC7Om6Tb7EiLF9teAszU9DlPDnfzuwJyTz8UAQOVLel3Jjc
 q2b8Wg/cNyr2zWDbzfoaumBRAUMPOdo+jWYRCMH8P6vtAJOINXonL1cAVy1KDfiGhP6BQ7lAz
 703n+miWAxpUk3nIQf6bmykFL3FvTAkl7STw1RvbzZ7KjvP4dx108MZG4Vme2HP1p6rt3G0g/
 pAr9sLvLM0WpVJHuC2cw0TsrH13pFmfuevknC9wOkHvAcp24N/zWvkIxIvrleKWufcll+uFYE
 BvmumgFhPsb8QV2SwIWucUhV6zUY1ckw6tYJ4lfeuA9u2dC5IEZoXkM3Jt6OkB0c6GaeiVdFV
 a/d0o6ESZR5TFkEYufvCxnqRiwJXTk+NG2Zx4UcaL7QzAI6x+nuVIMZhPsWoSzTXGb6jUuaga
 fq0QC8zBhsApd1Not5VCsdafp3VIEcdoVnggnfS0kZ9iGiiEEE+JurBC3n53c9BJNffpma9kd
 xTPmXuUFdyb8yT8H7JbQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To avoid missing arm64 specific warnings that get introduced
in this driver, allow compile-testing on all 64-bit architectures.

The only actual arm64 specific code in this driver is an open-
coded 128 bit MMIO write. On non-arm64 the same can be done
using memcpy_toio. What I also noticed is that the mmio store
(either one) is not endian-safe, this will only work on little-
endian configurations, so I also add a Kconfig dependency on
that, regardless of the architecture.
Finally, a depenndecy on CONFIG_64BIT is needed because of the
writeq().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: actually add !CPU_BIG_ENDIAN dependency as described in the
changelog
---
 drivers/crypto/hisilicon/Kconfig | 9 ++++++---
 drivers/crypto/hisilicon/qm.c    | 6 ++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index ebaf91e0146d..7bfcaa7674fd 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -16,14 +16,15 @@ config CRYPTO_DEV_HISI_SEC
 
 config CRYPTO_DEV_HISI_QM
 	tristate
-	depends on ARM64 && PCI && PCI_MSI
+	depends on ARM64 || COMPILE_TEST
+	depends on PCI && PCI_MSI
 	help
 	  HiSilicon accelerator engines use a common queue management
 	  interface. Specific engine driver may use this module.
 
 config CRYPTO_HISI_SGL
 	tristate
-	depends on ARM64
+	depends on ARM64 || COMPILE_TEST
 	help
 	  HiSilicon accelerator engines use a common hardware scatterlist
 	  interface for data format. Specific engine driver may use this
@@ -31,7 +32,9 @@ config CRYPTO_HISI_SGL
 
 config CRYPTO_DEV_HISI_ZIP
 	tristate "Support for HiSilicon ZIP accelerator"
-	depends on ARM64 && PCI && PCI_MSI
+	depends on PCI && PCI_MSI
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on !CPU_BIG_ENDIAN || COMPILE_TEST
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_HISI_SGL
 	select SG_SPLIT
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f975c393a603..a8ed699081b7 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -331,6 +331,12 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 	void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
 	unsigned long tmp0 = 0, tmp1 = 0;
 
+	if (!IS_ENABLED(CONFIG_ARM64)) {
+		memcpy_toio(fun_base, src, 16);
+		wmb();
+		return;
+	}
+
 	asm volatile("ldp %0, %1, %3\n"
 		     "stp %0, %1, %2\n"
 		     "dsb sy\n"
-- 
2.20.0

