Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97539E6FC;
	Tue, 21 Jul 2026 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642406; cv=none; b=VS/mAlQfnC/Y9Or6M8pgmD9r2RX8lgmwN0huqzSAFG00XkNOlrnJKHVXGdjbz1pNPfVN1ZdPt8cR7nHS+mtWkrvDcVn7OoXuUkWu7gKf4rUfhRYqETZv76UeWb0kpyiUKAOKopg1e+wDJDQnJlQIZQeWzrHlf/YUHk+rxfUNKYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642406; c=relaxed/simple;
	bh=yBIuQihIVgq8eemqwo2V4kfBsvv+fb+FArKsclDIDMo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rctKkEDBkRU249ftBGs1n3/tQ/3vsCnYHIuYkgYoV+RY+RZY0UUDK/JZDan5OLx0WxFD6OKeMWZwOi98NCjaFuxTq6T1Hsxzx5U3q++3HBlQxbIRu6v8dszVSqQRigdUGgIa3aHdzvzuyAw21HH4o4BdkBbYBBChQI7YSGfnsAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=KlEki36i; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="KlEki36i"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id DCD241A113A;
	Tue, 21 Jul 2026 14:00:02 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A160360368;
	Tue, 21 Jul 2026 14:00:02 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 492A111BD3A55;
	Tue, 21 Jul 2026 16:00:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642401; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ITPtmaCUeyEjw45SNx2etD9e/MRBG2mYsowxgE/yfQQ=;
	b=KlEki36iYM/E4cZhaoiH50HO7wrCT2EagtZ11SNn9e1CMHcutaV8UEhzzM2v7dCIRqGblh
	bEsaAWjdxihGCX92NlD/y1TFMqqe67mnu3nu/23Xpg65euU9bSawqqrAtZbWyKsCMdc5DO
	a0c4CubVP9m3jIt2Hb6iwsk4pa+w9ZYRDgkbomsc8rHmLT8pnit8jHZyuzRRgQbk9rqL9g
	YOchDB1FmpJJk0ZG5OI2pFgslwws83j2C/6uPCEC67T9731HYay+GBNvv+kuux9VkVJ5zP
	Xg7/jkeWIr2M2fMp9jAPHSoTIYdJB/k0rtr44BKmBvSIR+/q9snSHJibKn/Uug==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:42 +0200
Subject: [PATCH v3 15/19] crypto: talitos - Remove alg settings in
 talitos_register_common()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-15-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=2530;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=yBIuQihIVgq8eemqwo2V4kfBsvv+fb+FArKsclDIDMo=;
 b=ThJklSEPcbS4k53La3aB2Q/Q7VrSjWjCj+juQRGaHrXP6pnUT6w0gAfHQdHIuv6vpT9xc8pus
 EMg+gkRIlXsDSOcaMuCV6fhq168Xm+AE9bvKNW/7mQRnZGWBC6LOQJi
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Algorithm properties are now set at compile time for those who are not
dependent on runtime features.
Remove now-unused function and struct member.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 23 -----------------------
 drivers/crypto/talitos/talitos.h |  1 -
 2 files changed, 24 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 52ff5ef46fb6..ff938cc4e837 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -1040,23 +1040,6 @@ static void talitos_remove(struct platform_device *ofdev)
 		tasklet_kill(&priv->done_task[1]);
 }
 
-static void talitos_alg_set_common(struct talitos_private *priv,
-				   struct crypto_alg *alg, u32 custom_priority,
-				   u32 type)
-{
-	alg->cra_module = THIS_MODULE;
-	if (custom_priority)
-		alg->cra_priority = custom_priority;
-	else
-		alg->cra_priority = TALITOS_CRA_PRIORITY;
-	if (has_ftr_sec1(priv) && type != CRYPTO_ALG_TYPE_AHASH)
-		alg->cra_alignmask = 3;
-	else
-		alg->cra_alignmask = 0;
-	alg->cra_ctxsize = sizeof(struct talitos_ctx);
-	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
-}
-
 int talitos_register_common(struct device *dev,
 			    struct talitos_alg_template *template)
 {
@@ -1075,20 +1058,14 @@ int talitos_register_common(struct device *dev,
 	switch (t_alg->algt.type) {
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
-		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
-				       t_alg->algt.type);
 		ret = crypto_register_ahash(&t_alg->algt.alg.hash);
 		break;
 	case CRYPTO_ALG_TYPE_SKCIPHER:
 		alg = &t_alg->algt.alg.skcipher.base;
-		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
-				       t_alg->algt.type);
 		ret = crypto_register_skcipher(&t_alg->algt.alg.skcipher);
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.aead.base;
-		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
-				       t_alg->algt.type);
 		ret = crypto_register_aead(&t_alg->algt.alg.aead);
 		break;
 	default:
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index e36a2609d87d..3cbce0be705d 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -203,7 +203,6 @@ struct talitos_ctx {
 
 struct talitos_alg_template {
 	u32 type;
-	u32 priority;
 	union {
 		struct skcipher_alg skcipher;
 		struct ahash_alg hash;

-- 
2.55.0

