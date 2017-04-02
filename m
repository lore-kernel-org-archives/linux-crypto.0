From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH v5 4/4] crypto: xts - drop gf128mul dependency
Date: Sun,  2 Apr 2017 21:19:16 +0200
Message-ID: <20170402191916.9309-5-omosnacek@gmail.com>
References: <20170402191916.9309-1-omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Milan Broz <gmazyland@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34702 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdDBTUg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2017 15:20:36 -0400
Received: by mail-wr0-f194.google.com with SMTP id w43so28202688wrb.1
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2017 12:20:35 -0700 (PDT)
In-Reply-To: <20170402191916.9309-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the gf128mul_x_ble function used by xts.c is now defined inline
in the header file, the XTS module no longer depends on gf128mul.
Therefore, the 'select CRYPTO_GF128MUL' line can be safely removed.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 crypto/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6854c1f..aac4bc9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -374,7 +374,6 @@ config CRYPTO_XTS
 	tristate "XTS support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	select CRYPTO_GF128MUL
 	select CRYPTO_ECB
 	help
 	  XTS: IEEE1619/D16 narrow block cipher use with aes-xts-plain,
-- 
2.9.3
