Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC047C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 12:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90FCB207F9
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593519562;
	bh=+B/5KadR9ph4oZTJC6xZjWzAuzGP8oIUhYf4XHINBnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PZ4DRJIymnHiAzT8SVeYX784kWb3e7Z6HP1atnQnrjqf0QZdBO3wUXgs96m8hXolI
	 wEAogXd/KDA+3n8XkHCUWctT3j/K1B+7yluoVGUGG+OHg49lN3qdGdlI/N0E/VB/As
	 4ekgll51OxDYBGx777A2ZFEpw6RuRP1lew/VGG+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgF3MTW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 08:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732509AbgF3MTV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 08:19:21 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61CF5207F5;
        Tue, 30 Jun 2020 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593519560;
        bh=+B/5KadR9ph4oZTJC6xZjWzAuzGP8oIUhYf4XHINBnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LP/y7NjiyZhBP+IdZgAC0ccdJps+vWTLYoFpHiMCts5IiITy6ozic+If+PrU2ixYI
         0jkYx+Sf2kMark2ArdVoXD/r0REyUYLmih1PRa75DXAzrOmV4E35jKWa/z1nX1WKxd
         EXdCUQ9uhAUBOFjME1Vb6p/qFgaCFSXFF4kA3n4I=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Eric Biggers <ebiggers@google.com>,
        Tero Kristo <t-kristo@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH v3 01/13] crypto: amlogic-gxl - default to build as module
Date:   Tue, 30 Jun 2020 14:18:55 +0200
Message-Id: <20200630121907.24274-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630121907.24274-1-ardb@kernel.org>
References: <20200630121907.24274-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AmLogic GXL crypto accelerator driver is built into the kernel if
ARCH_MESON is set. However, given the single image policy of arm64, its
defconfig enables all platforms by default, and so ARCH_MESON is usually
enabled.

This means that the AmLogic driver causes the arm64 defconfig build to
pull in a huge chunk of the crypto stack as a builtin as well, which is
undesirable, so let's make the amlogic GXL driver default to 'm' instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/amlogic/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amlogic/Kconfig b/drivers/crypto/amlogic/Kconfig
index cf9547602670..cf2c676a7093 100644
--- a/drivers/crypto/amlogic/Kconfig
+++ b/drivers/crypto/amlogic/Kconfig
@@ -1,7 +1,7 @@
 config CRYPTO_DEV_AMLOGIC_GXL
 	tristate "Support for amlogic cryptographic offloader"
 	depends on HAS_IOMEM
-	default y if ARCH_MESON
+	default m if ARCH_MESON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	select CRYPTO_ECB
-- 
2.17.1

