Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794382401;
	b=3bdF8NvKo1drqIeIl6b3FM3TVifkavVABRvc5a4hr629JIKYDbWRjjtqeniXeto+AZmk
	 aJ+9mJpz9ZNKDKayiAhPtORdwaT+wcissRZRz5hqNT67LPbys3s8SgTT7zNK4DgOtL/2z
	 3zua+X9hmLuaEQBqJtGmeYb0Yto6WDDG54YhN83cChfETx44a79lGdTdLK7QMh44ISYrj
	 EzpSyJifRgHBS0VW4Szalymve4WjTS6ZQoiC5Z1uA1tqeY9AizutBmoNj6HZJT1n7IBeT
	 5MUXnxeI8jSbEnzaZtHUR/IMxrZWKRpQcYmX57zeQrKN0PWEqRojK1rD61vtQZXBcQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794382401;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xPuEMk2jVLMWocEgImFvR0HynFT+4ICJTsRNbU2/7sM=;
	b=eNa9sUcH3s8shT1OJhUmvayo3UbRfdhQUFDBnIAU4D251KJyMu6UpuA6s7ef6Pv1w+kM
	 hcawgyXIM87fGf6YibAO2Od55QYVh81UPNX6Hy4lUBrtAqFWDWYHhlSkAUuv3RCd/qcSU
	 X5jACAC/1EKk2LEpK53Fjx9nEa6Nh0Zls5mOolSsSWUXZjkXbScQnQSMU9mFCwP5W2cUP
	 Cv9Rgk7Cr4B7XLjGsgCr2OJzWN+KwmgpzaJ4dFus8oU+D/PxurgO5dhxEgwxfiZdm6VIU
	 NL1/t4nqxM7ww9FdubdKQkfNAMqivlj38SgCatMvEz3ZAjYeYZaBY4CODZHbzp6EZJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=wOIJGMfG;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DDE2606A326;
	Wed, 11 Nov 2026 07:33:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DDE2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=wOIJGMfG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=wOIJGMfGoHUSnV2mIf7qwQyN0BT0JIjhByCqASAM1SHPNXk4tEExJ+vR+3923azzoCRuQJbvIIxuQ
	 pMBQbSCLHYY0/TAzKa60c88y/y8Jeo0dBTVBhWlLLRtKUujFLaCcl2Y0Q/tIYAJtn4TbUJopvzG7JM
	 6QqtNZJWmNkcwM/s=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96af41a3e028-db394;
	Wed, 11 Nov 2026 15:33:18 +0800 (CST)
X-RM-TRANSID:2ee96af41a3e028-db394
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHB-W5100250 (unknown[36.137.216.21])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56af41a370a2-d34e7;
	Wed, 11 Nov 2026 15:33:18 +0800 (CST)
X-RM-TRANSID:2ee56af41a370a2-d34e7
From: Gu Bin <gubin@cmss.chinamobile.com>
To: andrew@codeconstruct.com.au,
	avifishman70@gmail.com,
	tmaimon77@gmail.com,
	tali.perry1@gmail.com,
	herbert@gondor.apana.org.au
Cc: venture@google.com,
	yuenn@google.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: npcm - use pm_runtime_resume_and_get() in npcm_rng_read()
Date: Wed, 11 Nov 2026 15:33:08 +0800
Message-ID: <20261111073309.1659-1-gubin@cmss.chinamobile.com>
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

npcm_rng_read() calls pm_runtime_get_sync() without checking the return
value and then polls and reads the RNG registers: when resuming the
device fails (negative return), the loop reads a device that never
resumed and the failure is lost - the function returns the (zero) byte
count instead of an error.

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

Fixes: c98429297d8b ("hwrng: npcm - add NPCM RNG driver")
Signed-off-by: Gu Bin <gubin@cmss.chinamobile.com>
---
 drivers/char/hw_random/npcm-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index a85f745963be..67a35df3bf80 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -58,7 +58,9 @@ static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	int retval = 0;
 	int ready;
 
-	pm_runtime_get_sync(priv->dev);
+	retval = pm_runtime_resume_and_get(priv->dev);
+	if (retval < 0)
+		return retval;
 
 	while (max) {
 		if (wait) {
-- 
2.50.1.windows.1



