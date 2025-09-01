Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022B22EC083;
	Mon,  1 Sep 2025 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756745560; cv=none; b=u4LQUPdodyGdjm5Lkz9UWc83c5Jf0vr/1tsOgyA/GfMoJiO/VW9Ts1IXyIvkoYPdAsJRqAD82mU66bMzD9roabo6o4Qe68gDyp6680TUVHAKPp/Dnv5+8lXIFAwu+JLKzQ1x3J6qlSWC7XBWPPLnA1pKv6GIpUsj/0nfi396s/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756745560; c=relaxed/simple;
	bh=XFff4ztVNM7A2DSEz/0F1H8morLJnpt2FM2EP8GGFrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeQCwxrm4VcRsszyYXGDyIaYQ6Zryi0jwXYEAawkLpWrzjfABbVlzCr08OqyjdxtVnzL5v2VpTNm//f/0tF6eoVaV0RYkQtqCnX3u3ir669fO5oNcIdbh7kGl4n2EIyZcnimHSgcR84t+BinRliFWOYDqVdM9pmnPs6HxiC9Sq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6wMPqlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6wMPqlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F928C4CEF1;
	Mon,  1 Sep 2025 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756745559;
	bh=XFff4ztVNM7A2DSEz/0F1H8morLJnpt2FM2EP8GGFrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6wMPqlmRWjBKxVvkAx/vHDcUfas7mJMf2Ap1GW85rSZbftX8+lA6yVGq7uTEztaK
	 NeYakRRvZ5bAZ9F3Fk1kxizo9UGaZcAgE8T8zrCgV+MOYYsQjl4n547Hix2iw5JxEK
	 shYpbOCM2/FgzdJyfpyizDzbe9YYYCTxi402D46BLOwjGLqdXNh/MZw/ak7oMZu7oF
	 E/ig2fA9HCBCHaXOwwceLsgXLoHPuEEY6yihoyqO8zXpgxkdUmWUOqJOipzT38B2CL
	 G2elLwJ9+ME82kWgdJQ56SStjoxoDJ2L7OnM8oRm+pLmzP193ROwQ5u1rMnGBmYNRG
	 yHNkYjoauRQjg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] crypto: sha1 - Implement export_core() and import_core()
Date: Mon,  1 Sep 2025 09:50:11 -0700
Message-ID: <20250901165013.48649-2-ebiggers@kernel.org>
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
depend on them.  Make crypto/sha1.c compatible with these legacy drivers
by adding export_core() and import_core() methods to it.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reported-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
Fixes: b10a74abcfc5 ("crypto: sha1 - Use same state format as legacy drivers")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/sha1.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/crypto/sha1.c b/crypto/sha1.c
index ecef4bf2d9c00..4fbf61cf03709 100644
--- a/crypto/sha1.c
+++ b/crypto/sha1.c
@@ -47,10 +47,22 @@ static int __crypto_sha1_import(struct sha1_ctx *ctx, const void *in)
 	p += sizeof(*ctx);
 	ctx->bytecount += *p;
 	return 0;
 }
 
+static int __crypto_sha1_export_core(const struct sha1_ctx *ctx, void *out)
+{
+	memcpy(out, ctx, offsetof(struct sha1_ctx, buf));
+	return 0;
+}
+
+static int __crypto_sha1_import_core(struct sha1_ctx *ctx, const void *in)
+{
+	memcpy(ctx, in, offsetof(struct sha1_ctx, buf));
+	return 0;
+}
+
 const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE] = {
 	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
 	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
 	0xaf, 0xd8, 0x07, 0x09
 };
@@ -92,10 +104,20 @@ static int crypto_sha1_export(struct shash_desc *desc, void *out)
 static int crypto_sha1_import(struct shash_desc *desc, const void *in)
 {
 	return __crypto_sha1_import(SHA1_CTX(desc), in);
 }
 
+static int crypto_sha1_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha1_export_core(SHA1_CTX(desc), out);
+}
+
+static int crypto_sha1_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_sha1_import_core(SHA1_CTX(desc), in);
+}
+
 #define HMAC_SHA1_KEY(tfm) ((struct hmac_sha1_key *)crypto_shash_ctx(tfm))
 #define HMAC_SHA1_CTX(desc) ((struct hmac_sha1_ctx *)shash_desc_ctx(desc))
 
 static int crypto_hmac_sha1_setkey(struct crypto_shash *tfm,
 				   const u8 *raw_key, unsigned int keylen)
@@ -141,10 +163,23 @@ static int crypto_hmac_sha1_import(struct shash_desc *desc, const void *in)
 
 	ctx->ostate = HMAC_SHA1_KEY(desc->tfm)->ostate;
 	return __crypto_sha1_import(&ctx->sha_ctx, in);
 }
 
+static int crypto_hmac_sha1_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_sha1_export_core(&HMAC_SHA1_CTX(desc)->sha_ctx, out);
+}
+
+static int crypto_hmac_sha1_import_core(struct shash_desc *desc, const void *in)
+{
+	struct hmac_sha1_ctx *ctx = HMAC_SHA1_CTX(desc);
+
+	ctx->ostate = HMAC_SHA1_KEY(desc->tfm)->ostate;
+	return __crypto_sha1_import_core(&ctx->sha_ctx, in);
+}
+
 static struct shash_alg algs[] = {
 	{
 		.base.cra_name		= "sha1",
 		.base.cra_driver_name	= "sha1-lib",
 		.base.cra_priority	= 300,
@@ -155,10 +190,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_sha1_update,
 		.final			= crypto_sha1_final,
 		.digest			= crypto_sha1_digest,
 		.export			= crypto_sha1_export,
 		.import			= crypto_sha1_import,
+		.export_core		= crypto_sha1_export_core,
+		.import_core		= crypto_sha1_import_core,
 		.descsize		= sizeof(struct sha1_ctx),
 		.statesize		= SHA1_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "hmac(sha1)",
@@ -173,10 +210,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_hmac_sha1_update,
 		.final			= crypto_hmac_sha1_final,
 		.digest			= crypto_hmac_sha1_digest,
 		.export			= crypto_hmac_sha1_export,
 		.import			= crypto_hmac_sha1_import,
+		.export_core		= crypto_hmac_sha1_export_core,
+		.import_core		= crypto_hmac_sha1_import_core,
 		.descsize		= sizeof(struct hmac_sha1_ctx),
 		.statesize		= SHA1_SHASH_STATE_SIZE,
 	},
 };
 
-- 
2.50.1

