Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF00340417;
	Fri,  2 Oct 2026 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790952571; cv=none; b=XeS4ld9HBwQsoH9JaCs7p2aeTkUEaCS6KFo+GGadZEVk2KrEV8efNHI1m2t+SXLn3L8vYDSDfeGJ1UWLCKI2jeMQMZ5OU6btEm3nooP2smnJkVuCaJtxNoJ2HHccMu+dsWo9WxQQ9MXAgPlAtoidl5D7vO3lb1WH1IitqeitwQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790952571; c=relaxed/simple;
	bh=2Iwh1YBp293wVOzp50snGvj+P98VSbsE/9m4UEmQTXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LwUTLg+8cxwJckN9RHnG0C41KYr4EDbNLBMSipywALrQ1cIie4naX9RBN3D1TheRLGIdcOI2Nk4pqwzd6C0pEIpBF76b2UhVK1x7hhcbArePuEJFe3vRZIevTufq8uLFFREDf0fGUgm7ZX8TARHO0IOVkwhHFLEP83MjXSme0dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xto4jLfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xto4jLfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7331F000FF;
	Fri,  2 Oct 2026 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790952569;
	bh=5kIp6AK84MEo9GlzF/Be95zArasU2AChgod6QlX+xlg=;
	h=From:To:Cc:Subject:Date;
	b=Xto4jLfJvUFRd1Cfb57Dyt861cC2741yPwg1ytnac1QHmnW8OXzRVdAD6pishXAaf
	 xfbQFtDw7fLA+G87oLwR9cHo1jjKo0iAyh75iQcFTKuclouv3DUcDEtkIkGHhgh5W6
	 cNlvGBlOYPQCcQBhY+npkTJMYusA5Nwe+MxKxJYjdb0U2IM/y46wGHcFkV8SIEwEgT
	 MqO6IsfyPiCcxNeRcLkNRCGunBnE6UehwY/5lD1t3X1xR2pSvXWXa8tovf58BLMtmU
	 eGsl6+3ygGN2hr0DTs+rWWdE34sKc5dC2ZNIVtKpW9KTK6JoYZsc1MXSbnaTE/Q28n
	 h+avyIg2yvPDA==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: stm32 - use devm_platform_ioremap_resource() in stm32_rng_probe()
Date: Fri,  2 Oct 2026 16:48:38 +0200
Message-ID: <20261002144839.51627-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1003; i=blum@kernel.org; h=from:subject; bh=2Iwh1YBp293wVOzp50snGvj+P98VSbsE/9m4UEmQTXI=; b=kA0DAAoWXqtxINjMdS4ByyZiAGq/xEejLZNBJ+SYr8+Ib0WyLcbJIkc4wUBkp/z3YfDJ30Ckt 4h1BAAWCgAdFiEE4Jr4mE11fHmyNFi5XqtxINjMdS4FAmq/xEcACgkQXqtxINjMdS4NCQD/bqnL tAU6U/IwSMVUcOr1/pua2Tlaa6fBpL+OPSm505YA/jiPDnXJcEll3KolODLI3efPvXG7ALDcIcy Fb3EPxYII
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The resource pointer is unused - use devm_platform_ioremap_resource()
and remove the unnecessary local variable.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index f5bfe54c01dc..8468a4a24d48 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -528,14 +528,13 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct stm32_rng_private *priv;
-	struct resource *res;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->base = devm_platform_get_and_ioremap_resource(ofdev, 0, &res);
+	priv->base = devm_platform_ioremap_resource(ofdev, 0);
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
