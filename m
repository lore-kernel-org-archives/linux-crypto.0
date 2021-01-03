Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4FAC433DB
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 14:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3D1320936
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Jan 2021 14:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbhACOEE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Jan 2021 09:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbhACOEE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Jan 2021 09:04:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 118712080D;
        Sun,  3 Jan 2021 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609682603;
        bh=dqHNyAKkpwyLmYZD5yeeB+ZjQZwdnDmtsYc8E0Z0vfE=;
        h=From:To:Cc:Subject:Date:From;
        b=NFIcH122ai3m5hUWP6QvxVgAMGxb3kIkIh5Jo6RtGsYshsvv9Uv2VdnZh0eOrNAsk
         vdfwiOo0oSAnXnTYxqUd0vWaguhpijijj53zJm9UHhNqr7WKFR9N9sMBb12Cj+I7Zf
         NZ0PEDa2Z43xVBt7pc10EUh9nqxfq8P/8GLnRbPxrQNqhBK597h5Co+VCvVHstxjjc
         b+msh48wSdGPavmQTrZeHOJaEluzzN9QimIfYUcD0XWPLDqQx0BGBmKXmMuDkgp+ky
         ZU0XZSAJ1jJxZvethaiUIUjZvOX2d7aFmvkurB4TsCZEaEneCzfKvQ6BuFcmPjCDiS
         Y+r1Ff7/94beA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tero Kristo <t-kristo@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: omap-sham - Fix link error without crypto-engine
Date:   Sun,  3 Jan 2021 15:03:04 +0100
Message-Id: <20210103140318.3902174-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver was converted to use the crypto engine helper
but is missing the corresponding Kconfig statement to ensure
it is available:

arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_probe':
omap-sham.c:(.text+0x374): undefined reference to `crypto_engine_alloc_init'
arm-linux-gnueabi-ld: omap-sham.c:(.text+0x384): undefined reference to `crypto_engine_start'
arm-linux-gnueabi-ld: omap-sham.c:(.text+0x510): undefined reference to `crypto_engine_exit'
arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_finish_req':
omap-sham.c:(.text+0x98c): undefined reference to `crypto_finalize_hash_request'
arm-linux-gnueabi-ld: omap-sham.c:(.text+0x9a0): undefined reference to `crypto_transfer_hash_request_to_engine'
arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_update':
omap-sham.c:(.text+0xf24): undefined reference to `crypto_transfer_hash_request_to_engine'
arm-linux-gnueabi-ld: drivers/crypto/omap-sham.o: in function `omap_sham_final':
omap-sham.c:(.text+0x1020): undefined reference to `crypto_transfer_hash_request_to_engine'

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8fa6d71a6da1..21abeb19f1eb 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -368,6 +368,7 @@ if CRYPTO_DEV_OMAP
 config CRYPTO_DEV_OMAP_SHAM
 	tristate "Support for OMAP MD5/SHA1/SHA2 hw accelerator"
 	depends on ARCH_OMAP2PLUS
+	select CRYPTO_ENGINE
 	select CRYPTO_SHA1
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
-- 
2.29.2

