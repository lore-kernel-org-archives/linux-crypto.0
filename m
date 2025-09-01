Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA53128D6;
	Mon,  1 Sep 2025 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756745560; cv=none; b=biXLpKwGNL+8oSrbeIUIW9l/yeol8nz6uBKHzBBmycLPbjw8iy1Bp0ITAkaVi45Z/ii5UWz76qUz71vejdC3X6VMl3Jc9ErEtBRBluANuQB+KgnOcCeXSaX70WAtoIaRIvpp8Uz+f9o9/EOqW/lvSHsoEouveuMu/vZNnUz12wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756745560; c=relaxed/simple;
	bh=BFnBbraOCacTgsat4VNzLx3wIcLl5nbM95+AHTdP3Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSfQQEdcwzsBVN0aAAJP/DBzAo2Sawr84uQtbH72w1shyA5U2pJAEbRY3Tv1pD9YGC0zOurWsyAGQKKEvmk9eNGT7+pC058O8zO4HUtuDCQrG+0Hs0A8kXFAOYROuTZUXAl517SeRM93CtN2sb0tE7IyRRVsEYjDMSVSZM7UCd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pgaSIIbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pgaSIIbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2FDC4CEF1;
	Mon,  1 Sep 2025 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756745560;
	bh=BFnBbraOCacTgsat4VNzLx3wIcLl5nbM95+AHTdP3Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgaSIIbJXnOTds5upAgyOGSLpTsayVHNwR2jip8DUB7QKUhF5AZiipmakyvV95EoX
	 KHf/lSBet2gthLiaGRRONcSdZ/fCCqhHVAWlRhWKQcci8fJgxtY9tfRHUX528fWpNG
	 TIOTOYot99i0iLe4bBhzPWIRYysPlMNB6lvAR3bZNeNC8Vw3PU/WnNXp7wKsUpvlu0
	 6JyHT01IaMmNHKjxHu5XDMRqIcn73Drs/WJkcBWmyiePWS+KVljXOVdNmGFllByFMw
	 BYWqj0OuvLTmvsEiCnSHVnBDu/4Ml7QMCd+hHDul5AAq/UtKWV83keQ67IWSWgh8Ao
	 UJn4rM+3OZcCw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] crypto: sha512 - Implement export_core() and import_core()
Date: Mon,  1 Sep 2025 09:50:13 -0700
Message-ID: <20250901165013.48649-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250901165013.48649-1-ebiggers@kernel.org>
References: <20250901165013.48649-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in
API"), the recently-added export_core() and import_core() methods in
struct shash_alg have effectively become mandatory (even though it is
not tested or enforced), since legacy drivers that need a fallback
depend on them.  Make crypto/sha512.c compatible with these legacy
drivers by adding export_core() and import_core() methods to it.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reported-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
Fixes: 4bc7f7b687a2 ("crypto: sha512 - Use same state format as legacy drivers")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/sha512.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/crypto/sha512.c b/crypto/sha512.c
index fb1c520978ef3..d320fe53913fa 100644
--- a/crypto/sha512.c
+++ b/crypto/sha512.c
@@ -48,10 +48,23 @@ static int __crypto_sha512_import(struct __sha512_ctx *ctx, const void *in)
 	p += sizeof(*ctx);
 	ctx->bytecount_lo += *p;
 	return 0;
 }
 
+static int __crypto_sha512_export_core(const struct __sha512_ctx *ctx,
+				       void *out)
+{
+	memcpy(out, ctx, offsetof(struct __sha512_ctx, buf));
+	return 0;
+}
+
+static int __crypto_sha512_import_core(struct __sha512_ctx *ctx, const void *in)
+{
+	memcpy(ctx, in, offsetof(struct __sha512_ctx, buf));
+	return 0;
+}
+
 /* SHA-384 */
 
 const u8 sha384_zero_message_hash[SHA384_DIGEST_SIZE] = {
 	0x38, 0xb0, 0x60, 0xa7, 0x51, 0xac, 0x96, 0x38,
 	0x4c, 0xd9, 0x32, 0x7e, 0xb1, 0xb1, 0xe3, 0x6a,
@@ -98,10 +111,20 @@ static int crypto_sha384_export(struct shash_desc *desc, void *out)
 static int crypto_sha384_import(struct shash_desc *desc, const void *in)
 {
 	return __crypto_sha512_import(&SHA384_CTX(desc)->ctx, in);
 }
 
+static int crypto_sha384_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha512_export_core(&SHA384_CTX(desc)->ctx, out);
+}
+
+static int crypto_sha384_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_sha512_import_core(&SHA384_CTX(desc)->ctx, in);
+}
+
 /* SHA-512 */
 
 const u8 sha512_zero_message_hash[SHA512_DIGEST_SIZE] = {
 	0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
 	0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
@@ -150,10 +173,20 @@ static int crypto_sha512_export(struct shash_desc *desc, void *out)
 static int crypto_sha512_import(struct shash_desc *desc, const void *in)
 {
 	return __crypto_sha512_import(&SHA512_CTX(desc)->ctx, in);
 }
 
+static int crypto_sha512_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha512_export_core(&SHA512_CTX(desc)->ctx, out);
+}
+
+static int crypto_sha512_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_sha512_import_core(&SHA512_CTX(desc)->ctx, in);
+}
+
 /* HMAC-SHA384 */
 
 #define HMAC_SHA384_KEY(tfm) ((struct hmac_sha384_key *)crypto_shash_ctx(tfm))
 #define HMAC_SHA384_CTX(desc) ((struct hmac_sha384_ctx *)shash_desc_ctx(desc))
 
@@ -202,10 +235,25 @@ static int crypto_hmac_sha384_import(struct shash_desc *desc, const void *in)
 
 	ctx->ctx.ostate = HMAC_SHA384_KEY(desc->tfm)->key.ostate;
 	return __crypto_sha512_import(&ctx->ctx.sha_ctx, in);
 }
 
+static int crypto_hmac_sha384_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha512_export_core(&HMAC_SHA384_CTX(desc)->ctx.sha_ctx,
+					   out);
+}
+
+static int crypto_hmac_sha384_import_core(struct shash_desc *desc,
+					  const void *in)
+{
+	struct hmac_sha384_ctx *ctx = HMAC_SHA384_CTX(desc);
+
+	ctx->ctx.ostate = HMAC_SHA384_KEY(desc->tfm)->key.ostate;
+	return __crypto_sha512_import_core(&ctx->ctx.sha_ctx, in);
+}
+
 /* HMAC-SHA512 */
 
 #define HMAC_SHA512_KEY(tfm) ((struct hmac_sha512_key *)crypto_shash_ctx(tfm))
 #define HMAC_SHA512_CTX(desc) ((struct hmac_sha512_ctx *)shash_desc_ctx(desc))
 
@@ -254,10 +302,25 @@ static int crypto_hmac_sha512_import(struct shash_desc *desc, const void *in)
 
 	ctx->ctx.ostate = HMAC_SHA512_KEY(desc->tfm)->key.ostate;
 	return __crypto_sha512_import(&ctx->ctx.sha_ctx, in);
 }
 
+static int crypto_hmac_sha512_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha512_export_core(&HMAC_SHA512_CTX(desc)->ctx.sha_ctx,
+					   out);
+}
+
+static int crypto_hmac_sha512_import_core(struct shash_desc *desc,
+					  const void *in)
+{
+	struct hmac_sha512_ctx *ctx = HMAC_SHA512_CTX(desc);
+
+	ctx->ctx.ostate = HMAC_SHA512_KEY(desc->tfm)->key.ostate;
+	return __crypto_sha512_import_core(&ctx->ctx.sha_ctx, in);
+}
+
 /* Algorithm definitions */
 
 static struct shash_alg algs[] = {
 	{
 		.base.cra_name		= "sha384",
@@ -270,10 +333,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_sha384_update,
 		.final			= crypto_sha384_final,
 		.digest			= crypto_sha384_digest,
 		.export			= crypto_sha384_export,
 		.import			= crypto_sha384_import,
+		.export_core		= crypto_sha384_export_core,
+		.import_core		= crypto_sha384_import_core,
 		.descsize		= sizeof(struct sha384_ctx),
 		.statesize		= SHA512_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "sha512",
@@ -286,10 +351,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_sha512_update,
 		.final			= crypto_sha512_final,
 		.digest			= crypto_sha512_digest,
 		.export			= crypto_sha512_export,
 		.import			= crypto_sha512_import,
+		.export_core		= crypto_sha512_export_core,
+		.import_core		= crypto_sha512_import_core,
 		.descsize		= sizeof(struct sha512_ctx),
 		.statesize		= SHA512_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "hmac(sha384)",
@@ -304,10 +371,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_hmac_sha384_update,
 		.final			= crypto_hmac_sha384_final,
 		.digest			= crypto_hmac_sha384_digest,
 		.export			= crypto_hmac_sha384_export,
 		.import			= crypto_hmac_sha384_import,
+		.export_core		= crypto_hmac_sha384_export_core,
+		.import_core		= crypto_hmac_sha384_import_core,
 		.descsize		= sizeof(struct hmac_sha384_ctx),
 		.statesize		= SHA512_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "hmac(sha512)",
@@ -322,10 +391,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_hmac_sha512_update,
 		.final			= crypto_hmac_sha512_final,
 		.digest			= crypto_hmac_sha512_digest,
 		.export			= crypto_hmac_sha512_export,
 		.import			= crypto_hmac_sha512_import,
+		.export_core		= crypto_hmac_sha512_export_core,
+		.import_core		= crypto_hmac_sha512_import_core,
 		.descsize		= sizeof(struct hmac_sha512_ctx),
 		.statesize		= SHA512_SHASH_STATE_SIZE,
 	},
 };
 
-- 
2.50.1

