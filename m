From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 1/2] crypto: caam - replace xstr macro with __stringify
Date: Wed, 14 Aug 2013 18:56:45 +0300
Message-ID: <1376495806-26226-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <kim.phillips@freescale.com>,
	<horia.geanta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:33639
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab3HNP7o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 11:59:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CAAM driver contains one macro (xstr) used for printing
the line location in a file where a memdump is done. This patch
replaces the xstr macro with the already existing __stringify
macro that performs the same function.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/caamalg.c  |   78 ++++++++++++++++++++--------------------
 drivers/crypto/caam/caamhash.c |   68 ++++++++++++++++++-----------------
 drivers/crypto/caam/key_gen.c  |    6 ++--
 3 files changed, 77 insertions(+), 75 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 5f8ac0f..86a0d41 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -82,8 +82,6 @@
 
 #ifdef DEBUG
 /* for print_hex_dumps with line references */
-#define xstr(s) str(s)
-#define str(s) #s
 #define debug(format, arg...) printk(format, arg)
 #else
 #define debug(format, arg...)
@@ -283,7 +281,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead enc shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "aead enc shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -351,7 +349,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead dec shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "aead dec shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -434,7 +432,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead givenc shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "aead givenc shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -498,7 +496,7 @@ static int aead_setkey(struct crypto_aead *aead,
 	       keylen, enckeylen, authkeylen);
 	printk(KERN_ERR "split_key_len %d split_key_pad_len %d\n",
 	       ctx->split_key_len, ctx->split_key_pad_len);
-	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 #endif
 
@@ -517,7 +515,7 @@ static int aead_setkey(struct crypto_aead *aead,
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 		       ctx->split_key_pad_len + enckeylen, 1);
 #endif
@@ -547,7 +545,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	u32 *desc;
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 #endif
 
@@ -596,7 +594,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher enc shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR,
+		       "ablkcipher enc shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -641,7 +640,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher dec shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR,
+		       "ablkcipher dec shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -778,13 +778,13 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_unmap(jrdev, edesc, req);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
 		       req->assoclen , 1);
-	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src) - ivsize,
 		       edesc->src_nents ? 100 : ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 		       edesc->src_nents ? 100 : req->cryptlen +
 		       ctx->authsize + 4, 1);
@@ -812,10 +812,10 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		 offsetof(struct aead_edesc, hw_desc));
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->dst),
 		       req->cryptlen, 1);
 #endif
@@ -835,7 +835,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		err = -EBADMSG;
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "iphdrout@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "iphdrout@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4,
 		       ((char *)sg_virt(req->assoc) - sizeof(struct iphdr)),
 		       sizeof(struct iphdr) + req->assoclen +
@@ -843,7 +843,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       ctx->authsize + 36, 1);
 	if (!err && edesc->sec4_sg_bytes) {
 		struct scatterlist *sg = sg_last(req->src, edesc->src_nents);
-		print_hex_dump(KERN_ERR, "sglastout@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "sglastout@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(sg),
 			sg->length + ctx->authsize + 16, 1);
 	}
@@ -876,10 +876,10 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	}
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
@@ -911,10 +911,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	}
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
 #endif
@@ -945,16 +945,16 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 #ifdef DEBUG
 	debug("assoclen %d cryptlen %d authsize %d\n",
 	      req->assoclen, req->cryptlen, authsize);
-	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
 		       req->assoclen , 1);
-	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       edesc->src_nents ? 100 : ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 			edesc->src_nents ? 100 : req->cryptlen, 1);
-	print_hex_dump(KERN_ERR, "shrdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "shrdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
 		       desc_bytes(sh_desc), 1);
 #endif
@@ -1023,15 +1023,15 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 #ifdef DEBUG
 	debug("assoclen %d cryptlen %d authsize %d\n",
 	      req->assoclen, req->cryptlen, authsize);
-	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
 		       req->assoclen , 1);
-	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv, ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 			edesc->src_nents > 1 ? 100 : req->cryptlen, 1);
-	print_hex_dump(KERN_ERR, "shrdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "shrdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
 		       desc_bytes(sh_desc), 1);
 #endif
@@ -1084,10 +1084,10 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 	int len, sec4_sg_index = 0;
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
 		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 		       edesc->src_nents ? 100 : req->nbytes, 1);
 #endif
@@ -1245,7 +1245,7 @@ static int aead_encrypt(struct aead_request *req)
 	init_aead_job(ctx->sh_desc_enc, ctx->sh_desc_enc_dma, edesc, req,
 		      all_contig, true);
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
@@ -1279,7 +1279,7 @@ static int aead_decrypt(struct aead_request *req)
 		return PTR_ERR(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dec src@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 		       req->cryptlen, 1);
 #endif
@@ -1288,7 +1288,7 @@ static int aead_decrypt(struct aead_request *req)
 	init_aead_job(ctx->sh_desc_dec,
 		      ctx->sh_desc_dec_dma, edesc, req, all_contig, false);
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
@@ -1435,7 +1435,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 		return PTR_ERR(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "giv src@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "giv src@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 		       req->cryptlen, 1);
 #endif
@@ -1444,7 +1444,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 	init_aead_giv_job(ctx->sh_desc_givenc,
 			  ctx->sh_desc_givenc_dma, edesc, req, contig);
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
@@ -1544,7 +1544,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	edesc->iv_dma = iv_dma;
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher sec4_sg@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ablkcipher sec4_sg@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->sec4_sg,
 		       sec4_sg_bytes, 1);
 #endif
@@ -1573,7 +1573,7 @@ static int ablkcipher_encrypt(struct ablkcipher_request *req)
 	init_ablkcipher_job(ctx->sh_desc_enc,
 		ctx->sh_desc_enc_dma, edesc, req, iv_contig);
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
@@ -1611,7 +1611,7 @@ static int ablkcipher_decrypt(struct ablkcipher_request *req)
 		ctx->sh_desc_dec_dma, edesc, req, iv_contig);
 	desc = edesc->hw_desc;
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 403368b..b2a7883 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -89,8 +89,6 @@
 
 #ifdef DEBUG
 /* for print_hex_dumps with line references */
-#define xstr(s) str(s)
-#define str(s) #s
 #define debug(format, arg...) printk(format, arg)
 #else
 #define debug(format, arg...)
@@ -329,7 +327,8 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ahash update shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR,
+		       "ahash update shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -347,7 +346,8 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ahash update first shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR,
+		       "ahash update first shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -364,7 +364,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ahash final shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ahash final shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -382,7 +382,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ahash finup shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ahash finup shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -401,7 +401,8 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ahash digest shdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR,
+		       "ahash digest shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
@@ -462,9 +463,9 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			 LDST_SRCDST_BYTE_CONTEXT);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "key_in@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "key_in@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, *keylen, 1);
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -477,7 +478,8 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 		wait_for_completion_interruptible(&result.completion);
 		ret = result.err;
 #ifdef DEBUG
-		print_hex_dump(KERN_ERR, "digested key@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR,
+			       "digested key@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, key_in,
 			       digestsize, 1);
 #endif
@@ -528,7 +530,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 #ifdef DEBUG
 	printk(KERN_ERR "split_key_len %d split_key_pad_len %d\n",
 	       ctx->split_key_len, ctx->split_key_pad_len);
-	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 #endif
 
@@ -543,7 +545,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		return -ENOMEM;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 		       ctx->split_key_pad_len, 1);
 #endif
@@ -636,11 +638,11 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 	kfree(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 		       ctx->ctx_len, 1);
 	if (req->result)
-		print_hex_dump(KERN_ERR, "result@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "result@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
@@ -674,11 +676,11 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 	kfree(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 		       ctx->ctx_len, 1);
 	if (req->result)
-		print_hex_dump(KERN_ERR, "result@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "result@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
@@ -712,11 +714,11 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 	kfree(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 		       ctx->ctx_len, 1);
 	if (req->result)
-		print_hex_dump(KERN_ERR, "result@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "result@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
@@ -750,11 +752,11 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 	kfree(edesc);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 		       ctx->ctx_len, 1);
 	if (req->result)
-		print_hex_dump(KERN_ERR, "result@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "result@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
@@ -850,7 +852,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		append_seq_out_ptr(desc, state->ctx_dma, ctx->ctx_len, 0);
 
 #ifdef DEBUG
-		print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 			       desc_bytes(desc), 1);
 #endif
@@ -869,9 +871,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 		*next_buflen = last_buflen;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "buf@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "buf@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, buf, *buflen, 1);
-	print_hex_dump(KERN_ERR, "next buf@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "next buf@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, next_buf,
 		       *next_buflen, 1);
 #endif
@@ -935,7 +937,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 						digestsize);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -1014,7 +1016,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						digestsize);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -1084,7 +1086,7 @@ static int ahash_digest(struct ahash_request *req)
 						digestsize);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -1138,7 +1140,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	edesc->src_nents = 0;
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -1226,7 +1228,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 
 #ifdef DEBUG
-		print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 			       desc_bytes(desc), 1);
 #endif
@@ -1248,9 +1250,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		*next_buflen = 0;
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "buf@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "buf@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, buf, *buflen, 1);
-	print_hex_dump(KERN_ERR, "next buf@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "next buf@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, next_buf,
 		       *next_buflen, 1);
 #endif
@@ -1319,7 +1321,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						digestsize);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -1412,7 +1414,7 @@ static int ahash_update_first(struct ahash_request *req)
 		map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
 
 #ifdef DEBUG
-		print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 			       desc_bytes(desc), 1);
 #endif
@@ -1436,7 +1438,7 @@ static int ahash_update_first(struct ahash_request *req)
 		sg_copy(next_buf, req->src, req->nbytes);
 	}
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "next buf@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "next buf@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, next_buf,
 		       *next_buflen, 1);
 #endif
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 87138d2..ea2e406 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -95,9 +95,9 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, keylen, 1);
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -110,7 +110,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		wait_for_completion_interruptible(&result.completion);
 		ret = result.err;
 #ifdef DEBUG
-		print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+		print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, key_out,
 			       split_key_pad_len, 1);
 #endif
-- 
1.7.7.6
