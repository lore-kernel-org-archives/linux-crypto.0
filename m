Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3325B0BD;
	Tue,  6 Oct 2026 20:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791318479; cv=none; b=lIakEu02ag5OeDAUN69ZQ/j6HJI0VhjhMc7isnR6mSuQ1UEzwHHKe4iCsm37ypL9qa/JpcPGALtWsQMb7wq5I4rSc9LqjlH0ASuvw1tlCGFxZSnSiFAIwV1ve08H8E9GtTeLdjCHzdhQ87q9VkzoFM7gIttehIoDsHoxNptRSjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791318479; c=relaxed/simple;
	bh=nQ68lgnNWIGQzaj+6IGjraICICFgXTOkubcAJ/wqw9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxtFpYT0n56/6P9Y9zGqtkP7WhYrBui+cDF2eAxJbbEWDG+2w8XkqNmgnq0iQod894F45VQPwF1K5rZCUAhcD4H1TL+F2YGsRZQCGUSDStSYmdwULc4Ajzrgo9rBAq86Rna2/zpWb8ECos1Jo446ITb8wqJ7EVVTlEShSqyZX9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qy3g2J/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qy3g2J/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965321F0089B;
	Tue,  6 Oct 2026 20:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791318478;
	bh=cqxmOhAaf0jJbiWYynr1D5oxbMRyOf/h5HQ0F1FiFV0=;
	h=From:To:Cc:Subject:Date;
	b=Qy3g2J/ML4rWXYkeIGYfCnGQn/4cLG3svw+yeSe1zz/dHkcYgNmbB5o8wTXc6AvjL
	 SF2OV7DPmIRguv5qrvlPJhjBFBzoN1E9E6aHfNTAmpnAbs9+5P04rOd8NecK/S3NUO
	 l5NfiuRCZIbJBPaZ6NG5YAbbQ11SehMm8znA2hRemGwzV0vNRZgnXU+3iZmsGBM72j
	 6GETpu27e31118+hkrqbb4ghYn7DCvM41cy4A0X5QAh//Ye/X6J/PgKSynkf/YuwKY
	 9SHFr7rEKUOQ/VPid8geo27WdaQTUzS1IHCzfuEjmQsixf1IUXxMqhXnjTxgm21Tez
	 g9Fc0fc7Lr5Tw==
From: Thorsten Blum <blum@kernel.org>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - simplify cctrng_probe()
Date: Tue,  6 Oct 2026 22:27:34 +0200
Message-ID: <20261006202734.104415-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=994; i=blum@kernel.org; h=from:subject; bh=nQ68lgnNWIGQzaj+6IGjraICICFgXTOkubcAJ/wqw9A=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlHI7d97+57tyD+gWvPSYnp6z6/yS+I+T1z7QemMlkVO VOvO7xTOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAia7cx/BXY/2Vz1PcjSxsU +o7U+G7zP7gpUvMK1ysuPfPA/L9sN4MZGVYUCyrJqvVYZ0b+XXM/mvNz5bPWRZoMKsZhqvPqtEu 3cwMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Handle the error directly and drop the goto statement.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a6925211c3b5..43bf99741bdf 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -539,7 +539,8 @@ static int cctrng_probe(struct platform_device *pdev)
 	rc = devm_hwrng_register(dev, &drvdata->rng);
 	if (rc) {
 		dev_err(dev, "Could not register hwrng device.\n");
-		goto post_pm_err;
+		cc_trng_pm_fini(drvdata);
+		return rc;
 	}
 
 	/* trigger HW to start generate data */
@@ -552,11 +553,6 @@ static int cctrng_probe(struct platform_device *pdev)
 	dev_info(dev, "ARM cctrng device initialized\n");
 
 	return 0;
-
-post_pm_err:
-	cc_trng_pm_fini(drvdata);
-
-	return rc;
 }
 
 static void cctrng_remove(struct platform_device *pdev)
