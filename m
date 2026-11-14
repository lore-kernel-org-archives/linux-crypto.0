Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.53.16.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675879;
	b=3I5hGSvFHelvBIG3iA2WScgubWjHf9kSEWf2CP66wxCPvBNRfIMB/RZ1BFoDWowe/hDn
	 bFuTBH9C3j5e0OMmz8jyyo9jatD0No8VodOm7lTEPLtNELTBXYSeefI0x4xzBaK7NI4el
	 Uzg6707CTysHrqEg9yjgUCY+j/V1+TgNRkG/9J6BJ75S1xRhC8Wm/dEQzc0nYiwxqsfGB
	 jFqe5ukCurLlJxTAzn1ka0pPbHG1L/moK2Ii5mVqaJTcOKakNcJ2jJCzGxh5ZQJwXP1M3
	 mKaD/9cCrlAYEdG3jPMSUTVpw/Zlqr3Enp57Q3GVrJCpcoJo+0U9IqR1YCumHu2YKyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675879;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jT4ljBE/NbhTGODfv1aO/Y34+Uzmxp+qCJ9yPuMME0A=;
	b=WtnnS4A/HS2d8hXqdb2oyXKudCMmLkEkXngJ9Rw+TWJ819RT3O8ZddTFZt5aA2TYWmew
	 WYV2nZZB4o/T+nzJZRnHKOlN7VmFhZUtOwRzbOKeQ1G+39CFYkyDxwYKeQJCNfflHdt63
	 Uw4M9tGvo8nos6oiGg09gmlSZoMxRG7/D3EysMoL4zKSyWOncbg6OIuLGBckkQd0OFJiJ
	 dW6ilaYMnwVjU4Ai11ySrHVyPRL/4YMWKf26rm1AWzn83PnlD1j80i9IC99Sddd03iOJx
	 Hxyk5aUFY6PlS9sNF4FpJ6m4BwR03MNXqz1mJNTFXAYFQJNsHQ8jBG0PgW170/fZBHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kaiser.cx;
	spf=pass smtp.mailfrom=kaiser.cx;
	arc=none smtp.remote-ip=152.53.16.207
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87521606A329;
	Sat, 14 Nov 2026 17:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87521606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from [185.104.138.115] (helo=nb282.user.codasip.com)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <martin@kaiser.cx>)
	id 1xSHB3-00000000iNz-0cTn;
	Sat, 14 Nov 2026 18:04:33 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 1/2] hwrng: cctrng - simplify runtime pm refcount code
Date: Sat, 14 Nov 2026 18:03:14 +0100
Message-ID: <20261114170335.1680546-2-martin@kaiser.cx>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261114170335.1680546-1-martin@kaiser.cx>
References: <20261114170335.1680546-1-martin@kaiser.cx>
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

Clean up the code for runtime pm refcounts.

The cc_trng_pm_get helper function isn't really useful, call
pm_runtime_resume_and_get directly.

In dev_err_probe, show the error code only once.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/cctrng.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index b5f2c75d2eb8..ef3ca6d8cc85 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -85,12 +85,6 @@ static inline u32 cc_ioread(struct cctrng_drvdata *drvdata, u32 reg)
 	return ioread32(drvdata->cc_base + reg);
 }
 
-
-static int cc_trng_pm_get(struct device *dev)
-{
-	return pm_runtime_resume_and_get(dev);
-}
-
 static void cc_trng_pm_put_suspend(struct device *dev)
 {
 	pm_runtime_put_autosuspend(dev);
@@ -239,11 +233,11 @@ static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 			/* re-check space in buffer to avoid potential race */
 			if (circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) {
 				/* increment device's usage counter */
-				int rc = cc_trng_pm_get(dev);
+				int rc = pm_runtime_resume_and_get(dev);
 
 				if (rc) {
 					dev_err(dev,
-						"cc_trng_pm_get returned %x\n",
+						"pm_runtime_resume_and_get returned %x\n",
 						rc);
 					return rc;
 				}
@@ -521,9 +515,9 @@ static int cctrng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, rc, "cc_trng_pm_init failed\n");
 
 	/* increment device's usage counter */
-	rc = cc_trng_pm_get(dev);
+	rc = pm_runtime_resume_and_get(dev);
 	if (rc)
-		return dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
+		return dev_err_probe(dev, rc, "pm_runtime_resume_and_get failed\n");
 
 	/* set pending_hw to verify that HW won't be triggered from read */
 	atomic_set(&drvdata->pending_hw, 1);
-- 
2.43.7

