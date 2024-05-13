Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72C580BE3;
	Mon, 13 May 2024 22:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715637853; cv=none; b=CMGBK7T+tV062ilMCzoqLhBgTcnKoDcyMye7hbVtAumlCtwnhFIc1EFytYypfju3ItMCmDNYBozqRVV38QyH0mTWORIZbEI/Opzh5YPja/GD1JBBxGuiA/2e9Z6RiBpKJZJJwpo0SdL5SBFdXGD3z4o+7ExEri3MnxEJLDe0bW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715637853; c=relaxed/simple;
	bh=+5NnhdTqGLgbqRt65aGcxQilFEyt2d+vF5jyJsqWz/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zi5SofWGkCpv9M3Yzskgfol3WQ8KgOGmtDaH+oIdv2WjrmPiQJa4p3y+2t+o3aRMqt2SqZix7X97LMAIhuLBolHDnADGw2KskKoMY0YqxVznVxFizNHrA8uJ5jk9PZ0qu0D+ii6DONjyNxq0zPSbbqvVlpqbaHcwYptO4SJw+D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=omC4OWUq; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="omC4OWUq"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id F1DE587CDA;
	Tue, 14 May 2024 00:04:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1715637848;
	bh=r7aGBuMKfnpQF7IqQKDwqXemymokbgzAAMpCCmuF0v4=;
	h=From:To:Cc:Subject:Date:From;
	b=omC4OWUq8OW0Fh1BIO1BB1rG7Ghaa5THWYgXgUqQO7sCYWq6+bfVn2BQKECj49yi0
	 y7496Llpj0770i2+ShOVs/CoPgq0+WxeaOmreOE9A3OaL7T7AiEwwQcGPDbomY0ji9
	 RZ+3scgUBYT3DkxpPLpgct9L/dBUnRMpimL72GnNwEyrb/U669A7tf9jnhLC8eBCdN
	 ItFO3LYUyRnSRY8ORmC8qxUzqQ/vay6UpYB1z2B0gfWhwziXYSMKLhWMvH547zMN1y
	 u2qSQ9o0D6aMgXDTcDO3VuJOmaTVRzu85iCScEol2s7SJ4oaX16oWWJzkGRHDrc8U0
	 vBdZ/XDsOKuzQ==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-clk@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH] [RFC] clk: stm32mp1: Keep RNG1 clock always running
Date: Tue, 14 May 2024 00:02:28 +0200
Message-ID: <20240513220349.183568-1-marex@denx.de>
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

In case of STM32MP15xC/F SoC, in case the RNG1 is enabled in DT, the RNG1
clock are managed by the driver. The RNG1 clock are toggled off on entry
to suspend and back on on resume. For reason thus far unknown (could this
be some chip issue?), when the system goes through repeated suspend/resume
cycles, the system eventually hangs after a few such cycles.

This can be reproduced with CONFIG_PM_DEBUG 'pm_test' this way:
"
echo core > /sys/power/pm_test
while true ; do
    echo mem > /sys/power/state
    sleep 2 ;
done
"
The system locks up after about a minute and if WDT is active, resets.

If the RNG1 clock are kept enabled across suspend/resume, either using
this change, or by keeping the clock enabled in RNG driver suspend/resume
callbacks, the system does not lock up.

NOTE: This patch is a workaround. It would be good to know why does this
      change make the hang go away, whether this is a chip issue or some
      other problem ?

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
---
 drivers/char/hw_random/stm32-rng.c | 2 ++
 drivers/clk/stm32/clk-stm32mp1.c   | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 7d0de8ab5e7f5..ec0314f05ff3e 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -403,6 +403,7 @@ static int __maybe_unused stm32_rng_suspend(struct device *dev)
 
 	writel_relaxed(priv->pm_conf.cr, priv->base + RNG_CR);
 
+	// Keeping the clock enabled across suspend/resume helps too
 	clk_disable_unprepare(priv->clk);
 
 	return 0;
@@ -434,6 +435,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 	int err;
 	u32 reg;
 
+	// Keeping the clock enabled across suspend/resume helps too
 	err = clk_prepare_enable(priv->clk);
 	if (err)
 		return err;
diff --git a/drivers/clk/stm32/clk-stm32mp1.c b/drivers/clk/stm32/clk-stm32mp1.c
index 7e2337297402a..1a6e853d935fa 100644
--- a/drivers/clk/stm32/clk-stm32mp1.c
+++ b/drivers/clk/stm32/clk-stm32mp1.c
@@ -2000,7 +2000,7 @@ static const struct clock_config stm32mp1_clock_cfg[] = {
 	KCLK(SDMMC3_K, "sdmmc3_k", sdmmc3_src, 0, G_SDMMC3, M_SDMMC3),
 	KCLK(FMC_K, "fmc_k", fmc_src, 0, G_FMC, M_FMC),
 	KCLK(QSPI_K, "qspi_k", qspi_src, 0, G_QSPI, M_QSPI),
-	KCLK(RNG1_K, "rng1_k", rng_src, 0, G_RNG1, M_RNG1),
+	KCLK(RNG1_K, "rng1_k", rng_src, CLK_IS_CRITICAL, G_RNG1, M_RNG1),
 	KCLK(RNG2_K, "rng2_k", rng_src, 0, G_RNG2, M_RNG2),
 	KCLK(USBPHY_K, "usbphy_k", usbphy_src, 0, G_USBPHY, M_USBPHY),
 	KCLK(STGEN_K, "stgen_k", stgen_src, CLK_IS_CRITICAL, G_STGEN, M_STGEN),
-- 
2.43.0

