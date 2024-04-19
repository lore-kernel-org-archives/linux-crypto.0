Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A1C8E0
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 05:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713502971; cv=none; b=R0qMBA7Uqu+zKjMrkKSylihaKTIMCTsHtjMTAvlvPal0pysDtHq6Km5Iwv+I5tOQGUncx2hgRTUHX3Wc7/3sW4m/V5F1JTvZHUvmA485FLPqyvzsFo9b8ZY5OdC3/8aurSqWGNaKmY5nLBDlFKIQh4f/QLOSdO9GIF2cyRYxipk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713502971; c=relaxed/simple;
	bh=oan5PPb1t3y2wgUTzxTuDPSnnBJ4N78UHsWl6AGbH3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVNwJcyUsedY4VSACm5KsMOYWc92uNFvjFaAVQneDAD+6rWlPYBRoRrjevut3O8FLxjaLWcb2tIJN+OcIPqQY6O7KlblYDNCziQSZ0PF6jCKtSWYWMY+1w3vjAM4SINO3HU9omiemfrvOYtS2uNY84E4T7qKv1noLfLNmaPGvro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CDwI4y4W; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CDwI4y4W"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id A605188634;
	Fri, 19 Apr 2024 07:02:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1713502964;
	bh=dXiSdXuRjgL9KxkWcT7+OJC9xqL1AyLvonePWQeFAz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDwI4y4WQ8MRkNLq1r4HmvBgudfM7QIfWjRCXzTTHTRZ22gnQuIFcdpXPmSOX3mKH
	 yOj0a/3g7Y1gedU6xv5aI45aqLrhGNGlfHzw4ALQBQxpqz3Nf+ZGxraQdlg55FoEh5
	 4q8pbaL9ssohq8GKX00afZT8Fvnp4qQ7fo1VyWXi2T7GHCVcoN6TPzLMUO2xXvoEyN
	 37wLFdsOmfHwe2NwAgp3k41l9RuOgYx0JU9tPWyaAwpvbU3u/tfgfzcVBQW8lywDvg
	 lSdM4ab8j2cnfnEuAcwoY84063hKC4ltcLux/AbMWMZtH0IfYd1d8fzL8JMftCByWf
	 O+M0eFcNXjPZg==
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
Subject: [PATCH 3/3] hwrng: stm32 - repair clock handling
Date: Fri, 19 Apr 2024 07:01:14 +0200
Message-ID: <20240419050201.181041-3-marex@denx.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240419050201.181041-1-marex@denx.de>
References: <20240419050201.181041-1-marex@denx.de>
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

The clock management in this driver does not seem to be correct. The
struct hwrng .init callback enables the clock, but there is no matching
.cleanup callback to disable the clock. The clock get disabled as some
later point by runtime PM suspend callback.

Furthermore, both runtime PM and sleep suspend callbacks access registers
first and disable clock which are used for register access second. If the
IP is already in RPM suspend and the system enters sleep state, the sleep
callback will attempt to access registers while the register clock are
already disabled. This bug has been fixed once before already in commit
9bae54942b13 ("hwrng: stm32 - fix pm_suspend issue"), and regressed in
commit ff4e46104f2e ("hwrng: stm32 - rework power management sequences") .

Fix this slightly differently, disable register clock at the end of .init
callback, this way the IP is disabled after .init. On every access to the
IP, which really is only stm32_rng_read(), do pm_runtime_get_sync() which
is already done in stm32_rng_read() to bring the IP from RPM suspend, and
pm_runtime_mark_last_busy()/pm_runtime_put_sync_autosuspend() to put it
back into RPM suspend.

Change sleep suspend/resume callbacks to enable and disable register clock
around register access, as those cannot use the RPM suspend/resume callbacks
due to slightly different initialization in those sleep callbacks. This way,
the register access should always be performed with clock surely enabled.

Fixes: ff4e46104f2e ("hwrng: stm32 - rework power management sequences")
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
 drivers/char/hw_random/stm32-rng.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index b6182f86d8a4b..0e903d6e22e30 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -363,6 +363,8 @@ static int stm32_rng_init(struct hwrng *rng)
 		return -EINVAL;
 	}
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
@@ -387,6 +389,11 @@ static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
 static int __maybe_unused stm32_rng_suspend(struct device *dev)
 {
 	struct stm32_rng_private *priv = dev_get_drvdata(dev);
+	int err;
+
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
 
 	if (priv->data->has_cond_reset) {
 		priv->pm_conf.nscr = readl_relaxed(priv->base + RNG_NSCR);
@@ -468,6 +475,8 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 		writel_relaxed(reg, priv->base + RNG_CR);
 	}
 
+	clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
-- 
2.43.0

