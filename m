Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.53.16.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675883;
	b=Ej3I42o5/OHyH3q3fdzX5f5ZHoYeeiW/uWgUTVPZ5D9RjoSdpVZWjwmU6kbBQzkhqofq
	 bsy0hk3VLjPgiXXfkiyYt1kjxkMmTRQ7VTewacnNNGchKJbBkjMlsL6B5/R6EvqpuLEJO
	 OU9BuXavYLUY6WZ/EiWrBR/K1EEWBnsSa0amTrC3A4sXJihfeHaxoW72mB7kK7iE/83Kq
	 kDe/DYTxfFi7c4ChIV7xmqwLqP+UbNC90ZPGa06cVelf/zmnVSdi8SV4ufqaKMOo1dySp
	 S51D1VptznC3AWWhKfCVw1n9RCHYzkRC793pTHydC5nGmwtG/xDf2GARNMibEb4jijw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675883;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=W8rV6YQ1VeU+g2fmS3D8hZYDH/00zIn60Z4HqeLb/+Y=;
	b=y20usbMaj6+r6s80uFHm9Xg3RjpGRJUl1AUaREgjGmJOB3ER2Dvm9Rc+/ep0hcznlss3
	 vIdbiZzSYmYkczImwlak12Q0KPwMXWgRWyKMs230vZa8SVFxkMBM33vip4mO+vduWw1cA
	 Pn5AfGyggQh9KNhdfFcv4TD17o7w9Jlnhrey7eh+JvxljbYidZtO+K3Nbi57ePBdN2+aw
	 vA2OvrW9ra9FSy9ZIvgL0PBS0XKahhWBzc+y6RdbT9ejOF3NYakT+Wj8Z2tNuhJoM6/xg
	 bGyaKiNncvEhoEixam++nnBVzyb+TZzjSKuBmUVgnj/m4x90vNzCW3QRLkGqMv0tdkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kaiser.cx;
	spf=pass smtp.mailfrom=kaiser.cx;
	arc=none smtp.remote-ip=152.53.16.207
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F27606A884;
	Sat, 14 Nov 2026 17:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10F27606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from [185.104.138.115] (helo=nb282.user.codasip.com)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <martin@kaiser.cx>)
	id 1xSHB9-00000000iNz-0PUq;
	Sat, 14 Nov 2026 18:04:39 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 2/2] hwrng: cctrng - use device-managed api for runtime pm
Date: Sat, 14 Nov 2026 18:03:15 +0100
Message-ID: <20261114170335.1680546-3-martin@kaiser.cx>
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

Use the device-managed api to enable runtime pm in the probe function.
The disable function is called from the devres layer when the device
is removed.

Disabling runtime pm was the only operation in the driver's remove
function. It can now be deleted.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/cctrng.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index ef3ca6d8cc85..ac77c6afea5b 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -97,26 +97,10 @@ static int cc_trng_pm_init(struct cctrng_drvdata *drvdata)
 	/* must be before the enabling to avoid redundant suspending */
 	pm_runtime_set_autosuspend_delay(dev, CC_TRNG_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
-	/* set us as active - note we won't do PM ops until cc_trng_pm_go()! */
+	/* set us as active - note we won't do PM ops until devm_pm_runtime_enable()! */
 	return pm_runtime_set_active(dev);
 }
 
-static void cc_trng_pm_go(struct cctrng_drvdata *drvdata)
-{
-	struct device *dev = &(drvdata->pdev->dev);
-
-	/* enable the PM module*/
-	pm_runtime_enable(dev);
-}
-
-static void cc_trng_pm_fini(struct cctrng_drvdata *drvdata)
-{
-	struct device *dev = &(drvdata->pdev->dev);
-
-	pm_runtime_disable(dev);
-}
-
-
 static inline int cc_trng_parse_sampling_ratio(struct cctrng_drvdata *drvdata)
 {
 	struct device *dev = &(drvdata->pdev->dev);
@@ -534,25 +518,13 @@ static int cctrng_probe(struct platform_device *pdev)
 	cc_trng_hw_trigger(drvdata);
 
 	/* All set, we can allow auto-suspend */
-	cc_trng_pm_go(drvdata);
+	devm_pm_runtime_enable(dev);
 
 	dev_info(dev, "ARM cctrng device initialized\n");
 
 	return 0;
 }
 
-static void cctrng_remove(struct platform_device *pdev)
-{
-	struct cctrng_drvdata *drvdata = platform_get_drvdata(pdev);
-	struct device *dev = &pdev->dev;
-
-	dev_dbg(dev, "Releasing cctrng resources...\n");
-
-	cc_trng_pm_fini(drvdata);
-
-	dev_info(dev, "ARM cctrng device terminated\n");
-}
-
 static int __maybe_unused cctrng_suspend(struct device *dev)
 {
 	struct cctrng_drvdata *drvdata = dev_get_drvdata(dev);
@@ -634,7 +606,6 @@ static struct platform_driver cctrng_driver = {
 		.pm = &cctrng_pm,
 	},
 	.probe = cctrng_probe,
-	.remove = cctrng_remove,
 };
 
 module_platform_driver(cctrng_driver);
-- 
2.43.7

