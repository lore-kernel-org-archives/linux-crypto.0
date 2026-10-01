Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53693A6F10;
	Thu,  1 Oct 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867198; cv=none; b=DFzFV3r+ROqnOIA+qg4uFyYcF8Sv4C0JVzMC6zM+PUl0kOpaY8riPI+I9BqA3IGObdOgglAJmRqDqf19p27XOIm+4B+qzsDE53t/VJ9x8ABDc/4PUBhKMYrnQkZZWAuBywlAiVxTcg1rAJs3A5djNy1Y6egGa7rjx1+R3632T84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867198; c=relaxed/simple;
	bh=6tnpaxSYCnecmkR2q7Y2SX+ha2jZJ9VAu4sMFH6bceM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EvW/Y68e5+gZ7XWvpzc6cs6mk6dZu3TNK6RU3BHwNu1XieqI7Dne1Y5VXuQweA2OVTwz8Q+33hpEqeeY775vD0zl5ybJngJRZOggPUXxAGMJFbGIaWhV4J4+x1qR02sm66h6VT8GWFhIp33tmPeD347jXKMC35+SCQP82hjOaFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ajkguinj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ajkguinj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AB01F00898;
	Thu,  1 Oct 2026 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790867197;
	bh=bqQFgH+WBxsZQmR/PwdeROrCNijo0oLTzM8iyufxI7k=;
	h=From:To:Cc:Subject:Date;
	b=Ajkguinj54ZGtZlDRxO77k1F85GAUj6PLxkWsWocBkMPxrH+fRhCelfgAmFPFqbO7
	 TP3RYOtDpmNJveHZGIWSxsy1+H86zftp5ZgV0IZdcTlgmYDvB66vAhBe9nhX4pD6z9
	 TUENRi9vxigH4AX6nV9PTpFzhkjCn0+u0vc5L3AsVq0DJRNBvhG3chRaCK50CpIuLy
	 UQRV3azz7n9W5alTsKd0KUwzy7t4RvZyDlcvNiKeh/+hoX+3jtzV+i0TLF1aKf5EeP
	 hz9HngvIBtXcOcP1Tl7QnGsO6+mUUtHO0uCw/lbdKfnqgV09c4LzFVMy4dr8j/tn+8
	 Q2kCu5YDXBKwg==
From: Thorsten Blum <blum@kernel.org>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] hwrng: cctrng - drop redundant initializations
Date: Thu,  1 Oct 2026 17:06:04 +0200
Message-ID: <20261001150603.143696-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2024; i=blum@kernel.org; h=from:subject; bh=6tnpaxSYCnecmkR2q7Y2SX+ha2jZJ9VAu4sMFH6bceM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFn7ym7XbKm28fZbpC7r0nfe00I+ibGgXPPsXrWfsvcZn 5d8izjRUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABP59prhf9r6N4aBuznVN126 M39p72HxOSfP+Me4n/T5nFI4c9OiVzwM/7SqO5t2bXQ5fljb8YvtEvfnaU6x4Z2sTmWSEcJcu5U 28wAA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The variables are reassigned before their initial values are read - drop
the redundant initializations.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
Changes in v2:
- Missed two redundant initializations
- v1: https://lore.kernel.org/r/20260930200139.110437-4-blum@kernel.org/
---
 drivers/char/hw_random/cctrng.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 51290ea345c3..be35f058f37a 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -91,7 +91,7 @@ static int cc_trng_pm_get(struct device *dev)
 
 static void cc_trng_pm_put_suspend(struct device *dev)
 {
-	int rc = 0;
+	int rc;
 
 	rc = pm_runtime_put_autosuspend(dev);
 	if (rc)
@@ -208,7 +208,7 @@ static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	struct cctrng_drvdata *drvdata = (struct cctrng_drvdata *)rng->priv;
 	struct device *dev = &(drvdata->pdev->dev);
 	u32 *buf = (u32 *)drvdata->circ.buf;
-	size_t copied = 0;
+	size_t copied;
 	size_t cnt_w;
 	size_t size;
 	size_t left;
@@ -268,7 +268,7 @@ static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 static void cc_trng_hw_trigger(struct cctrng_drvdata *drvdata)
 {
-	u32 tmp_smpl_cnt = 0;
+	u32 tmp_smpl_cnt;
 	struct device *dev = &(drvdata->pdev->dev);
 
 	dev_dbg(dev, "cctrng hw trigger.\n");
@@ -309,8 +309,8 @@ static void cc_trng_hw_trigger(struct cctrng_drvdata *drvdata)
 
 static void cc_trng_compwork_handler(struct work_struct *w)
 {
-	u32 isr = 0;
-	u32 ehr_valid = 0;
+	u32 isr;
+	u32 ehr_valid;
 	struct cctrng_drvdata *drvdata =
 			container_of(w, struct cctrng_drvdata, compwork);
 	struct device *dev = &(drvdata->pdev->dev);
@@ -453,7 +453,7 @@ static int cctrng_probe(struct platform_device *pdev)
 {
 	struct cctrng_drvdata *drvdata;
 	struct device *dev = &pdev->dev;
-	int rc = 0;
+	int rc;
 	u32 val;
 	int irq;
 
