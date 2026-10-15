Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D976D4E13EA
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 09:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056004; cv=none; b=kKmLlPPAeafZVdpJiauGcmL030x8cTpque4zHMtRZZx8X8AGCaBSUWY6NQpfK9dZdrjWlTPtjJARQ2AhSly8nxNSYhFn1WZyu4lt7kmtefrayL5zA1X/8wZWUaiztoiH3Vo2Rxdr0vFBMRLpuTDrlXTiukZ+8xNvYY5jXOoul6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056004; c=relaxed/simple;
	bh=GE94iwYk0n2AbTKeoxmILt0nZTTm7tiI7vLGLi74RQM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pr8qss+AThBQGnRMowePYrPIBhIHll2TN24tHVNp0AYVxi72l2B2qOGEYOsaUC7buLtvvBrDA4myg3pG+I17Q+mjm6X3UgYfQLAyTW7WO+/b0wZBBi4k8tzeHVoLQNS0JsB7vWw6qSyAhNFfSXGWKXHWNyodyWieQaDa+BJT3OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XCi9ruH9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XCi9ruH9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	Cc:To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=UQ7P2je2Gs3vP6BL1AxH/HTG3IbVK2Y0ffYoKH93Ydo=; b=XCi9r
	uH9JufMedhMQxDl3yUAaCaR3zpwkwboUhamygQyG85aLw9sNunXiQGzZexUXE0pZC0y3DlvEnx8DF
	2uPs3CRH/LFvKaYnyd3IqXVktk9/d7rclRn/PAT/0+0lyLkuAkLYpVTMwfqJSJ/DwYDUyV+xGuxVP
	KXnc3u8mPu8NeLoOkYDlpVt5XKCqqr8ulBmfFfqBk8sQWxwruW0LPEoKvpdxKpWfC+vOmzvjAebn0
	cR8IdG7eKSj8u0Il/BNcmBApXpBEBWKlZdPuXLp0v31N2QP8igEkqGiEHXQHjLgUKKaGm9YH3N+kI
	dt6vEfJ6adUYzPcySp5G3kNNzO+gQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHHcx-0000000474C-49hz;
	Thu, 15 Oct 2026 17:19:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:19:55 +1100
Date: Thu, 15 Oct 2026 20:19:55 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Brian Norris <briannorris@chromium.org>
Subject: [RESEND PATCH] hwrng: cctrng - Discard pm_runtime_put_autosuspend()
 return value
Message-ID: <atCau3kHbzUefyMA@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Brian Norris <briannorris@chromium.org>

Printing an error message on pm_runtime_put_autosuspend() returning a
non-zero value is not particularly useful.

Returning an error code from pm_runtime_put_autosuspend() merely means
that it has not queued up a timer or work item to check whether or not
the device can be suspended and there are many perfectly valid
situations in which that can happen, like after writing "on" to the
device's runtime PM "control" attribute in sysfs for one example.

Accordingly, update cc_trng_pm_put_suspend() to simply discard the
return value of pm_runtime_put_autosuspend().

This will facilitate a planned change of the
pm_runtime_put_autosuspend() return type to void in the future, similar
to commit 3afd8df02433 ("PM: runtime: Change pm_runtime_put() return
type to void").

Signed-off-by: Brian Norris <briannorris@chromium.org>

 drivers/char/hw_random/cctrng.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a6925211c3b5..7e1e1a7844b0 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -96,11 +96,7 @@ static int cc_trng_pm_get(struct device *dev)
 
 static void cc_trng_pm_put_suspend(struct device *dev)
 {
-	int rc = 0;
-
-	rc = pm_runtime_put_autosuspend(dev);
-	if (rc)
-		dev_err(dev, "pm_runtime_put_autosuspend returned %x\n", rc);
+	pm_runtime_put_autosuspend(dev);
 }
 
 static int cc_trng_pm_init(struct cctrng_drvdata *drvdata)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
