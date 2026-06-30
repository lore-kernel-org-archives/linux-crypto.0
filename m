Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590C26F293
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jun 2026 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814754; cv=none; b=NXtpNZNyOFAutis0MxRKAOOTOJz4uHYH/QNOzKzvRdHFNxM9EaEM6JpcSAKpKR9E8iMdqFgRlGrzCuzDGTdogKX3/X8XFEUbocbFxEfc46Hu55XcbUSJc3OpkNh86a0YK6Zw8rB/VpIROZhtnNZqyjU0j/drvTUw772/6FwQl8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814754; c=relaxed/simple;
	bh=pcsuBUJx09l9FL78SknJ7UiH2glyj5fmomEjAfqDvVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YTvc6fg0mppt/Y+LeOust/9Q+Gw/YjBxNGgFsuh4E4UOTiN6Y7mwMNYXBmvhtaR7d+rm4WlDyIP5Ijl/33kLR/Cc47FwO45M3L79yoiPCO6AodJJolgfG1hzJHb8ctq2eXQOOgsstAe9McoTdHtP8LQIFPXxADce6rj1d9FXtv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rhl39RgS; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rhl39RgS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782814748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MlMb5zPXUX4woYeZVRLy6YT/2hgcV3iro1eZZxfNI+g=;
	b=rhl39RgSg7lnKmjtlU7vzEKfDxvQCc7L4CnzS+L91cymc3+Ul0+kX9JPYE4BNSJuTzC0C8
	gbq33AYKCso2rWzDIOxxKN+0a1aNWwGMLqB2IWAJhkkZuWMi4ANxiPkdpH/geU3rCIB9Nf
	UfUN9vqMXeshqgO+2S6pceSO+cWNjTE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] hwrng: atmel - drop __maybe_unused from atmel_trng_pm_ops
Date: Tue, 30 Jun 2026 12:18:01 +0200
Message-ID: <20260630101801.684164-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=971; i=thorsten.blum@linux.dev; h=from:subject; bh=pcsuBUJx09l9FL78SknJ7UiH2glyj5fmomEjAfqDvVI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnO0286xHYWsGryv5ixuGbjt21P/506ZMWRts79Zmyn6 dK7OmfVOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAibUcZGZry4lq3MfxJcbnK 4C9uGrraaXnenNtXXlvU/WWbUvzRxoWRYb5iyWuN8FNLmK+cnjorI6rQ3SWi8eKCo1dOZSp8O6u ZywIA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since atmel_trng_driver keeps atmel_trng_pm_ops referenced and pm_ptr()
uses IS_ENABLED(), which allows the compiler to optimize away unused
variables, drop the redundant __maybe_unused annotation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/char/hw_random/atmel-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 6ed24be3481d..10082add0886 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -186,7 +186,7 @@ static int __maybe_unused atmel_trng_runtime_resume(struct device *dev)
 	return atmel_trng_init(trng);
 }
 
-static const struct dev_pm_ops __maybe_unused atmel_trng_pm_ops = {
+static const struct dev_pm_ops atmel_trng_pm_ops = {
 	SET_RUNTIME_PM_OPS(atmel_trng_runtime_suspend,
 			   atmel_trng_runtime_resume, NULL)
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
