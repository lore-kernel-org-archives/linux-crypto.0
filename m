Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C9EC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 13:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C874D64E7A
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 13:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhBANpR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhBANpQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 08:45:16 -0500
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189E1C061573
        for <linux-crypto@vger.kernel.org>; Mon,  1 Feb 2021 05:44:35 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by andre.telenet-ops.be with bizsmtp
        id PpkZ240064C55Sk01pkZ5E; Mon, 01 Feb 2021 14:44:34 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l6ZVI-002TCq-LI; Mon, 01 Feb 2021 14:44:32 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l6ZVI-002vxi-24; Mon, 01 Feb 2021 14:44:32 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Srujana Challa <schalla@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] crypto: marvell - CRYPTO_DEV_OCTEONTX2_CPT should depend on ARCH_THUNDER2
Date:   Mon,  1 Feb 2021 14:44:31 +0100
Message-Id: <20210201134431.699419-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Marvell OcteonTX2 CPT physical function PCI device is present only
on OcteonTx2 SoC, and not available as an independent PCIe endpoint.
Hence add a dependency on ARCH_THUNDER2, to prevent asking the user
about this driver when configuring a kernel without OcteonTx2 platform
support.

Fixes: 5e8ce8334734c5f2 ("crypto: marvell - add Marvell OcteonTX2 CPT PF driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/crypto/marvell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 2efbd79180ce4b22..d4c4433c8db8244a 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -38,7 +38,7 @@ config CRYPTO_DEV_OCTEONTX_CPT
 
 config CRYPTO_DEV_OCTEONTX2_CPT
 	tristate "Marvell OcteonTX2 CPT driver"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARCH_THUNDER2 || COMPILE_TEST
 	depends on PCI_MSI && 64BIT
 	depends on CRYPTO_LIB_AES
 	select OCTEONTX2_MBOX
-- 
2.25.1

