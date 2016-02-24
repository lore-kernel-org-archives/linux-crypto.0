From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/2] crypto: Add hash param to pkcs1pad
Date: Wed, 24 Feb 2016 09:12:47 -0800
Message-ID: <20160224171247.29272.61682.stgit@tstruk-mobl1>
References: <20160224171237.29272.51126.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: dhowells@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160224171237.29272.51126.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This adds hash param to pkcs1pad.
The pkcs1pad template can work with or without the hash.
When hash param is provided then the verify operation will
also verify the output against the known digest.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa-pkcs1pad.c |  182 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 156 insertions(+), 26 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 50f5c97..1cea67d 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -18,12 +18,89 @@
 #include <linux/module.h>
 #include <linux/random.h>
 
+/*
+ * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
+ */
+static const u8 rsa_digest_info_md5[] = {
+	0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
+	0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
+	0x05, 0x00, 0x04, 0x10
+};
+
+static const u8 rsa_digest_info_sha1[] = {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2b, 0x0e, 0x03, 0x02, 0x1a,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 rsa_digest_info_rmd160[] = {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2b, 0x24, 0x03, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 rsa_digest_info_sha224[] = {
+	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
+	0x05, 0x00, 0x04, 0x1c
+};
+
+static const u8 rsa_digest_info_sha256[] = {
+	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x20
+};
+
+static const u8 rsa_digest_info_sha384[] = {
+	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
+	0x05, 0x00, 0x04, 0x30
+};
+
+static const u8 rsa_digest_info_sha512[] = {
+	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
+	0x05, 0x00, 0x04, 0x40
+};
+
+static const struct rsa_asn1_template {
+	const char	*name;
+	const u8	*data;
+	size_t		size;
+} rsa_asn1_templates[] = {
+#define _(X) { #X, rsa_digest_info_##X, sizeof(rsa_digest_info_##X) }
+	_(md5),
+	_(sha1),
+	_(rmd160),
+	_(sha256),
+	_(sha384),
+	_(sha512),
+	_(sha224),
+	{ NULL }
+#undef _
+};
+
+static const struct rsa_asn1_template *rsa_lookup_asn1(const char *name)
+{
+	const struct rsa_asn1_template *p;
+
+	for (p = rsa_asn1_templates; p->name; p++)
+		if (strcmp(name, p->name) == 0)
+			return p;
+	return NULL;
+}
+
 struct pkcs1pad_ctx {
 	struct crypto_akcipher *child;
-
+	const char *hash_name;
 	unsigned int key_size;
 };
 
+struct pkcs1pad_inst_ctx {
+	struct crypto_akcipher_spawn spawn;
+	const char *hash_name;
+};
+
 struct pkcs1pad_request {
 	struct akcipher_request child_req;
 
@@ -339,13 +416,22 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	const struct rsa_asn1_template *digest_info = NULL;
 	int err;
-	unsigned int ps_end;
+	unsigned int ps_end, digest_size = 0;
 
 	if (!ctx->key_size)
 		return -EINVAL;
 
-	if (req->src_len > ctx->key_size - 11)
+	if (ctx->hash_name) {
+		digest_info = rsa_lookup_asn1(ctx->hash_name);
+		if (!digest_info)
+			return -EINVAL;
+
+		digest_size = digest_info->size;
+	}
+
+	if (req->src_len + digest_size > ctx->key_size - 11)
 		return -EOVERFLOW;
 
 	if (req->dst_len < ctx->key_size) {
@@ -371,11 +457,16 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	if (!req_ctx->in_buf)
 		return -ENOMEM;
 
-	ps_end = ctx->key_size - req->src_len - 2;
+	ps_end = ctx->key_size - digest_size - req->src_len - 2;
 	req_ctx->in_buf[0] = 0x01;
 	memset(req_ctx->in_buf + 1, 0xff, ps_end - 1);
 	req_ctx->in_buf[ps_end] = 0x00;
 
+	if (digest_info) {
+		memcpy(req_ctx->in_buf + ps_end + 1, digest_info->data,
+		       digest_info->size);
+	}
+
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
@@ -408,6 +499,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	const struct rsa_asn1_template *digest_info;
 	unsigned int pos;
 
 	if (err == -EOVERFLOW)
@@ -422,20 +514,33 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 		goto done;
 	}
 
-	if (req_ctx->out_buf[0] != 0x01) {
-		err = -EINVAL;
+	err = -EBADMSG;
+	if (req_ctx->out_buf[0] != 0x01)
 		goto done;
-	}
+
 	for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
 		if (req_ctx->out_buf[pos] != 0xff)
 			break;
+
 	if (pos < 9 || pos == req_ctx->child_req.dst_len ||
-			req_ctx->out_buf[pos] != 0x00) {
-		err = -EINVAL;
+	    req_ctx->out_buf[pos] != 0x00)
 		goto done;
-	}
 	pos++;
 
+	if (ctx->hash_name) {
+		digest_info = rsa_lookup_asn1(ctx->hash_name);
+		if (!digest_info)
+			goto done;
+
+		if (memcmp(req_ctx->out_buf + pos, digest_info->data,
+			   digest_info->size))
+			goto done;
+
+		pos += digest_info->size;
+	}
+
+	err = 0;
+
 	if (req->dst_len < req_ctx->child_req.dst_len - pos)
 		err = -EOVERFLOW;
 	req->dst_len = req_ctx->child_req.dst_len - pos;
@@ -444,7 +549,6 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 		sg_copy_from_buffer(req->dst,
 				sg_nents_for_len(req->dst, req->dst_len),
 				req_ctx->out_buf + pos, req->dst_len);
-
 done:
 	kzfree(req_ctx->out_buf);
 
@@ -481,7 +585,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
 	int err;
 
-	if (!ctx->key_size || req->src_len != ctx->key_size)
+	if (!ctx->key_size || req->src_len < ctx->key_size)
 		return -EINVAL;
 
 	if (ctx->key_size > PAGE_SIZE)
@@ -518,6 +622,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 static int pkcs1pad_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct akcipher_instance *inst = akcipher_alg_instance(tfm);
+	struct pkcs1pad_inst_ctx *ictx = akcipher_instance_ctx(inst);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct crypto_akcipher *child_tfm;
 
@@ -526,7 +631,7 @@ static int pkcs1pad_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(child_tfm);
 
 	ctx->child = child_tfm;
-
+	ctx->hash_name = ictx->hash_name;
 	return 0;
 }
 
@@ -539,10 +644,11 @@ static void pkcs1pad_exit_tfm(struct crypto_akcipher *tfm)
 
 static void pkcs1pad_free(struct akcipher_instance *inst)
 {
-	struct crypto_akcipher_spawn *spawn = akcipher_instance_ctx(inst);
+	struct pkcs1pad_inst_ctx *ctx = akcipher_instance_ctx(inst);
+	struct crypto_akcipher_spawn *spawn = &ctx->spawn;
 
 	crypto_drop_akcipher(spawn);
-
+	kfree(ctx->hash_name);
 	kfree(inst);
 }
 
@@ -550,9 +656,11 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
 	struct akcipher_instance *inst;
+	struct pkcs1pad_inst_ctx *ctx;
 	struct crypto_akcipher_spawn *spawn;
 	struct akcipher_alg *rsa_alg;
 	const char *rsa_alg_name;
+	const char *hash_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -566,11 +674,18 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(rsa_alg_name))
 		return PTR_ERR(rsa_alg_name);
 
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	hash_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(hash_name))
+		hash_name = NULL;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
-	spawn = akcipher_instance_ctx(inst);
+	ctx = akcipher_instance_ctx(inst);
+	spawn = &ctx->spawn;
+	ctx->hash_name = hash_name ? kstrdup(hash_name, GFP_KERNEL) : NULL;
+
 	crypto_set_spawn(&spawn->base, akcipher_crypto_instance(inst));
 	err = crypto_grab_akcipher(spawn, rsa_alg_name, 0,
 			crypto_requires_sync(algt->type, algt->mask));
@@ -580,15 +695,28 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	rsa_alg = crypto_spawn_akcipher_alg(spawn);
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.base.cra_name,
-				CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
-				rsa_alg->base.cra_name) >=
-			CRYPTO_MAX_ALG_NAME ||
-			snprintf(inst->alg.base.cra_driver_name,
-				CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
-				rsa_alg->base.cra_driver_name) >=
-			CRYPTO_MAX_ALG_NAME)
+
+	if (!hash_name) {
+		if (snprintf(inst->alg.base.cra_name,
+			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
+			     rsa_alg->base.cra_name) >=
+					CRYPTO_MAX_ALG_NAME ||
+		    snprintf(inst->alg.base.cra_driver_name,
+			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
+			     rsa_alg->base.cra_driver_name) >=
+					CRYPTO_MAX_ALG_NAME)
 		goto out_drop_alg;
+	} else {
+		if (snprintf(inst->alg.base.cra_name,
+			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
+			     rsa_alg->base.cra_name, hash_name) >=
+				CRYPTO_MAX_ALG_NAME ||
+		    snprintf(inst->alg.base.cra_driver_name,
+			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
+			     rsa_alg->base.cra_driver_name, hash_name) >=
+					CRYPTO_MAX_ALG_NAME)
+		goto out_free_hash;
+	}
 
 	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = rsa_alg->base.cra_priority;
@@ -610,10 +738,12 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = akcipher_register_instance(tmpl, inst);
 	if (err)
-		goto out_drop_alg;
+		goto out_free_hash;
 
 	return 0;
 
+out_free_hash:
+	kfree(ctx->hash_name);
 out_drop_alg:
 	crypto_drop_akcipher(spawn);
 out_free_inst:
