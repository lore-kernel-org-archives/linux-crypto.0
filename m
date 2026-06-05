Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FCF33DEC2;
	Fri,  5 Jun 2026 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780687733; cv=none; b=F2+rxqTHkJkfEOExnWHhszWknZbGYvs+y9WdnwwlnHASFqic4TLYZ9e8GYAzRp/AoIWHcj+4IgDQyUTHKwJeeRCk7E0nvqhhME65ToXGsTVRwnskygDMbn/JJ6i+pcTaih4EmLD3GWm+hJabiTtgOaNS9AV6TElbNcJCnrr1hgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780687733; c=relaxed/simple;
	bh=vdtEDajxxZVgnp50aMgTU9QM3ODnDkdA+q7IJkMReQY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WHGirVnyPeaGPIPsDDpVPKWVynA3iEQ3K9etQDSyyFxLX3Ad+TETFm3twJUN11gokQlae/p4BkgdtxddBnEPOguDlqoLGUl7f2AbKj7W6lamnYKcTJDyoth6ZaqcIleOhKKAvKQtGyUtWb7IeEMETvlJsy3ystuUJAB94bPipa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=theesfeld.net; spf=fail smtp.mailfrom=theesfeld.net; dkim=fail (0-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b=vptDfhut reason="key not found in DNS"; arc=none smtp.client-ip=185.70.43.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b="vptDfhut"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theesfeld.net;
	s=protonmail2; t=1780687729; x=1780946929;
	bh=cq9yyO2RKkR9c5bNY/rnxelk0EBMhcs43KERyqnMXzY=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=vptDfhutrPhOGlpJ9binHcZFeRpO+WoSJEcCFgP6XEvN6pMQlha+K/3uuXjdMnEhI
	 ti5jfc7dMENFVNNeYctlXaFT+WumNMsQj607YlQkVl8R9apQqjxHs+XvSKKZ8mLvkI
	 oLgxNs68oFnLgwBINyEJFtyxR2TcW4JBYYfTjlY/S8y/IPHNEehdxwlWXn6naqt9lI
	 rMPGuWG3jhh/uiYHY4dU5gOMjelbLWswZcA68SN+8EqQJgFY/vlFY3JOGR/Y7/XSIu
	 kPxI/j/6Ly8ESUyGw1/sSFGRzzlwZ0by0csmXIJRy4C5L7QCLP40pN0Ei8ZF1NKjN1
	 pohVd7UqZW+fg==
X-Pm-Submission-Id: 4gXBLj30K8z1DDL0
From: William Theesfeld <william@theesfeld.net>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: omap - balance runtime PM and clocks on probe-defer paths
Date: Fri,  5 Jun 2026 15:28:42 -0400
Message-ID: <20260605192842.372935-1-william@theesfeld.net>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

omap_rng_probe() calls pm_runtime_enable() and pm_runtime_resume_and_get()
to bring the device up.  If either devm_clk_get() call subsequently
returns -EPROBE_DEFER, the function returns -EPROBE_DEFER directly,
leaking the runtime PM usage counter taken by resume_and_get() and
leaving pm_runtime enabled.

Convert both early returns to set ret and jump to err_register, which
already performs the matching pm_runtime_put_sync() + pm_runtime_disable()
unwind.  Because devm_clk_get() returns ERR_PTR on failure (not NULL)
and err_register calls clk_disable_unprepare() unconditionally, also
NULL out the failed clk pointers before the goto so that
clk_disable_unprepare() (which only handles NULL safely, not ERR_PTR)
does not deref an error pointer.

While here, NULL out priv->clk and priv->clk_reg in the existing
"optional clock not present" else branches.  In that pre-existing case
the pointer was left as ERR_PTR, and the unconditional
clk_disable_unprepare() in omap_rng_remove() would have dereferenced
it on driver unbind.  No functional change for systems where both
clocks are present.

Found by smatch ("missing unwind goto?").

Signed-off-by: William Theesfeld <william@theesfeld.net>
---
 drivers/char/hw_random/omap-rng.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5e8b50f15..1902865a9 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -459,8 +459,11 @@ static int omap_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER) {
+		priv->clk = NULL;
+		ret = -EPROBE_DEFER;
+		goto err_register;
+	}
 	if (!IS_ERR(priv->clk)) {
 		ret = clk_prepare_enable(priv->clk);
 		if (ret) {
@@ -468,11 +471,21 @@ static int omap_rng_probe(struct platform_device *pdev)
 				"Unable to enable the clk: %d\n", ret);
 			goto err_register;
 		}
+	} else {
+		/*
+		 * No optional clock present; make priv->clk safe for the
+		 * unconditional clk_disable_unprepare() in err_register and
+		 * in omap_rng_remove().
+		 */
+		priv->clk = NULL;
 	}
 
 	priv->clk_reg = devm_clk_get(&pdev->dev, "reg");
-	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER) {
+		priv->clk_reg = NULL;
+		ret = -EPROBE_DEFER;
+		goto err_register;
+	}
 	if (!IS_ERR(priv->clk_reg)) {
 		ret = clk_prepare_enable(priv->clk_reg);
 		if (ret) {
@@ -481,6 +494,9 @@ static int omap_rng_probe(struct platform_device *pdev)
 				ret);
 			goto err_register;
 		}
+	} else {
+		/* Same rationale as for priv->clk above. */
+		priv->clk_reg = NULL;
 	}
 
 	ret = (dev->of_node) ? of_get_omap_rng_device_details(priv, pdev) :
-- 
2.54.0

