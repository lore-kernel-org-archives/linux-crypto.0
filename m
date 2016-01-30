From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: keywrap - memzero the correct memory
Date: Sat, 30 Jan 2016 17:38:28 +0300
Message-ID: <20160130143828.GC3462@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We're clearing the wrong memory.  The memory corruption is likely
harmless because we weren't going to use that stack memory again but not
zeroing is a potential information leak.

Fixes: e28facde3c39 ('crypto: keywrap - add key wrapping block chaining mode')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index b1d106c..72014f9 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -212,7 +212,7 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 			  SEMIBSIZE))
 		ret = -EBADMSG;
 
-	memzero_explicit(&block, sizeof(struct crypto_kw_block));
+	memzero_explicit(block, sizeof(struct crypto_kw_block));
 
 	return ret;
 }
@@ -297,7 +297,7 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 	/* establish the IV for the caller to pick up */
 	memcpy(desc->info, block->A, SEMIBSIZE);
 
-	memzero_explicit(&block, sizeof(struct crypto_kw_block));
+	memzero_explicit(block, sizeof(struct crypto_kw_block));
 
 	return 0;
 }
