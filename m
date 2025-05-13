Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E531E5B97
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116242; cv=none; b=GKQKWp3h6gYHeQOwSS4vbuiG13oMx1ImWCvaqNU/3XB2zrze3XJKiA0xt/SUXbxiHKWDA9O5IKGljiLN4fHdukHqTGf04V8QMnb/amBrNIuBtLoOMyvksKpEAXH/u1jFZsO72M6ZBC663KgJeQWWCtWuIO5WVVYrbUiowH3CyJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116242; c=relaxed/simple;
	bh=GFy88AjyoH/ImDN89svWXlGnfy2pb0fhiGyAUhre9Js=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=JC+zpP6EIxzegIfUERQUjM/YDdrKWZEjDigGyz2ZTQhPJf94FFF9W4WDwJGe/5wLmp7zR/YIBUF9fHna+kqtvtmbhprvQlGx6H8c2qPjvcb4yXCVlkOVIp65ipPrBpNmOBcP/bIlAf6OFg9ndZ65DVBJlOyqaLF/d0AGMjaRVq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r2cSTnvR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r2cSTnvR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1V2wVUkULAV/+Sb8MCLK5k1wKu01X18xmPR28zR/g40=; b=r2cSTnvRL3br+JM7Y6e+LIw1uV
	1e39Trn2I1gMcqTkpZmPTVGuBJ+hE5pomHY8ZQJKcUYl29WRF/QEVjci6RZbishGbLRkJQ24ysUEX
	dERKqIZrXzbBGM9sq81Yg8kvXNgd7wcDJSAPkI0FaXIdyoBG1s6qZExsRsEIIdH+W3slVLlQ7Aztw
	cA5Gzcus8SlNri4TkExIQ3lEQ0k6iGFoZflurkYjYeZnLxU9R3cO3WPvcigzMQPKsuYFtGhqH31TI
	8ODrX1BOulELXi49XLPlFx90BvuBWoYWibDZB1QrW3BEYPkkJb9DAR0WfFq3Wp5IctvOJGuH+z2mp
	7nYab7FA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEik2-005g4S-1C;
	Tue, 13 May 2025 14:03:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:03:50 +0800
Date: Tue, 13 May 2025 14:03:50 +0800
Message-Id: <710e21ad559adb09d5ec81a9b0d1739dde0c8a00.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 02/11] crypto: aspeed/hash - Reorganise struct
 aspeed_sham_reqctx
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Move the from-device DMA buffer to the front of the structure.

Sort the rest by size and alignment.

Keep the partial block buffer at the end.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace.h b/drivers/crypto/aspeed/aspeed-hace.h
index 7ff1798bc198..a34677f10966 100644
--- a/drivers/crypto/aspeed/aspeed-hace.h
+++ b/drivers/crypto/aspeed/aspeed-hace.h
@@ -165,6 +165,12 @@ struct aspeed_sham_ctx {
 };
 
 struct aspeed_sham_reqctx {
+	/* DMA buffer written by hardware */
+	u8			digest[SHA512_DIGEST_SIZE] __aligned(64);
+
+	/* Software state sorted by size. */
+	u64			digcnt[2];
+
 	unsigned long		flags;		/* final update flag should no use*/
 	unsigned long		op;		/* final or update */
 	u32			cmd;		/* trigger cmd */
@@ -181,14 +187,13 @@ struct aspeed_sham_reqctx {
 	const __be32		*sha_iv;
 
 	/* remain data buffer */
-	u8			buffer[SHA512_BLOCK_SIZE * 2];
 	dma_addr_t		buffer_dma_addr;
 	size_t			bufcnt;		/* buffer counter */
 
-	/* output buffer */
-	u8			digest[SHA512_DIGEST_SIZE] __aligned(64);
 	dma_addr_t		digest_dma_addr;
-	u64			digcnt[2];
+
+	/* This is DMA too but read-only for hardware. */
+	u8			buffer[SHA512_BLOCK_SIZE * 2];
 };
 
 struct aspeed_engine_crypto {
-- 
2.39.5

