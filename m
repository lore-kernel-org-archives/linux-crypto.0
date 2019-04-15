Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C14FC10F13
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 049B82084E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555288755;
	bh=5uymJCveF8COrm6rR5YBYmJGlUn7zlH3/PcTZD9Oo/k=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mDt4I4GhJS69XT//77w444IsiVaURK9QeinhUQiWyQisopFCrRFJrvxCSwpnZrcWD
	 OrLYSuAcZUwvSWVQ1yv5qF0dh6cUxSol3LUQYeHm+dYZhmCY84oB2JK8ePH3P1HZ4+
	 clRX/IjDAzPwkUlSkYGsgGtTSLbY043JqREyoyOc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfDOAjO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 20:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfDOAjN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 20:39:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 259C520880
        for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2019 00:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555288751;
        bh=5uymJCveF8COrm6rR5YBYmJGlUn7zlH3/PcTZD9Oo/k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dJz3LKENQV+CDFR3KY3BWk1nW+xt6CLdhoTxxxe2VTbBYZgMpqLaVZKmd7kiqmOT4
         G6W72BKgZ6PmPJrhsXacypbz3/gMmnBlYrWkJwRPOgJ69muo+VzBe4ntfAgG2BTAOO
         htx+AW/CDDg/PG/pDAiPFL49yDiUh41Rr52FnaeY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC PATCH 3/3] crypto: shash - remove shash_desc::flags
Date:   Sun, 14 Apr 2019 17:37:09 -0700
Message-Id: <20190415003709.1531-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190415003709.1531-1-ebiggers@kernel.org>
References: <20190415003709.1531-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The flags field in 'struct shash_desc' never actually does anything.
The only ostensibly supported flag is CRYPTO_TFM_REQ_MAY_SLEEP.
However, no shash algorithm ever sleeps, making this flag a no-op.

With this being the case, inevitably some users who can't sleep wrongly
pass MAY_SLEEP.  These would all need to be fixed if any shash algorithm
actually started sleeping.  For example, the shash_ahash_*() functions,
which wrap a shash algorithm with the ahash API, pass through MAY_SLEEP
from the ahash API to the shash API.  However, the shash functions are
called under kmap_atomic(), so actually they're assumed to never sleep.

Even if it turns out that some users do need preemption points while
hashing large buffers, we could easily provide a helper function
crypto_shash_update_large() which divides the data into smaller chunks
and calls crypto_shash_update() and cond_resched() for each chunk.  It's
not necessary to have a flag in 'struct shash_desc', nor is it necessary
to make individual shash algorithms aware of this at all.

Therefore, remove shash_desc::flags, and document that the
crypto_shash_*() functions can be called from any context.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/api-samples.rst                  |  1 -
 arch/arm/crypto/ghash-ce-glue.c                       |  3 ---
 arch/x86/crypto/ghash-clmulni-intel_glue.c            |  2 --
 arch/x86/power/hibernate.c                            |  1 -
 crypto/adiantum.c                                     |  1 -
 crypto/asymmetric_keys/pkcs7_verify.c                 |  1 -
 crypto/asymmetric_keys/verify_pefile.c                |  1 -
 crypto/asymmetric_keys/x509_public_key.c              |  1 -
 crypto/cryptd.c                                       |  3 ---
 crypto/drbg.c                                         |  1 -
 crypto/hmac.c                                         | 11 -----------
 crypto/shash.c                                        |  4 ----
 crypto/testmgr.c                                      |  2 --
 drivers/block/drbd/drbd_receiver.c                    |  1 -
 drivers/block/drbd/drbd_worker.c                      |  2 --
 drivers/crypto/axis/artpec6_crypto.c                  |  2 --
 drivers/crypto/bcm/cipher.c                           |  1 -
 drivers/crypto/bcm/util.c                             |  1 -
 drivers/crypto/ccp/ccp-crypto-sha.c                   |  2 --
 drivers/crypto/chelsio/chcr_algo.c                    |  2 --
 drivers/crypto/mediatek/mtk-sha.c                     |  3 ---
 drivers/crypto/n2_core.c                              |  2 --
 drivers/crypto/omap-sham.c                            |  2 --
 drivers/crypto/padlock-sha.c                          |  5 -----
 drivers/crypto/qat/qat_common/qat_algs.c              |  1 -
 drivers/crypto/s5p-sss.c                              |  1 -
 drivers/crypto/vmx/ghash.c                            |  1 -
 drivers/infiniband/sw/rxe/rxe.h                       |  1 -
 drivers/md/dm-crypt.c                                 |  3 ---
 drivers/md/dm-integrity.c                             |  2 --
 drivers/net/ppp/ppp_mppe.c                            |  1 -
 drivers/net/wireless/intersil/orinoco/mic.c           |  1 -
 drivers/nfc/s3fwrn5/firmware.c                        |  1 -
 drivers/staging/ks7010/ks_hostif.c                    |  1 -
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c          |  1 -
 .../staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c |  1 -
 drivers/target/iscsi/iscsi_target_auth.c              |  1 -
 drivers/thunderbolt/domain.c                          |  1 -
 fs/cifs/misc.c                                        |  1 -
 fs/crypto/keyinfo.c                                   |  1 -
 fs/ecryptfs/crypto.c                                  |  1 -
 fs/ecryptfs/keystore.c                                |  1 -
 fs/ext4/ext4.h                                        |  1 -
 fs/f2fs/f2fs.h                                        |  1 -
 fs/nfsd/nfs4recover.c                                 |  1 -
 fs/ubifs/auth.c                                       |  6 ------
 fs/ubifs/replay.c                                     |  2 --
 include/crypto/hash.h                                 | 10 ++++++++--
 include/linux/jbd2.h                                  |  1 -
 kernel/kexec_file.c                                   |  1 -
 lib/crc-t10dif.c                                      |  1 -
 lib/digsig.c                                          |  1 -
 lib/libcrc32c.c                                       |  1 -
 net/bluetooth/amp.c                                   |  1 -
 net/bluetooth/smp.c                                   |  1 -
 net/sctp/auth.c                                       |  1 -
 net/sctp/sm_make_chunk.c                              |  2 --
 net/sunrpc/auth_gss/gss_krb5_crypto.c                 |  2 --
 net/sunrpc/auth_gss/gss_krb5_mech.c                   |  1 -
 net/wireless/lib80211_crypt_tkip.c                    |  1 -
 security/apparmor/crypto.c                            |  2 --
 security/integrity/evm/evm_crypto.c                   |  1 -
 security/integrity/ima/ima_crypto.c                   |  4 ----
 security/keys/dh.c                                    |  1 -
 security/keys/encrypted-keys/encrypted.c              |  1 -
 security/keys/trusted.c                               |  1 -
 66 files changed, 8 insertions(+), 113 deletions(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index 0f6ca8b7261e9..f14afaaf2f324 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -133,7 +133,6 @@ Code Example For Use of Operational State Memory With SHASH
         if (!sdesc)
             return ERR_PTR(-ENOMEM);
         sdesc->shash.tfm = alg;
-        sdesc->shash.flags = 0x0;
         return sdesc;
     }
 
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 60123e9ea9d8f..39d1ccec1aab4 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -186,7 +186,6 @@ static int ghash_async_init(struct ahash_request *req)
 	struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
 
 	desc->tfm = child;
-	desc->flags = req->base.flags;
 	return crypto_shash_init(desc);
 }
 
@@ -243,7 +242,6 @@ static int ghash_async_digest(struct ahash_request *req)
 		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
 
 		desc->tfm = child;
-		desc->flags = req->base.flags;
 		return shash_ahash_digest(req, desc);
 	}
 }
@@ -256,7 +254,6 @@ static int ghash_async_import(struct ahash_request *req, const void *in)
 	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
 
 	desc->tfm = cryptd_ahash_child(ctx->cryptd_tfm);
-	desc->flags = req->base.flags;
 
 	return crypto_shash_import(desc, in);
 }
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 4099a0ae17dd1..e3f3e6fd9d655 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -172,7 +172,6 @@ static int ghash_async_init(struct ahash_request *req)
 	struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
 
 	desc->tfm = child;
-	desc->flags = req->base.flags;
 	return crypto_shash_init(desc);
 }
 
@@ -252,7 +251,6 @@ static int ghash_async_digest(struct ahash_request *req)
 		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
 
 		desc->tfm = child;
-		desc->flags = req->base.flags;
 		return shash_ahash_digest(req, desc);
 	}
 }
diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
index bcddf09b5aa39..4845b8c7be7f4 100644
--- a/arch/x86/power/hibernate.c
+++ b/arch/x86/power/hibernate.c
@@ -90,7 +90,6 @@ static int get_e820_md5(struct e820_table *table, void *buf)
 	}
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	size = offsetof(struct e820_table, entries) +
 		sizeof(struct e820_entry) * table->nr_entries;
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index e6de50f669aa7..395a3ddd37074 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -265,7 +265,6 @@ static int adiantum_hash_message(struct skcipher_request *req,
 	int err;
 
 	hash_desc->tfm = tctx->hash;
-	hash_desc->flags = 0;
 
 	err = crypto_shash_init(hash_desc);
 	if (err)
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 97c77f66b20d6..f7b0980bf02df 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -56,7 +56,6 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		goto error_no_desc;
 
 	desc->tfm   = tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	/* Digest the message [RFC2315 9.3] */
 	ret = crypto_shash_digest(desc, pkcs7->data, pkcs7->data_len,
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index d178650fd524c..f8e4a932bcfbc 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -354,7 +354,6 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 		goto error_no_desc;
 
 	desc->tfm   = tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
 		goto error;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 9338b4558cdc5..bd96683d8cde3 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -77,7 +77,6 @@ int x509_get_sig_params(struct x509_certificate *cert)
 		goto error;
 
 	desc->tfm = tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ret = crypto_shash_digest(desc, cert->tbs, cert->tbs_size, sig->digest);
 	if (ret < 0)
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 42533cf80accf..b3bb99390ae79 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -545,7 +545,6 @@ static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
 		goto out;
 
 	desc->tfm = child;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = crypto_shash_init(desc);
 
@@ -637,7 +636,6 @@ static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
 		goto out;
 
 	desc->tfm = child;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = shash_ahash_digest(req, desc);
 
@@ -666,7 +664,6 @@ static int cryptd_hash_import(struct ahash_request *req, const void *in)
 	struct shash_desc *desc = cryptd_shash_desc(req);
 
 	desc->tfm = ctx->child;
-	desc->flags = req->base.flags;
 
 	return crypto_shash_import(desc, in);
 }
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 710b3046a4df2..2a5b16bb000c3 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1587,7 +1587,6 @@ static int drbg_init_hash_kernel(struct drbg_state *drbg)
 	}
 
 	sdesc->shash.tfm = tfm;
-	sdesc->shash.flags = 0;
 	drbg->priv_data = sdesc;
 
 	return crypto_shash_alignmask(tfm);
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 4ceb3f1f0eb84..a68c1266121f5 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -57,8 +57,6 @@ static int hmac_setkey(struct crypto_shash *parent,
 	unsigned int i;
 
 	shash->tfm = hash;
-	shash->flags = crypto_shash_get_flags(parent)
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (keylen > bs) {
 		int err;
@@ -91,8 +89,6 @@ static int hmac_export(struct shash_desc *pdesc, void *out)
 {
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-
 	return crypto_shash_export(desc, out);
 }
 
@@ -102,7 +98,6 @@ static int hmac_import(struct shash_desc *pdesc, const void *in)
 	struct hmac_ctx *ctx = hmac_ctx(pdesc->tfm);
 
 	desc->tfm = ctx->hash;
-	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	return crypto_shash_import(desc, in);
 }
@@ -117,8 +112,6 @@ static int hmac_update(struct shash_desc *pdesc,
 {
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-
 	return crypto_shash_update(desc, data, nbytes);
 }
 
@@ -130,8 +123,6 @@ static int hmac_final(struct shash_desc *pdesc, u8 *out)
 	char *opad = crypto_shash_ctx_aligned(parent) + ss;
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-
 	return crypto_shash_final(desc, out) ?:
 	       crypto_shash_import(desc, opad) ?:
 	       crypto_shash_finup(desc, out, ds, out);
@@ -147,8 +138,6 @@ static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 	char *opad = crypto_shash_ctx_aligned(parent) + ss;
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-
 	return crypto_shash_finup(desc, data, nbytes, out) ?:
 	       crypto_shash_import(desc, opad) ?:
 	       crypto_shash_finup(desc, out, ds, out);
diff --git a/crypto/shash.c b/crypto/shash.c
index 599468478f7bb..e55c1f558bc3d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -238,7 +238,6 @@ static int shash_async_init(struct ahash_request *req)
 	struct shash_desc *desc = ahash_request_ctx(req);
 
 	desc->tfm = *ctx;
-	desc->flags = req->base.flags;
 
 	return crypto_shash_init(desc);
 }
@@ -293,7 +292,6 @@ static int shash_async_finup(struct ahash_request *req)
 	struct shash_desc *desc = ahash_request_ctx(req);
 
 	desc->tfm = *ctx;
-	desc->flags = req->base.flags;
 
 	return shash_ahash_finup(req, desc);
 }
@@ -328,7 +326,6 @@ static int shash_async_digest(struct ahash_request *req)
 	struct shash_desc *desc = ahash_request_ctx(req);
 
 	desc->tfm = *ctx;
-	desc->flags = req->base.flags;
 
 	return shash_ahash_digest(req, desc);
 }
@@ -344,7 +341,6 @@ static int shash_async_import(struct ahash_request *req, const void *in)
 	struct shash_desc *desc = ahash_request_ctx(req);
 
 	desc->tfm = *ctx;
-	desc->flags = req->base.flags;
 
 	return crypto_shash_import(desc, in);
 }
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4928c614dd40b..0e6363af3ae81 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1329,7 +1329,6 @@ static void generate_random_hash_testvec(struct crypto_shash *tfm,
 
 	/* Digest */
 	desc->tfm = tfm;
-	desc->flags = 0;
 	vec->digest_error = crypto_shash_digest(desc, vec->plaintext,
 						vec->psize, (u8 *)vec->digest);
 done:
@@ -3028,7 +3027,6 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		u32 *ctx = (u32 *)shash_desc_ctx(shash);
 
 		shash->tfm = tfm;
-		shash->flags = 0;
 
 		*ctx = 420553207;
 		err = crypto_shash_final(shash, (u8 *)&val);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c7ad88d91a09e..843a9b9b3d740 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -5443,7 +5443,6 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	rcu_read_unlock();
 
 	desc->tfm = connection->cram_hmac_tfm;
-	desc->flags = 0;
 
 	rv = crypto_shash_setkey(connection->cram_hmac_tfm, (u8 *)secret, key_len);
 	if (rv) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 268ef0c5d4ab6..6781bcf3ec26f 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -304,7 +304,6 @@ void drbd_csum_ee(struct crypto_shash *tfm, struct drbd_peer_request *peer_req,
 	void *src;
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	crypto_shash_init(desc);
 
@@ -332,7 +331,6 @@ void drbd_csum_bio(struct crypto_shash *tfm, struct bio *bio, void *digest)
 	struct bvec_iter iter;
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	crypto_shash_init(desc);
 
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 57e5dca3253f6..d2fb72811442a 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2247,8 +2247,6 @@ artpec6_crypto_hash_set_key(struct crypto_ahash *tfm,
 		SHASH_DESC_ON_STACK(hdesc, tfm_ctx->child_hash);
 
 		hdesc->tfm = tfm_ctx->child_hash;
-		hdesc->flags = crypto_ahash_get_flags(tfm) &
-			       CRYPTO_TFM_REQ_MAY_SLEEP;
 
 		tfm_ctx->hmac_key_length = blocksize;
 		ret = crypto_shash_digest(hdesc, key, keylen,
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 28f592f7e1b7a..2bf3c034b7551 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2139,7 +2139,6 @@ static int ahash_init(struct ahash_request *req)
 			goto err_hash;
 		}
 		ctx->shash->tfm = hash;
-		ctx->shash->flags = 0;
 
 		/* Set the key using data we already have from setkey */
 		if (ctx->authkeylen > 0) {
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index d8cda5fb75ad8..91ec56399d84c 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -242,7 +242,6 @@ int do_shash(unsigned char *name, unsigned char *result,
 		goto do_shash_err;
 	}
 	sdesc->shash.tfm = hash;
-	sdesc->shash.flags = 0x0;
 
 	if (key_len > 0) {
 		rc = crypto_shash_setkey(hash, key, key_len);
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 10a61cd54fced..3e10573f589e7 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -293,8 +293,6 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (key_len > block_size) {
 		/* Must hash the input key */
 		sdesc->tfm = shash;
-		sdesc->flags = crypto_ahash_get_flags(tfm) &
-			CRYPTO_TFM_REQ_MAY_SLEEP;
 
 		ret = crypto_shash_digest(sdesc, key, key_len,
 					  ctx->u.sha.key);
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 8d8cf80b92940..8a76fce229435 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2130,7 +2130,6 @@ static int chcr_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	 * ipad in hmacctx->ipad and opad in hmacctx->opad location
 	 */
 	shash->tfm = hmacctx->base_hash;
-	shash->flags = crypto_shash_get_flags(hmacctx->base_hash);
 	if (keylen > bs) {
 		err = crypto_shash_digest(shash, key, keylen,
 					  hmacctx->ipad);
@@ -3517,7 +3516,6 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 		SHASH_DESC_ON_STACK(shash, base_hash);
 
 		shash->tfm = base_hash;
-		shash->flags = crypto_shash_get_flags(base_hash);
 		bs = crypto_shash_blocksize(base_hash);
 		align = KEYCTX_ALIGN_PAD(max_authsize);
 		o_ptr =  actx->h_iopad + param.result_size + align;
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 5f4f845adbb8e..a0806ba40c68d 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -365,7 +365,6 @@ static int mtk_sha_finish_hmac(struct ahash_request *req)
 	SHASH_DESC_ON_STACK(shash, bctx->shash);
 
 	shash->tfm = bctx->shash;
-	shash->flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
 
 	return crypto_shash_init(shash) ?:
 	       crypto_shash_update(shash, bctx->opad, ctx->bs) ?:
@@ -810,8 +809,6 @@ static int mtk_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 	SHASH_DESC_ON_STACK(shash, bctx->shash);
 
 	shash->tfm = bctx->shash;
-	shash->flags = crypto_shash_get_flags(bctx->shash) &
-		       CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (keylen > bs) {
 		err = crypto_shash_digest(shash, key, keylen, bctx->ipad);
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 9450c41211b28..06a7ab3608221 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -469,8 +469,6 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return err;
 
 	shash->tfm = child_shash;
-	shash->flags = crypto_ahash_get_flags(tfm) &
-		CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	bs = crypto_shash_blocksize(child_shash);
 	ds = crypto_shash_digestsize(child_shash);
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 0641185bd82f9..51b20abac4647 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1055,7 +1055,6 @@ static int omap_sham_finish_hmac(struct ahash_request *req)
 	SHASH_DESC_ON_STACK(shash, bctx->shash);
 
 	shash->tfm = bctx->shash;
-	shash->flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
 
 	return crypto_shash_init(shash) ?:
 	       crypto_shash_update(shash, bctx->opad, bs) ?:
@@ -1226,7 +1225,6 @@ static int omap_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
 	SHASH_DESC_ON_STACK(shash, tfm);
 
 	shash->tfm = tfm;
-	shash->flags = flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	return crypto_shash_digest(shash, data, len, out);
 }
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 21e5cae0a1e04..e641481a3cd9a 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -39,7 +39,6 @@ static int padlock_sha_init(struct shash_desc *desc)
 	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
 
 	dctx->fallback.tfm = ctx->fallback;
-	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 	return crypto_shash_init(&dctx->fallback);
 }
 
@@ -48,7 +47,6 @@ static int padlock_sha_update(struct shash_desc *desc,
 {
 	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
 
-	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 	return crypto_shash_update(&dctx->fallback, data, length);
 }
 
@@ -65,7 +63,6 @@ static int padlock_sha_import(struct shash_desc *desc, const void *in)
 	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
 
 	dctx->fallback.tfm = ctx->fallback;
-	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 	return crypto_shash_import(&dctx->fallback, in);
 }
 
@@ -91,7 +88,6 @@ static int padlock_sha1_finup(struct shash_desc *desc, const u8 *in,
 	unsigned int leftover;
 	int err;
 
-	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 	err = crypto_shash_export(&dctx->fallback, &state);
 	if (err)
 		goto out;
@@ -153,7 +149,6 @@ static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
 	unsigned int leftover;
 	int err;
 
-	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 	err = crypto_shash_export(&dctx->fallback, &state);
 	if (err)
 		goto out;
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 975c75198f56d..c8d401646902f 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -164,7 +164,6 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	memset(ctx->ipad, 0, block_size);
 	memset(ctx->opad, 0, block_size);
 	shash->tfm = ctx->hash_tfm;
-	shash->flags = 0x0;
 
 	if (auth_keylen > block_size) {
 		int ret = crypto_shash_digest(shash, auth_key,
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 1afdcb81d8ed1..9ef25230c1995 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1534,7 +1534,6 @@ static int s5p_hash_shash_digest(struct crypto_shash *tfm, u32 flags,
 	SHASH_DESC_ON_STACK(shash, tfm);
 
 	shash->tfm = tfm;
-	shash->flags = flags & ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	return crypto_shash_digest(shash, data, len, out);
 }
diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 611ff591410ea..b5a6883bb09eb 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -101,7 +101,6 @@ static int p8_ghash_init(struct shash_desc *desc)
 	dctx->bytes = 0;
 	memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
 	dctx->fallback_desc.tfm = ctx->fallback;
-	dctx->fallback_desc.flags = desc->flags;
 	return crypto_shash_init(&dctx->fallback_desc);
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index 2e2dff4788334..ecf6e659c0dad 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -80,7 +80,6 @@ static inline u32 rxe_crc32(struct rxe_dev *rxe,
 	SHASH_DESC_ON_STACK(shash, rxe->tfm);
 
 	shash->tfm = rxe->tfm;
-	shash->flags = 0;
 	*(u32 *)shash_desc_ctx(shash) = crc;
 	err = crypto_shash_update(shash, next, len);
 	if (unlikely(err)) {
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dd65657987780..9faed1c92b526 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -332,7 +332,6 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	int err;
 
 	desc->tfm = essiv->hash_tfm;
-	desc->flags = 0;
 
 	err = crypto_shash_digest(desc, cc->key, cc->key_size, essiv->salt);
 	shash_desc_zero(desc);
@@ -606,7 +605,6 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 	int i, r;
 
 	desc->tfm = lmk->hash_tfm;
-	desc->flags = 0;
 
 	r = crypto_shash_init(desc);
 	if (r)
@@ -768,7 +766,6 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 
 	/* calculate crc32 for every 32bit part and xor it */
 	desc->tfm = tcw->crc32_tfm;
-	desc->flags = 0;
 	for (i = 0; i < 4; i++) {
 		r = crypto_shash_init(desc);
 		if (r)
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d57d997a52c81..1366d886907c2 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -532,7 +532,6 @@ static void section_mac(struct dm_integrity_c *ic, unsigned section, __u8 result
 	unsigned j, size;
 
 	desc->tfm = ic->journal_mac;
-	desc->flags = 0;
 
 	r = crypto_shash_init(desc);
 	if (unlikely(r)) {
@@ -1278,7 +1277,6 @@ static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector
 	unsigned digest_size;
 
 	req->tfm = ic->internal_hash;
-	req->flags = 0;
 
 	r = crypto_shash_init(req);
 	if (unlikely(r < 0)) {
diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index 7ccdc62c6052e..ff61dd8748dea 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -222,7 +222,6 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 		goto out_free;
 	}
 	state->sha1->tfm = shash;
-	state->sha1->flags = 0;
 
 	digestsize = crypto_shash_digestsize(shash);
 	if (digestsize < MPPE_MAX_KEY_LEN)
diff --git a/drivers/net/wireless/intersil/orinoco/mic.c b/drivers/net/wireless/intersil/orinoco/mic.c
index 67b0c05afbdbe..a324bc4b79388 100644
--- a/drivers/net/wireless/intersil/orinoco/mic.c
+++ b/drivers/net/wireless/intersil/orinoco/mic.c
@@ -65,7 +65,6 @@ int orinoco_mic(struct crypto_shash *tfm_michael, u8 *key,
 	hdr[ETH_ALEN * 2 + 3] = 0;
 
 	desc->tfm = tfm_michael;
-	desc->flags = 0;
 
 	err = crypto_shash_setkey(tfm_michael, key, MIC_KEYLEN);
 	if (err)
diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index b7828fb252f27..b681073ae8bab 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -449,7 +449,6 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 		SHASH_DESC_ON_STACK(desc, tfm);
 
 		desc->tfm = tfm;
-		desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 		ret = crypto_shash_digest(desc, fw->image, image_size,
 					  hash_data);
diff --git a/drivers/staging/ks7010/ks_hostif.c b/drivers/staging/ks7010/ks_hostif.c
index 06ebea0be1184..122d4c0af3637 100644
--- a/drivers/staging/ks7010/ks_hostif.c
+++ b/drivers/staging/ks7010/ks_hostif.c
@@ -219,7 +219,6 @@ michael_mic(u8 *key, u8 *data, unsigned int len, u8 priority, u8 *result)
 	}
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index 55da8c9dfe50e..a084e1501f9da 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -507,7 +507,6 @@ static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
 	int err;
 
 	desc->tfm = tfm_michael;
-	desc->flags = 0;
 
 	if (crypto_shash_setkey(tfm_michael, key, 8))
 		return -1;
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index 829fa4bd253c0..d67bb57994c41 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -503,7 +503,6 @@ static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
 	int err;
 
 	desc->tfm = tfm_michael;
-	desc->flags = 0;
 
 	if (crypto_shash_setkey(tfm_michael, key, 8))
 		return -1;
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 4e680d753941f..ca7d7e8aecc01 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -252,7 +252,6 @@ static int chap_server_compute_md5(
 	}
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	ret = crypto_shash_init(desc);
 	if (ret < 0) {
diff --git a/drivers/thunderbolt/domain.c b/drivers/thunderbolt/domain.c
index 7416bdbd85761..b7980c856898e 100644
--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -678,7 +678,6 @@ int tb_domain_challenge_switch_key(struct tb *tb, struct tb_switch *sw)
 	}
 
 	shash->tfm = tfm;
-	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	memset(hmac, 0, sizeof(hmac));
 	ret = crypto_shash_digest(shash, challenge, sizeof(hmac), hmac);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index bee203055b300..1a6040998227c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -917,7 +917,6 @@ cifs_alloc_hash(const char *name,
 	}
 
 	(*sdesc)->shash.tfm = *shash;
-	(*sdesc)->shash.flags = 0x0;
 	return 0;
 }
 
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 322ce9686bdba..2cb4956f85117 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -402,7 +402,6 @@ static int derive_essiv_salt(const u8 *key, int keysize, u8 *salt)
 	{
 		SHASH_DESC_ON_STACK(desc, tfm);
 		desc->tfm = tfm;
-		desc->flags = 0;
 
 		return crypto_shash_digest(desc, key, keysize, salt);
 	}
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index f664da55234e9..491cf5baa8c23 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -68,7 +68,6 @@ static int ecryptfs_hash_digest(struct crypto_shash *tfm,
 	int err;
 
 	desc->tfm = tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	err = crypto_shash_digest(desc, src, len, dst);
 	shash_desc_zero(desc);
 	return err;
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index e74fe84d08868..90fbac5d485b3 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -769,7 +769,6 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	}
 
 	s->hash_desc->tfm = s->hash_tfm;
-	s->hash_desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	rc = crypto_shash_digest(s->hash_desc,
 				 (u8 *)s->auth_tok->token.password.session_key_encryption_key,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fac..0833b5fc0668a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2024,7 +2024,6 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
 
 	desc.shash.tfm = sbi->s_chksum_driver;
-	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
 
 	BUG_ON(crypto_shash_update(&desc.shash, address, length));
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 87f75ebd2fd60..21b0ab6bd15a4 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1422,7 +1422,6 @@ static inline u32 __f2fs_crc32(struct f2fs_sb_info *sbi, u32 crc,
 	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver) != sizeof(desc.ctx));
 
 	desc.shash.tfm = sbi->s_chksum_driver;
-	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
 
 	err = crypto_shash_update(&desc.shash, address, length);
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 5188f9f70c78c..8c8563441208f 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -126,7 +126,6 @@ nfs4_make_rec_clidname(char *dname, const struct xdr_netobj *clname)
 		SHASH_DESC_ON_STACK(desc, tfm);
 
 		desc->tfm = tfm;
-		desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 		status = crypto_shash_digest(desc, clname->data, clname->len,
 					     cksum.data);
diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 5bf5fd08879e6..b758004085c47 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -33,7 +33,6 @@ int __ubifs_node_calc_hash(const struct ubifs_info *c, const void *node,
 	int err;
 
 	shash->tfm = c->hash_tfm;
-	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = crypto_shash_digest(shash, node, le32_to_cpu(ch->len), hash);
 	if (err < 0)
@@ -56,7 +55,6 @@ static int ubifs_hash_calc_hmac(const struct ubifs_info *c, const u8 *hash,
 	int err;
 
 	shash->tfm = c->hmac_tfm;
-	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = crypto_shash_digest(shash, hash, c->hash_len, hmac);
 	if (err < 0)
@@ -88,7 +86,6 @@ int ubifs_prepare_auth_node(struct ubifs_info *c, void *node,
 		return -ENOMEM;
 
 	hash_desc->tfm = c->hash_tfm;
-	hash_desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	ubifs_shash_copy_state(c, inhash, hash_desc);
 
 	err = crypto_shash_final(hash_desc, hash);
@@ -123,7 +120,6 @@ static struct shash_desc *ubifs_get_desc(const struct ubifs_info *c,
 		return ERR_PTR(-ENOMEM);
 
 	desc->tfm = tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = crypto_shash_init(desc);
 	if (err) {
@@ -364,7 +360,6 @@ static int ubifs_node_calc_hmac(const struct ubifs_info *c, const void *node,
 	ubifs_assert(c, ofs_hmac + hmac_len < len);
 
 	shash->tfm = c->hmac_tfm;
-	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = crypto_shash_init(shash);
 	if (err)
@@ -483,7 +478,6 @@ int ubifs_hmac_wkm(struct ubifs_info *c, u8 *hmac)
 		return 0;
 
 	shash->tfm = c->hmac_tfm;
-	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = crypto_shash_init(shash);
 	if (err)
diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index 0a0e65c07c6d6..5c8a81a019a41 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -576,7 +576,6 @@ static int authenticate_sleb_hash(struct ubifs_info *c, struct shash_desc *log_h
 	SHASH_DESC_ON_STACK(hash_desc, c->hash_tfm);
 
 	hash_desc->tfm = c->hash_tfm;
-	hash_desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ubifs_shash_copy_state(c, log_hash, hash_desc);
 	return crypto_shash_final(hash_desc, hash);
@@ -587,7 +586,6 @@ static int authenticate_sleb_hmac(struct ubifs_info *c, u8 *hash, u8 *hmac)
 	SHASH_DESC_ON_STACK(hmac_desc, c->hmac_tfm);
 
 	hmac_desc->tfm = c->hmac_tfm;
-	hmac_desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	return crypto_shash_digest(hmac_desc, hash, c->hash_len, hmac);
 }
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 3b31c1b349ae6..d21bea2c43829 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -146,8 +146,6 @@ struct ahash_alg {
 
 struct shash_desc {
 	struct crypto_shash *tfm;
-	u32 flags;
-
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -819,6 +817,7 @@ static inline void *shash_desc_ctx(struct shash_desc *desc)
  * cipher handle must point to a keyed message digest cipher in order for this
  * function to succeed.
  *
+ * Context: Any context.
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
@@ -835,6 +834,7 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
  * crypto_shash_update and crypto_shash_final. The parameters have the same
  * meaning as discussed for those separate three functions.
  *
+ * Context: Any context.
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
@@ -850,6 +850,7 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
  * caller-allocated output buffer out which must have sufficient size (e.g. by
  * calling crypto_shash_descsize).
  *
+ * Context: Any context.
  * Return: 0 if the export creation was successful; < 0 if an error occurred
  */
 static inline int crypto_shash_export(struct shash_desc *desc, void *out)
@@ -866,6 +867,7 @@ static inline int crypto_shash_export(struct shash_desc *desc, void *out)
  * the input buffer. That buffer should have been generated with the
  * crypto_ahash_export function.
  *
+ * Context: Any context.
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
 static inline int crypto_shash_import(struct shash_desc *desc, const void *in)
@@ -886,6 +888,7 @@ static inline int crypto_shash_import(struct shash_desc *desc, const void *in)
  * operational state handle. Any potentially existing state created by
  * previous operations is discarded.
  *
+ * Context: Any context.
  * Return: 0 if the message digest initialization was successful; < 0 if an
  *	   error occurred
  */
@@ -907,6 +910,7 @@ static inline int crypto_shash_init(struct shash_desc *desc)
  *
  * Updates the message digest state of the operational state handle.
  *
+ * Context: Any context.
  * Return: 0 if the message digest update was successful; < 0 if an error
  *	   occurred
  */
@@ -923,6 +927,7 @@ int crypto_shash_update(struct shash_desc *desc, const u8 *data,
  * into the output buffer. The caller must ensure that the output buffer is
  * large enough by using crypto_shash_digestsize.
  *
+ * Context: Any context.
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
@@ -939,6 +944,7 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out);
  * crypto_shash_update and crypto_shash_final. The parameters have the same
  * meaning as discussed for those separate functions.
  *
+ * Context: Any context.
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5fe84fd..c2ffff5f9ae28 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1606,7 +1606,6 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 		JBD_MAX_CHECKSUM_SIZE);
 
 	desc.shash.tfm = journal->j_chksum_driver;
-	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
 
 	err = crypto_shash_update(&desc.shash, address, length);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f1d0e00a3971e..f7fb8f6a688fd 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -688,7 +688,6 @@ static int kexec_calculate_store_digests(struct kimage *image)
 		goto out_free_desc;
 
 	desc->tfm   = tfm;
-	desc->flags = 0;
 
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 4d0d47c1ffbd4..e89ebfdbb0fc0 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -69,7 +69,6 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 
 	rcu_read_lock();
 	desc.shash.tfm = rcu_dereference(crct10dif_tfm);
-	desc.shash.flags = 0;
 	*(__u16 *)desc.ctx = crc;
 
 	err = crypto_shash_update(&desc.shash, buffer, len);
diff --git a/lib/digsig.c b/lib/digsig.c
index 6ba6fcd92dd10..3b0a579bdcdf8 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -240,7 +240,6 @@ int digsig_verify(struct key *keyring, const char *sig, int siglen,
 		goto err;
 
 	desc->tfm = shash;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	crypto_shash_init(desc);
 	crypto_shash_update(desc, data, datalen);
diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index f0a2934605bff..4e9829c4d64c3 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -47,7 +47,6 @@ u32 crc32c(u32 crc, const void *address, unsigned int length)
 	int err;
 
 	shash->tfm = tfm;
-	shash->flags = 0;
 	*ctx = crc;
 
 	err = crypto_shash_update(shash, address, length);
diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
index 78bec8df8525b..aaa39409eeb75 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -161,7 +161,6 @@ static int hmac_sha256(u8 *key, u8 ksize, char *plaintext, u8 psize, u8 *output)
 	}
 
 	shash->tfm = tfm;
-	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ret = crypto_shash_digest(shash, plaintext, psize, output);
 
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 621146d04c038..e68c715f8d371 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -183,7 +183,6 @@ static int aes_cmac(struct crypto_shash *tfm, const u8 k[16], const u8 *m,
 	}
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	/* Swap key and message from LSB to MSB */
 	swap_buf(k, tmp, 16);
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 39d72e58b8e55..31569f4809f65 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -760,7 +760,6 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 		SHASH_DESC_ON_STACK(desc, tfm);
 
 		desc->tfm = tfm;
-		desc->flags = 0;
 		crypto_shash_digest(desc, (u8 *)auth,
 				    end - (unsigned char *)auth, digest);
 		shash_desc_zero(desc);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d05c57664e36e..72e74503f9fc6 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1684,7 +1684,6 @@ static struct sctp_cookie_param *sctp_pack_cookie(
 
 		/* Sign the message.  */
 		desc->tfm = sctp_sk(ep->base.sk)->hmac;
-		desc->flags = 0;
 
 		err = crypto_shash_setkey(desc->tfm, ep->secret_key,
 					  sizeof(ep->secret_key)) ?:
@@ -1755,7 +1754,6 @@ struct sctp_association *sctp_unpack_cookie(
 		int err;
 
 		desc->tfm = sctp_sk(ep->base.sk)->hmac;
-		desc->flags = 0;
 
 		err = crypto_shash_setkey(desc->tfm, ep->secret_key,
 					  sizeof(ep->secret_key)) ?:
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index 4f43383971baa..6f2d30d7b766d 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -977,7 +977,6 @@ krb5_rc4_setup_seq_key(struct krb5_ctx *kctx,
 	}
 
 	desc->tfm = hmac;
-	desc->flags = 0;
 
 	/* Compute intermediate Kseq from session key */
 	err = crypto_shash_setkey(hmac, kctx->Ksess, kctx->gk5e->keylength);
@@ -1045,7 +1044,6 @@ krb5_rc4_setup_enc_key(struct krb5_ctx *kctx,
 	}
 
 	desc->tfm = hmac;
-	desc->flags = 0;
 
 	/* Compute intermediate Kcrypt from session key */
 	for (i = 0; i < kctx->gk5e->keylength; i++)
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 56cc85c5bc06d..6e5d6d2402158 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -438,7 +438,6 @@ context_derive_keys_rc4(struct krb5_ctx *ctx)
 	}
 
 	desc->tfm = hmac;
-	desc->flags = 0;
 
 	err = crypto_shash_digest(desc, sigkeyconstant, slen, ctx->cksum);
 	kzfree(desc);
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 35f06563207dd..11eaa5956f001 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -501,7 +501,6 @@ static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
 	}
 
 	desc->tfm = tfm_michael;
-	desc->flags = 0;
 
 	if (crypto_shash_setkey(tfm_michael, key, 8))
 		return -1;
diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index af03d98c75520..baba63bc66b1d 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -43,7 +43,6 @@ char *aa_calc_hash(void *data, size_t len)
 		goto fail;
 
 	desc->tfm = apparmor_tfm;
-	desc->flags = 0;
 
 	error = crypto_shash_init(desc);
 	if (error)
@@ -81,7 +80,6 @@ int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 		goto fail;
 
 	desc->tfm = apparmor_tfm;
-	desc->flags = 0;
 
 	error = crypto_shash_init(desc);
 	if (error)
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index c37d08118af5d..e11564eb645bb 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -124,7 +124,6 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 		return ERR_PTR(-ENOMEM);
 
 	desc->tfm = *tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	rc = crypto_shash_init(desc);
 	if (rc) {
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 16a4f45863b18..a32878e10ebc9 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -333,7 +333,6 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	SHASH_DESC_ON_STACK(shash, tfm);
 
 	shash->tfm = tfm;
-	shash->flags = 0;
 
 	hash->length = crypto_shash_digestsize(tfm);
 
@@ -469,7 +468,6 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 	int rc, i;
 
 	shash->tfm = tfm;
-	shash->flags = 0;
 
 	hash->length = crypto_shash_digestsize(tfm);
 
@@ -591,7 +589,6 @@ static int calc_buffer_shash_tfm(const void *buf, loff_t size,
 	int rc;
 
 	shash->tfm = tfm;
-	shash->flags = 0;
 
 	hash->length = crypto_shash_digestsize(tfm);
 
@@ -664,7 +661,6 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
 	SHASH_DESC_ON_STACK(shash, tfm);
 
 	shash->tfm = tfm;
-	shash->flags = 0;
 
 	rc = crypto_shash_init(shash);
 	if (rc != 0)
diff --git a/security/keys/dh.c b/security/keys/dh.c
index 711e89d8c4153..23f95dec771bc 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -112,7 +112,6 @@ static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
 	if (!sdesc)
 		goto out_free_tfm;
 	sdesc->shash.tfm = tfm;
-	sdesc->shash.flags = 0x0;
 
 	*sdesc_ret = sdesc;
 
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 347108f660a18..1b1456b21a938 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -333,7 +333,6 @@ static int calc_hash(struct crypto_shash *tfm, u8 *digest,
 	int err;
 
 	desc->tfm = tfm;
-	desc->flags = 0;
 
 	err = crypto_shash_digest(desc, buf, buflen, digest);
 	shash_desc_zero(desc);
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index bcc9c6ead7fd3..45ffd9e539371 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -55,7 +55,6 @@ static struct sdesc *init_sdesc(struct crypto_shash *alg)
 	if (!sdesc)
 		return ERR_PTR(-ENOMEM);
 	sdesc->shash.tfm = alg;
-	sdesc->shash.flags = 0x0;
 	return sdesc;
 }
 
-- 
2.21.0

