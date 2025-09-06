Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CEB27EFE7;
	Sat,  6 Sep 2025 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757195676; cv=none; b=QVzRzDT3Pec+uowLzn8lngE4jDcSRpmpIAmmix/DuZJbsotVZYQhQnlCvypCUau3IKyZDzlstiJWjb9+Cn1Z+Gi40n5zN9AUhI/bbN5iGUJwTSD/ECB/BhSvdRZn00wGXxW27UKF8EUDsNxjpmiRV3J9ZLDQxg9L2V+z9jozNOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757195676; c=relaxed/simple;
	bh=h53jvfFCwXYylbb7aps6yXM2yBvyZd6YfS28Nu7Gzmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vEf7lW0va2K6VSZA2kgHrdlB5jrXFIoZu7cyDaCiRAUcbKoKnt/33VOf2PHg3BmEql5QH5oOIfNJffE6jr/6srrPmmKhOXLTv2uTX7NosRYSNKE7bWadiAuQobPzZ0cEOVcqw2r+RKaGfo3JeKGA4/v1rxG7wxMhWV1uIamGN6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPf7pw8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPf7pw8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376AEC4CEE7;
	Sat,  6 Sep 2025 21:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757195675;
	bh=h53jvfFCwXYylbb7aps6yXM2yBvyZd6YfS28Nu7Gzmg=;
	h=From:To:Cc:Subject:Date:From;
	b=DPf7pw8hUJnfXl+EPhEt9uuBOZtbYn18iPBvd40fkJT3pr53UD3J+6O+a3pNxw994
	 cSQoCPHVAscanaGxQZ/BIb5m/49LbAvOX8jofQLhzlDSNUsVoJJ2hNCObJT5ryMArE
	 uXkmuOs04JGpMe6a9IJbZGJ6jDu0Ma1Cle47XuzYY9FyRR52bWaPSNY0q8PrjTKVvz
	 /8bBSidglaoVFBACQcPwUnbdNlFrGPv/GLwbd/pllQ+TunbuMGFHP9RPT/D+Y8gjyn
	 TNNEjMNepwQL+HbfCty41Q5YMPImugQsvErhFITLUv4MTYiuLpabk4c6lTIxGP4Dbh
	 p7dDyWtIRSOxA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: md5 - Implement export_core() and import_core()
Date: Sat,  6 Sep 2025 14:54:17 -0700
Message-ID: <20250906215417.89584-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
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
depend on them.  Make crypto/md5.c compatible with these legacy drivers
by adding export_core() and import_core() methods to it.

Fixes: ba8ee22a7f92 ("crypto: md5 - Wrap library and add HMAC support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 crypto/md5.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/crypto/md5.c b/crypto/md5.c
index d05c53e6f3c2c..c167d203c710a 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -44,10 +44,22 @@ static int __crypto_md5_import(struct md5_ctx *ctx, const void *in)
 	p += sizeof(*ctx);
 	ctx->bytecount += *p;
 	return 0;
 }
 
+static int __crypto_md5_export_core(const struct md5_ctx *ctx, void *out)
+{
+	memcpy(out, ctx, offsetof(struct md5_ctx, buf));
+	return 0;
+}
+
+static int __crypto_md5_import_core(struct md5_ctx *ctx, const void *in)
+{
+	memcpy(ctx, in, offsetof(struct md5_ctx, buf));
+	return 0;
+}
+
 const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
 	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
 	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
 };
 EXPORT_SYMBOL_GPL(md5_zero_message_hash);
@@ -88,10 +100,20 @@ static int crypto_md5_export(struct shash_desc *desc, void *out)
 static int crypto_md5_import(struct shash_desc *desc, const void *in)
 {
 	return __crypto_md5_import(MD5_CTX(desc), in);
 }
 
+static int crypto_md5_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_md5_export_core(MD5_CTX(desc), out);
+}
+
+static int crypto_md5_import_core(struct shash_desc *desc, const void *in)
+{
+	return __crypto_md5_import_core(MD5_CTX(desc), in);
+}
+
 #define HMAC_MD5_KEY(tfm) ((struct hmac_md5_key *)crypto_shash_ctx(tfm))
 #define HMAC_MD5_CTX(desc) ((struct hmac_md5_ctx *)shash_desc_ctx(desc))
 
 static int crypto_hmac_md5_setkey(struct crypto_shash *tfm,
 				  const u8 *raw_key, unsigned int keylen)
@@ -137,10 +159,23 @@ static int crypto_hmac_md5_import(struct shash_desc *desc, const void *in)
 
 	ctx->ostate = HMAC_MD5_KEY(desc->tfm)->ostate;
 	return __crypto_md5_import(&ctx->hash_ctx, in);
 }
 
+static int crypto_hmac_md5_export_core(struct shash_desc *desc, void *out)
+{
+	return __crypto_md5_export_core(&HMAC_MD5_CTX(desc)->hash_ctx, out);
+}
+
+static int crypto_hmac_md5_import_core(struct shash_desc *desc, const void *in)
+{
+	struct hmac_md5_ctx *ctx = HMAC_MD5_CTX(desc);
+
+	ctx->ostate = HMAC_MD5_KEY(desc->tfm)->ostate;
+	return __crypto_md5_import_core(&ctx->hash_ctx, in);
+}
+
 static struct shash_alg algs[] = {
 	{
 		.base.cra_name		= "md5",
 		.base.cra_driver_name	= "md5-lib",
 		.base.cra_priority	= 300,
@@ -151,10 +186,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_md5_update,
 		.final			= crypto_md5_final,
 		.digest			= crypto_md5_digest,
 		.export			= crypto_md5_export,
 		.import			= crypto_md5_import,
+		.export_core		= crypto_md5_export_core,
+		.import_core		= crypto_md5_import_core,
 		.descsize		= sizeof(struct md5_ctx),
 		.statesize		= MD5_SHASH_STATE_SIZE,
 	},
 	{
 		.base.cra_name		= "hmac(md5)",
@@ -169,10 +206,12 @@ static struct shash_alg algs[] = {
 		.update			= crypto_hmac_md5_update,
 		.final			= crypto_hmac_md5_final,
 		.digest			= crypto_hmac_md5_digest,
 		.export			= crypto_hmac_md5_export,
 		.import			= crypto_hmac_md5_import,
+		.export_core		= crypto_hmac_md5_export_core,
+		.import_core		= crypto_hmac_md5_import_core,
 		.descsize		= sizeof(struct hmac_md5_ctx),
 		.statesize		= MD5_SHASH_STATE_SIZE,
 	},
 };
 

base-commit: 8d2702c5dc96bc441879b83becbccedeb2bd4476
-- 
2.50.1

