Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8160E30C36C;
	Mon,  1 Sep 2025 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756745560; cv=none; b=dkxuoKY0GSlziMClzfiuJbrQeB5Xqlv2cz0PtLvJMZ2h6aL2RlqrPY0tKxbHOC8KvVSPjp1dzGWB01DM0vYwYmtVPHXv4PQqbeaIByyNf5TD+1fK2fDCKPG2InDUstxBsk+llgZqVvBr1yfPVjwrtjOlOEkfMUCtgk0hNnSgU3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756745560; c=relaxed/simple;
	bh=QuU468Jvbl/uNqnPkAm2+dsVpZFhcNVq9FG/MzFDUic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJkJgcVaBNX/c30T2Nd5OQz9iE3pL1BTtx14rn/gF5eAVlM5PUNzcKGZxODirysm7wtbzgrO2pKQXQxmGt0b/gtEDI6Gjjv2JASpUkk9k1y67jzfm7lBrFzl1RYibZ1ubuTFxR85CnGN/Qy3Bo2a04Tn1dFkNGb6dg1ScraGhXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYnuWhSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYnuWhSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E81C4CEF4;
	Mon,  1 Sep 2025 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756745560;
	bh=QuU468Jvbl/uNqnPkAm2+dsVpZFhcNVq9FG/MzFDUic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYnuWhSAbv10enSoDIiyC0C2cd60DSGc67JXd5C//tLtW55hrGMYJ2mG7sQPODa5Z
	 blsA8xepRs5RcRlKV4tz6REFR5YBTKwSAGKVeS7QnZXzj1NU+JhcRXvbxPN4Lm1FY/
	 UlSxYz/G1yZxrbJno/iCcTqd0mHuYKs7kZM+tdlIAhVaxFWpPRkPmLVxA5HsOAJrFB
	 49blsTSoHqkno51hH2ORFSonu2LK5dM6Tr6llmsMjToDAX6YetxYM1AGCJzILsnfZ4
	 I5vb71ucxBTdyMSUbid5nAITDpOmEE0OdGf7DVdcf2aPfVozXzt47whzl86dK9h2vm
	 8y4cII+xpqEkw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] crypto: sha256 - Implement export_core() and import_core()
Date: Mon,  1 Sep 2025 09:50:12 -0700
Message-ID: <20250901165013.48649-3-ebiggers@kernel.org>
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
depend on them.  Make crypto/sha256.c compatible with these legacy
drivers by adding export_core() and import_core() methods to it.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reported-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
Fixes: 07f090959bba ("crypto: sha256 - Use same state format as legacy drivers")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/sha256.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index 052806559f06c..fb81defe084c6 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -48,10 +48,23 @@ static int __crypto_sha256_import(struct __sha256_ctx *ctx, const void *in)
 	p += sizeof(*ctx);
 	ctx->bytecount += *p;
 	return 0;
 }
 
+static int __crypto_sha256_export_core(const struct __sha256_ctx *ctx,
+				       void *out)
+{
+	memcpy(out, ctx, offsetof(struct __sha256_ctx, buf));
+	return 0;
+}
+
+static int __crypto_sha256_import_core(struct __sha256_ctx *ctx, const void *in)
+{
+	memcpy(ctx, in, offsetof(struct __sha256_ctx, buf));
+	return 0;
+}
+
 /* SHA-224 */
 
 const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE] = {
 	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
 	0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2,
@@ -96,10 +109,20 @@ static int crypto_sha224_export(struct shash_desc *desc, void *out)
 static int crypto_sha224_import(struct shash_desc *desc, const void *in)
 {
 	return __crypto_sha256_import(&SHA224_CTX(desc)->ctx, in);
 }
 
+static int crypto_sha224_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha256_export_core(&SHA224_CTX(desc)->ctx, out);
+}
+
+static int crypto_sha224_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_sha256_import_core(&SHA224_CTX(desc)->ctx, in);
+}
+
 /* SHA-256 */
 
 const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
 	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
 	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
@@ -144,10 +167,20 @@ static int crypto_sha256_export(struct shash_desc *desc, void *out)
 static int crypto_sha256_import(struct shash_desc *desc, const void *in)
 {
 	return __crypto_sha256_import(&SHA256_CTX(desc)->ctx, in);
 }
 
+static int crypto_sha256_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha256_export_core(&SHA256_CTX(desc)->ctx, out);
+}
+
+static int crypto_sha256_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_sha256_import_core(&SHA256_CTX(desc)->ctx, in);
+}
+
 /* HMAC-SHA224 */
 
 #define HMAC_SHA224_KEY(tfm) ((struct hmac_sha224_key *)crypto_shash_ctx(tfm))
 #define HMAC_SHA224_CTX(desc) ((struct hmac_sha224_ctx *)shash_desc_ctx(desc))
 
@@ -196,10 +229,25 @@ static int crypto_hmac_sha224_import(struct shash_desc *desc, const void *in)
 
 	ctx->ctx.ostate = HMAC_SHA224_KEY(desc->tfm)->key.ostate;
 	return __crypto_sha256_import(&ctx->ctx.sha_ctx, in);
 }
 
+static int crypto_hmac_sha224_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha256_export_core(&HMAC_SHA224_CTX(desc)->ctx.sha_ctx,
+					   out);
+}
+
+static int crypto_hmac_sha224_import_core(struct shash_desc *desc,
+					  const void *in)
+{
+	struct hmac_sha224_ctx *ctx = HMAC_SHA224_CTX(desc);
+
+	ctx->ctx.ostate = HMAC_SHA224_KEY(desc->tfm)->key.ostate;
+	return __crypto_sha256_import_core(&ctx->ctx.sha_ctx, in);
+}
+
 /* HMAC-SHA256 */
 
 #define HMAC_SHA256_KEY(tfm) ((struct hmac_sha256_key *)crypto_shash_ctx(tfm))
 #define HMAC_SHA256_CTX(desc) ((struct hmac_sha256_ctx *)shash_desc_ctx(desc))
 
@@ -248,10 +296,25 @@ static int crypto_hmac_sha256_import(struct shash_desc *desc, const void *in)
 
 	ctx->ctx.ostate = HMAC_SHA256_KEY(desc->tfm)->key.ostate;
 	return __crypto_sha256_import(&ctx->ctx.sha_ctx, in);
 }
 
+static int crypto_hmac_sha256_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha256_export_core(&HMAC_SHA256_CTX(desc)->ctx.sha_ctx,
+					   out);
+}
+
+static int crypto_hmac_sha256_import_core(struct shash_desc *desc,
+					  const void *in)
+{
+	struct hmac_sha256_ctx *ctx = HMAC_SHA256_CTX(desc);
+
+	ctx->ctx.ostate = HMAC_SHA256_KEY(desc->tfm)->key.ostate;
+	return __crypto_sha256_import_core(&ctx->ctx.sha_ctx, in);
+}
+
 /* Algorithm definitions */
 
 static struct shash_alg algs[] = {
 	{
 		.base.cra_name		= "sha224",
@@ -264,10 +327,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_sha224_update,
 		.final			= crypto_sha224_final,
 		.digest			= crypto_sha224_digest,
 		.export			= crypto_sha224_export,
 		.import			= crypto_sha224_import,
+		.export_core		= crypto_sha224_export_core,
+		.import_core		= crypto_sha224_import_core,
 		.descsize		= sizeof(struct sha224_ctx),
 		.statesize		= SHA256_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "sha256",
@@ -280,10 +345,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_sha256_update,
 		.final			= crypto_sha256_final,
 		.digest			= crypto_sha256_digest,
 		.export			= crypto_sha256_export,
 		.import			= crypto_sha256_import,
+		.export_core		= crypto_sha256_export_core,
+		.import_core		= crypto_sha256_import_core,
 		.descsize		= sizeof(struct sha256_ctx),
 		.statesize		= SHA256_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "hmac(sha224)",
@@ -298,10 +365,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_hmac_sha224_update,
 		.final			= crypto_hmac_sha224_final,
 		.digest			= crypto_hmac_sha224_digest,
 		.export			= crypto_hmac_sha224_export,
 		.import			= crypto_hmac_sha224_import,
+		.export_core		= crypto_hmac_sha224_export_core,
+		.import_core		= crypto_hmac_sha224_import_core,
 		.descsize		= sizeof(struct hmac_sha224_ctx),
 		.statesize		= SHA256_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "hmac(sha256)",
@@ -316,10 +385,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_hmac_sha256_update,
 		.final			= crypto_hmac_sha256_final,
 		.digest			= crypto_hmac_sha256_digest,
 		.export			= crypto_hmac_sha256_export,
 		.import			= crypto_hmac_sha256_import,
+		.export_core		= crypto_hmac_sha256_export_core,
+		.import_core		= crypto_hmac_sha256_import_core,
 		.descsize		= sizeof(struct hmac_sha256_ctx),
 		.statesize		= SHA256_SHASH_STATE_SIZE,
 	},
 };
 
-- 
2.50.1

