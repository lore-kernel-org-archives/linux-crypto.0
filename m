Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A82BE655;
	Fri,  2 Oct 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790951793; cv=none; b=OWXFVTP0cRxU9T7Iec0dDUQWPwNg88uSmND0uGPEgTwWdryDimE4ybYKQUyB45GlgRZanhwr6QIMaBqxNmLVcVQLjf/FBh5LnrCVIvooBj4MI0TZ8uVh/wTF9wr8lRck6/9mHZ3KXK6zropc8dWvmjo1b5j3MCB4jOOMiFfJxZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790951793; c=relaxed/simple;
	bh=slpYjfvppyIYCvee4mbPKEgF5KZtNosKvyE5AxWLmic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N0rE3c6bUEoI47285u+Ulked8xQjYoD1lBcjU0I0qcSCv8bPHlRr1lgmwUCVDAwcFuL+duuKMUOsIonjY/yJbJjmlKvjMZ0y9ox/6IaW9YXN7emk3vniTpct80NM9pwTnCwcVjKp4o27aA6OguaR1pxl80JiPAMTJptxFUsrS+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kc1hpE5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kc1hpE5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E959E1F000FF;
	Fri,  2 Oct 2026 14:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790951791;
	bh=YaXAl32+bJwu3Ubi8gzjduwO4aL0flsfqwPdvVWa9Kc=;
	h=From:To:Cc:Subject:Date;
	b=kc1hpE5AqE8Xj5dP3BGj9j9it+sPlQj6jilIyzY67TjShxNrN4rl30fvv013IJaT9
	 mKPB3v95kTB4r1MIv613BRAyghPLsW6HpMRbP2RjJnRI6kAohzwx3dDvAv6s61b/nC
	 tB8+hHgg6fN4jLgCMWHthvl4maCc4u5V6HvpR7NkmOOxGcEMvvikTqrv5LioAOXIYw
	 QV+DgtpQHRCdkJxqdPBkQL4HwgRKcPxNLJNj3DJNUTtv9FddYZHSnuNLE3RO2icNCk
	 kKJFgVAHGmkqQJz/du6zKww+Hc6WxvW5qG7p+aQDfrrNL7cdKgdU4ZAM0fqKK7+zjf
	 UvRYhUmAqAy/g==
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
Subject: [PATCH] hwrng: stm32 - drop redundant initializations
Date: Fri,  2 Oct 2026 16:35:53 +0200
Message-ID: <20261002143556.43214-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1465; i=blum@kernel.org; h=from:subject; bh=slpYjfvppyIYCvee4mbPKEgF5KZtNosKvyE5AxWLmic=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFn7D/owf9lk7Cno7JfuESMu8/PI270a6mrOc8vnT5/89 kzoxxlyHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjARLU1Ghofq92Qk28/deKOk OJ3ts3cuv/qav7n6V5dsdJmzkeG36UyG/w5Za1ZdKns+QcviBBdL2iXuW8FrCyamTDcXbcy/oJ8 4ixMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The variables are reassigned before their initial values are read - drop
the redundant initializations.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index f5bfe54c01dc..d3fc910f674a 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -156,7 +156,7 @@ static int stm32_rng_conceal_seed_error_cond_reset(struct stm32_rng_private *pri
  */
 static int stm32_rng_conceal_seed_error_sw_reset(struct stm32_rng_private *priv)
 {
-	unsigned int i = 0;
+	unsigned int i;
 	u32 sr = readl_relaxed(priv->base + RNG_SR);
 
 	writel_relaxed(sr & ~RNG_SR_SEIS, priv->base + RNG_SR);
@@ -187,7 +187,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct stm32_rng_private *priv = container_of(rng, struct stm32_rng_private, rng);
 	unsigned int i = 0;
-	int retval = 0, err = 0;
+	int retval, err;
 	u32 sr;
 
 	retval = pm_runtime_resume_and_get(priv->dev);
@@ -264,7 +264,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
 {
 	struct stm32_rng_private *priv =
 	    container_of(rng, struct stm32_rng_private, rng);
-	unsigned long clock_rate = 0;
+	unsigned long clock_rate;
 	uint clock_div = 0;
 
 	clock_rate = clk_get_rate(priv->clk_bulk[0].clk);
