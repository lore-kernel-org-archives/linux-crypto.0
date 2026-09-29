Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71047C0F0;
	Tue, 29 Sep 2026 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717971; cv=none; b=GfwK/T2vaeS9Grt7ZtTfMbNcx8nsBGXEvrA7LPPa467zelAlImvXHNQOC7k8rsg7AGUm5h6v8wCtbdPw3J7W/Q1XMTNDjtw1b3pJ9QO3OlDWI2DsRBA9X4jYkzcoi7j2IrvlOVHNKTOGFpxKe02WvcYZaCuv/RpAsoTCe8QRRYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717971; c=relaxed/simple;
	bh=3rcAUys/sxfu6RZEzaJsDobT9wbVC6AePxK7n/KkZG4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S0zrAnHRlj/6GyS6suJ9PZVpSdCxQ+ADUOfN2rP+vJ1VbsQoAwua6nfSq/HUYzYll1QbeRWp2A6OlL9a5RjPmVBKIo+Vxz1aCVOGlwNY0kP6F30CvupxIEXqReayW6ri4KZ/lJO0kSXuz/wywuoXMHhaiOwHj6GQlVcouGqctwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B05jVogI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B05jVogI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509D01F000FF;
	Tue, 29 Sep 2026 21:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717970;
	bh=iMx8HlLpT41Aijq5Ei7QZP47cZW2EVlhOZ9kuaWFBQo=;
	h=From:To:Cc:Subject:Date;
	b=B05jVogInhfRIXWsxxYUeUJSzofHlwV6HCI+RTgMWfCOuvIteCL6C3eZDTuqwp3xj
	 yiGw06JJX08zBdkrXUIvBgGSEMWMJFIg1YUdTy2X55rs2rVYNScnytW6h/PIlxvqO3
	 d7kOXkqOab5l1dfBbJJV3xfNJrdk9biJ5m9I10S8b+/3RjVgFhAOljx1SD4fU1ok8G
	 B3vlwyW4tEWkK/t06bIjinB32JnnWGcmnIq/v7DDW3zBpgs7HC7GKFfsf1Y6P6yIWl
	 uVPDmAstjjEVNNFtSp1/0ZzoYHDExG7cmEVl5mLPSK9x632GKOaGgIFF6KDRlvikMO
	 nssuwV62x2dWw==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thorsten Blum <blum@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: atmel - use HZ_PER_MHZ in atmel_trng_init()
Date: Tue, 29 Sep 2026 23:37:50 +0200
Message-ID: <20260929213751.103658-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1340; i=blum@kernel.org; h=from:subject; bh=3rcAUys/sxfu6RZEzaJsDobT9wbVC6AePxK7n/KkZG4=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl79Nebb+q7uYk9vrIu5dLhcBkuZ/lv3erb7za/eeguY vv96vOQjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIyE6Gfwa5hXPyP0pVsWav z7m3KNy9e23EtWkr3Y91BLBzc2gX9DIynFnPejRAbUrwti8J3+omqJ/7HLGrU63GtGpLpttDv3P 53AA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Combine and inline the rate check to simplify the code. Drop the local
rate variable and use HZ_PER_MHZ instead of the hard-coded frequency.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/atmel-rng.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 06e79d516743..fe444196e6b3 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -17,6 +17,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/units.h>
 
 #define TRNG_CR		0x00
 #define TRNG_MR		0x04
@@ -85,20 +86,14 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 
 static int atmel_trng_init(struct atmel_trng *trng)
 {
-	unsigned long rate;
 	int ret;
 
 	ret = clk_prepare_enable(trng->clk);
 	if (ret)
 		return ret;
 
-	if (trng->has_half_rate) {
-		rate = clk_get_rate(trng->clk);
-
-		/* if peripheral clk is above 100MHz, set HALFR */
-		if (rate > 100000000)
-			writel(TRNG_HALFR, trng->base + TRNG_MR);
-	}
+	if (trng->has_half_rate && clk_get_rate(trng->clk) > 100 * HZ_PER_MHZ)
+		writel(TRNG_HALFR, trng->base + TRNG_MR);
 
 	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
 
