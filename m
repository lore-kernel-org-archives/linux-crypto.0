From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/16] crypto: seqiv - Add seqniv
Date: Thu, 21 May 2015 15:11:14 +0800
Message-ID: <E1YvKdO-0005gj-Lz@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48900 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbbEUHLR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:17 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdO-00031j-To
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:15 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a new IV generator seqniv which is identical to
seqiv except that it skips the IV when authenticating.  This is
intended to be used by algorithms such as rfc4106 that does the
IV authentication implicitly.

Note that the code used for seqniv is in fact identical to the
compatibility case for seqiv.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 27dbab8a..a9bfbda 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -584,6 +584,7 @@ static void seqiv_aead_exit(struct crypto_tfm *tfm)
 }
 
 static struct crypto_template seqiv_tmpl;
+static struct crypto_template seqniv_tmpl;
 
 static struct crypto_instance *seqiv_ablkcipher_alloc(struct rtattr **tb)
 {
@@ -710,6 +711,51 @@ put_rng:
 	goto out;
 }
 
+static struct crypto_instance *seqniv_alloc(struct rtattr **tb)
+{
+	struct aead_instance *inst;
+	struct crypto_aead_spawn *spawn;
+	struct aead_alg *alg;
+	int err;
+
+	err = crypto_get_default_rng();
+	if (err)
+		return ERR_PTR(err);
+
+	inst = aead_geniv_alloc(&seqniv_tmpl, tb, 0, 0);
+
+	if (IS_ERR(inst))
+		goto put_rng;
+
+	if (inst->alg.ivsize < sizeof(u64)) {
+		aead_geniv_free(inst);
+		inst = ERR_PTR(-EINVAL);
+		goto put_rng;
+	}
+
+	spawn = aead_instance_ctx(inst);
+	alg = crypto_spawn_aead_alg(spawn);
+
+	inst->alg.setkey = seqiv_aead_setkey;
+	inst->alg.setauthsize = seqiv_aead_setauthsize;
+	inst->alg.encrypt = seqiv_aead_encrypt_compat_first;
+	inst->alg.decrypt = seqiv_aead_decrypt_compat;
+
+	inst->alg.base.cra_init = seqiv_aead_compat_init;
+	inst->alg.base.cra_exit = seqiv_aead_compat_exit;
+
+	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
+	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
+	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
+
+out:
+	return aead_crypto_instance(inst);
+
+put_rng:
+	crypto_put_default_rng();
+	goto out;
+}
+
 static void seqiv_free(struct crypto_instance *inst)
 {
 	if ((inst->alg.cra_flags ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
@@ -726,9 +772,31 @@ static struct crypto_template seqiv_tmpl = {
 	.module = THIS_MODULE,
 };
 
+static struct crypto_template seqniv_tmpl = {
+	.name = "seqniv",
+	.alloc = seqniv_alloc,
+	.free = seqiv_free,
+	.module = THIS_MODULE,
+};
+
 static int __init seqiv_module_init(void)
 {
-	return crypto_register_template(&seqiv_tmpl);
+	int err;
+
+	err = crypto_register_template(&seqiv_tmpl);
+	if (err)
+		goto out;
+
+	err = crypto_register_template(&seqniv_tmpl);
+	if (err)
+		goto out_undo_niv;
+
+out:
+	return err;
+
+out_undo_niv:
+	crypto_unregister_template(&seqiv_tmpl);
+	goto out;
 }
 
 static void __exit seqiv_module_exit(void)
@@ -742,3 +810,4 @@ module_exit(seqiv_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Sequence Number IV Generator");
 MODULE_ALIAS_CRYPTO("seqiv");
+MODULE_ALIAS_CRYPTO("seqniv");
