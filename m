Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FD1C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 437CB20882
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389056AbfISOHc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:07:32 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:36263 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387729AbfISOHc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 10:07:32 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MoNu2-1hr3gK0pC4-00opsW; Thu, 19 Sep 2019 16:07:08 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Mao Wenan <maowenan@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Hao Fang <fanghao11@huawei.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: hisilicon - allow compile-testing on x86
Date:   Thu, 19 Sep 2019 16:05:53 +0200
Message-Id: <20190919140650.1289963-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190919140650.1289963-1-arnd@arndb.de>
References: <20190919140650.1289963-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:L7yFWwAi2zf3EJZdDKTARe8DorH4eKw0qZyaUsxtBx/h0sffIYB
 e8Yw7mJLacGWfYTjz4p2DANakmc5fVkH/g00PMf2e9O1XYMlOk1l9xJxm4dQs8vPVJ16+rW
 csMCYx6e//nqUPpv7OHqtkaKee/me8uL0b+EsluvjkwWo59IhiAorJzdzcYzqgrqZYmJkLU
 R978hgPWrh33xNCwQgCiw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:U87jcL4Z/TM=:4pPibzFIUuSk1FSlna8JIa
 T2nINl/0ftlVxAFJw5TvQotaV3QAxh0CEfYUye6n2JfiDGNokKz57ptxjUrBf2vz2TdIUdMxi
 AhTKxNm8XdNCKKd81fyVb7CNYtTl77RahdYc6lfTsI2N+olkAmsz7q1uvFVQ2d3p6plPKFEOM
 n/Y4EZE7uxkU6kFJWcLYM5/bhVCBtCda/xUfd/70kENzzBfaFMVPTmoCO4GD85ulqxNzt3wTk
 e4RMXRAsi83Gng7ye+j/vEK0e5ahzw2MMDN2ASZJ3GzylxmnV815NK+q/h1tIwIjtd/ABIMQA
 tRvfoYBJaboNV1RNI26EzaVSxaSG85OivNGNV6juW6X4uZR7JHxJYYhHYuHt1Hm9sqvZLz2eC
 qwpKUSlhOtr/hE/RSYoRdAa/EvqBGkaETpZyeLvk4N/3RouOegrAijQLaZ+lTav7Z8+watKLa
 T5y+1PjoUtPrLNbvxHCe/zlVe+lzpJATYgKTLfKiMA2yQyEi/+MFBkqOR4OIMT9RqwDaNJzxD
 2JqpLbStGTmNK7QQlu2+f/DkjPxF7fHsD6Mgg+EURLmd9Ar+KzxQcLlENUCWTGp5gahqSnKil
 QBA7ziFNzoG26Xywr0RAefqpr/yvU2PZnd7OCjp6Vd1YRt8N0kAgJsuoLMbCKspn1O4+3ZMpH
 lI1hkLH5r58vCzA4O+DniOTR3Kv/GT+44//nJRw46TP6aixs4lcHVN6g2Jo2f8xWU3CPR+Rpq
 v6DRTcTki+eJMLpitaEagg+eFsRLj0HPqr6JPFssFVdhMOnANGyNHT8SG2W2KrnXnLJ0ldhCw
 djVMui3MN2gphpYoSiMRZJZaAXqbBS0fIUj3RRc3WuR4K7QiL37OkujZGndeS1NUTFsmtkP1T
 RxTer+YX4QlPFeijdx6Q==
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
 drivers/crypto/hisilicon/Kconfig | 8 +++++---
 drivers/crypto/hisilicon/qm.c    | 6 ++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index ebaf91e0146d..dfbd668a431e 100644
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
@@ -31,7 +32,8 @@ config CRYPTO_HISI_SGL
 
 config CRYPTO_DEV_HISI_ZIP
 	tristate "Support for HiSilicon ZIP accelerator"
-	depends on ARM64 && PCI && PCI_MSI
+	depends on PCI && PCI_MSI
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
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

