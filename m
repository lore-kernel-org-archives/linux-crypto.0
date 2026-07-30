Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCBC3BED1E
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 20:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444561; cv=none; b=cGMvtau0raM0JZ6HrG4LlEoV/jiz5cI4BVUU32cYg+kazv2Fz0z55o4Fdlp5O9OAY3XPE918NdwlPgQiT8AfVkgP3DUbr7lJ08qnpqVmKP9f0iszGLKtPz+F3KRkoV6f7sAdq8M78J6Z6imipFs0dPVJBaEjNeByofCetDavC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444561; c=relaxed/simple;
	bh=KQjDx8OiIfwfzPDkx8703XvKPDz7tifMvyh1UpP5Wqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BgffnYsGhWcAerO8dTL+Fvhx8M/F/q2rsmtvZFZQ+vc9kGvjJp0mJ+uJMdmBpjI+Wqs7GhdIJgVeijZKlnrM1r7dN+ULgk3cR0H7BHsmHA5r7J6q8a0QyER8izlgUkNTKBCylujH7f0xZLIRX9q14AOYxS3C3JcjvY5T66eWqoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTGCtw7t; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTGCtw7t"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cacb8416a1so2646995ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 13:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785444558; x=1786049358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+ztttA4ibcaxOlaFxobuUDX/tAujvV4xkdOsxKr0lQ=;
        b=jTGCtw7tEAgY5HmB4KiPnrCuedn1tlwzMvyfiawk+uec1EuczngwIe6r0Ng/hVXBim
         N012siuQLVWaqeyo/kT1n9NEnNKoYZkSroFTvGsGWW7OF+NU0ZSwSYz/FmdB9+bQaJro
         Un7oa3yVhUS932wm4UiU2+nLkIjI1E55CCdOtxRANEojsp7Ikiq+ccxbCndQhfGzrzDj
         e4kUU9Wv1txpZQ8MpkPUxxaTFV34UOidvk54dyZgMzHpP6fcGx9B+UXBRItAt3yQ6R9h
         EK1DLN8GGqBOWzA1+kriTi+KyN3nMYV6FiDskR+1GE8hnAyhE0xu1tGBbs7pcGLgVBDM
         arow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785444558; x=1786049358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+ztttA4ibcaxOlaFxobuUDX/tAujvV4xkdOsxKr0lQ=;
        b=H38YEPfhX9lfd5nRdYccE/CBVNxztZbUogXGw/jWZOYfnAw2nrjtvLY6BoPAtGOODV
         KKNvYiWeVv/rsJeoqorMH8IpB5tQYflpxSu3MhBC+wSTfNewA4ArB8DS1nB7URhxcI4u
         EbkQZgM8o/HjVjjMoI3na6Z4XmK1hPF+mFUhOsHtljCASKFhyVeO+pmst3VRt75a4D5j
         pXiWMZr5YyXFVA29pdrawhLtd/40EJZpIIogRZt7xW88dBiU9nswlTqkrF0wXO+XkxB5
         kXmGVP6BBtsGHesla1MUDgMHDTWD5ObvACAY8p1nQ+CRqjTqlHzNfHjSRhQOCNmy+0Vg
         PzlA==
X-Gm-Message-State: AOJu0YwaIhfpzwByZnKCdoc8eghzllUICsfhczYEJRJ13pg8R5fVJIcO
	VXGQkSXGdFki8nh74Di2OCFpWQWMyBlVB3KuSFtCJtzhTSNSMDnYJtKFymVLy1U4
X-Gm-Gg: AR+sD11UdS74yzyLjTyZZ8Qlpt4jBfh1vopEMKeFQiT7zuBKLVdI/1RGG1Qq25JwK+o
	iPDp0lxYJXPo8JBE7/DPyWIRhiH/m62zUFVnXfa+odtmT1dQODc4LeU27kw/9b1nE9jpeg955oo
	C1wkaBU2Cs+iIJh7qUiIIsRhEFsAqUQotcqmBiJf70IFPKKDqgOwijJZhf79ZWxR0Yw3MGRhEAZ
	TUlL4X1rs0GDkA58BcFP44o4KDniHWFEMkwP+dijEDph1tf8bPMNokbxEztkyZV9aVgu3HgqsWH
	Qr6V+wtILkbl5HjwkFqXmE6g0TRlCj/w4bS/Uu13RvxlUMOUwpDl8iBxaadDWeIS4fJlrDOX9nc
	AiymejAVviS+3wnVZT7csd4w6FwM1VWDFX1pEUbf5h5l6yaSllVfalqAdtcqQvHQpmTKUuuNHsp
	M+Vz6y2e0z8MJk4lwHV8eX/6CB/Vs01W/dagZK46F0AjUIhOpPsbVN3U9oQnyrb0OAsB5BjIxsP
	QenFhEYOsSMcF9KmrakJY5Y/Jilrdw3S2ToMi5RCjmRtRPfE8dZskLnEgJda9E5sRRZLw79xnPP
	FExluOr5yxXkJ6ou/GLRh9kER/B09WPRtMPltQ==
X-Received: by 2002:a17:902:d986:b0:2ca:cde5:29c4 with SMTP id d9443c01a7336-2d035d301f2mr39429585ad.47.1785444557946;
        Thu, 30 Jul 2026 13:49:17 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a154ebsm31416485ad.14.2026.07.30.13.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:49:17 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc: get irq and ioremap resource first
Date: Thu, 30 Jul 2026 13:49:15 -0700
Message-ID: <20260730204915.1102403-1-rosenp@gmail.com>
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
 drivers/crypto/amcc/crypto4xx_core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 0271b5e4d923..ec18aa90a86f 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1206,9 +1206,19 @@ static int crypto4xx_probe(struct platform_device *ofdev)
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
@@ -1251,9 +1261,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (!core_dev->dev)
 		return -ENOMEM;
 
-	core_dev->dev->ce_base = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(core_dev->dev->ce_base))
-		return PTR_ERR(core_dev->dev->ce_base);
+	core_dev->dev->ce_base = ce_base;
 
 	/*
 	 * Older version of 460EX/GT have a hardware bug.
@@ -1291,7 +1299,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		     (unsigned long) dev);
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
-	core_dev->irq = platform_get_irq(ofdev, 0);
+	core_dev->irq = irq;
 	if (core_dev->irq < 0) {
 		rc = core_dev->irq;
 		goto err_iomap;
-- 
2.55.0

