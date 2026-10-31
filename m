Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.53.16.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793458102;
	b=eHLaKFW/UEEpdq2tI8naebAWUPpgJTm+7+KXF7D/y7xd1qn/7+Z+NpNnHXa6snIrB1AE
	 SwsKiSztvq54/q7OoZppRIhB0pBI0ynT1rPFuLTVhRm+1fia3ndLuLbwJNflLBE7M3zA8
	 zVJMluDxa02fP+OsWkqNE/4QsKqXHTczqXj249PU/3vLmgMxphxRnjhFSpmb0PohN6lip
	 1tMT9sqm5wg6IN86+elsa375nlrF7+H+ZCwcmrle/QfZFXtCC6hzUseGWD+gP2kp+zepw
	 KY4gqZHy9CrcQRe4i8BWayM4DexAPigLBvH1LEzZlcbx3T9bBa3DiAMnD72tI5gXQrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793458102;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XrVrWqMATAHE/YlBzQd3sd5zcx5pm3st6lTv2jbSA2w=;
	b=AybOTuN5TOZk+/flc4iNQAsOkczcRgHAzyXdePVPfT2hWu5vJzRRkkkneTm/SqGX+8Ip
	 3lFbHDHjb+PrcQHM9/H3nPnnPx2JP1EPk2fojcfH8xAsNuOBZ8GYxpTgP2OTZPDRXbnPt
	 64St57VqyIKy1mkoIFm6nq0grK+7DD0M8UpqCiOGLOAqLdbeJyNAa9vrAK1epsm5e5u3y
	 k2Zyk6zZmIDunR+OVgswBlb8VgzF+8mRRcfchBbrQrEWKMezhYudifUAdX8qkl2tI38Xj
	 ABdGT38swR53tH4/OPYbSuKhpp1CxwESH7lzTLP+gCGwjpzzKy3RmGd8awzZcfnzQ5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kaiser.cx;
	spf=pass smtp.mailfrom=kaiser.cx;
	arc=none smtp.remote-ip=152.53.16.207
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E6606A31A;
	Sat, 31 Oct 2026 14:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 058E6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from ipservice-092-209-185-051.092.209.pools.vodafone-ip.de ([92.209.185.51] helo=nb282.user.codasip.com)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <martin@kaiser.cx>)
	id 1xNAND-00000002Cxz-4AfD;
	Sat, 31 Oct 2026 15:48:00 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Martin Kaiser <martin@kaiser.cx>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] hwrng: cctrng - fix usage counter in error path
Date: Sat, 31 Oct 2026 15:46:20 +0100
Message-ID: <20261031144729.2327464-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If probe fails after the runtime pm usage counter was incremented,
we have to decrement it before we exit.

Remove the cc_trng_pm_fini call in the error path. It calls
pm_runtime_disable before runtime pm is enabled.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
based on sashiko review
https://lore.kernel.org/linux-crypto/67844d9d-d4d4-4026-9549-73589afcc1ff@wanadoo.fr/T/#m1a770f5f9eeed95b48cad7545580aed4fa74e6fa

compile-tested only

v2:
 - don't duplicate the error code in dev_err_probe

 drivers/char/hw_random/cctrng.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 03401ee59a8e..088aa031bf22 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -533,9 +533,8 @@ static int cctrng_probe(struct platform_device *pdev)
 	/* registration of the hwrng device */
 	rc = devm_hwrng_register(dev, &drvdata->rng);
 	if (rc) {
-		dev_err(dev, "Could not register hwrng device.\n");
-		cc_trng_pm_fini(drvdata);
-		return rc;
+		pm_runtime_put_noidle(dev);
+		return dev_err_probe(dev, rc, "Could not register hwrng device\n");
 	}
 
 	/* trigger HW to start generate data */
-- 
2.43.7

