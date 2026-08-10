Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799532236F0
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389364; cv=none; b=XYKSUFhfOB/ID4KmXTHB+pH+z9enude+J599nKUY+KH0FlxIGh+45KsjElKVobsWC2n34c9gUcLPHcIQqVq5wJPwA+VyY7l7BMQ41QsoXNwa1b9YFc16Q/ECADOhA56KCk0dAW7M5ZUnNR58WQ/5gzdfVE/AZlwgZkhBbSheE3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389364; c=relaxed/simple;
	bh=wa3wcmgR67O7D2nH+2tIr3RTM6Xp4NvE1JJxCL6fcVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yva/LdvTdHL0tL5N60HrvNEzzt21WdalsL8XmPFq3kNx+UF7Yxg0t1dIoZFypsuo0Cz8z3XthV321CDxnLEvmWIwhJ30DtW1aPYsSMnNYGVWMNF0xmj7m+3dsbXOCKQkccTQ6l+lnj+5f472xIq2iuZcpbbNaS6M+0myYdHwCww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbNqATp/; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbNqATp/"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92f03daaa97so113448485a.2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 12:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786389362; x=1786994162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hDOQVlhgAUfRXwfnBXThUQBtwQznzJjmgAE87hgHb3I=;
        b=UbNqATp/u2x4vA6GJoEJHcqUZZQsiXYcmiN/ELrWx+4eJugWWo61tlI1SACesUqG9V
         rIKbONdIlIPncluoopApuUvMb8ysMQzCWP3rsn11fZT6RApBgpPwL8OP4wHKoUkpaPu8
         9kF+KMPtp3+q063/uRXodEHRMt3oCJeYC4/Qbl3zwL26G9iXsHDP1djP0ucBxWDh57YC
         52JVpnFiO+to9uwAIHz1ed4DaEQugktryV/1mISE+T2HtNTbR9Jvnq/cEMxc54lAlvOU
         ZdXXer/66AcP9NkuxGLbDiLAJMstUdxz9f8l/xHN95di0nZZ6TIkvKU2dcAoDPyB840I
         HBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786389362; x=1786994162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hDOQVlhgAUfRXwfnBXThUQBtwQznzJjmgAE87hgHb3I=;
        b=WLFOC+9LNnTpnIEEEMAJwTgWMsrPmjSfvizd2lCE4Gnh9LTWDCf7hHzSUjB1AOhDZJ
         Ec6cbNmMaW/b6kIowzjXyM3XQQ8RtFewc6mn6i8JopKLvN7dz8lGzMCDhN8pnsEQ7YUZ
         /gEhGFGmA7Ei7BPmBjMVIc3bm9p0JDnd6XQCc66ab0VMwYPQL4wPLG8gPKu7rG8zawpD
         lXAcWIjh1B6q5iwT2mn3D8OqmnctIv+jFmGJZYbLozj8v880E/k9Yl9EEXuz2Y47wgY/
         x2GztwJxBy1NYz+efNkrfLPhWUdfMxcmR5aJl77Zz18/sQVcnMq+5LeNKrCSOAmetpcK
         4Shw==
X-Gm-Message-State: AOJu0YzDtOv+yI0lRx7UzwQ4zhPoRVPt6lo1ZqvV4jo8my1aGdHxGI9n
	++U6NCcX+YAQhh6ySteSoRPjzX/WGKZPhIlQwXhe7ss39y83BJS7Pviiw9i/Dg==
X-Gm-Gg: AR+sD12PUlcOxapbBLKRAOdcwzrEuXxbS2PtyFPT9hd1TvCBPSa+11vBjm5Gyj/TVlO
	a8aWqe02k4x7NbzTNQflsi5cWj7dFOtrfJYdBqwPI1N7+OeMEw9ZppY4FjBTqOBvnoWwJh6DxN1
	KJ+oZuuJiWWGmYgay75geXGqu58NhlKbGSQpeCUOzbIhTtbMmSXkhuyCYIeJoxTSFL9tvDAlCP6
	ULMIeN8iEcl1h8Bnda2Um+/GWieNhigmu5Rk+p0MoQFXuFKk3OtdqiL/jppfTT9ooPgecl90129
	dlkRFzUN8X9D/hUKOtZJ4QtklyM2jsXDWgc/xML4EcH40xxMQuJUEoxPbKKgfLSURJThIKYVfKv
	JJLHwop6O5K78LcQb2FTQHWH9Zv6UJhYOV54mvKVWA+Ntppfw1eIPBuyUBVffdaNjPlfgg2gjHF
	cB9K5HrmJhNGWXwc84vEd2LH9K+7/WnxRFklAco5eSV3XOjndJe8lvYvDJG0QPwfSy/T7wGqWDf
	o/AenIW2vKoUZzFJMJCukOARPnWKUodgxoBrLJIBcQAUEkan/fzMLabGeDJ7MTlb+ULYxannMDD
	51nIWn8qLhbgUP/h5sSQB2Va5usGpeWet8zeUdPgQuIny0FhzQ==
X-Received: by 2002:a05:620a:630d:10b0:930:84d0:fd3b with SMTP id af79cd13be357-9369cfecc70mr412974785a.7.1786389362158;
        Mon, 10 Aug 2026 12:16:02 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e03f05bsm855095085a.2.2026.08.10.12.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 12:16:01 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: amcc: get irq and ioremap resource first
Date: Mon, 10 Aug 2026 12:15:59 -0700
Message-ID: <20260810191559.21977-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These functions can return -EPROBE_DEFER and require no special setup
other than the platform_device which is already provided.

Avoids doing extra work when not needed.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2; remove now dead error check.
 drivers/crypto/amcc/crypto4xx_core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index e13b49c22570..af2613c6e3c8 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1209,9 +1209,19 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev;
 	struct device_node *np;
+	void __iomem *ce_base;
+	int irq;
 	u32 pvr;
 	bool is_revb = true;
 
+	irq = platform_get_irq(ofdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ce_base = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(ce_base))
+		return PTR_ERR(ce_base);
+
 	np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto");
 	if (np) {
 		mtdcri(SDR0, PPC460EX_SDR0_SRST,
@@ -1254,9 +1264,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (!core_dev->dev)
 		return -ENOMEM;
 
-	core_dev->dev->ce_base = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(core_dev->dev->ce_base))
-		return PTR_ERR(core_dev->dev->ce_base);
+	core_dev->dev->ce_base = ce_base;
 
 	/*
 	 * Older version of 460EX/GT have a hardware bug.
@@ -1294,11 +1302,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		     (unsigned long) dev);
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
-	core_dev->irq = platform_get_irq(ofdev, 0);
-	if (core_dev->irq < 0) {
-		rc = core_dev->irq;
-		goto err_tasklet;
-	}
+	core_dev->irq = irq;
 	rc = request_irq(core_dev->irq,
 			 is_revb ? crypto4xx_ce_interrupt_handler_revb :
 				   crypto4xx_ce_interrupt_handler,
-- 
2.55.0

