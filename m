Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF901C862C
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455456; cv=none; b=H/Hw+1xzgwDmSLi8T2ZaPYAxc8JeD9+iMiUgiEzO7auG7exVajL3vu/DXSswgOMnY9wweQLV7Szqz4yBd7AXxpcssikzyLaanH68A5S1CDuFijXaNJNmhOeQr9fSrQ/4BJ4UVmO5u93bztrZaYcIaQ2NpZZZlfP6Ga6EweCyj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455456; c=relaxed/simple;
	bh=SwlhGLI5ABQ+4kwVL4+CADMhoasTxzwHGGxNhpjD+C4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Fa5lk+dxN3ADObNGZ9qcoJk2g60FakbI2h2SDhMN5Na2bLaqtJfpc3pRFoPsL7h4SpvAq2oxOpFVb0H3n0FVCHIp7CTIr1wPmdOnfd8cQe4AuDhu0XSzYAxSu6x8+nyiRnPkhn4SCNGpt14GM+HHzJBErXWCKMd7Bq7VaaqJYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UcXbNYUt; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UcXbNYUt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6ybvfjV9nGSeH9SxNxhZzbYxhA2M+Dhenb90x5WeRdY=; b=UcXbNYUtmnYkM+E+OZh5NafuLs
	Hb834arIyaWe+aumzvCgxt1Rqupd3h7Ur2sFLPOtqEI23xVNfyZWm62T7OHcUZfyUDL9oqXXRF9tl
	Y/7Z7ZGI5kGg/w1mzg5Gj9W41GetY80ACPwRXIjO5xG0rVM9BAud3fMUFpZ61TxF4AM7S/aey3wLp
	mbsiveMpPThvqb7pvrG2ahODuur5teNFFUNRRMQQkTM+EGW0aKHMNwS6X84zljGsHTj07ZH24PN5+
	HzPo84q9OkD6oRl7Hb04fjuoQFq1qT0A5E+YxyWaVpAs2WvitO6hMLDdfiAi3cSM9tKebnJgvtjrb
	cWsaK93A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YYF-00F5Kv-1k;
	Sat, 12 Apr 2025 18:57:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:31 +0800
Date: Sat, 12 Apr 2025 18:57:31 +0800
Message-Id: <e77446f9cf0598d63dd4a766fd69a8d67d9ea94b.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] crypto: lib/sm3 - Export generic block function
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the generic block function so that it can be used by the
Crypto API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/sm3.h |  1 +
 lib/crypto/sm3.c     | 25 ++++++++++++-------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index 1f021ad0533f..d49211ba9a20 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -58,6 +58,7 @@ static inline void sm3_init(struct sm3_state *sctx)
 	sctx->count = 0;
 }
 
+void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks);
 void sm3_update(struct sm3_state *sctx, const u8 *data, unsigned int len);
 void sm3_final(struct sm3_state *sctx, u8 *out);
 
diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
index 18c2fb73ba16..de64aa913280 100644
--- a/lib/crypto/sm3.c
+++ b/lib/crypto/sm3.c
@@ -166,19 +166,22 @@ static void sm3_transform(struct sm3_state *sctx, u8 const *data, u32 W[16])
 #undef W1
 #undef W2
 
-static inline void sm3_block(struct sm3_state *sctx,
-		u8 const *data, int blocks, u32 W[16])
+void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks)
 {
-	while (blocks--) {
+	u32 W[16];
+
+	do {
 		sm3_transform(sctx, data, W);
 		data += SM3_BLOCK_SIZE;
-	}
+	} while (--blocks);
+
+	memzero_explicit(W, sizeof(W));
 }
+EXPORT_SYMBOL_GPL(sm3_block_generic);
 
 void sm3_update(struct sm3_state *sctx, const u8 *data, unsigned int len)
 {
 	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
-	u32 W[16];
 
 	sctx->count += len;
 
@@ -192,19 +195,17 @@ void sm3_update(struct sm3_state *sctx, const u8 *data, unsigned int len)
 			data += p;
 			len -= p;
 
-			sm3_block(sctx, sctx->buffer, 1, W);
+			sm3_block_generic(sctx, sctx->buffer, 1);
 		}
 
 		blocks = len / SM3_BLOCK_SIZE;
 		len %= SM3_BLOCK_SIZE;
 
 		if (blocks) {
-			sm3_block(sctx, data, blocks, W);
+			sm3_block_generic(sctx, data, blocks);
 			data += blocks * SM3_BLOCK_SIZE;
 		}
 
-		memzero_explicit(W, sizeof(W));
-
 		partial = 0;
 	}
 	if (len)
@@ -218,7 +219,6 @@ void sm3_final(struct sm3_state *sctx, u8 *out)
 	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
 	__be32 *digest = (__be32 *)out;
 	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
-	u32 W[16];
 	int i;
 
 	sctx->buffer[partial++] = 0x80;
@@ -226,18 +226,17 @@ void sm3_final(struct sm3_state *sctx, u8 *out)
 		memset(sctx->buffer + partial, 0, SM3_BLOCK_SIZE - partial);
 		partial = 0;
 
-		sm3_block(sctx, sctx->buffer, 1, W);
+		sm3_block_generic(sctx, sctx->buffer, 1);
 	}
 
 	memset(sctx->buffer + partial, 0, bit_offset - partial);
 	*bits = cpu_to_be64(sctx->count << 3);
-	sm3_block(sctx, sctx->buffer, 1, W);
+	sm3_block_generic(sctx, sctx->buffer, 1);
 
 	for (i = 0; i < 8; i++)
 		put_unaligned_be32(sctx->state[i], digest++);
 
 	/* Zeroize sensitive information. */
-	memzero_explicit(W, sizeof(W));
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 EXPORT_SYMBOL_GPL(sm3_final);
-- 
2.39.5

