Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9251EB1A8;
	Tue, 22 Apr 2025 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745315845; cv=none; b=er9tpzmtfDibbE9Pu9E9aTUiUnnTvJ4ZD8jglcMck2OTrQljYw5ytcPEJ4LCHDhZ9JqOEIQGHY3Kh2Ra2Iwhkt84oQEIIWrLIiL5aTnwNggunu8mXmdT6zrDg05fE82xBlJb8OZLGFyjbbwke9qeJjcP4XElsh0ht2rldalA4Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745315845; c=relaxed/simple;
	bh=t1U5iu98UOVrBT4ZBbp17ocR2D+pzk83ZqkZJHQyekw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G86rwTsOXZlYxLcxCiy6pCTjcic8AMfZ3HjcYkEaYqPKO+iMjYdF0Me/jXzqGO9oVeZcskzTn58buU3IPpaTTjScVAxWcGh1PPg/FRpKTXO+sQlFejd67AvSgviz6YqsAexbysGn8HJu8yPxxjEHAYkPzzK+SfbnzrSh69MPuTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oRY1KBfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRY1KBfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B2DC4CEE9;
	Tue, 22 Apr 2025 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745315844;
	bh=t1U5iu98UOVrBT4ZBbp17ocR2D+pzk83ZqkZJHQyekw=;
	h=From:To:Cc:Subject:Date:From;
	b=oRY1KBfXD6XpEip2QJIKF9vcSvOYFSGYWB0yBS2TWWN5XoySex5XlxZQCPTgqSV/F
	 ygHLWy89V2pRzcET2vZhQSkH4AzcEz+Wgyv25q9Hu5x254EpYG3RdSnq01Qhfqu5Fu
	 Hg5ywdrncFxOLNJ5Nxk+11e9H0mRkJrVr6zOebhcrfGLxOoFT6vt0MkDGX+UehGJU9
	 URsZlrh0Si+X4AQdnCX0qGjPvHkZXPozCyQcJJ1rFLVD4cL2o9j6ZvOrrPfcF9JmS2
	 ih6c+DOzJleOp6+LRk7lkUmlJok5QtjmwdLw99V3ycWVCrZyooXKY2ydUFB92V/BDt
	 yjEmO4PBxHDGQ==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-sha204a - Set hwrng quality to lowest possible
Date: Tue, 22 Apr 2025 11:57:18 +0200
Message-ID: <20250422095718.17360-1-kabel@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

According to the review by Bill Cox [1], the Atmel SHA204A random number
generator produces random numbers with very low entropy.

Set the lowest possible entropy for this chip just to be safe.

[1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html

Fixes: da001fb651b00e1d ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/crypto/atmel-sha204a.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 75bebec2c757..0fcf4a39de27 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -163,6 +163,12 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	i2c_priv->hwrng.name = dev_name(&client->dev);
 	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
 
+	/*
+	 * According to review by Bill Cox [1], this HWRNG has very low entropy.
+	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
+	 */
+	i2c_priv->hwrng.quality = 1;
+
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
 	if (ret)
 		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
-- 
2.49.0

