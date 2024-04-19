Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4605C8DE
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 05:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713502969; cv=none; b=uGTY0hTLik0wmf4vE3L0gPj6WxFxxAjjZIYn/wFMFqIANWYerj62lajxT4CjMtk6Gpv48+XAwnsyvWxXUOsh8Abts9GKOPL3S3KFu5AXWAFvSaOkcV4bpOi6VWOKIP2WwxMQxD/Wgo7+9GvFJ1YX1CIfDC76k5PWWshqIzYCLuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713502969; c=relaxed/simple;
	bh=klXsnYwRxUuk8G3WI88QnoY2DTIIQVgqWQrvc0VV8SM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZhfOXknc2Og89WGDtIvLn9PGxhsze12CpViLntoFfHqSEPSwXUKriICGHdCWJJ7jKGfTHxEbadMNdyuXFsQPNuq5umYCKC0Ar6lg9+qDX0V5i0cuSnCMWO5teGNAgbPQh6R5odBR2Pn9vGtbSNyoBX5CZCLKOihxbttd8Wf+6X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=hvx9/2A8; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="hvx9/2A8"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id DDF178860F;
	Fri, 19 Apr 2024 07:02:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1713502962;
	bh=/7K16+lFmr4GqBnQeBVfOAuaKd9QSck1GMug9WoFvSw=;
	h=From:To:Cc:Subject:Date:From;
	b=hvx9/2A8C66P7Ncj6RgdVN2zrwlZvYezmUNYIy9IIrbIFJAbMnbIZoDz+toUyofWe
	 CM8gEv6pWbQVu7mmiIvIaHVy91BtdOFRD7j6ublgWaGsiLnYArlH9EA16MqtLQwi8K
	 AFa6Ku7UhlUE5G8SeJD2CdoHMRBm3cXkdwsZO+MQjFX0Xz4UshAmuAOnBz3HpXaH4U
	 JQGgDLVPkORbskbWgvZZhUMLFqN8pR0pijJdZmDYgO5o+o37i0XG2v0Bsml85zXU8C
	 v8XxQ9hmp1u6Nyx48Zv5vFb3NF5TFbqXZ2GU/8OvnBbA28Df2nvVO50HLN+lsk4kVV
	 YNK8TJWNJtbwA==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 1/3] hwrng: stm32 - use logical OR in conditional
Date: Fri, 19 Apr 2024 07:01:12 +0200
Message-ID: <20240419050201.181041-1-marex@denx.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

The conditional is used to check whether err is non-zero OR whether
reg variable is non-zero after clearing bits from it. This should be
done using logical OR, not bitwise OR, fix it.

Fixes: 6b85a7e141cb ("hwrng: stm32 - implement STM32MP13x support")
Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: kernel@dh-electronics.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 379bc245c5202..1cc61ef8ee54c 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -353,7 +353,7 @@ static int stm32_rng_init(struct hwrng *rng)
 	err = readl_relaxed_poll_timeout_atomic(priv->base + RNG_SR, reg,
 						reg & RNG_SR_DRDY,
 						10, 100000);
-	if (err | (reg & ~RNG_SR_DRDY)) {
+	if (err || (reg & ~RNG_SR_DRDY)) {
 		clk_disable_unprepare(priv->clk);
 		dev_err((struct device *)priv->rng.priv,
 			"%s: timeout:%x SR: %x!\n", __func__, err, reg);
-- 
2.43.0

