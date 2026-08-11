Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035D306765
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 04:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786423198; cv=none; b=aClT/fc8h6VUSicrJoidgHLmOgBoiahDDDUK1UekbVxEPS6R+x+c2dRjh9CsFKXIk+/9xAlAy0kujkhxa9FUzNJI4i9h/R100aD88HbywYuzIlBQE0R69LykqepgOqsNd/H8l2lytk9MVb2ikI1nGfRcmE0ijmnuqONYCCG72Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786423198; c=relaxed/simple;
	bh=dVnC8L0/sSxN9C4zfBd3149vpmTDHVJRvq0RsDP37fc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P8eW/YcvgJ2aVrh7rvEmkpMc1eSxBk1eibXbJuAh86V+PQV1+aeHZvsdPWSqTF5rt9G9qh/Cat91g+BJyuZJQXvfWd7wlbI0mDlBuy+uchfa4t7w+kPQS/5Yf1G/vgvOt2ozBtmQyrylqCM4TxNf9PvlhPAn9KnkorWq2mYqeus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQdMPGRg; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQdMPGRg"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-936623c6dd3so34532185a.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 21:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786423196; x=1787027996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8btNxdr/sEbsixqeO0kHXxTmMEi//7b7qBEAg0b5Zi4=;
        b=JQdMPGRg8eyH/m4+3yF2ZElbVzmxWKcxwAJUb/sLmfMBZkTl+NoTN6UVW2gdvGTV9F
         VzIhoFEefA1n22+/UU8M19M3vwklhpYY/XJwnYpZH11/Ssh0BFT2lzY0SjFXm0DFDIoh
         wLC5B8Dgk4YqtMMobMgnBHQ9NnLxcki9AOIyT/st1dV7z902HLmPsAUCmcdQXDujPTKv
         MtJdqJ1Yf0D24qGarpPJIVjCitT6A8zdB1EKdtcH41jlew9BSzhYZZZ17k+1CLPSRhen
         G4gWybhUeNbdJf9RMhlBI/tH36DBLo8Y+4NAzXwH7Mi6KQnSeXrO52ZSaBJj7McyDxj1
         NR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786423196; x=1787027996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8btNxdr/sEbsixqeO0kHXxTmMEi//7b7qBEAg0b5Zi4=;
        b=f5u5oT7ru5XzBWt18R3Sz3wEJIxjAc4mUQ0JCuYOZz3+ZoOp2GHaDhl35EJqr6Vnsc
         1IdeRrLNelUtEz2No3M9yPbL3tH2aFPodXRNasz6ihTZyvWvwDSgzspDltETsdlygiDe
         mpckomLoXq5dsjXnRcNhRU6moyAPXOk1b8zE3xInBSH1oPnfMu6uOm9nu9UmeEsc5mkU
         n9MQxbHt8QqYSAidA5gEqYODrUG391cgPgwy4i6JMCtvKYjMUH5hP8pfRMiGB/lCZv4P
         NIuRD0/K75qrDNzQB6L9VLx6BALzZ82NjXAOBEXDuGSC+OjU+VE/6ONPbQjrqWc3V42p
         BasA==
X-Gm-Message-State: AOJu0YwNoY0f+LhHYp16CvBCzDk4CV1HTzhnDdqa1bpogrRjmGynDEX1
	MaBDZJgRSXTvWTLAuS2TE9YXQXMmqk/sm0aA8rCL50TofzhSIaxJRYDtcUIKuQ==
X-Gm-Gg: AR+sD12QDyd9hwK+UFQLC24Q7+UzwO40FXnaR+zmrdJLpKeKILnBbpy7U0caHXN58QW
	M8nXsiktLiypZygUnElk/rhkVaXNhCeUcenP0w6YrBpWBBUb8Ss9Z0ktgg6ADkhPO+fGR7pGTIe
	YRP6jqnANjWLkI0lyN+wJrLU94Qo1UuqNXuQTNEy6gcZfBp3h6dJHTPEnZ5+Ut4/gSkDz5+TMID
	xv4ep7CTHbxqcDSu3PtXWZukvaIikD7onB+jYH7ZZuxVFELyGK7PlpTV0Xse5wl52ap2fM90vJX
	RQr4eoFi9AKP2TUTrDfYfKepw+0rZGGBYMrAcZwuu9gsW6CKmtBuM76YTW6Q0b4qcjU188lnL1Z
	Ua/ZDVrabCXwEJKVvukO/F+SqRGD7D2tY8mBXXWq0pXBqAruWb6qBECqqf8cKIjyDQWV1b49pPR
	l+iM+NO4mCnYeSL7Pc5joJSceY3oG2XLvNXNvJJYKSv3JPSTYf8IoiuGbM+5HkI6uZ2DIPv+7RC
	UNbdC8Uvl+96pbCTLe13ADqn3p8LPOeAiRr69DxwIoATJI1IU13T5Q5RLYNHinbvFTiVPn1RAfV
	0VZGy9YEsMHa5txL2gkzm/n0lzWwN1FALXnr6Q==
X-Received: by 2002:a05:620a:890a:b0:918:7e9e:de74 with SMTP id af79cd13be357-936a944b1bfmr20788685a.17.1786423196168;
        Mon, 10 Aug 2026 21:39:56 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936a848fc8fsm32826685a.13.2026.08.10.21.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 21:39:55 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: talitos: pass talitos_private to irq handlers
Date: Mon, 10 Aug 2026 21:39:53 -0700
Message-ID: <20260811043953.150589-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The irq handlers only need priv, which they can get from the
dev_get_drvdata() they currently perform on the struct device passed
as data. Pass priv directly as the irq handler data and drop the
dev_get_drvdata() call, while deriving dev from priv->dev where
still needed.

Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/talitos.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index fa96b6bf17e3..89e00581ebb7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -751,8 +751,7 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 #define DEF_TALITOS1_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
 static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
 {									       \
-	struct device *dev = data;					       \
-	struct talitos_private *priv = dev_get_drvdata(dev);		       \
+	struct talitos_private *priv = data;				       \
 	u32 isr, isr_lo;						       \
 	unsigned long flags;						       \
 									       \
@@ -765,7 +764,7 @@ static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
 									       \
 	if (unlikely(isr & ch_err_mask || isr_lo & TALITOS1_IMR_LO_INIT)) {    \
 		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
+		talitos_error(priv->dev, isr & ch_err_mask, isr_lo);	       \
 	}								       \
 	else {								       \
 		if (likely(isr & ch_done_mask)) {			       \
@@ -786,8 +785,7 @@ DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
 #define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
 static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
 {									       \
-	struct device *dev = data;					       \
-	struct talitos_private *priv = dev_get_drvdata(dev);		       \
+	struct talitos_private *priv = data;				       \
 	u32 isr, isr_lo;						       \
 	unsigned long flags;						       \
 									       \
@@ -800,7 +798,7 @@ static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
 									       \
 	if (unlikely(isr & ch_err_mask || isr_lo)) {			       \
 		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
+		talitos_error(priv->dev, isr & ch_err_mask, isr_lo);	       \
 	}								       \
 	else {								       \
 		if (likely(isr & ch_done_mask)) {			       \
@@ -3361,7 +3359,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
-				  dev_driver_string(dev), dev);
+				  dev_driver_string(dev), priv);
 		goto primary_out;
 	}
 
@@ -3372,18 +3370,18 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	/* get the primary irq line */
 	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
-				  dev_driver_string(dev), dev);
+				  dev_driver_string(dev), priv);
 		goto primary_out;
 	}
 
 	err = request_irq(priv->irq[0], talitos2_interrupt_ch0_2, 0,
-			  dev_driver_string(dev), dev);
+			  dev_driver_string(dev), priv);
 	if (err)
 		goto primary_out;
 
 	/* get the secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
-			  dev_driver_string(dev), dev);
+			  dev_driver_string(dev), priv);
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
 		priv->irq[1] = 0;
-- 
2.55.0

