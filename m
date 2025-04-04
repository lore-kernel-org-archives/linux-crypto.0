Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC212B94;
	Fri,  4 Apr 2025 00:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725048; cv=none; b=MDo1yUXpNFzFrVb+gQ69gDzTN/RmWM6IwAO6w01Ke/E7sn2G2vzS5lAMtBewjCB4rSRn9sbTE40dOivQrCe/HGAyo7c4zJafGIjWHdEtUc2uRCLVzpj/gix7dWB7cegamRrx0zmXFlOaVpOScFhcOPqJ1mlhmWfDxw45iY2i6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725048; c=relaxed/simple;
	bh=N1rx+buJgba+EBFZDjpuHz7VBrsBZQiPgC9nHkyWe28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bM3Ap4Q3wUDymVZf6mndcrj2dl6tclOBoLDb+5S4TFTqw8jJ7NWiROB13t6k4wGR05grithWvASJhgUbKHiKfbdqJ+YzzfQ4hXIGgowyTyjk2PANjwcG9jocwyZ6ijN40U1GVYYRjGDbplv0NUxnudIkti53kNNs6JwCgTs8XhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHYUn5Ag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHYUn5Ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4D1C4CEE3;
	Fri,  4 Apr 2025 00:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725047;
	bh=N1rx+buJgba+EBFZDjpuHz7VBrsBZQiPgC9nHkyWe28=;
	h=From:To:Cc:Subject:Date:From;
	b=OHYUn5AgMGdHuRCsuNl+u/8Ksx98wbWw8jgl+4Z3PvHOztRwR/Bp6L/232eV1R+u7
	 J0VLq++fgUQQBc9RnpVM/zNIwi1x52cdQGsNUkzADBM0s5Z1xxUiq5dOiz96GFe6Z+
	 Zuas4ry0tM29V7AOR5C841moSuA936/QJZnObCtWkwUdOg/fnuiKVcsQdrzFddSxcv
	 eh7iNOU2edDymGwtbLPHre8cAbB/4467hrXkw2TnO7zNAvhCbVa3MDMJWsZ8ToAgxL
	 g64h8LnyrQ4tutEZJNPFuy8L4QGovTD1Lvu+U7cTZcc7rqBHweC/rOTHCEZopBeATk
	 7BXy19C4g2zSw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	ignat@cloudflare.com,
	davem@davemloft.net,
	andy@kernel.org,
	angelogioacchino.delregno@collabora.com,
	Jonathan.Cameron@huawei.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 01/23] crypto: ecdsa - Harden against integer overflows in DIV_ROUND_UP()
Date: Thu,  3 Apr 2025 20:03:38 -0400
Message-Id: <20250404000402.2688049-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit b16510a530d1e6ab9683f04f8fb34f2e0f538275 ]

Herbert notes that DIV_ROUND_UP() may overflow unnecessarily if an ecdsa
implementation's ->key_size() callback returns an unusually large value.
Herbert instead suggests (for a division by 8):

  X / 8 + !!(X & 7)

Based on this formula, introduce a generic DIV_ROUND_UP_POW2() macro and
use it in lieu of DIV_ROUND_UP() for ->key_size() return values.

Additionally, use the macro in ecc_digits_from_bytes(), whose "nbytes"
parameter is a ->key_size() return value in some instances, or a
user-specified ASN.1 length in the case of ecdsa_get_signature_rs().

Link: https://lore.kernel.org/r/Z3iElsILmoSu6FuC@gondor.apana.org.au/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecc.c         |  2 +-
 crypto/ecdsa-p1363.c |  2 +-
 crypto/ecdsa-x962.c  |  4 ++--
 include/linux/math.h | 12 ++++++++++++
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 50ad2d4ed672c..6cf9a945fc6c2 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(ecc_get_curve);
 void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
 			   u64 *out, unsigned int ndigits)
 {
-	int diff = ndigits - DIV_ROUND_UP(nbytes, sizeof(u64));
+	int diff = ndigits - DIV_ROUND_UP_POW2(nbytes, sizeof(u64));
 	unsigned int o = nbytes & 7;
 	__be64 msd = 0;
 
diff --git a/crypto/ecdsa-p1363.c b/crypto/ecdsa-p1363.c
index eaae7214d69bc..4454f1f8f33f5 100644
--- a/crypto/ecdsa-p1363.c
+++ b/crypto/ecdsa-p1363.c
@@ -22,7 +22,7 @@ static int ecdsa_p1363_verify(struct crypto_sig *tfm,
 {
 	struct ecdsa_p1363_ctx *ctx = crypto_sig_ctx(tfm);
 	unsigned int keylen = crypto_sig_keysize(ctx->child);
-	unsigned int ndigits = DIV_ROUND_UP(keylen, sizeof(u64));
+	unsigned int ndigits = DIV_ROUND_UP_POW2(keylen, sizeof(u64));
 	struct ecdsa_raw_sig sig;
 
 	if (slen != 2 * keylen)
diff --git a/crypto/ecdsa-x962.c b/crypto/ecdsa-x962.c
index 6a77c13e192b1..90a04f4b9a2f5 100644
--- a/crypto/ecdsa-x962.c
+++ b/crypto/ecdsa-x962.c
@@ -81,8 +81,8 @@ static int ecdsa_x962_verify(struct crypto_sig *tfm,
 	struct ecdsa_x962_signature_ctx sig_ctx;
 	int err;
 
-	sig_ctx.ndigits = DIV_ROUND_UP(crypto_sig_keysize(ctx->child),
-				       sizeof(u64));
+	sig_ctx.ndigits = DIV_ROUND_UP_POW2(crypto_sig_keysize(ctx->child),
+					    sizeof(u64));
 
 	err = asn1_ber_decoder(&ecdsasignature_decoder, &sig_ctx, src, slen);
 	if (err < 0)
diff --git a/include/linux/math.h b/include/linux/math.h
index f5f18dc3616b0..0198c92cbe3ef 100644
--- a/include/linux/math.h
+++ b/include/linux/math.h
@@ -34,6 +34,18 @@
  */
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+/**
+ * DIV_ROUND_UP_POW2 - divide and round up
+ * @n: numerator
+ * @d: denominator (must be a power of 2)
+ *
+ * Divides @n by @d and rounds up to next multiple of @d (which must be a power
+ * of 2). Avoids integer overflows that may occur with __KERNEL_DIV_ROUND_UP().
+ * Performance is roughly equivalent to __KERNEL_DIV_ROUND_UP().
+ */
+#define DIV_ROUND_UP_POW2(n, d) \
+	((n) / (d) + !!((n) & ((d) - 1)))
+
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
 
 #define DIV_ROUND_DOWN_ULL(ll, d) \
-- 
2.39.5

