Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794388035;
	b=1ub1/slktKukoaOpqY+F5xYtfjbnsrXk1CkkjQ1zNM5jNz8uoaljQ8okIN01jtAtjoC+
	 3oUBRHWd3S00fJSdGTsCRBcyUsKjWpaRGV05Vqp0e/Fq+yxbWnVBVA7hMx77bkt2j2Tas
	 1v30Tonh6Mu+W8X/VZ+il1sm+RXmC8/2pIYV7SSi6sv+3dGDdnhY8NsrQlcJkX9x4592Q
	 npVfbNHAPZYJqNIzHRsAJGu49EkFOo/t+DtDp15UJ8Kq3fI2qsRbAETZypHt6dEHDEiUo
	 4SxnC7bqcGd6E0DyDT8+hOOBylBW38rVMyCh0QwhLMNIgUCjw0D57mBTo3th0/YEIDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794388035;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zY5dQkELre1GS4SkxRkb95S2IVHHtMfAcsv7zPuOtlk=;
	b=OYThXobf/P3rJrkyZ5e6JSs+of5zcS72RxrjBh0TuaHGam0MTZNLciYshZyG0He/oHh8
	 Ws+r5YTvYa1vtvz8N6x9vlD4gEy37EzCP5phAqc1UzrUJ1IZTQxscg2Z+eIZn7Wmld7xG
	 X+pb7H3zKBLRwXj/qGWd6N82+Lh2ThJo3c223LhYW0lHO7g0/JVOkPa+C4l4OlgsZC44f
	 TnmGny8rMUBlZ2pfYlTXAEeJtopNCxiBvz7rG8NGryZGmsUa4kHEjIJvkOFPWfvkVUhC4
	 SfdNUM2+lgOWNTmPWx8iQ+DzuPVz/Klfz19+vq3qowCxk4S4ux3IuVvrukrX0HbLWyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=FNgNCbsz;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FAD606A32A;
	Wed, 11 Nov 2026 09:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88FAD606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=FNgNCbsz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=FNgNCbsz7HLqW9Vb87BoZ/1KcMEMA4K3vSd4gxtBpKKLH+K4Z/1V26y1/EBOjfdYtFToJaHwfCGcx
	 l+evLcvfIaIIQdFrP9V/R3MlSk+2LfvNec7u2baoNuDqgySH3wiE10+IVTWLf8NdFLiZdcF1dh0Gg4
	 ysQXlR20399Mg9zw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96af430416b2-dca56;
	Wed, 11 Nov 2026 17:07:13 +0800 (CST)
X-RM-TRANSID:2ee96af430416b2-dca56
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[36.137.216.21])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66af4303a7e7-d684d;
	Wed, 11 Nov 2026 17:07:13 +0800 (CST)
X-RM-TRANSID:2ee66af4303a7e7-d684d
From: Gu Bin <gubin@cmss.chinamobile.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] hwrng: mtk - use pm_runtime_resume_and_get() in mtk_rng_read()
Date: Wed, 11 Nov 2026 17:06:58 +0800
Message-ID: <20261111090704.1699-2-gubin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261111090704.1699-1-gubin@cmss.chinamobile.com>
References: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
 <20261111090704.1699-1-gubin@cmss.chinamobile.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mtk_rng_read() calls pm_runtime_get_sync() without checking the return
value and immediately starts polling and reading the RNG registers:
when resuming the device fails (negative return), the reads hit a
device that never resumed, and the failure is only surfaced indirectly
(if at all) through the -EIO fallback of the final return.

Use pm_runtime_resume_and_get() instead and bail out on the error: the
helper reports the resume failure and drops the usage counter reference
it took, which a failed pm_runtime_get_sync() leaves behind (the usage
counter is incremented before the resume attempt, so returning
directly after a failed get_sync() would leak the reference and the
device could never autosuspend again). The tail
pm_runtime_put_sync_autosuspend() must not be used for this bailout:
the device never resumed, so balancing the counter is all that is
needed. On success the helper returns 0, which is exactly what the
read counter expects at that point.

Fixes: 81d2b34508c6 ("hwrng: mtk - add runtime PM support")
Signed-off-by: Gu Bin <gubin@cmss.chinamobile.com>
---
 drivers/char/hw_random/mtk-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 127b82d979e8..1e8e458dab25 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -95,7 +95,9 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	struct mtk_rng *priv = to_mtk_rng(rng);
 	int retval = 0;
 
-	pm_runtime_get_sync(priv->dev);
+	retval = pm_runtime_resume_and_get(priv->dev);
+	if (retval < 0)
+		return retval;
 
 	while (max >= sizeof(u32)) {
 		if (!mtk_rng_wait_ready(rng, wait))
-- 
2.55.0.windows.3



