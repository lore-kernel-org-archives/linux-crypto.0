Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDE3D5252;
	Wed, 15 Jul 2026 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153568; cv=none; b=u/4TttXZ/AHvbgMIglsEBTqZQV8WgMaZ1cAuTHYA9eTMKF44OEKkIfrWSoaswscwdJDJ3Xca6qj6CTQtMHIouvS1xSXSk9XoxmqoyVIeslwqhV0ao61yfV3wjGaT3DHUcSwuLqapazZc7TRdN/k1enC1v07pzH1t8DkGqPIEDFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153568; c=relaxed/simple;
	bh=/Prcikhmu8XrhKbJiWPHIr0zTI9gWz+xF6iukhXfuYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+gneWrXMzwP/I+S26r0FENi04mI3V3DoxoEKsRTL5Q6tVBjbbhPd5fVCv8rXMrYD6mEfoCu7S5W7WWLekpgKdUYZT88YwvHblIjol/IkJytLx8pCjk7QlhLHqv/kES8qxxY/3yj03zr5nlQ1ULgSdpmcgT6VAxLIhXfhpMkxiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5CG0aQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5CG0aQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC19A1F00A3D;
	Wed, 15 Jul 2026 22:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153565;
	bh=mfbbgvlQ+9Z+7biX+EDzESayj6dZLFr8DxKzrfLdc1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5CG0aQqH5AwZLR+rXc1a5Ud3YY2lhdxYoQj9JxSCS+8xj/AAc/S7+wBe7UmUUsrD
	 DqqfyzGhPWixRvdYVaZYcndje8t7uYmzMuEet5mbmBQSSDSOhKwaAMX6/ccCmY3Nim
	 lwxd7yDchsuSeWyuLZHBLOFPhfucLni7kEtlhRuy8k5NzkYAq24+Cq0vqewBFlLcqj
	 Gv/TU33RfAToNleAUEagFuS6/dabQHlii3wS9qLWnplfG6aL48w4om7MoLuF8QMxYG
	 sbFpAUZZe73oAjXuGdlEaayw3Sz16kJGSBptDe6gVG2PaEFl2KZdgWphH36r3nJwWs
	 5Ne39dx7ZEOsg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 10/13] crypto: aes - Add CTR and XCTR support using library
Date: Wed, 15 Jul 2026 15:11:50 -0700
Message-ID: <20260715221153.246410-11-ebiggers@kernel.org>
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

Implement the "ctr(aes)" and "xctr(aes)" crypto_skcipher algorithms
using the corresponding library functions.

Among other benefits, this allows the architecture-optimized AES-CTR and
AES-XCTR code to be migrated into the library while still leaving it
accessible via crypto_skcipher, eliminating lots of boilerplate code.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of these algorithms haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |  1 +
 crypto/aes.c   | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f413cfc9a3e2..5a198275e4fc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -360,6 +360,7 @@ config CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_AES_CBC if CRYPTO_CBC != n || CRYPTO_CTS != n
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
+	select CRYPTO_LIB_AES_CTR if CRYPTO_CTR != n || CRYPTO_XCTR != n
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB != n
 	select CRYPTO_HASH if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
 	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
diff --git a/crypto/aes.c b/crypto/aes.c
index 2455abc29252..6b298e788630 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -7,6 +7,7 @@
 
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/aes-cbc.h>
+#include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
@@ -456,6 +457,31 @@ crypto_aes_cbc_cts_decrypt(struct skcipher_request *req)
 	return crypto_aes_cbc_cts_crypt_nonlinear(req, /* enc= */ false);
 }
 
+/* AES-CTR */
+
+static __maybe_unused int crypto_aes_ctr_crypt(struct skcipher_request *req)
+{
+	const struct aes_enckey *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	AES_CRYPT_SG(aes_ctr, req->dst, req->src, req->cryptlen, 0, req->iv,
+		     key);
+	return 0;
+}
+
+/* AES-XCTR */
+
+static __maybe_unused int crypto_aes_xctr_crypt(struct skcipher_request *req)
+{
+	const struct aes_enckey *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	u64 ctr = 1;
+
+	AES_CRYPT_SG(aes_xctr, req->dst, req->src, req->cryptlen, 0, &ctr,
+		     req->iv, key);
+	return 0;
+}
+
 static struct skcipher_alg skcipher_algs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_ECB)
 	{
@@ -504,6 +530,40 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_cbc_cts_decrypt,
 	},
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CTR)
+	{
+		.base.cra_name = "ctr(aes)",
+		.base.cra_driver_name = "ctr-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = 1,
+		.base.cra_ctxsize = sizeof(struct aes_enckey),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.chunksize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_skcipher_setenckey,
+		.encrypt = crypto_aes_ctr_crypt,
+		.decrypt = crypto_aes_ctr_crypt,
+	},
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_XCTR)
+	{
+		.base.cra_name = "xctr(aes)",
+		.base.cra_driver_name = "xctr-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = 1,
+		.base.cra_ctxsize = sizeof(struct aes_enckey),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.chunksize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_skcipher_setenckey,
+		.encrypt = crypto_aes_xctr_crypt,
+		.decrypt = crypto_aes_xctr_crypt,
+	},
+#endif
 };
 
 static int __init crypto_aes_mod_init(void)
@@ -576,3 +636,11 @@ MODULE_ALIAS_CRYPTO("cbc-aes-lib");
 MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
 MODULE_ALIAS_CRYPTO("cts-cbc-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CTR)
+MODULE_ALIAS_CRYPTO("ctr(aes)");
+MODULE_ALIAS_CRYPTO("ctr-aes-lib");
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_XCTR)
+MODULE_ALIAS_CRYPTO("xctr(aes)");
+MODULE_ALIAS_CRYPTO("xctr-aes-lib");
+#endif
-- 
2.55.0

