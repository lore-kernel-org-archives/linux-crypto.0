Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795570568;
	b=ETkwSkU5GUUXK5nLiZcSlkjW19EZkA9gs/KH7U40H2DQ9ZrS5byEkJ1VUlK66b8EAUyn
	 edWuqMaGUfXHlQdRH+hM4OqxNvoQ+n5yyGeYX1140EjyqsDj/JYmw70w3qeO2s4vRTnFs
	 Hogvk++VE/GNxrHtuspK7EVoAMS/6VAuctcWPZztfI8Aldi6OHNRcOcOaImUv4gc552T9
	 78Qo+2euLbbvTy5tgt6EEk+6RUSJVYkqerrylqBejG9Xbl0GmwdAedlAu14nKem6x+dwx
	 /2IZwztA1n8N9EiOwi7XblFxG0+aSADVt/ranrgqMwwvqhyyhRt9QffJGdtsZKjPDCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795570568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z3Z/RZ1iLpPez8vxlH2tNMM5H+6B90tZKMExJt1Ugd4=;
	b=joDFcwmF34m4AJIlquiP4b6OmMAsmbE9F9hKC1RPkfFQLKRwcd+u95Lmp4d/pyfMIOLq
	 But18AyQYzBbhn28usNlNHsloFrYUaOEdq0F0dSijJ6lMb3NKXO+T8L/G82ZHoXYmgzvg
	 LgCwhTgXb01/Bz7/J9I1piCitU45Oq43b1n35NEIQ4GUA8upmNjuNE2sZi4Y6BGmTzO5r
	 zWEi+n24O8qqqRluMalMcYPSUztNrWf7vJTQd7NTyl5YJUQ57A/ai2NL6DFYYaAPvOK1e
	 L/cBEsM3zl7Skbyo193Ukn2q4VV78GEHg+nWe/oi4gvV6GPHISInwzm0ZddWfHBhAKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SQ+GGqMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5057606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SQ+GGqMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327E21F000C6;
	Wed, 25 Nov 2026 01:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795570567;
	bh=z3Z/RZ1iLpPez8vxlH2tNMM5H+6B90tZKMExJt1Ugd4=;
	h=From:To:Cc:Subject:Date;
	b=SQ+GGqMFa6yjJx5aZ+FNybfPaziORsb0tO4zf8KUMEBSx5hdD7+Vq4Tq2ts5/19ba
	 o05McK9MqSJrHK5JQbPapBDGVxL+FpK8k3VcN4w/Sj85Nt4njVQABvB2u92Uod+h6d
	 FE/vlA5sQjYuklwbDElRJ7bZwRbc2UL5BneJY4SIct0FKCcu0rE4btOuOlhRE3AMgy
	 ZCoC7ntZ19ft3dZzI9I0o1DqupEavVL1YTJ72sByEXjWv6TBTTNkklP0OhXiWhas5x
	 C9RBexn8/TE6jJajVOt23OYja1BxNPx4E0fOp1dsKOiK3FcP95PF0d6oQk5Y4qTr0k
	 ABkQfcS7dDfzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: adiantum - Eliminate slab memory allocation in setkey
Date: Tue, 24 Nov 2026 17:35:53 -0800
Message-ID: <20261125013553.94480-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instances of the adiantum template are some of the only skcipher
algorithms that allocate slab memory in their ->setkey() function.

This is causing a problem for blk-crypto, which sets a key while holding
a lock that can be taken during direct reclaim.

That case will be fixed by using memalloc_noio_save() to make the
allocation inherit GFP_NOIO
(https://lore.kernel.org/linux-block/20261123181408.62972-1-laveeshb@laveeshbansal.com/).
Regardless, there's actually no need for adiantum_setkey() to allocate
memory.  The only reason it did so originally was because "nhpoly1305"
was a separate crypto_shash algorithm, so the big NH key array was
hidden behind an opaque pointer.  However, that's now been fixed.

Eliminate the slab memory allocation in adiantum_setkey() by:

   (1) Making it generate the derived key material in adiantum_tfm_ctx,
       in the same memory where the final converted keys end up anyway.

   (2) Moving the skcipher_request, scatterlist, and IV to the stack.
       For safety, ensure the CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE flag is
       not set (though xchacha12 and xchacha20 don't set it anyway).

   (3) Deleting the crypto_wait object, which was unnecessary.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/adiantum.c | 81 +++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 38 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 5ddf585abb666..825958c6e4769 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -60,9 +60,15 @@ struct adiantum_instance_ctx {
 struct adiantum_tfm_ctx {
 	struct crypto_skcipher *streamcipher;
 	struct crypto_cipher *blockcipher;
-	struct poly1305_core_key header_hash_key;
-	struct poly1305_core_key msg_poly_key;
-	u32 nh_key[NH_KEY_WORDS];
+	union {
+		struct {
+			struct poly1305_core_key header_hash_key;
+			struct poly1305_core_key msg_poly_key;
+			u32 nh_key[NH_KEY_WORDS];
+		};
+		/* Used only during adiantum_setkey() */
+		u8 derived_keys[BLOCKCIPHER_KEY_SIZE + HASH_KEY_SIZE];
+	};
 };
 
 struct nhpoly1305_ctx {
@@ -106,14 +112,11 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	struct {
-		u8 iv[XCHACHA_IV_SIZE];
-		u8 derived_keys[BLOCKCIPHER_KEY_SIZE + HASH_KEY_SIZE];
-		struct scatterlist sg;
-		struct crypto_wait wait;
-		struct skcipher_request req; /* must be last */
-	} *data;
-	u8 *keyp;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(
+		req, (struct crypto_sync_skcipher *)tctx->streamcipher);
+	u8 poly_keys[2 * POLY1305_BLOCK_SIZE];
+	u8 iv[XCHACHA_IV_SIZE] = { 1 };
+	struct scatterlist sg;
 	int err;
 
 	/* Set the stream cipher key (K_S) */
@@ -126,46 +129,42 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return err;
 
 	/* Derive the subkeys */
-	data = kzalloc(sizeof(*data) +
-		       crypto_skcipher_reqsize(tctx->streamcipher), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-	data->iv[0] = 1;
-	sg_init_one(&data->sg, data->derived_keys, sizeof(data->derived_keys));
-	crypto_init_wait(&data->wait);
-	skcipher_request_set_tfm(&data->req, tctx->streamcipher);
-	skcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
-						  CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      crypto_req_done, &data->wait);
-	skcipher_request_set_crypt(&data->req, &data->sg, &data->sg,
-				   sizeof(data->derived_keys), data->iv);
-	err = crypto_wait_req(crypto_skcipher_encrypt(&data->req), &data->wait);
+	memset(tctx->derived_keys, 0, sizeof(tctx->derived_keys));
+	sg_init_one(&sg, tctx->derived_keys, sizeof(tctx->derived_keys));
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, &sg, &sg, sizeof(tctx->derived_keys),
+				   iv);
+	err = crypto_skcipher_encrypt(req);
 	if (err)
 		goto out;
-	keyp = data->derived_keys;
 
 	/* Set the block cipher key (K_E) */
 	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(tctx->blockcipher,
 				crypto_skcipher_get_flags(tfm) &
 				CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(tctx->blockcipher, keyp,
+	err = crypto_cipher_setkey(tctx->blockcipher, tctx->derived_keys,
 				   BLOCKCIPHER_KEY_SIZE);
 	if (err)
 		goto out;
-	keyp += BLOCKCIPHER_KEY_SIZE;
 
 	/* Set the hash key (K_H) */
-	poly1305_core_setkey(&tctx->header_hash_key, keyp);
-	keyp += POLY1305_BLOCK_SIZE;
-	poly1305_core_setkey(&tctx->msg_poly_key, keyp);
-	keyp += POLY1305_BLOCK_SIZE;
-	for (int i = 0; i < NH_KEY_WORDS; i++)
-		tctx->nh_key[i] = get_unaligned_le32(&keyp[i * 4]);
-	keyp += NH_KEY_BYTES;
-	WARN_ON(keyp != &data->derived_keys[ARRAY_SIZE(data->derived_keys)]);
+	memcpy(poly_keys, &tctx->derived_keys[BLOCKCIPHER_KEY_SIZE],
+	       2 * POLY1305_BLOCK_SIZE);
+	memmove(tctx->nh_key,
+		&tctx->derived_keys[BLOCKCIPHER_KEY_SIZE +
+				    2 * POLY1305_BLOCK_SIZE],
+		NH_KEY_BYTES);
+	poly1305_core_setkey(&tctx->header_hash_key, &poly_keys[0]);
+	poly1305_core_setkey(&tctx->msg_poly_key,
+			     &poly_keys[POLY1305_BLOCK_SIZE]);
+	le32_to_cpu_array(tctx->nh_key, NH_KEY_WORDS);
+	memzero_explicit(poly_keys, sizeof(poly_keys));
 out:
-	kfree_sensitive(data);
+	if (err)
+		memzero_explicit(tctx->derived_keys,
+				 sizeof(tctx->derived_keys));
+	skcipher_request_zero(req);
 	return err;
 }
 
@@ -506,6 +505,11 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	streamcipher = crypto_spawn_skcipher(&ictx->streamcipher_spawn);
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
+	if (WARN_ON(crypto_skcipher_reqsize(streamcipher) >
+		    MAX_SYNC_SKCIPHER_REQSIZE)) {
+		err = -EINVAL;
+		goto err_free_streamcipher;
+	}
 
 	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn);
 	if (IS_ERR(blockcipher)) {
@@ -590,7 +594,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = crypto_grab_skcipher(&ictx->streamcipher_spawn,
 				   skcipher_crypto_instance(inst),
 				   crypto_attr_alg_name(tb[1]), 0,
-				   mask | CRYPTO_ALG_ASYNC /* sync only */);
+				   mask | CRYPTO_ALG_ASYNC /* sync only */ |
+					   CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 	if (err)
 		goto err_free_inst;
 	streamcipher_alg = crypto_spawn_skcipher_alg_common(&ictx->streamcipher_spawn);

base-commit: 04cd6899aaaeeab82afb97e58eb8619fde35b47d
-- 
2.56.1

