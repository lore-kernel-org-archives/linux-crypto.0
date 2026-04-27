Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A0F3D6494
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777308041; cv=none; b=u85Cf8mGHBw92bvs5WnV/7Tok9TwcxuiHUoSPfW/RBeXX+qnhrjVA1UnF5wIwMz+rZDMmf6pG1gLEIlcm2Lx0TSgBdHX7MaLaZ889+J8aigjwrkNIKGiKutpen/cpFbPLiYz82ovqh0mop/9FNZ8C8KJR24WtbjB6M7SYFK3yrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777308041; c=relaxed/simple;
	bh=tLfxGfZ8FK6o1WjyY8CrkwQT5BZ1HxjhnlCKtV2r3/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRgVzD1cFHyB6yPzzy2o1O0ejR3AnMZvB5IKJ0ax2e/XIws0/ioPPOSkvtsg3WOo6Sq0cqln5X+fl7KPyoEpisEf8g3hkpnmMLkVa1IfYjSwRNdHoB4q4PU5R0GazVtjiVjWQ+2UDkxUWCRQmQdGGPP0MQHt5LX/qw/6ff9hdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aPx3bjIm; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aPx3bjIm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777308036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UL1kvB9Ji20YADD2O7j5GE++8RuOFTqcHyAxji8oAys=;
	b=aPx3bjImo3cA3H6UxscWcOW3PLdy5JIH+u2p6iwAzkK2q7oPWgKLH9fyIPNwSH3vOs8lC3
	SX/ZDFHugiVdUANi+npTH3fKPavHtTMuVqqhdv+mbTJVe53wvGuc+6jPJ1S4GlrexIn3Uc
	cyCbfG2lk6jE7jDcC4lS9uag1Q4NnAg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: caam - use print_hex_dump_devel to guard key hex dumps
Date: Mon, 27 Apr 2026 18:39:39 +0200
Message-ID: <20260427163937.337966-5-thorsten.blum@linux.dev>
In-Reply-To: <20260427163937.337966-3-thorsten.blum@linux.dev>
References: <20260427163937.337966-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2990; i=thorsten.blum@linux.dev; h=from:subject; bh=tLfxGfZ8FK6o1WjyY8CrkwQT5BZ1HxjhnlCKtV2r3/Q=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvJwY++Lpt07fvtbJJH893fZN49/3X5m+1G8uX23GzN VjGrii41FHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATOfWA4Z/uDsagH6JpmX0T 712Z6xHrmBXxJv1KndWLoocv4p/yFDxiZLh5VnXSh62e33Nffbjt9vTvJnO29UVfJU493Rfesaj hwXZOAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use print_hex_dump_devel() for dumping sensitive key material in
*_setkey() to avoid leaking secrets at runtime when CONFIG_DYNAMIC_DEBUG
is enabled.

Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/caam/caamalg_qi2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index bf10c3dda745..6b47bcc16a50 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -301,7 +301,7 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 	dev_dbg(dev, "keylen %d enckeylen %d authkeylen %d\n",
 		keys.authkeylen + keys.enckeylen, keys.enckeylen,
 		keys.authkeylen);
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->adata.keylen = keys.authkeylen;
@@ -315,7 +315,7 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 	memcpy(ctx->key + ctx->adata.keylen_pad, keys.enckey, keys.enckeylen);
 	dma_sync_single_for_device(dev, ctx->key_dma, ctx->adata.keylen_pad +
 				   keys.enckeylen, ctx->dir);
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -732,7 +732,7 @@ static int gcm_setkey(struct crypto_aead *aead,
 	ret = aes_check_keylen(keylen);
 	if (ret)
 		return ret;
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -828,7 +828,7 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -927,7 +927,7 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -955,7 +955,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;
