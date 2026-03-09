Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8F41C2F3
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090748; cv=none; b=lApeFVIMO5cjAi4D9Zk0m0YHW2KpInHbd5c1Cx74WKrXg96xxgRp3tWuG0yQE2kROYwgBbzzrEdRA6TDA45hL4kX1qgA1khUcZ0PsCE/wpL8+ZcCi5t7lxbYQtk0BofGmwgzTKvSBWoP870aaOikf8Avm+Y7lBSSDy9ZteJ/sGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090748; c=relaxed/simple;
	bh=XPpul2ao42q/7bFDJdqitqHKcml0oQtqR27LghI2aa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RcEu4JGN5+sN1S3c6aV5nGvY6quYosvKWm3S2zI9Vj2rzpC/sI1kd89DJEiegLqG/l0hujGNh6y7ajOiZ6rodBqWI/0gKulTl3J+n6r404gzqHgv3mfj313S2t1dsRPSwxR9lz3ANZFwGaiFSL96KnLwPFe6pvR06v/mPCX64C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cRB9lqBc; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cRB9lqBc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773090743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cpTYeJh42cZvPRFS5bBe1Vg0lrjXL5sYMb3s1PdTh+o=;
	b=cRB9lqBcVUYh0qSQGWv6pDNjd5DIsGv9093zkCr3Zl/xRlo5fDDsZtRCAwyeJcxh7+ArUl
	TROeagEaoqOlbOktayaKscMaN1njvD6qXaGAocKpS5rfMxJxWARwjMQnbgwla2hGvDqrAz
	HVSjr9e5rpLCFEEs9hWvhLJAC3qxFEc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: artpec6 - use memcpy_and_pad to simplify prepare_hash
Date: Mon,  9 Mar 2026 22:11:21 +0100
Message-ID: <20260309211119.81778-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1501; i=thorsten.blum@linux.dev; h=from:subject; bh=XPpul2ao42q/7bFDJdqitqHKcml0oQtqR27LghI2aa8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnrzctdV9ZJeJlL1m/Wn7s+RfSWdeGsv3E2OUv3iB2Zo ZrY/z2to5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACZyqIrhf+bB3XvyX+2YqNmc cUUmcYF+SY9G9Kv0DY4OU754z44+fonhn6V/l3Nz2yYbBs+6DD+2uAuNz52z7sTGmzVwrL+6uvc 4AwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use memcpy_and_pad() instead of memcpy() followed by memset() to
simplify artpec6_crypto_prepare_hash().

Also fix a duplicate word in a comment and remove a now-redundant one.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/axis/artpec6_crypto.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index b04d6379244a..a4793b76300c 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1323,7 +1323,7 @@ static int artpec6_crypto_prepare_hash(struct ahash_request *areq)
 
 	artpec6_crypto_init_dma_operation(common);
 
-	/* Upload HMAC key, must be first the first packet */
+	/* Upload HMAC key, it must be the first packet */
 	if (req_ctx->hash_flags & HASH_FLAG_HMAC) {
 		if (variant == ARTPEC6_CRYPTO) {
 			req_ctx->key_md = FIELD_PREP(A6_CRY_MD_OPER,
@@ -1333,11 +1333,8 @@ static int artpec6_crypto_prepare_hash(struct ahash_request *areq)
 						     a7_regk_crypto_dlkey);
 		}
 
-		/* Copy and pad up the key */
-		memcpy(req_ctx->key_buffer, ctx->hmac_key,
-		       ctx->hmac_key_length);
-		memset(req_ctx->key_buffer + ctx->hmac_key_length, 0,
-		       blocksize - ctx->hmac_key_length);
+		memcpy_and_pad(req_ctx->key_buffer, blocksize, ctx->hmac_key,
+			       ctx->hmac_key_length, 0);
 
 		error = artpec6_crypto_setup_out_descr(common,
 					(void *)&req_ctx->key_md,
