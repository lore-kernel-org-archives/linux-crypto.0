Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794382372;
	b=OwP5UUj4IrG2wES2llm4EG8v3pOvo95wwui4zT9xDgwkXz4ruCIjuh46S2GK5WjYZa3d
	 LHBigldYIaVINhebnMNH4LcN+992TFTJqv9SLyEQsNV67NTmynVYzwN7r5PsJeccM2gNN
	 hHzz7G5kbDTcufDRmjtlNNTvOmIBdKM8GJHRVrJW1KG519Sq2R788LhR/ZIoDcAQ7lPXa
	 /KfQOsWzTeN2LwqCgTC2PJLHLcljkGmhFFjGVP2Vqu1rYrQkrg9VpPfiwsMos++rsBKoe
	 KE98dVJ58z9bofPF87pvDR+vG3XjJtMYgx5zhA4Y9gakMfEPXMYGPj6EnYrXxEyQuMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794382372;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jhQtOuk8zHkM7reWLtWObyZkmP6dpOPJpNjyxPj5gEA=;
	b=o3GndzrOuGt2a+isLM+sIoDl1fr5U2UNDG0wHQLjLHywOpoz3Og20xhR00lxlHHC5qFD
	 ULjIVxeAAJ3dbhJsW3ASaa9Al5uuAKK9G1ypYvRQbojkfHR1knA1byB/h6U0Qr9DCMRli
	 gHeyth8VUCDcQlDD1Z7FGysLWrLpc05rsotkJtQkWbhatyyeVQZOhSHkQ/+EC7IgFfBhH
	 9P06u1LLSaX9/BfcEKJnValsvyi3lYP/MxwdA2LdxMEg+y7RDcep5Zqc5VpbbpcPdW0Q9
	 ds4HDOFylA/Z8HmdYsz6XD19AGgqGax2ybDPRDzU95JMka+we24WMz3ZVP9ltv0vjXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b="f/lN//iC";
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFEB606A327;
	Wed, 11 Nov 2026 07:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDFEB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=f/lN//iC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=f/lN//iCEJ0y4+w8q87XPCCZ+yqt1GpSzx+RMOz/BUIYVsud2SOxI3NOAMSKcfxO2WoFrTApIJ4kO
	 BcVJoWBIwAY5hDpPNKucjD+f3Uhj9Yfp0wMedmF99tsyEnNO0LzoXEngjftbdbPGMueR6mbRAAFFuo
	 yKBn3uX6rriQRVAM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86af41a1fae6-75c62;
	Wed, 11 Nov 2026 15:32:47 +0800 (CST)
X-RM-TRANSID:2ee86af41a1fae6-75c62
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHB-W5100250 (unknown[36.137.216.21])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86af41a18137-d31a3;
	Wed, 11 Nov 2026 15:32:47 +0800 (CST)
X-RM-TRANSID:2ee86af41a18137-d31a3
From: Gu Bin <gubin@cmss.chinamobile.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: mtk - use pm_runtime_resume_and_get() in mtk_rng_read()
Date: Wed, 11 Nov 2026 15:32:35 +0800
Message-ID: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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
2.50.1.windows.1



