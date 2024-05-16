Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7831D1E487
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 19:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715888302; cv=none; b=cbJO5h41kRRAOCYv04dm4+GtxikPQUBU+/BK/QxUPK9NLSZxCmxl7Nn7FPeHHgS6UzN8T/2yE1peJzeXSNRfVgkdVbCo17bOyx+RvPGSmNugi4mtvGYLW1WYV8oO+kmSpoqShrGFHucrpU9a4zf2AMLaumrwwtG/gD9bcd7XloY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715888302; c=relaxed/simple;
	bh=R2WYzFmKlrElnekTi7gNNE9f7TIw6wHPYb5acr/HXS0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=giqnIu+6QAJUWcZz2hGYmhkDbW5c3Jm1KjoZzz9yXiawaHDOzVwYR87DoM13cLCNJpCB2+dLc61MVdfivvp/dwlXsbYRayzGT4dUMOb6VEGywgL6/cPbN++KIjJj/vO8ESVQD6D1I43OQffhxkJzyHibOeKC1s0LKh4mxFqpwcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=fAhcsNkD; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="fAhcsNkD"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 36DFC883E7;
	Thu, 16 May 2024 21:38:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1715888298;
	bh=dh7Mqd4f++NHj/N+9IevrvNykG+N8Z8Ls872HqTQVvo=;
	h=From:To:Cc:Subject:Date:From;
	b=fAhcsNkDNlZMlACDyGaE206FqUSLIv183j3cMfyOcR2At6R6oKdRd0CUhb+Qno4aY
	 0HFBEM+N2Hz9hY/Vg8wmonkhCSZHx1hQM4POhGZq5hplreyrfg7qbcYOPHTsvL91Q2
	 PNdl5zlW/5VqsO8L73UhRPUAEJ3Pb/R2tGfHziDy9bDuEH7gtEKLP+Hz/JY0ym0cbd
	 nmjpavCxpa3vIlsnoNcGTKex/nnB1dmplv6NUtl+Lk2I1mS7L+BypFje/3h21vPCIZ
	 Zbtucmt2htK4inU9NmTqAY0G9ryPdasTliGzTZBxv94sraVGXaaUpa4oKgjdn+AKQj
	 41DIXw5VrLrIw==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v2 1/2] hwrng: stm32 - use pm_runtime_resume_and_get()
Date: Thu, 16 May 2024 21:37:40 +0200
Message-ID: <20240516193757.12458-1-marex@denx.de>
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

include/linux/pm_runtime.h pm_runtime_get_sync() description suggests to
... consider using pm_runtime_resume_and_get() instead of it, especially
if its return value is checked by the caller, as this is likely to result
in cleaner code.

This is indeed better, switch to pm_runtime_resume_and_get() which
correctly suspends the device again in case of failure. Also add error
checking into the RNG driver in case pm_runtime_resume_and_get() does
fail, which is currently not done, and it does detect sporadic -EACCES
error return after resume, which would otherwise lead to a hang due to
register access on un-resumed hardware. Now the read simply errors out
and the system does not hang.

Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: kernel@dh-electronics.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
---
V2: Add AB from Gatien
---
 drivers/char/hw_random/stm32-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 0e903d6e22e30..6dec4adc49853 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -187,7 +187,9 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	int retval = 0, err = 0;
 	u32 sr;
 
-	pm_runtime_get_sync((struct device *) priv->rng.priv);
+	retval = pm_runtime_resume_and_get((struct device *)priv->rng.priv);
+	if (retval)
+		return retval;
 
 	if (readl_relaxed(priv->base + RNG_SR) & RNG_SR_SEIS)
 		stm32_rng_conceal_seed_error(rng);
-- 
2.43.0

