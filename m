Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41F93D47D9;
	Wed, 15 Jul 2026 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153566; cv=none; b=DEKPr/N5S2lPK/3cQFyYSUm96Yn1g4TZUb57DXti4J1d54qNI1A4KjaBK8DBuGLTOqo2/7k6TrpdVklDTZvS/LFLgHyp83Wo71W7K9uwatA8/tPZADhgbHWD2h0KStVmZifnVzeZXgU11dXhvBSYMa4bU1kJkFZuJk4mFkcCNJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153566; c=relaxed/simple;
	bh=emc4ZzynoiIxASrNcQvknVIfR6XSRRDto7re5ntlg6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+WQvtrpL6m0Ih0KQPf9LTyItArpYwMZPwq1tiHeuvL/aSSFrtL2ryRgrffrIXFVuTpv8pp4+tKtk4UEFhNyyyk6SttctsctFJoLSpkUVWBvhVzj0XQ+nAAq+OfIFBCdQYqA7OAjaI4HPp1t38fAnUiv2QK2G4sLXbKTGxZTw30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGEAqaBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGEAqaBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770CC1F00ACA;
	Wed, 15 Jul 2026 22:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153564;
	bh=aJSWNLerwUGZGtDyOQn2ByaQCAig9/sHV/RcIsrhaXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGEAqaBR4n1zDC9UIQJtoJEeN8ECKY3CUbdBgO5ugOE0Sy1Yvpc1e1JRY8LGcQBK6
	 fmzfY4sgRSggrLTmjFHm+K4dMqHa9iMeESX+mg2RNZ66CZhgkLI1tVaA6X4GS2XUWZ
	 RtkFNdbUQbDrdk4s6MsnhFIErbrnlMxOVv2DvadHlBgT/JWv+Q8Y7MmRZH/RRPsmxx
	 mnTXBeWbnEdsH9Pp2bqvDOtymERBBu3Dp5MeNWVdcdicar064FWIM5HqOUEShPVtFK
	 p7fkFF74CdNv7yfAfcZHGJoeACzuY7sr8S/X6PwtGRpzHU9+6ycBskiPuv2iJHXF1T
	 NLhC4G3yqnobg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 09/13] crypto: aes - Add CBC and CBC-CTS support using library
Date: Wed, 15 Jul 2026 15:11:49 -0700
Message-ID: <20260715221153.246410-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260715221153.246410-1-ebiggers@kernel.org>
References: <20260715221153.246410-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the "cbc(aes)" and "cts(cbc(aes))" crypto_skcipher algorithms
using the corresponding library functions.

Among other benefits, this allows the architecture-optimized AES-CBC and
AES-CBC-CTS code to be migrated into the library while still leaving it
accessible via crypto_skcipher, eliminating lots of boilerplate code.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of these algorithms haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   1 +
 crypto/aes.c   | 169 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1888ae9d3fa3..f413cfc9a3e2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -358,6 +358,7 @@ config CRYPTO_AES
 	tristate "AES (Advanced Encryption Standard)"
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_AES_CBC if CRYPTO_CBC != n || CRYPTO_CTS != n
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB != n
 	select CRYPTO_HASH if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
diff --git a/crypto/aes.c b/crypto/aes.c
index 5fc487e584c4..2455abc29252 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-cbc.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
@@ -221,6 +222,19 @@ crypto_aes_skcipher_setenckey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return aes_prepareenckey(key, in_key, key_len);
 }
 
+/*
+ * Return true if the request uses only a single scatterlist element and high
+ * memory isn't enabled.  This assumes that both scatterlists are non-NULL, i.e.
+ * the caller must have handled the cryptlen == 0 case already.
+ */
+static inline bool
+skcipher_request_is_linear_lowmem(const struct skcipher_request *req)
+{
+	return !IS_ENABLED(CONFIG_HIGHMEM) &&
+	       req->dst->length >= req->cryptlen &&
+	       req->src->length >= req->cryptlen;
+}
+
 /*
  * Call crypt_func() (a function that operates on simple virtual addresses) zero
  * or more times to en/decrypt 'cryptlen' bytes of data from the source
@@ -327,6 +341,121 @@ static __maybe_unused int crypto_aes_ecb_decrypt(struct skcipher_request *req)
 	return 0;
 }
 
+/* AES-CBC */
+
+static void crypto_aes_cbc_encrypt_sg(struct skcipher_request *req,
+				      unsigned int cryptlen,
+				      const struct aes_key *key)
+{
+	AES_CRYPT_SG(aes_cbc_encrypt, req->dst, req->src, cryptlen, 0, req->iv,
+		     key);
+}
+
+static void crypto_aes_cbc_decrypt_sg(struct skcipher_request *req,
+				      unsigned int cryptlen,
+				      const struct aes_key *key)
+{
+	AES_CRYPT_SG(aes_cbc_decrypt, req->dst, req->src, cryptlen, 0, req->iv,
+		     key);
+}
+
+static __maybe_unused int crypto_aes_cbc_encrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen % AES_BLOCK_SIZE))
+		return -EINVAL;
+	crypto_aes_cbc_encrypt_sg(req, req->cryptlen, key);
+	return 0;
+}
+
+static __maybe_unused int crypto_aes_cbc_decrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen % AES_BLOCK_SIZE))
+		return -EINVAL;
+	crypto_aes_cbc_decrypt_sg(req, req->cryptlen, key);
+	return 0;
+}
+
+/* AES-CBC-CTS */
+
+/*
+ * This handles AES-CBC-CTS en/decryption requests that use a nonlinear
+ * scatterlist layout or where HIGHMEM is enabled.  It is explicitly 'noinline'
+ * to keep the temporary buffer out of the stack frame of the fast path.
+ */
+static noinline int
+crypto_aes_cbc_cts_crypt_nonlinear(struct skcipher_request *req, bool enc)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	unsigned int main_len = req->cryptlen;
+	unsigned int tail_len;
+	u8 tmp[2 * AES_BLOCK_SIZE] __aligned(__alignof__(long));
+
+	if (main_len == AES_BLOCK_SIZE) {
+		/* Single block is a special case that just does CBC. */
+		if (enc)
+			crypto_aes_cbc_encrypt_sg(req, main_len, key);
+		else
+			crypto_aes_cbc_decrypt_sg(req, main_len, key);
+		return 0;
+	}
+	/* Just do the last two blocks separately. */
+	tail_len = AES_BLOCK_SIZE + ((main_len - 1) % AES_BLOCK_SIZE) + 1;
+	main_len -= tail_len;
+	if (enc)
+		crypto_aes_cbc_encrypt_sg(req, main_len, key);
+	else
+		crypto_aes_cbc_decrypt_sg(req, main_len, key);
+	memcpy_from_sglist(tmp, req->src, main_len, tail_len);
+	if (enc)
+		aes_cbc_cts_encrypt(tmp, tmp, tail_len, req->iv, key);
+	else
+		aes_cbc_cts_decrypt(tmp, tmp, tail_len, req->iv, key);
+	memcpy_to_sglist(req->dst, main_len, tmp, tail_len);
+	memzero_explicit(tmp, sizeof(tmp));
+	return 0;
+}
+
+static __maybe_unused int
+crypto_aes_cbc_cts_encrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (likely(skcipher_request_is_linear_lowmem(req))) {
+		/* Fast path */
+		aes_cbc_cts_encrypt(sg_virt(req->dst), sg_virt(req->src),
+				    req->cryptlen, req->iv, key);
+		return 0;
+	}
+	return crypto_aes_cbc_cts_crypt_nonlinear(req, /* enc= */ true);
+}
+
+static __maybe_unused int
+crypto_aes_cbc_cts_decrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (likely(skcipher_request_is_linear_lowmem(req))) {
+		/* Fast path */
+		aes_cbc_cts_decrypt(sg_virt(req->dst), sg_virt(req->src),
+				    req->cryptlen, req->iv, key);
+		return 0;
+	}
+	return crypto_aes_cbc_cts_crypt_nonlinear(req, /* enc= */ false);
+}
+
 static struct skcipher_alg skcipher_algs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_ECB)
 	{
@@ -343,6 +472,38 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_ecb_decrypt,
 	},
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CBC)
+	{
+		.base.cra_name = "cbc(aes)",
+		.base.cra_driver_name = "cbc-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct aes_key),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_skcipher_setkey,
+		.encrypt = crypto_aes_cbc_encrypt,
+		.decrypt = crypto_aes_cbc_decrypt,
+	},
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_CTS)
+	{
+		.base.cra_name = "cts(cbc(aes))",
+		.base.cra_driver_name = "cts-cbc-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct aes_key),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_skcipher_setkey,
+		.encrypt = crypto_aes_cbc_cts_encrypt,
+		.decrypt = crypto_aes_cbc_cts_decrypt,
+	},
+#endif
 };
 
 static int __init crypto_aes_mod_init(void)
@@ -407,3 +568,11 @@ MODULE_ALIAS_CRYPTO("cbcmac-aes-lib");
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("ecb-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CBC)
+MODULE_ALIAS_CRYPTO("cbc(aes)");
+MODULE_ALIAS_CRYPTO("cbc-aes-lib");
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_CTS)
+MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
+MODULE_ALIAS_CRYPTO("cts-cbc-aes-lib");
+#endif
-- 
2.55.0

