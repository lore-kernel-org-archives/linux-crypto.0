Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5EF42A9D;
	Fri,  4 Apr 2025 00:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725098; cv=none; b=UOyeSlgxmLPmqQA/C3ufDvH8sHG3A8iyTtF0S5ECi+WCI8Dm7/gV4CM4vzXp37O/Z/83PE85aIc0nhjaoun09rBS4wTAlmsiYpkuwAGCd9x6HNihh0Itg0vDPo2fQNRC9+Vfn7QzNXHztGlCcAgw4MkzpYraKS5j6ekm+EzWqe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725098; c=relaxed/simple;
	bh=N1rx+buJgba+EBFZDjpuHz7VBrsBZQiPgC9nHkyWe28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P8WrQYndYDN95J5UOX0wsVBRDR6ss/VTVUHuZo955HuXpIIHY951utEluICzgx2NF1pr2TDYnKJFY1KAZRTNaSH7KNe57sMJKHABZEUE2Iq1nbfma/ys3v4DCH1SL872ForarCa3bUPG2MtVO0rBnDIl8akf2UY7JkEk4lW4+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSGeLuF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSGeLuF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD13C4CEE3;
	Fri,  4 Apr 2025 00:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725098;
	bh=N1rx+buJgba+EBFZDjpuHz7VBrsBZQiPgC9nHkyWe28=;
	h=From:To:Cc:Subject:Date:From;
	b=TSGeLuF5UFrlKHC2eOqil2d10bJ6K8dhzivsCGi1BL0yPdUsnABVM2FL/s45mWznq
	 cpb6eP9hvlwjGhXzIiYprnjsBzqVg+b+MZ5dZYYvn1bGpIa6C1VtrQdfCK7t9P8lNA
	 OrQzozpQnsBWYHLVgmVTxBdFYqGXHtG3n+S93WOwKAnuRaeYgxm1CfxfPBllYsY/UU
	 KbtvYjKGuZETLJj+R3izfkUaJTgZgASeuPtc8Pu7a6Uf/mPDAwsEvwuOD9HXgZ50Be
	 t5cjrafq0UQxGXN+2lS7HC3vepPZQNNIb1Ed5o40tcMbzhtjBKFlZhrWXpYQetBfEK
	 t/yO5j0WL4TJQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	ignat@cloudflare.com,
	davem@davemloft.net,
	angelogioacchino.delregno@collabora.com,
	andy@kernel.org,
	Jonathan.Cameron@huawei.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 01/22] crypto: ecdsa - Harden against integer overflows in DIV_ROUND_UP()
Date: Thu,  3 Apr 2025 20:04:30 -0400
Message-Id: <20250404000453.2688371-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.9
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

