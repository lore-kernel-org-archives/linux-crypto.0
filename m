From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] crypto: aesni-intel: use crypto_[un]register_algs
Date: Fri, 11 May 2012 16:00:48 +0300
Message-ID: <20120511130048.26495.55851.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37453 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EKNAx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 May 2012 09:00:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. Simplifies init/exit code and reduce object size.

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aesni-intel_glue.c |  727 +++++++++++++++---------------------
 1 file changed, 305 insertions(+), 422 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c799352..20c6220 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -222,27 +222,6 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	}
 }
 
-static struct crypto_alg aesni_alg = {
-	.cra_name		= "aes",
-	.cra_driver_name	= "aes-aesni",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
-	.cra_alignmask		= 0,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(aesni_alg.cra_list),
-	.cra_u	= {
-		.cipher	= {
-			.cia_min_keysize	= AES_MIN_KEY_SIZE,
-			.cia_max_keysize	= AES_MAX_KEY_SIZE,
-			.cia_setkey		= aes_set_key,
-			.cia_encrypt		= aes_encrypt,
-			.cia_decrypt		= aes_decrypt
-		}
-	}
-};
-
 static void __aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
@@ -257,27 +236,6 @@ static void __aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	aesni_dec(ctx, dst, src);
 }
 
-static struct crypto_alg __aesni_alg = {
-	.cra_name		= "__aes-aesni",
-	.cra_driver_name	= "__driver-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
-	.cra_alignmask		= 0,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(__aesni_alg.cra_list),
-	.cra_u	= {
-		.cipher	= {
-			.cia_min_keysize	= AES_MIN_KEY_SIZE,
-			.cia_max_keysize	= AES_MAX_KEY_SIZE,
-			.cia_setkey		= aes_set_key,
-			.cia_encrypt		= __aes_encrypt,
-			.cia_decrypt		= __aes_decrypt
-		}
-	}
-};
-
 static int ecb_encrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -326,28 +284,6 @@ static int ecb_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static struct crypto_alg blk_ecb_alg = {
-	.cra_name		= "__ecb-aes-aesni",
-	.cra_driver_name	= "__driver-ecb-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= ecb_encrypt,
-			.decrypt	= ecb_decrypt,
-		},
-	},
-};
-
 static int cbc_encrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -396,28 +332,6 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-static struct crypto_alg blk_cbc_alg = {
-	.cra_name		= "__cbc-aes-aesni",
-	.cra_driver_name	= "__driver-cbc-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= cbc_encrypt,
-			.decrypt	= cbc_decrypt,
-		},
-	},
-};
-
 #ifdef CONFIG_X86_64
 static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 			    struct blkcipher_walk *walk)
@@ -461,29 +375,6 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 
 	return err;
 }
-
-static struct crypto_alg blk_ctr_alg = {
-	.cra_name		= "__ctr-aes-aesni",
-	.cra_driver_name	= "__driver-ctr-aes-aesni",
-	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
-	.cra_u = {
-		.blkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= aes_set_key,
-			.encrypt	= ctr_crypt,
-			.decrypt	= ctr_crypt,
-		},
-	},
-};
 #endif
 
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -572,30 +463,6 @@ static int ablk_ecb_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct crypto_alg ablk_ecb_alg = {
-	.cra_name		= "ecb(aes)",
-	.cra_driver_name	= "ecb-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_ecb_alg.cra_list),
-	.cra_init		= ablk_ecb_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-};
-
 static int ablk_cbc_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_ablkcipher *cryptd_tfm;
@@ -607,31 +474,6 @@ static int ablk_cbc_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct crypto_alg ablk_cbc_alg = {
-	.cra_name		= "cbc(aes)",
-	.cra_driver_name	= "cbc-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_cbc_alg.cra_list),
-	.cra_init		= ablk_cbc_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-};
-
 #ifdef CONFIG_X86_64
 static int ablk_ctr_init(struct crypto_tfm *tfm)
 {
@@ -644,32 +486,6 @@ static int ablk_ctr_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct crypto_alg ablk_ctr_alg = {
-	.cra_name		= "ctr(aes)",
-	.cra_driver_name	= "ctr-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_ctr_alg.cra_list),
-	.cra_init		= ablk_ctr_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_encrypt,
-			.geniv		= "chainiv",
-		},
-	},
-};
-
 #ifdef HAS_CTR
 static int ablk_rfc3686_ctr_init(struct crypto_tfm *tfm)
 {
@@ -682,32 +498,6 @@ static int ablk_rfc3686_ctr_init(struct crypto_tfm *tfm)
 	ablk_init_common(tfm, cryptd_tfm);
 	return 0;
 }
-
-static struct crypto_alg ablk_rfc3686_ctr_alg = {
-	.cra_name		= "rfc3686(ctr(aes))",
-	.cra_driver_name	= "rfc3686-ctr-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_rfc3686_ctr_alg.cra_list),
-	.cra_init		= ablk_rfc3686_ctr_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize = AES_MIN_KEY_SIZE+CTR_RFC3686_NONCE_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE+CTR_RFC3686_NONCE_SIZE,
-			.ivsize	     = CTR_RFC3686_IV_SIZE,
-			.setkey	     = ablk_set_key,
-			.encrypt     = ablk_encrypt,
-			.decrypt     = ablk_decrypt,
-			.geniv	     = "seqiv",
-		},
-	},
-};
 #endif
 #endif
 
@@ -723,31 +513,6 @@ static int ablk_lrw_init(struct crypto_tfm *tfm)
 	ablk_init_common(tfm, cryptd_tfm);
 	return 0;
 }
-
-static struct crypto_alg ablk_lrw_alg = {
-	.cra_name		= "lrw(aes)",
-	.cra_driver_name	= "lrw-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_lrw_alg.cra_list),
-	.cra_init		= ablk_lrw_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-};
 #endif
 
 #ifdef HAS_PCBC
@@ -762,31 +527,6 @@ static int ablk_pcbc_init(struct crypto_tfm *tfm)
 	ablk_init_common(tfm, cryptd_tfm);
 	return 0;
 }
-
-static struct crypto_alg ablk_pcbc_alg = {
-	.cra_name		= "pcbc(aes)",
-	.cra_driver_name	= "pcbc-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_pcbc_alg.cra_list),
-	.cra_init		= ablk_pcbc_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-};
 #endif
 
 #ifdef HAS_XTS
@@ -801,31 +541,6 @@ static int ablk_xts_init(struct crypto_tfm *tfm)
 	ablk_init_common(tfm, cryptd_tfm);
 	return 0;
 }
-
-static struct crypto_alg ablk_xts_alg = {
-	.cra_name		= "xts(aes)",
-	.cra_driver_name	= "xts-aes-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
-	.cra_ctxsize		= sizeof(struct async_aes_ctx),
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_ablkcipher_type,
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(ablk_xts_alg.cra_list),
-	.cra_init		= ablk_xts_init,
-	.cra_exit		= ablk_exit,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize	= 2 * AES_MIN_KEY_SIZE,
-			.max_keysize	= 2 * AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey		= ablk_set_key,
-			.encrypt	= ablk_encrypt,
-			.decrypt	= ablk_decrypt,
-		},
-	},
-};
 #endif
 
 #ifdef CONFIG_X86_64
@@ -1050,32 +765,6 @@ static int rfc4106_decrypt(struct aead_request *req)
 	}
 }
 
-static struct crypto_alg rfc4106_alg = {
-	.cra_name = "rfc4106(gcm(aes))",
-	.cra_driver_name = "rfc4106-gcm-aesni",
-	.cra_priority = 400,
-	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = 1,
-	.cra_ctxsize = sizeof(struct aesni_rfc4106_gcm_ctx) + AESNI_ALIGN,
-	.cra_alignmask = 0,
-	.cra_type = &crypto_nivaead_type,
-	.cra_module = THIS_MODULE,
-	.cra_list = LIST_HEAD_INIT(rfc4106_alg.cra_list),
-	.cra_init = rfc4106_init,
-	.cra_exit = rfc4106_exit,
-	.cra_u = {
-		.aead = {
-			.setkey = rfc4106_set_key,
-			.setauthsize = rfc4106_set_authsize,
-			.encrypt = rfc4106_encrypt,
-			.decrypt = rfc4106_decrypt,
-			.geniv = "seqiv",
-			.ivsize = 8,
-			.maxauthsize = 16,
-		},
-	},
-};
-
 static int __driver_rfc4106_encrypt(struct aead_request *req)
 {
 	u8 one_entry_in_sg = 0;
@@ -1233,26 +922,316 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 	}
 	return retval;
 }
+#endif
 
-static struct crypto_alg __rfc4106_alg = {
-	.cra_name		= "__gcm-aes-aesni",
-	.cra_driver_name	= "__driver-gcm-aes-aesni",
+static struct crypto_alg aesni_algs[] = { {
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-aesni",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= AES_MIN_KEY_SIZE,
+			.cia_max_keysize	= AES_MAX_KEY_SIZE,
+			.cia_setkey		= aes_set_key,
+			.cia_encrypt		= aes_encrypt,
+			.cia_decrypt		= aes_decrypt
+		}
+	}
+}, {
+	.cra_name		= "__aes-aesni",
+	.cra_driver_name	= "__driver-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= AES_MIN_KEY_SIZE,
+			.cia_max_keysize	= AES_MAX_KEY_SIZE,
+			.cia_setkey		= aes_set_key,
+			.cia_encrypt		= __aes_encrypt,
+			.cia_decrypt		= __aes_decrypt
+		}
+	}
+}, {
+	.cra_name		= "__ecb-aes-aesni",
+	.cra_driver_name	= "__driver-ecb-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-aes-aesni",
+	.cra_driver_name	= "__driver-cbc-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_ecb_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_cbc_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+#ifdef CONFIG_X86_64
+}, {
+	.cra_name		= "__ctr-aes-aesni",
+	.cra_driver_name	= "__driver-ctr-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(aes)",
+	.cra_driver_name	= "ctr-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_ctr_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+}, {
+	.cra_name		= "__gcm-aes-aesni",
+	.cra_driver_name	= "__driver-gcm-aes-aesni",
 	.cra_priority		= 0,
 	.cra_flags		= CRYPTO_ALG_TYPE_AEAD,
 	.cra_blocksize		= 1,
-	.cra_ctxsize	= sizeof(struct aesni_rfc4106_gcm_ctx) + AESNI_ALIGN,
+	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
+				  AESNI_ALIGN,
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_aead_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(__rfc4106_alg.cra_list),
 	.cra_u = {
 		.aead = {
 			.encrypt	= __driver_rfc4106_encrypt,
 			.decrypt	= __driver_rfc4106_decrypt,
 		},
 	},
-};
+}, {
+	.cra_name		= "rfc4106(gcm(aes))",
+	.cra_driver_name	= "rfc4106-gcm-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
+				  AESNI_ALIGN,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_nivaead_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= rfc4106_init,
+	.cra_exit		= rfc4106_exit,
+	.cra_u = {
+		.aead = {
+			.setkey		= rfc4106_set_key,
+			.setauthsize	= rfc4106_set_authsize,
+			.encrypt	= rfc4106_encrypt,
+			.decrypt	= rfc4106_decrypt,
+			.geniv		= "seqiv",
+			.ivsize		= 8,
+			.maxauthsize	= 16,
+		},
+	},
+#ifdef HAS_CTR
+}, {
+	.cra_name		= "rfc3686(ctr(aes))",
+	.cra_driver_name	= "rfc3686-ctr-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_rfc3686_ctr_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.ivsize	     = CTR_RFC3686_IV_SIZE,
+			.setkey	     = ablk_set_key,
+			.encrypt     = ablk_encrypt,
+			.decrypt     = ablk_decrypt,
+			.geniv	     = "seqiv",
+		},
+	},
+#endif
+#endif
+#ifdef HAS_LRW
+}, {
+	.cra_name		= "lrw(aes)",
+	.cra_driver_name	= "lrw-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_lrw_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE + AES_BLOCK_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE + AES_BLOCK_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+#endif
+#ifdef HAS_PCBC
+}, {
+	.cra_name		= "pcbc(aes)",
+	.cra_driver_name	= "pcbc-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_pcbc_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+#endif
+#ifdef HAS_XTS
+}, {
+	.cra_name		= "xts(aes)",
+	.cra_driver_name	= "xts-aes-aesni",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_aes_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_xts_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+			.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
 #endif
+} };
 
 
 static const struct x86_cpu_id aesni_cpu_id[] = {
@@ -1263,120 +1242,24 @@ MODULE_DEVICE_TABLE(x86cpu, aesni_cpu_id);
 
 static int __init aesni_init(void)
 {
-	int err;
+	int err, i;
 
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
 
-	if ((err = crypto_fpu_init()))
-		goto fpu_err;
-	if ((err = crypto_register_alg(&aesni_alg)))
-		goto aes_err;
-	if ((err = crypto_register_alg(&__aesni_alg)))
-		goto __aes_err;
-	if ((err = crypto_register_alg(&blk_ecb_alg)))
-		goto blk_ecb_err;
-	if ((err = crypto_register_alg(&blk_cbc_alg)))
-		goto blk_cbc_err;
-	if ((err = crypto_register_alg(&ablk_ecb_alg)))
-		goto ablk_ecb_err;
-	if ((err = crypto_register_alg(&ablk_cbc_alg)))
-		goto ablk_cbc_err;
-#ifdef CONFIG_X86_64
-	if ((err = crypto_register_alg(&blk_ctr_alg)))
-		goto blk_ctr_err;
-	if ((err = crypto_register_alg(&ablk_ctr_alg)))
-		goto ablk_ctr_err;
-	if ((err = crypto_register_alg(&__rfc4106_alg)))
-		goto __aead_gcm_err;
-	if ((err = crypto_register_alg(&rfc4106_alg)))
-		goto aead_gcm_err;
-#ifdef HAS_CTR
-	if ((err = crypto_register_alg(&ablk_rfc3686_ctr_alg)))
-		goto ablk_rfc3686_ctr_err;
-#endif
-#endif
-#ifdef HAS_LRW
-	if ((err = crypto_register_alg(&ablk_lrw_alg)))
-		goto ablk_lrw_err;
-#endif
-#ifdef HAS_PCBC
-	if ((err = crypto_register_alg(&ablk_pcbc_alg)))
-		goto ablk_pcbc_err;
-#endif
-#ifdef HAS_XTS
-	if ((err = crypto_register_alg(&ablk_xts_alg)))
-		goto ablk_xts_err;
-#endif
-	return err;
+	err = crypto_fpu_init();
+	if (err)
+		return err;
 
-#ifdef HAS_XTS
-ablk_xts_err:
-#endif
-#ifdef HAS_PCBC
-	crypto_unregister_alg(&ablk_pcbc_alg);
-ablk_pcbc_err:
-#endif
-#ifdef HAS_LRW
-	crypto_unregister_alg(&ablk_lrw_alg);
-ablk_lrw_err:
-#endif
-#ifdef CONFIG_X86_64
-#ifdef HAS_CTR
-	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
-ablk_rfc3686_ctr_err:
-#endif
-	crypto_unregister_alg(&rfc4106_alg);
-aead_gcm_err:
-	crypto_unregister_alg(&__rfc4106_alg);
-__aead_gcm_err:
-	crypto_unregister_alg(&ablk_ctr_alg);
-ablk_ctr_err:
-	crypto_unregister_alg(&blk_ctr_alg);
-blk_ctr_err:
-#endif
-	crypto_unregister_alg(&ablk_cbc_alg);
-ablk_cbc_err:
-	crypto_unregister_alg(&ablk_ecb_alg);
-ablk_ecb_err:
-	crypto_unregister_alg(&blk_cbc_alg);
-blk_cbc_err:
-	crypto_unregister_alg(&blk_ecb_alg);
-blk_ecb_err:
-	crypto_unregister_alg(&__aesni_alg);
-__aes_err:
-	crypto_unregister_alg(&aesni_alg);
-aes_err:
-fpu_err:
-	return err;
+	for (i = 0; i < ARRAY_SIZE(aesni_algs); i++)
+		INIT_LIST_HEAD(&aesni_algs[i].cra_list);
+
+	return crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 }
 
 static void __exit aesni_exit(void)
 {
-#ifdef HAS_XTS
-	crypto_unregister_alg(&ablk_xts_alg);
-#endif
-#ifdef HAS_PCBC
-	crypto_unregister_alg(&ablk_pcbc_alg);
-#endif
-#ifdef HAS_LRW
-	crypto_unregister_alg(&ablk_lrw_alg);
-#endif
-#ifdef CONFIG_X86_64
-#ifdef HAS_CTR
-	crypto_unregister_alg(&ablk_rfc3686_ctr_alg);
-#endif
-	crypto_unregister_alg(&rfc4106_alg);
-	crypto_unregister_alg(&__rfc4106_alg);
-	crypto_unregister_alg(&ablk_ctr_alg);
-	crypto_unregister_alg(&blk_ctr_alg);
-#endif
-	crypto_unregister_alg(&ablk_cbc_alg);
-	crypto_unregister_alg(&ablk_ecb_alg);
-	crypto_unregister_alg(&blk_cbc_alg);
-	crypto_unregister_alg(&blk_ecb_alg);
-	crypto_unregister_alg(&__aesni_alg);
-	crypto_unregister_alg(&aesni_alg);
+	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 
 	crypto_fpu_exit();
 }
