Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D611E346AF1
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 23:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032285; cv=none; b=X5BNV2J7cGj9s0y0JZkFyQgHYPvmX1C7d9laJ6F3vwdIRjhgjSK8FpdJ9LiKyrGtlKBwf4hIXgc8eb/RgFOBKfYhiv9zh2mzQiTq9ptQQeb2hpx2915VAZjABZQYZh9FwGs0WuxGcOPty6kZzg7ra19TFjj5NdJA+7+anjWT6HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032285; c=relaxed/simple;
	bh=6NP/wTedvUKno+6UvFa0hyzd8LxjMbCVzqb8GNwpXiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mDSSyYSI7kOhWX62AYXZU8ikbhUwHXIZYty6FY25LSSWSXt4d1t20YysyWb08o6mcvkqLgwgtTIaQcYNF/k76KwhV0tBhBCdj0mf0/aEjV5tM8WI7zQuaryMLAv4dRmqk4w797qpaJLUazuk8ERWUyFWXuG9RNhyGbZmoNLfQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9EOFdXN; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9EOFdXN"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd4f99cso3845878a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 16:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790032283; x=1790637083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TV5O2OyI6mATpQhVZegfkIlJOsJB/H0eSLCm/N9OKew=;
        b=h9EOFdXNBMSXgJlhEA1LGzKuGvw4MBcD7yzb6z/m459DbIn/RpX6kSTsmwCxBrKYiJ
         IigMFZKqsAgmj4obwZRulWtoNCOSsOVKvojRLQ7duHNGHXw+IJU/clPRFMqzG40BUdwU
         nsjB0QRVUfDLhKyaZCE8FptCxzLayILmoZEUhKBnB+tKCrF1V0k/L9FDkaFZ9xidTnCW
         GNeic50+TwazGsmZNT34JcR5G4C06uXchoNjnLmnfWwZ7i92UIQyD3vMSx2z0sHo+Wv7
         JPO90xfYI1ou79cnoZ+2QLNMgxG5my7uUTMaeMyGKoE2Dcy/+dRh3f4kfVY3+jDTjVYP
         ZEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790032283; x=1790637083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TV5O2OyI6mATpQhVZegfkIlJOsJB/H0eSLCm/N9OKew=;
        b=GfPmpYOFaUwanYHMjOE6iYP627Mi+r1AjSqDe0Ni02533o0tmGfSCfL0HfxKBY4HG6
         izQgDY4+zQAHsvwc3Z1fbES80hNhzt2bKnhbhru6BzSj2rvOddY3bwiLlJBe8LvJiGA1
         7qMVD3qHT/HtYLSFSJ5j2HM8R0owr760MOXWGGbHuPN0ovtttH2qzGwUdGlqBYULMCgR
         IzkxFIr7PjdTSZidOL9M2Mo7nld+GeW83LEKrBVvY2nJSwU3HI0VcvSF25Z4jTrwvRfd
         KrfVbMOooNCVku7ZZJs5OGy3cVShCHcm5IDOvWNgDwL5BaQh6FuEScQtjCh/5fAXKikV
         +WaQ==
X-Gm-Message-State: AFuF++mlCfTYKxxePEsaGk6DYS2N+QV51jZyohSFYnYOPtxP0ndf1Ji3
	k/qXwpB160PAzvzOJHdIpjoJRdOdTaM5mPxBOTpnW9AyNsbSef48JM2dr66pSA==
X-Gm-Gg: AYBFou1LL61dNmwpVL/xfSc89pgFnl6wON/qv5p5Ns0aN0MaDTcRl2/rkFSp+xSrysf
	CHWDbsGLsYtBZhINuiS4becdJvG+14CVOKskqJ3BHpHIMmXK/WyOAkhM128mZ/RJnaZaayQVcwt
	P86Wp0Q7eoVBkdwVTFcnfoq3gBw4gzTI25bZYyQWjE8GEV4FwuyUE2Ciwr8KoSfFlKG95eCE2Bz
	2dh0+5akh9mQ2vEGYCSjMuFfJ4pi4t96jVTR4IridY8n1iKT9K/OtFRhXFb/emfd7wLHcKjlOg3
	J3eUvVutof4l8zvig6ZFAEq0Y97OHYDBDRQwAUaz3802jvdpUXE+4oDhLfnQOqUao+CQP6FERxP
	eXkK491itk2fYFZuQnw17EovkhXrinml0OTg/R/LP4PHQMF+h1yQjIPFwSk/C3MhChp+Tygk7iK
	e3nYG4Z595KR4cX82OroXQo2fsZHyPurkjD9ke4VlxKu6Vq2QANKLRqRogbN16Z1S571W68WD63
	/lHNkto+oft7h2BulMiZDsPIW7S2YGOA3aAFa8qDr7VUBxazEzM1M8VeyGYAvQr6aek34XZLE0v
	bS64Cm3sEXpCQKUnb8UIbzN3RFP9xvgkiDtpFP4QxItk4mx7
X-Received: by 2002:a17:90b:2d10:b0:39e:24ab:9fb0 with SMTP id 98e67ed59e1d1-39e54cc6fe0mr18328991a91.6.1790032283084;
        Mon, 21 Sep 2026 16:11:23 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a069a0de1asm832670a91.17.2026.09.21.16.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 16:11:22 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: eip93 - fix IRQ teardown ordering in remove path
Date: Mon, 21 Sep 2026 16:11:21 -0700
Message-ID: <20260921231121.63342-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the devm-managed threaded IRQ with request_irq() so free_irq()
can run in eip93_cleanup() instead of after the remove callback has
returned. Register the IRQ only after tasklet_init() and the ring
locks are set up, so the handler can never schedule an uninitialized
tasklet.

The original probe requested the IRQ before eip93_desc_init() and
tasklet_init(), and eip93_cleanup() killed the tasklet before masking
the device interrupts. An IRQ arriving in either window could schedule
a tasklet that was not yet initialized or had already been killed.

Reorder eip93_cleanup() to:
  1. mask and clear the device interrupts
  2. free_irq(), which synchronizes and removes the handler
  3. tasklet_kill(), which drains anything scheduled before the mask

The tasklet re-enables the EIP93_INT_RDR_THRESH interrupt as its last
action once the result ring is drained, so mask the device interrupts a
second time after tasklet_kill() to keep the hardware quiet while it is
powered off.

The driver implements ONESHOT semantics itself: the hardirq handler
masks the interrupt source before scheduling the tasklet. Use
request_irq() so the line is unmasked for the tasklet and the
IRQF_ONESHOT WARN_ON_ONCE is avoided.

Add an err_free_tasklet path in probe so a request_irq() failure
releases the tasklet and descriptor resources instead of leaking them.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: extra clear/disable in _remove.
 .../crypto/inside-secure/eip93/eip93-main.c   | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index e62785952b0d..cc504590fd0f 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -395,9 +395,21 @@ static int eip93_desc_init(struct eip93_device *eip93)
 
 static void eip93_cleanup(struct eip93_device *eip93)
 {
+	/* Stop HW from asserting IRQ first */
+	eip93_irq_clear(eip93, EIP93_INT_ALL);
+	eip93_irq_disable(eip93, EIP93_INT_ALL);
+
+	/* Synchronize and unregister the IRQ handler */
+	free_irq(eip93->irq, eip93);
+
+	/* Drain any tasklet scheduled before the IRQ was disabled */
 	tasklet_kill(&eip93->ring->done_task);
 
-	/* Clear/ack all interrupts before disable all */
+	/*
+	 * The tasklet re-enables the RDR interrupt when it drains the
+	 * result ring, so mask the device interrupts again before the
+	 * hardware is switched off.
+	 */
 	eip93_irq_clear(eip93, EIP93_INT_ALL);
 	eip93_irq_disable(eip93, EIP93_INT_ALL);
 
@@ -430,12 +442,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	if (eip93->irq < 0)
 		return eip93->irq;
 
-	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
-					NULL, IRQF_ONESHOT,
-					dev_name(eip93->dev), eip93);
-	if (ret)
-		return ret;
-
 	ret = eip93_desc_init(eip93);
 	if (ret)
 		return ret;
@@ -448,6 +454,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	spin_lock_init(&eip93->ring->idr_lock);
 	idr_init(&eip93->ring->crypto_async_idr);
 
+	ret = request_irq(eip93->irq, eip93_irq_handler, 0,
+			  dev_name(eip93->dev), eip93);
+	if (ret)
+		goto err_free_tasklet;
+
 	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
 
 	eip93_initialize(eip93, algo_flags);
@@ -472,6 +483,12 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 		 readl(eip93->base + EIP93_REG_PE_OPTION_0));
 
 	return 0;
+
+err_free_tasklet:
+	idr_destroy(&eip93->ring->crypto_async_idr);
+	tasklet_kill(&eip93->ring->done_task);
+	eip93_desc_free(eip93);
+	return ret;
 }
 
 static void eip93_crypto_remove(struct platform_device *pdev)
-- 
2.55.0

