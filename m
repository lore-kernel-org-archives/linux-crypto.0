Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3B31A4F20
	for <linux-crypto@vger.kernel.org>; Tue, 24 Sep 2024 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177315; cv=none; b=QVfUE+9bzkjm8ZvByBTzUgDaSSuZHZ8vZl73jLqY7s5idmQdTshNLu5UMDhE69bZgJrAjMWPnplhhzXLeFtEGvGJFvhA1q4VHdEIgUmhrFl2igLgj/C1UuJ5YJDjXik6oF9RGdNyH87gUJBIbE7TX2R7W+V6PGC/W0Fy7YdYmRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177315; c=relaxed/simple;
	bh=q5UZeL435xxsbTRnqVMbE7I0KXvGXLPvKEVUcMhQiG8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jmVsNvcHnI2ptoKBcsjzoPaQPAcbARPvY+lL+XLCwHdmitFXTwWUnDTR2SmjtlEW9e/NConCXg5hQ8wk6Kzewrc/YshYHkfr15uhmeXSfjRNIUI/njXkVinCgopinzg8saSYX9y4Fgpes6uItim9+SGpvcw5GG9aCE/GrBkfZvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=asH3XX6e; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="asH3XX6e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727177310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6mfOBUZu5uZrIMueNvcR/vKvNgdMRDW+ab3CDDANE+I=;
	b=asH3XX6efe/nroWVM1/qEH2MmlEtBZHcFQO2/GQrju2RKZrWH0cijuIAqLR4pD+u1IbgQL
	rX6t27rWVfL0t0ylvNIgJoTN9zCcc15zWTK+EidY00uJJ7sJIcHaSIesaPp0ITgpYIkHfm
	4isCmI4lypoZ4Bw39DeNNMJ+s1XKBBg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hmac - Improve local variable types
Date: Tue, 24 Sep 2024 13:27:27 +0200
Message-ID: <20240924112727.240950-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since crypto_shash_blocksize(), crypto_shash_digestsize(), and
crypto_shash_statesize() return an unsigned int, also use unsigned int
for the local variables.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/hmac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 7cec25ff9889..6ab7ce4cb930 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -31,9 +31,9 @@ struct hmac_ctx {
 static int hmac_setkey(struct crypto_shash *parent,
 		       const u8 *inkey, unsigned int keylen)
 {
-	int bs = crypto_shash_blocksize(parent);
-	int ds = crypto_shash_digestsize(parent);
-	int ss = crypto_shash_statesize(parent);
+	unsigned int bs = crypto_shash_blocksize(parent);
+	unsigned int ds = crypto_shash_digestsize(parent);
+	unsigned int ss = crypto_shash_statesize(parent);
 	struct hmac_ctx *tctx = crypto_shash_ctx(parent);
 	struct crypto_shash *hash = tctx->hash;
 	u8 *ipad = &tctx->pads[0];
@@ -108,8 +108,8 @@ static int hmac_update(struct shash_desc *pdesc,
 static int hmac_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	int ds = crypto_shash_digestsize(parent);
-	int ss = crypto_shash_statesize(parent);
+	unsigned int ds = crypto_shash_digestsize(parent);
+	unsigned int ss = crypto_shash_statesize(parent);
 	const struct hmac_ctx *tctx = crypto_shash_ctx(parent);
 	const u8 *opad = &tctx->pads[ss];
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
@@ -124,8 +124,8 @@ static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 {
 
 	struct crypto_shash *parent = pdesc->tfm;
-	int ds = crypto_shash_digestsize(parent);
-	int ss = crypto_shash_statesize(parent);
+	unsigned int ds = crypto_shash_digestsize(parent);
+	unsigned int ss = crypto_shash_statesize(parent);
 	const struct hmac_ctx *tctx = crypto_shash_ctx(parent);
 	const u8 *opad = &tctx->pads[ss];
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
-- 
2.46.1

