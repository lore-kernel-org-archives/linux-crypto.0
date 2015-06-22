From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_aead - Temporarily disable all AEAD algorithms
Date: Mon, 22 Jun 2015 10:31:40 +0800
Message-ID: <20150622023140.GA5914@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37541 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbFVCbn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 22:31:43 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As the AEAD conversion is still ongoing, we do not yet wish to
export legacy AEAD implementations to user-space, as their calling
convention will change.

This patch actually disables all AEAD algorithms because some of
them (e.g., cryptd) will need to be modified to propagate this flag.

Subsequent patches will reenable them on an individual basis.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_aead.c    |    3 ++-
 include/linux/crypto.h |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 38a6cab..e0408a4 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -514,7 +514,8 @@ static struct proto_ops algif_aead_ops = {
 
 static void *aead_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_aead(name, type, mask);
+	return crypto_alloc_aead(name, type | CRYPTO_ALG_AEAD_NEW,
+				 mask | CRYPTO_ALG_AEAD_NEW);
 }
 
 static void aead_release(void *private)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 964e573..81ef938 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -102,6 +102,12 @@
 #define CRYPTO_ALG_INTERNAL		0x00002000
 
 /*
+ * Temporary flag used to prevent legacy AEAD implementations from
+ * being used by user-space.
+ */
+#define CRYPTO_ALG_AEAD_NEW		0x00004000
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
