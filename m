From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] crypto/drbg: report backend_cra_name when allocation fails
Date: Wed, 10 Jun 2015 22:27:48 +0900
Message-ID: <1433942868-16447-2-git-send-email-sergey.senozhatsky@gmail.com>
References: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36818 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654AbbFJN2p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 09:28:45 -0400
In-Reply-To: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Be more verbose and also report ->backend_cra_name when
crypto_alloc_shash() or crypto_alloc_cipher() fail in
drbg_init_hash_kernel() or drbg_init_sym_kernel()
correspondingly.

Example
 DRBG: could not allocate digest TFM handle: hmac(sha256)

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 crypto/drbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 04836b4..d42f678 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1590,7 +1590,8 @@ static int drbg_init_hash_kernel(struct drbg_state *drbg)
 
 	tfm = crypto_alloc_shash(drbg->core->backend_cra_name, 0, 0);
 	if (IS_ERR(tfm)) {
-		pr_info("DRBG: could not allocate digest TFM handle\n");
+		pr_info("DRBG: could not allocate digest TFM handle: %s\n",
+				drbg->core->backend_cra_name);
 		return PTR_ERR(tfm);
 	}
 	BUG_ON(drbg_blocklen(drbg) != crypto_shash_digestsize(tfm));
@@ -1641,7 +1642,8 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 
 	tfm = crypto_alloc_cipher(drbg->core->backend_cra_name, 0, 0);
 	if (IS_ERR(tfm)) {
-		pr_info("DRBG: could not allocate cipher TFM handle\n");
+		pr_info("DRBG: could not allocate cipher TFM handle: %s\n",
+				drbg->core->backend_cra_name);
 		return PTR_ERR(tfm);
 	}
 	BUG_ON(drbg_blocklen(drbg) != crypto_cipher_blocksize(tfm));
-- 
2.4.3.368.g7974889
