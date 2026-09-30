Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0EE3D9531;
	Wed, 30 Sep 2026 20:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790798570; cv=none; b=l70Q+FWREjCcoeujq970vzgngQkF7YyIVNbxAMVX/QRJvgD1Y30/J4jZ3W+GN36KHz2qveH7fN8fwRdHzgkLA4dL73gn3t98QHAMCjjofy5adRqvXgTiKNrY1WuWUZ3YXjS+ua9nggPcEq0LCHrE++Rk1s+gcbdphAp99/Z4Jvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790798570; c=relaxed/simple;
	bh=c5EukF6uv7WBeTnyxLkrBVOXpfaPrFhrhf+C51kSo1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hvC36Pfig6l6Avww40tV9MBRwCBU+bbo20oeSnRZoEf6BJvWbR+Fw9kD+DmTk1wN84d/8IV4fWL/RJtBKglnP27NNN0UbBnGAWmcZdv9iuF0XAVDvulcimM7Xxd3ICJPc+0OrbirkB8JQ4zQwQ6la51Olh7g3PsCez5KICpg9bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQ6qmLGj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQ6qmLGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567F81F000FF;
	Wed, 30 Sep 2026 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790798569;
	bh=mJ92uyiRl9sbWq53QxHyZ8I7YErr63tZMa+NZnLTBv4=;
	h=From:To:Cc:Subject:Date;
	b=nQ6qmLGjrdv1HXc0VWPjaqiEfBA5A1RSO0oD858mhxn0hQHS1ZAhl1Dj8A6mlE4N0
	 2Ymb2uT2mwxqTZI1XOFWtWxikjqt5QNvk2G2OELOMEMwWl0WQ0iKFpAQFClycDtKTO
	 kjMKf1+1nKeEorBi76nbY/ov+t9V9s1dwqezvGMIX+ZdZv2HSDoEIjSTFMK9RvUzxL
	 lbNyCqPWOPrWPs+k+iNQ+ci3wveoqOwicJUXUPJhyunzAxE3PaVSpiVKhUav9uwT74
	 GXa2okFvXtrt8tI4gn7n/adxx1R+TgDB4BPj1CbI8iq2LOeMVtbaZ3FSMcxVRYoBH/
	 es0/476eT+xyw==
From: Thorsten Blum <blum@kernel.org>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - drop redundant initializations
Date: Wed, 30 Sep 2026 22:01:41 +0200
Message-ID: <20260930200139.110437-4-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1374; i=blum@kernel.org; h=from:subject; bh=c5EukF6uv7WBeTnyxLkrBVOXpfaPrFhrhf+C51kSo1o=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl7sxbnuj0L7f3AKPH2T4nTR//d1qGLOVw1VnR89WZKE O8KeXqqo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACYiHM/I8N7sEbdzlbqWjt6H 18tbpl/qu5P7gSlDhNF8TTCDapHfZkaGGRdFU6XdmW9bbDqlUeTPksr1OWV5TY4s07kTloe3nVj KAAA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The variables are reassigned before their initial values are read - drop
the redundant initializations.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 51290ea345c3..829b9b86dc96 100644
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
