Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA66C3A1A3C
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959371; cv=none; b=GPk4whrTNc7DnRHfzvvj6nvpVkUelCMzrcf0pI6Z3d5GDnRf8UM3N8aMRWVD5o140fBy16d+MF8A646gEdHno4Dy88nn8NOuHPNpW28+u08fpVjErflR+HT8kJPmUOEBR4mksHdAH4ThJa+v3+nN2pBDGDpCTh14N1KwNN9axhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959371; c=relaxed/simple;
	bh=4FkOXZsTOD7ajNYlCTnufqOPDtAh/zL5EiNS+b3F0Hw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MHL8YVvXYXX6bc1Rusk5ifHKtIxNHfF6UTynnNL/nB2GMdBTRssa0VK2d42MjFMSqNewnAK7jEKY2wdRFjPCP37G5vRNDG+52KLyXaAqViWF4muEFrC5pBKvI80AcyctEwcCoTI95gc1PTpNP/yMERsb5eJ33qXnHbj0jKCoA/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=pXjpjZ8z; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="pXjpjZ8z"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 53BB7C62447;
	Thu, 28 May 2026 09:09:27 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2D26660495;
	Thu, 28 May 2026 09:09:27 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E4DA110888508;
	Thu, 28 May 2026 11:09:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959366; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=hTzGd5WnXim15n8ioTfjw21a5s8U5icq3n7d7bKzC5o=;
	b=pXjpjZ8zAna9pEEVt4jA9X7EndoB1qhTTQUDt3jkDueChw3PEOhVuCh7z1zLw9Y6TVyO85
	LM5m4TjQR/2LO9LBQAxbE95rlvsIpxIBZz7laXcTvKaYisK71su6PDJguQNKYJBg1pS6D8
	czRpZN/JDHnK47LhwuLAQa0gAS0Xor2jyEfJRvhtIb2sIbzZaYQnAgo5PsucfUX2dV6FFR
	1aF0Akst6O2kdR9athhbrosgeOeA9T0YiudaWHDIReeIqeZB3pxowwH5MR8WUJBMquU1bv
	lTk9ffBRXdNaxzVZT7uGscTCyfADipn6EMOIrJERq1n2eFVJ/bBV2tqq5XjeOg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:19 +0200
Subject: [PATCH 06/29] crypto: talitos - Introduce registration helper
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-6-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=2683;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=4FkOXZsTOD7ajNYlCTnufqOPDtAh/zL5EiNS+b3F0Hw=;
 b=5AVFfck2l4nlkcNT5NYb/6j6Q7qIcNKAKg9oJ4FNY8S5WDc9Eub7MN2DYkjIzd8G37uapPZgC
 8at3ycbnRO6DgJDMsbpqYKwzp16dNsqFf59o6RzQuRYIN/LYRHOPtXz
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Add talitos_register_common() that will be called in each respective
crypto implementation file.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 53 ++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.h |  3 +++
 2 files changed, 56 insertions(+)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 3fc1069062da..869739dcc4d7 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -3095,6 +3095,59 @@ static void talitos_remove(struct platform_device *ofdev)
 		tasklet_kill(&priv->done_task[1]);
 }
 
+static void talitos_alg_set_common(struct talitos_private *priv,
+				   struct crypto_alg *alg, u32 custom_priority,
+				   u32 type)
+{
+	alg->cra_module = THIS_MODULE;
+	if (custom_priority)
+		alg->cra_priority = custom_priority;
+	else
+		alg->cra_priority = TALITOS_CRA_PRIORITY;
+	if (has_ftr_sec1(priv) && type != CRYPTO_ALG_TYPE_AHASH)
+		alg->cra_alignmask = 3;
+	else
+		alg->cra_alignmask = 0;
+	alg->cra_ctxsize = sizeof(struct talitos_ctx);
+	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
+}
+
+int talitos_register_common(struct device *dev,
+			    struct talitos_alg_template *template)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	struct talitos_crypto_alg *t_alg;
+	struct crypto_alg *alg;
+	int ret;
+
+	t_alg = devm_kzalloc(dev, sizeof(struct talitos_crypto_alg),
+			     GFP_KERNEL);
+	if (!t_alg)
+		return -ENOMEM;
+
+	t_alg->algt = *template;
+
+	switch (t_alg->algt.type) {
+	default:
+		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
+		devm_kfree(dev, t_alg);
+		return -EINVAL;
+	}
+
+	if (ret) {
+		dev_err(dev, "%s alg registration failed\n",
+			alg->cra_driver_name);
+		devm_kfree(dev, t_alg);
+		return 0;
+	}
+
+	t_alg->dev = dev;
+
+	list_add_tail(&t_alg->entry, &priv->alg_list);
+
+	return 0;
+}
+
 static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 						    struct talitos_alg_template
 						           *template)
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 1f81d336dae8..afed9947f4c0 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -523,6 +523,9 @@ int talitos_init_common(struct talitos_ctx *ctx,
 			struct talitos_crypto_alg *talitos_alg);
 void talitos_cra_exit(struct crypto_tfm *tfm);
 
+int talitos_register_common(struct device *dev,
+			    struct talitos_alg_template *template);
+
 /* Hardware RNG */
 
 int talitos_register_rng(struct device *dev);

-- 
2.54.0

