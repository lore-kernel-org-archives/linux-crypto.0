Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [176.9.242.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C9A1BC58
	for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2024 10:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728900804; cv=none; b=r/LCsWpBcJNKfzSvLztbqp88qcrSI7eHBn7V79NJ0WQgIBoq8F2toI+spv2SVOQEuFXgJsRVxVngJoPhBQTz7HOiUcLPFT8pSdH/wD2OVDvdKUAD8czgtzLbmPCwYxj/PNI5iqLcakft4nsG+ACvP5gZqF/rCm10miEhhT1vZLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728900804; c=relaxed/simple;
	bh=KzqWPAxOFjjQfmivOb2n5l2Nr8ARXryRdqsJqFnwyH0=;
	h=Message-ID:From:Date:Subject:To:Cc; b=GPZLAXVjOyR9CFBOj+83cS5F7/+h5M+8IuKpMRa6aTxHMdfnXZ1bC4TLIngfwtNseeBoOF27BwDz4B+iZSYlSJaVjyp4tEKSKSuT0/lCxFcDmIsCs1iCEDKHUgWPjEQOm1fEOOCKWoPCXCwY+xgtn0nbDkOVC/+gZBOMJlTnWIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=176.9.242.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 59F59102E7ECB;
	Mon, 14 Oct 2024 12:05:03 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by h08.hostsharing.net (Postfix) with ESMTPSA id 1DDC160FC0F1;
	Mon, 14 Oct 2024 12:05:03 +0200 (CEST)
X-Mailbox-Line: From e843333c7b9522f7cd3b609e4eae7da3ddb8405c Mon Sep 17 00:00:00 2001
Message-ID: <e843333c7b9522f7cd3b609e4eae7da3ddb8405c.1728900075.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 14 Oct 2024 12:04:41 +0200
Subject: [PATCH] crypto: ecdsa - Update Kconfig help text for NIST P521
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Commit a7d45ba77d3d ("crypto: ecdsa - Register NIST P521 and extend test
suite") added support for ECDSA signature verification using NIST P521,
but forgot to amend the Kconfig help text.  Fix it.

Fixes: a7d45ba77d3d ("crypto: ecdsa - Register NIST P521 and extend test
suite")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b3fb3b2ae12f..6b0bfbccac08 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -296,7 +296,7 @@ config CRYPTO_ECDSA
 	help
 	  ECDSA (Elliptic Curve Digital Signature Algorithm) (FIPS 186,
 	  ISO/IEC 14888-3)
-	  using curves P-192, P-256, and P-384
+	  using curves P-192, P-256, P-384 and P-521
 
 	  Only signature verification is implemented.
 
-- 
2.43.0

