Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712E38F926
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 20:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788554436; cv=none; b=lGvBPWUz96R2kp8gxH+jj6Tq7TorOQdj66oPts3Y0qJFoHJwLzPKkytdAfaP65N07UDd7Z3zwjfHlzT5Dh9BWd5mOs8/KhH8N1T8G53529ABkXqw3ZzvKrinnazwjuTb0Y0r8Epq8O23giB5Dyf0TqnfMUZT3GJf1Ir22y+ttZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788554436; c=relaxed/simple;
	bh=Ht189HnxuW9/5kZPei1tU8ZN06U8E6CpummCXodBWJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=klKJOSfk/9UEMencFvZLYTP88AlRaJLgRaIImKSiiK2ydL3ut5p9SQZUYIiR4fts94KaWqvdYRGI1q4sYVfDe7LDgO+en2YEQyzoDxyxsiV3/YW5qDI3LQbS1oT0gGNAY6qpDRU5ndcFdRWcWll28K3W1VFHgcVaAbkt1M7HlaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUQyD+WA; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUQyD+WA"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso1852449a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2026 13:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788554431; x=1789159231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B7pP4ZoCtvrO0SLtDKQxVQKoo2XC7Dfze8y4P05m/Gw=;
        b=CUQyD+WANJtMEJoIp4RvUDxQFHwkf70TyAsgjQxrtfgeX9py6UNWrtYQY6S1eRozFO
         yOiU3/xi9tsFjCDpbVCSsY2Y6AIF2i9xaqlycrH0qnnuZR4KFiDhU/oJTSCGu3y9qBMe
         bSm7Rkt4jyKaJpIS2OYVh5xjYEjy/2uPoAbFv7EWMgJCkyfujNJLvO9RCEb4+pW3eWvi
         TUuRwIDvGlMuv9V59rOBC/wiKVgJbFNohqIivG8+njJLgNU8p+C6m4vj8LXOxHqr1mXZ
         SZTIc8BxorOda7hy1S7AcXbjY4p2retbchwoDErByubM88vtF4mT9LWUr4qNMjreCiDo
         ardg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788554431; x=1789159231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B7pP4ZoCtvrO0SLtDKQxVQKoo2XC7Dfze8y4P05m/Gw=;
        b=rfCA2aXM1eca+Eimv+wXU3jIx/zT4O4ZsiA/JJp33IvCYqRd/ggdC37i5zleQZftEx
         KnLGYna9ndPbqJvmHRNKvtP1rXbXF62Ky7WNA9xwubodjwHGhuMOkeFrpHZFIcF0uzPS
         dhlIMF1l9LuzvKhL+M7PO1TM+zK+6Ox4J43r3i3AtBeUy8rK6TU5w/TK1C94nU/XIdgJ
         JAgEV/ODYluSExLId9yOVfg+GfAp5E9Gq8Tr0+8WtQ1OUax4YpsxVTqypxQwKB2jC8fY
         UwaVNlyjZ1WQc0Mh45UBm6T/TPfPq1G5ieFq2UovgwT+ChNkwGUxH1RV5GQWygW1XEUX
         9oPQ==
X-Gm-Message-State: AFuF++kY8xZMgY4ZVShskWndBfaJJInk4N2PxxQSQZtxyTVGjYmDzorf
	m9vr0ezDMUAXr/eqlx/38qvpKLqJAqxShPbpl/d7r2RKYYbiWCTRU9uuxbD5Jw==
X-Gm-Gg: AYBFou1sT492n53XQYgSEBgitQAjR+IM80brxbT2lesZacJlJNLR6f+wXGLidE8f64s
	lHkS8HNKrHTeCJrdkhjQsbxEQ8VStLVUQJ0iRW2KHzo/pWw5mnYNhlIMIpbgs1G0LzJgIm41v6h
	hyAQBEQh+w4d4XOFbD32fZ5o2dCzhbpnwkgnaxfjMigONjS0mm2zLlEb4M+CEjIh10Ct+sGxDBv
	66xS849pfWxsYT5gq08JQw45KvE8l2uF/pCpX2pM4qNpG9u3icd2yxC/iEPj638s4O62r9cras0
	NHvdLUyD6I6hLWjLi4yhgDQ73V8ZglJsR3op9Fw8JB8wA7oHd7xeLjKNqnBrrmsqki+064tAw17
	hjora4YXmZTtSFi0/Auv4zzDcGpCZf4NIJvahhuZrXcbtL6uI91IE7TgEbaZTt2Dvm3lNhrg2oE
	1t/8Q22Gio2TKq7cNe2DtxKQOkdYHOZ5lqpIMw8MSLrYo6HXDu/cyYEbePT5YyP/hc7PwNHuUb2
	y/BnI4VsiQushogcbXSJAcuLrulVKF8hMVEmczG9Mm5VgBoD3s2D588vzNhetG/Pz0OnD2kb7uM
	+YCibMxAvUcMZF/G1p3y4XlG04ZFcuTNIIxvfw==
X-Received: by 2002:a17:90a:c106:b0:398:e1f4:bda1 with SMTP id 98e67ed59e1d1-39b2624cf3fmr13075002a91.21.1788554431089;
        Fri, 04 Sep 2026 13:40:31 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c397b1sm12081357a91.8.2026.09.04.13.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 13:40:30 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: talitos: pass talitos_private to irq handlers
Date: Fri,  4 Sep 2026 13:40:28 -0700
Message-ID: <20260904204028.56285-1-rosenp@gmail.com>
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
 v2: assign priv->dev
 drivers/crypto/talitos.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index fa96b6bf17e3..41a87d7c30a0 100644
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
@@ -3242,7 +3240,7 @@ static void talitos_remove(struct platform_device *ofdev)
 
 	for (i = 0; i < 2; i++)
 		if (priv->irq[i] > 0)
-			free_irq(priv->irq[i], dev);
+			free_irq(priv->irq[i], priv);
 
 	tasklet_kill(&priv->done_task[0]);
 	if (priv->irq[1] > 0)
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
@@ -3422,6 +3420,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	dev_set_drvdata(dev, priv);
 
+	priv->dev = dev;
 	priv->ofdev = ofdev;
 
 	spin_lock_init(&priv->reg_lock);
-- 
2.55.0

