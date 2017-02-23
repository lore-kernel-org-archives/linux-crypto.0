From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] crypto: Add ECB dependency for XTS mode
Date: Thu, 23 Feb 2017 08:38:26 +0100
Message-ID: <20170223073826.19066-1-gmazyland@gmail.com>
References: <20170221231717.GA7186@nicolas-laptop>
Cc: herbert@gondor.apana.org.au, nicolasporcel06@gmail.com,
        Milan Broz <gmazyland@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35029 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdBWHkU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 02:40:20 -0500
Received: by mail-wr0-f193.google.com with SMTP id q39so2894040wrb.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2017 23:39:36 -0800 (PST)
In-Reply-To: <20170221231717.GA7186@nicolas-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the
   commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
   crypto: xts - Convert to skcipher
the XTS mode is based on ECB, so the mode must select
ECB otherwise it can fail to initialize.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 160f08e721cc..9c245eb0dd83 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -374,6 +374,7 @@ config CRYPTO_XTS
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
+	select CRYPTO_ECB
 	help
 	  XTS: IEEE1619/D16 narrow block cipher use with aes-xts-plain,
 	  key size 256, 384 or 512 bits. This implementation currently
-- 
2.11.0
