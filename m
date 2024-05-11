Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAED57C85;
	Sat, 11 May 2024 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715439389; cv=none; b=ojXdovRyNQFzitv6fx0fG+xdAn1DZl2HJlTA2Vp5g+r1+iKIcKjd1gR7Y01b6HuXn2i53KQ2lF2xLoYzR9Mze6Or2TmnIpFVkkY+7kqWf/Eqh5haID1VAP9KsumBONU38Lxt6Q4CCzsQ/OwRYH4NGNyLS46XZkc/rh4O0AfmIOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715439389; c=relaxed/simple;
	bh=ostRkU80NQtZiyg93ykwl5RgPPchPg2q6wou11iXOtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gu1HadmmjcZE1dt7vKjC9W3x6Afx+INpbqo/YV7aIDbh4t1tAa6UyuQ79SzDvzvk5BlbAFfj0qDu805HeAfVPMFbdhJz+G5nuZew13nRaswm4nHgPaenqlCXU8waOdUAoQpX7m8Ba8my5SN6t3NWdrc+6O6reEnPhoyrLZ3alzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=oR+a8CX1; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="oR+a8CX1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=NLOqo6x1lRGOC08LgTPWzckycmCY5FTFMVeKS/Maf0w=; b=oR+a8CX1aiXBGqEE
	CNtnNku7sUs5iR+oR4PfOOo/u/RJ8YnixBZ4DIJpTptjy89mErnQhhWFVAY4Y68aOOq0gIDO+pEUk
	vQCPgthuWa7uBUVL+IdrB2z4HrvWxodv2+vMWvMneGuUp2DwAmQOFu5isdnzp4UmEqVmae7U/F1bS
	f/DOXvm9dbh8K6ndjZLYvTNgnP8URNf2mIo2jAqsdUCmDN8AC7siSwMVvUgPGquGM6Pv5RWsd9rcz
	RDthkp+gfzIT8fHszGgVWvtG6hTV6tXhXKSg5neazb5YrZppcrMZZxjWd9EYT4UvPukG13o9nuACN
	2wTTaqMQZfc4hgKHcA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1s5o96-000W7o-2I;
	Sat, 11 May 2024 14:56:21 +0000
From: linux@treblig.org
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org,
	andreas@gaisler.com,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: niagara2: Remove unused struct 'n2_skcipher_request_context'
Date: Sat, 11 May 2024 15:56:20 +0100
Message-ID: <20240511145620.226548-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'n2_skcipher_request_context' was added in
commit 23a6564a6b51 ("crypto: niagara2 - switch to skcipher API")
but never used.
Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/n2_core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 59d472cb11e75..251e088a53dff 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -720,10 +720,6 @@ static inline struct n2_skcipher_alg *n2_skcipher_alg(struct crypto_skcipher *tf
 	return container_of(alg, struct n2_skcipher_alg, skcipher);
 }
 
-struct n2_skcipher_request_context {
-	struct skcipher_walk	walk;
-};
-
 static int n2_aes_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			 unsigned int keylen)
 {
-- 
2.45.0

