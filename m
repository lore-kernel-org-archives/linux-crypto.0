Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CA2C2BA1A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 16:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E135E20784
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 16:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgDHQ2A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 12:28:00 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:57835 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgDHQ2A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 12:28:00 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mlf8e-1iwCBb14J0-00ikQe; Wed, 08 Apr 2020 18:27:25 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, Hao Fang <fanghao11@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Mao Wenan <maowenan@huawei.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon: add more dependencies
Date:   Wed,  8 Apr 2020 18:27:12 +0200
Message-Id: <20200408162718.4004527-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:V2ngFhoDCSDjH5BjAbBiWmlInJtYPUDMeoP4smM30gW9Ea1Cnmh
 4Lx2ESOxK96rjTRlOtXu/eoWy44UMC+664n8hIUNjJU3GQzP95vIJBaQdvyO4YNhVp9rJLz
 chJXdMEoXPNhtoBhvHy/P3A8Vxt+65Tn9liKxpKFJGR2sX0Sj0QvyU8DOUF5gjdipUoGih9
 NOn3FxOgK1JMYh6bydmyA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:d++rc+lfq/M=:nFy/xfcBPXlDE8F0Ie8T8t
 fsLO2LLx4JngDQ2kSNYHtJwL8ZCWcMsO1OH8xuZ1ehMUpaKaE/4cvLBJgMfpwe5RgE0ma85YX
 BycNRl7zkxd7slu87j3RTebw4kXHMXtS07GLMjauy5NFVyEB0apygI7k6Pva4lrHRzWOMvwW1
 5V+MOND1t7csQQa865314uUiJ+iZylTn1JEMd7uz2BUAIj2fvtoA5fAyvNJ8W7yNMXbBTTSva
 EwDmSy0t1xH1W+/qma3Cj08PYC/ElMNf/PuyUUv/oz1k7HDZHb1xABqFl9K2BT4HakhTXyksh
 6H92SdRtSjhzTmrLohHk6gQSXp2FIBwY4qJvrlJik65KX93z/pYu9zX9mZapHFc51WBO+DShh
 cK6JRjf09V0ZUp92lA0pGU0Zfk8L+kUQlji+mElsyXsClbMTXbHfOh4+K6o81+yahyy8L+H/+
 HlTzpkr8sZ1wMbaY04HnhQxTAuq1SxWtSh5EbHosHsJM1BJ1c2WH/Xf37OTI+SLXcXiDD3iqf
 O9nSkrzpMP4hZDvOveJA4vpxLrh0Akuq/Soimi80HwlRdBY5QybkQWFXL9KKqL5mDPwEbee+g
 lhTTR4mdoZMFEBIt48dM83bzfE/6zX5b5eTOBPPUsFpPwuZoVngnfii0zHJUXG9x5EsJyXOI4
 mNKrAHspW1R09hE/ei4Np29ZBBNVsoit4kDTFORnRDQAtRyswtVxGSyd10qOBDGmvvrI9jteR
 RTJZCGoreVYxCFOyyeZvwtWd5biAi7HSMbw+jOh9IjB9F+wxsTDMjWBlZRntfLZaXJGLZYPoi
 lBOorTbNdjfPwWx5uxuBkjnp04D6FtTL6Qkki8GDBRwjeMveiw=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The added dependencies must be applied recursively to
other modules that select CRYPTO_DEV_HISI_QM, to avoid
running into the same problem again:

WARNING: unmet direct dependencies detected for CRYPTO_DEV_HISI_QM
  Depends on [m]: CRYPTO [=y] && CRYPTO_HW [=y] && (ARM64 [=y] || COMPILE_TEST [=y]) && PCI [=y] && PCI_MSI [=y] && (UACCE [=m] || UACCE [=m]=n)
  Selected by [y]:
  - CRYPTO_DEV_HISI_SEC2 [=y] && CRYPTO [=y] && CRYPTO_HW [=y] && PCI [=y] && PCI_MSI [=y] && (ARM64 [=y] || COMPILE_TEST [=y] && 64BIT [=y])
  - CRYPTO_DEV_HISI_HPRE [=y] && CRYPTO [=y] && CRYPTO_HW [=y] && PCI [=y] && PCI_MSI [=y] && (ARM64 [=y] || COMPILE_TEST [=y] && 64BIT [=y])
ld: drivers/crypto/hisilicon/qm.o: in function `hisi_qm_uninit': qm.c:(.text+0x23b8): undefined reference to `uacce_remove'

Fixes: 47c16b449921 ("crypto: hisilicon - qm depends on UACCE")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/hisilicon/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 095850d01dcc..9c3004663fe8 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -28,6 +28,7 @@ config CRYPTO_DEV_HISI_SEC2
 	select CRYPTO_SHA512
 	depends on PCI && PCI_MSI
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on UACCE || UACCE=n
 	help
 	  Support for HiSilicon SEC Engine of version 2 in crypto subsystem.
 	  It provides AES, SM4, and 3DES algorithms with ECB
@@ -59,6 +60,7 @@ config CRYPTO_DEV_HISI_HPRE
 	tristate "Support for HISI HPRE accelerator"
 	depends on PCI && PCI_MSI
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on UACCE || UACCE=n
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_DH
 	select CRYPTO_RSA
-- 
2.26.0

