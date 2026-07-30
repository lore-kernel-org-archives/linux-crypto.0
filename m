Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84948474269
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 23:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453367; cv=none; b=hFtzsT8QXeRxY3RDEVjFd7TXPuZ+KbhpxyBWQTA/EQzc809FkUh8wD+vB0mJByv2B2NGmgO16ddtuUIJDPmiZa0js8j1bOAzJzAp/dZus0p9txZ4BTZOFiALZDLYYfdx303zDVQxFEHoGjPGh4AipcEkC8QNgJfohSyezioVB/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453367; c=relaxed/simple;
	bh=k46R8NV4nzCJkUeBxInNMx2ShBB/ei4eKa4a7/1hpYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tX2FhG6YxtmS0YzCbyPKe1F5HbWjoLzIYpJJpOaE5npX2m8mCB1Jztkg2CuJGYTfFlvU255VGepMi7RBCC99hqB9AkRDLv1wgNAnzIHrH+ehgGdvEz9B/6W9e93DtDYwze3TSjBuGdaNtkLHdQUquK6L/PGZXBXpVF8X3b9P8uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0zx2bNU; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0zx2bNU"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ced3386430so3182145ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 16:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785453366; x=1786058166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sscADE7cqna/tqNzcv4rEvOR2epXbUMsFulPTJ1FF2o=;
        b=Q0zx2bNURV+ODh1eMxsy400+uVCqcHyY4PuMgrXw0VFn8nr61yXL0VMbOP2A0ti90G
         dzSkO3k3YyTR3OeHlvthOY4KWZwY7wl1U6KTk/pCoS14crYvihHBI6id3O1yAt+Jau7+
         86CYI9sqoTu8g3j4F/iOkz/sC6aH4IPAd+6GyWwMzo8d9dGxkHdJVizhNbnbKXxL9V4e
         UzQ3OdxOh7RbLVYSbxIwAnqiXXtUDxIv127fd/SgfUpxO3q15xmeOKLTKim/IwHMWK7O
         ktyQvAMouSBQOe0Ey+sn/QkKH4HgKPU+FSM1c0I+wNRP55g6P5rnb2EgcOVZxEZ6mrM4
         X/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785453366; x=1786058166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sscADE7cqna/tqNzcv4rEvOR2epXbUMsFulPTJ1FF2o=;
        b=mHtIhOVmq4q/Vax30YDrWJpF+L88jtJ9Nh1F8popMOkZjXrpE9zsxbdNCc2fV6iBzz
         NXYUQs1JFnNVwHezZNk74+FKB+Bvgo2Qx9Ygr5H0XulSVK17Udv092mQgJeOvzsshbSj
         1+arBkCCiVPFiCVOahgMG6MLbmWXvti4sIVsw5/JtVjAD0kwpEqWqYOm5JAUIltpUD4Y
         uGDK+Frp4+H5Tyh0BSVfVo2XQj+acqr4SCUI5q6a3EGq5J3AOvhumr/fUQA5GP94zbv+
         SFewjmKxh8vLrEP3iHql2skzdzRa3Wcdrfk+WswNpLobR7BAh/8U7yEFqdcP/kigDgVU
         Rclg==
X-Gm-Message-State: AOJu0YxkmII67vV4nLsHwsoCwe6nsb2AgeIwWHiNDuYR9OWHzJTkD6Ss
	DJPVe8sQ6UOrY4PaulfPZuwHADFPmpOAivvHHbuqCt2HSFHgG6bTAZRiIXVUKA==
X-Gm-Gg: AR+sD11FClCn40Z1yVGU8whfl1hOHeREB3EXloXU1XXds5WIVTzFfsseoerkmPh42F3
	IWeODyVQS5lskJjCqFHd5B7N+7RUgq7f9WGkiE80gXfqDYjFcr4oDIVQTYX+shbjxFhz17naNap
	m24yqxqlmoayBOyjxkti476xeX/zxtrgOBoxDnCBbH6Z5qrK4KzoKIHyy8G+LcBxdFdRRkB8/qY
	pZuHxzt48j9CF9GrXnxHQNNq/Qr3vquk5OsfArQwSVJoqtuM18kyzJ7mnGjScfyocYU43wTci2G
	+165K/vsg7XF2jOJeszWysow0vqqe3yAPAo8YhoVo8L9xbqEqb9shfJ8OgYX9GBq7QyGE6pgAsz
	Pfe8YH1WqgEvFHF8NcWla1h8vusvVYnH8vlPDef8YQk1Bymt+BaPMTPs5fyLblZlUWU+o8IXS14
	pgYjt60+ZVL1vvEOHZRNqPMPka0wev4NdFtNy+78RjmO/xnm0Kh5PaZggoi17tmlJXJZzvVd2Nw
	xIzGV47ZglN0uCSGC4BeNWXTb0W5gnUFa7tVFQRGoeEyXIobGCtTWMqH4VrtY+mWFgp66zt4+Ri
	w3NlXAYAiNzpvw2rtRYdPaToKkN2Y1FV/qQdJw==
X-Received: by 2002:a17:903:28e:b0:2c8:1c05:16aa with SMTP id d9443c01a7336-2d035be9bb3mr41081165ad.19.1785453365759;
        Thu, 30 Jul 2026 16:16:05 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c55a7dsm32517265ad.84.2026.07.30.16.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 16:16:04 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: caam/jr: fix use-after-free in interrupt handler teardown
Date: Thu, 30 Jul 2026 16:16:03 -0700
Message-ID: <20260730231603.1169539-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

caam_jr_shutdown() currently calls tasklet_kill() without freeing the
IRQ first, creating a window where the interrupt handler can fire and
schedule the tasklet after it has been killed.  Move from
devm_request_irq() to request_irq()/free_irq() so that the IRQ is
explicitly freed in caam_jr_shutdown() before the tasklet is killed.

As part of this change, pass jrp directly as the dev_id cookie to
request_irq() instead of the device pointer.  This lets the interrupt
handler obtain jrp directly from the cookie, eliminating the
dev_get_drvdata() call in the hot path.

Two related fixes:
- Use jrp->dev instead of the now-undefined dev local in the handler's
  error path.
- Set jrpriv->dev before calling caam_jr_init() so that jrp->dev is
  valid before the IRQ is registered and the handler can run.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/caam/jr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index bddeaaaca487..b577c6a2e4aa 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -173,6 +173,7 @@ static int caam_jr_shutdown(struct device *dev)
 
 	ret = caam_reset_hw_jr(dev);
 
+	free_irq(jrp->irq, jrp);
 	tasklet_kill(&jrp->irqtask);
 
 	return ret;
@@ -218,8 +219,7 @@ static void caam_jr_remove(struct platform_device *pdev)
 /* Main per-ring interrupt handler */
 static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 {
-	struct device *dev = st_dev;
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_drv_private_jr *jrp = st_dev;
 	u32 irqstate;
 
 	/*
@@ -236,7 +236,7 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 	 * restart the queue (and fix code).
 	 */
 	if (irqstate & JRINT_JR_ERROR) {
-		dev_err(dev, "job ring error: irqstate: %08x\n", irqstate);
+		dev_err(jrp->dev, "job ring error: irqstate: %08x\n", irqstate);
 		BUG();
 	}
 
@@ -563,8 +563,8 @@ static int caam_jr_init(struct device *dev)
 		     (unsigned long)&jrp->tasklet_params);
 
 	/* Connect job ring interrupt handler. */
-	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
-				 dev_name(dev), dev);
+	error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
+				 dev_name(dev), jrp);
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
@@ -658,12 +658,12 @@ static int caam_jr_probe(struct platform_device *pdev)
 	if (error)
 		return error;
 
+	jrpriv->dev = jrdev;
+
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
 	if (error)
 		return error;
-
-	jrpriv->dev = jrdev;
 	spin_lock(&driver_data.jr_alloc_lock);
 	list_add_tail(&jrpriv->list_node, &driver_data.jr_list);
 	spin_unlock(&driver_data.jr_alloc_lock);
-- 
2.55.0

