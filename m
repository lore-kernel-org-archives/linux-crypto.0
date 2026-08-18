Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1472B9B7;
	Tue, 18 Aug 2026 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059736; cv=none; b=RqLKTqyqdFS6ifDa2wF4/3s641279TpLVMbdYm/SbjQO9w1mJq6n+mQ9o91FLqetF5iD97tjFErnepjEoZxGssFukIkst7YVJLZmSwtNerFpO83s2BHP9fyQpO77XexSmkR+DgbEr9w/hCM7FJJCp5QtVUn5oCZ/gb9jLi8i5oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059736; c=relaxed/simple;
	bh=w+vN8HIpXoFEr/B/BIERtfqwf1Wih/j+7pUZTpdkNHQ=;
	h=Message-ID:From:Subject:To:Date; b=WUx4CdU6ar0eHmzxXmY+fVagFW6IVAkA7cjH3BmJ1WDu1z9QF9+v7SxLarsUiC6DByiAbbgVhb/ZS+BpdtZK2twmo1mioKNGVuSJDA76GEb4PPdQKZgnghYcJ+RtDF0u7Dm5mtGjK+5BONuMChM7qZKafUB8Kny/1FT6elv/UIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=eIipD9Kg; arc=none smtp.client-ip=203.205.221.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="eIipD9Kg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787059730; bh=zlCMDPgouDyD8iUH3iFlNzl8ETNsxMGJix6EiM0iCoo=;
	h=From:Subject:To:Date;
	b=eIipD9KgenWT99NHU9Ij5+96pEEVTUEgiU/mioR90VwEhjSMR7bG11VC/gFxYTKXa
	 B+JkM7dmZgA2z31zZDMuEIDcDPJxxOfZceh2UQnBxsWnfcyhKAojxAX1oz2eeEaiXM
	 eUbu0RuytAzRmp7436teUajJEcNCwrFpbYiLdEik=
Received: from [127.0.1.1] ([5.195.0.150])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 1721C6D8; Tue, 18 Aug 2026 21:05:50 +0800
X-QQ-mid: xmsmtpt1787059638tnnznmvvy
Message-ID: <tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+8M5j8ototF3WV1fj+kjU0LOU5IJfmN1ZgbiYhETmgWW/2g8qw3
	 fU58lD+Hpl6kEkTOXhOeBYD5dMOTWyGXdEn8UXTUhLi9kSMhIO0EWqnN8fIxhUsFCVVngIrSyFUZ
	 S6h4DnD1DZB1oL/CHoe0PwOVHBlxSfGkk32Uf6nsSgD4WqLk4s/d1Cmq6CSgLn40adaWKWJ7WUMP
	 4dB7xOk78mTaqfKqOtODY+V/b6EuTgEEevrh/Hl5ljFuWC8OA+e5fm2dcfLCyYdL8gqIa8+W+c4e
	 1idUBXmE8bE9WtYHGJKW0GqFvv4Ry2y/6HYd6YWE+4jNPkTHy59Vx6J1Hy9o33K4IlDyGsEzVMNv
	 F5yrAo76oplKqVCUOd6T6OFcWA+K853q5fb+GbAgg5wnCzgpq9dJv3PLbKvX6MnvTsUujXGjzC20
	 kaTVt4ILmGP4jcJuZzJmkHy7j3CstEvG2vtpSamN4bP4cUYyUVvz7YiCDgt2S0ScwSkdt1bTYYsq
	 6iLy33S1oTXkRgkgG9X81cGaZFsXzJ3eTa+kpzsl3nhVlGhiVKCv7JlO9iimxzTkU6WNOuBclAK1
	 IGrcxLzdKHL4lZLZ5StS8EUDIH6dNY0v+Ox+18lnZLrSgVjgf1pOFeMjTjfMZlaDJTnX49x1Bw+D
	 A5gBU2kn2E8lIuY7mcg6AmJjE7nwGnO7+Xy8W+ReJv3EBa9GDtSYYEdowzWRqoSOPoJlaN9NDjpW
	 uF3fzzlw59IQnBMHVgJpYLJgUptXfy6Epxh+M272mfvhMjAlF4zNyAo5smzji/9wE95j8cSNiNU4
	 NbacIwe2HyB0aM5/BVCfr74//N9V+AkhjGsZO8Tgmheu5q0xp/qwjRFje1EwTqGwZd1ObSUnMKdp
	 N48kxwkAKZQXK8qgO4FIIX63a7lHObYvIWKrD5Q3CUFPNVG3h8uBoJMTBJMvNIHqb5Ot8lYJqCQy
	 vx26NTpOHWIt2/IGsp1WKeFQZ8xY4ujufB40VNi9nrjB69Uxmc+oSD+GUtQM0AiWKLRp6JrSQPlM
	 ozmByRMiiyTuzRfkt3E13DbFn1kmPaGdQBAHMDmtzHj4zt+JB4CeMZFXrYRbGTyBFlbo6msw==
X-QQ-XMRINFO: N+gupeqCsbX2VDY1MJ80Zvm2Nd9q8sTYww==
From: Jiawen Liu <1298662399@qq.com>
Subject: [PATCH] char: omap-rng: fix runtime PM cleanup
To: Deepak Saxena <dsaxena@plexity.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 18 Aug 2026 17:28:48 +0400
X-OQ-MSGID: <178705972862.291840.5611231794927964618@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Clean up runtime PM on deferred probe.

omap_rng_probe leaks runtime PM state if devm_clk_get returns
-EPROBE_DEFER after pm_runtime_resume_and_get succeeds. Direct return
skips put/disable.

Route -EPROBE_DEFER paths through resource-matched runtime PM cleanup in
omap_rng_probe.

Signed-off-by: jiawen <1298662399@qq.com>
---
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -459,8 +459,10 @@
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_pm_runtime;
+	}
 	if (!IS_ERR(priv->clk)) {
 		ret = clk_prepare_enable(priv->clk);
 		if (ret) {
@@ -471,8 +473,10 @@
 	}
 
 	priv->clk_reg = devm_clk_get(&pdev->dev, "reg");
-	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_pm_runtime_clock_1;
+	}
 	if (!IS_ERR(priv->clk_reg)) {
 		ret = clk_prepare_enable(priv->clk_reg);
 		if (ret) {
@@ -497,6 +501,16 @@
 
 	return 0;
 
+err_pm_runtime_clock_1:
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
+	goto err_pm_runtime;
+
+err_pm_runtime:
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	goto err_ioremap;
+
 err_register:
 	priv->base = NULL;
 	pm_runtime_put_sync(&pdev->dev);

