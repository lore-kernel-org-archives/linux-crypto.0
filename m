Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863E51386DA
	for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2024 07:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732866430; cv=none; b=YO4pnweAwpXjZo6i6OxBL9Latf0lkmbk28pA6QOFJtFEEfXuvaM54bK+TMLPvVHBgp4ijLNnHvOLimUbCN8he8OTQqlCJIn/6Te2wy/dZKgtaM55nmToDlrzGCLltPT5to+WLaypja0AgFTzbR458w1oHXSR8f3FuNWTKpelCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732866430; c=relaxed/simple;
	bh=cjyBJ+T/YR3Y3tHS7qyPO5oLlmCFprhBBNMx2vdSpbc=;
	h=Message-Id:From:Date:Subject:To:Cc; b=Yqi+Z7f/am1Hen5yrVbgzrezXsw42ffCRzMt8LY1wMTRfkfU37KEsUjxmyU1JY9zGXHu/ZkMcILMKqiIF6P7mkL3hzv3gsmlA1IP5QgKvvkvmiMEwuZa4e/AWQtnv8tMSsbl3kqxVZkZxlgFHrbJKllFECHWyE06uogSoIKB554=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id C90963000D5B1;
	Fri, 29 Nov 2024 08:46:56 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id A58C4C719D; Fri, 29 Nov 2024 08:46:56 +0100 (CET)
Message-Id: <3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Fri, 29 Nov 2024 08:46:58 +0100
Subject: [PATCH crypto-2.6] crypto: rsassa-pkcs1 - Avoid pointing to rodata in
 scatterlists
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Zorro Lang <zlang@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-crypto@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Zorro reports a BUG_ON() when running boot-time crypto selftests on
arm64:

Since commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg
backend"), sg_set_buf() is called with the address of a test vector in
the .rodata section.  That fails on arm64 as virt_addr_valid() returns
false.  Architectures such as x86 are more lenient and transparently
translate the virtual address pointing into the kernel image to a
physical address.  However Mark points out that the BUG_ON() may still
occur if testmgr.c is built as a module because the test vectors would
then be module/vmalloc addresses rather than virt/linear or kernel image
addresses.

Avoid the issue by auto-detecting whether the src buffer of a sign or
verify operation is a valid virtual address and duplicating the buffer
if not.

An alternative approach would be to use crypto_akcipher_sync_encrypt()
and crypto_akcipher_sync_decrypt(), however that would *always*
duplicate the src buffer (rather than only when it's necessary)
and thus negatively impact performance.

In addition to the src buffer, the Full Hash Prefix likewise lives in
the .rodata section and is always included in a scatterlist when
performing a sign operation, so duplicate it on instance creation.

Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
Reported-by: Zorro Lang <zlang@redhat.com>
Closes: https://lore.kernel.org/r/20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Mark Rutland <mark.rutland@arm.com>
---
 crypto/rsassa-pkcs1.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 4d077fc9..5839a85 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -153,6 +153,7 @@ struct rsassa_pkcs1_ctx {
 struct rsassa_pkcs1_inst_ctx {
 	struct crypto_akcipher_spawn spawn;
 	const struct hash_prefix *hash_prefix;
+	const u8 *hash_prefix_data;
 };
 
 static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
@@ -165,6 +166,7 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 	struct rsassa_pkcs1_ctx *ctx = crypto_sig_ctx(tfm);
 	unsigned int child_reqsize = crypto_akcipher_reqsize(ctx->child);
 	struct akcipher_request *child_req __free(kfree_sensitive) = NULL;
+	void *src_copy __free(kfree_sensitive) = NULL;
 	struct scatterlist in_sg[3], out_sg;
 	struct crypto_wait cwait;
 	unsigned int pad_len;
@@ -185,6 +187,16 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 	if (slen + hash_prefix->size > ctx->key_size - 11)
 		return -EOVERFLOW;
 
+	/*
+	 * Only kmalloc virtual addresses shall be used in a scatterlist,
+	 * so duplicate src if it points e.g. into kernel or module rodata.
+	 */
+	if (!virt_addr_valid(src)) {
+		src = src_copy = kmemdup(src, slen, GFP_KERNEL);
+		if (!src)
+			return -ENOMEM;
+	}
+
 	pad_len = ctx->key_size - slen - hash_prefix->size - 1;
 
 	child_req = kmalloc(sizeof(*child_req) + child_reqsize + pad_len,
@@ -203,7 +215,7 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 	crypto_init_wait(&cwait);
 	sg_init_table(in_sg, 3);
 	sg_set_buf(&in_sg[0], in_buf, pad_len);
-	sg_set_buf(&in_sg[1], hash_prefix->data, hash_prefix->size);
+	sg_set_buf(&in_sg[1], ictx->hash_prefix_data, hash_prefix->size);
 	sg_set_buf(&in_sg[2], src, slen);
 	sg_init_one(&out_sg, dst, dlen);
 	akcipher_request_set_tfm(child_req, ctx->child);
@@ -239,6 +251,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	struct rsassa_pkcs1_ctx *ctx = crypto_sig_ctx(tfm);
 	unsigned int child_reqsize = crypto_akcipher_reqsize(ctx->child);
 	struct akcipher_request *child_req __free(kfree_sensitive) = NULL;
+	void *src_copy __free(kfree_sensitive) = NULL;
 	struct scatterlist in_sg, out_sg;
 	struct crypto_wait cwait;
 	unsigned int dst_len;
@@ -252,6 +265,16 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	    rsassa_pkcs1_invalid_hash_len(dlen, hash_prefix))
 		return -EINVAL;
 
+	/*
+	 * Only kmalloc virtual addresses shall be used in a scatterlist,
+	 * so duplicate src if it points e.g. into kernel or module rodata.
+	 */
+	if (!virt_addr_valid(src)) {
+		src = src_copy = kmemdup(src, slen, GFP_KERNEL);
+		if (!src)
+			return -ENOMEM;
+	}
+
 	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
 	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
 			    GFP_KERNEL);
@@ -366,6 +389,7 @@ static void rsassa_pkcs1_free(struct sig_instance *inst)
 	struct crypto_akcipher_spawn *spawn = &ctx->spawn;
 
 	crypto_drop_akcipher(spawn);
+	kfree(ctx->hash_prefix_data);
 	kfree(inst);
 }
 
@@ -412,6 +436,13 @@ static int rsassa_pkcs1_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto err_free_inst;
 	}
 
+	ctx->hash_prefix_data = kmemdup(ctx->hash_prefix->data,
+					ctx->hash_prefix->size, GFP_KERNEL);
+	if (!ctx->hash_prefix_data) {
+		err = -ENOMEM;
+		goto err_free_inst;
+	}
+
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "pkcs1(%s,%s)", rsa_alg->base.cra_name,
-- 
2.43.0

