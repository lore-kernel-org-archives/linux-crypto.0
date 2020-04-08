Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE61C2D0F4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 16:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 186C720784
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 16:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgDHQ12 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 12:27:28 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:41467 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbgDHQ12 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 12:27:28 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MjSsm-1itzH12Epe-00kyeD; Wed, 08 Apr 2020 18:26:57 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Gary R Hook <gary.hook@amd.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp -- don't "select" CONFIG_DMADEVICES
Date:   Wed,  8 Apr 2020 18:26:48 +0200
Message-Id: <20200408162652.3987688-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:sEiAFmsI4jSz+YsYNVKrukcmJUzj+jzuCBgwkm4AxKPvP9ESvyt
 RG5MGGqH/KVtfFrhuSR8+2r5DvqaGDd31bBVWy76coI6+ImvqrxCSU7uzQfuAUPCbdq1/VT
 2RUiuFbJdpHvqJW3DWdRxq0VNdeTL2t/g0nKAJPq2VwmekurXa5+6Kn+qc35DfKZ4ZitSJZ
 cphcicWkB680vwhzdpOIg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:g1KPF25dW9Y=:RvEFfLm/QuwkaJh3tuOHQ0
 808kW0bfQFD7MoXh5AnGtAELbpAr8fizORGwhuUWRfANZ8e/CBusfz/pIaHTJIMHoE4mLLWgH
 gLoVJB++lZit1AC4rHp5sZvTAanBIieIpNtmp0JwLo3YDfXgln5UampnxZ8g3hTuQ7cgeIc0B
 DVluz/zb9e6Rgos8vWrf+UISWLxZdFZ8SixhP06ZTW+jJgaEtGZ5cHW2qMWCLegmI2AKD9ZVL
 1FOtgALbiJZhkWbZGs3JzcW0iinpaavOwnU6Xzfy824PLvSU2bv4O9EB7INhR2g3nX5yrnJWM
 MFGXaR4PE9k/hk0NFB8SUwkNYx/srO91jxByN2CJovjx4aNs7Wz+bh8OPHcXnrizRKNKxBLJ6
 bcF6zEoOpKBQ50LH8AiRFm6Vgl0F1Rny4Pk1lSb+sRYynX82K3PE9Sag68PbkElZTgILXNmF7
 CLOrHk9mZV4U90c/wc69oqroIIqu8F0rbwWhjWgWNNbsPJBFy4fBDVLslbrpdol8wViz5AjuH
 92puMEoN9ojETU7xoK4j0g4TWkcucbwzRw8NXtE6KdHytOwEwqcjWLohe1j4u4X00MfHN3jcI
 j+EGx+KXUFj6wVl3nCuVdThh2QlmAXbvYq5GcrX6KGAhtOBKfysbzlpKBDNN3GKoIvhWSR+zC
 f28xMzSbEwrTwczgWboGIPvj7YTDzBGW/2VDyRyESArsu2Pob0o9mHKqLFt3XGVMdAPtQQaXn
 15oS0ePWwmmAjd+hb0neHGrnhTb1022kAH/5DBPRmwYbE++8zK1Y8MNeizZN7OM88SY4hasvF
 HZegLdgSZGlsgK0tjGCEdvPGUHLW8IEf03pi2W9BF7SArphMow=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DMADEVICES is the top-level option for the slave DMA
subsystem, and should not be selected by device drivers,
as this can cause circular dependencies such as:

drivers/net/ethernet/freescale/Kconfig:6:error: recursive dependency detected!
drivers/net/ethernet/freescale/Kconfig:6:	symbol NET_VENDOR_FREESCALE depends on PPC_BESTCOMM
drivers/dma/bestcomm/Kconfig:6:	symbol PPC_BESTCOMM depends on DMADEVICES
drivers/dma/Kconfig:6:	symbol DMADEVICES is selected by CRYPTO_DEV_SP_CCP
drivers/crypto/ccp/Kconfig:10:	symbol CRYPTO_DEV_SP_CCP depends on CRYPTO
crypto/Kconfig:16:	symbol CRYPTO is selected by LIBCRC32C
lib/Kconfig:222:	symbol LIBCRC32C is selected by LIQUIDIO
drivers/net/ethernet/cavium/Kconfig:65:	symbol LIQUIDIO depends on PTP_1588_CLOCK
drivers/ptp/Kconfig:8:	symbol PTP_1588_CLOCK is implied by FEC
drivers/net/ethernet/freescale/Kconfig:23:	symbol FEC depends on NET_VENDOR_FREESCALE

The LIQUIDIO driver causing this problem is addressed in a
separate patch, but this change is needed to prevent it from
happening again.

Using "depends on DMADEVICES" is what we do for all other
implementations of slave DMA controllers as well.

Fixes: b3c2fee5d66b ("crypto: ccp - Ensure all dependencies are specified")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccp/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index e0a8bd15aa74..32268e239bf1 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -10,10 +10,9 @@ config CRYPTO_DEV_CCP_DD
 config CRYPTO_DEV_SP_CCP
 	bool "Cryptographic Coprocessor device"
 	default y
-	depends on CRYPTO_DEV_CCP_DD
+	depends on CRYPTO_DEV_CCP_DD && DMADEVICES
 	select HW_RANDOM
 	select DMA_ENGINE
-	select DMADEVICES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	help
-- 
2.26.0

