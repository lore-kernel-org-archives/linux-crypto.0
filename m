Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F0D367F5E
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163422; cv=none; b=qHP8r1sqVkfOGZZHMHBbsNYtQsSQOKp3sOtORNb5v3GH6FhgyShp6N/KbcnUHNtfqyYnMoYiSEUmf7v0ENC+AAoFONtE0XDWRGSpH4lIdG2bOvixDxyXQBqIJbgJ3tNUEgHa51NqWmxAmLm2XJKlLTkpj8O0uI00H7xWNEjflOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163422; c=relaxed/simple;
	bh=Q5OMEAnl/bZliL3iiCqOcTG1zWclibaQxmiQSaH+s30=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KpYl9sEAM/l+gxhY0Bs1VFIHMtYjMX6JR1G8ZNEYpdG5zK+P1v0HPkI1af9OToufRvW/7y5JDgaF7nmBDzOZ12yykCixgPARbSl+x2GeoTeq3m+qRC7In4sdGUoh5mI+Y8S8tCGumxxBCuG1Kk0+SVM++ZPFjPFiZw0V5B4ZR4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=gBIQppY9; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="gBIQppY9"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 027211A38A1
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:36:59 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id CC4DC5FF03;
	Thu, 11 Jun 2026 07:36:58 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AC635106B9E5A;
	Thu, 11 Jun 2026 09:36:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163418; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=I2VdvpjoG990ORkfvman0mMzavWUZHSUhqFRw/ORxxg=;
	b=gBIQppY9YpfAGhVVcv/qeV+WaHZQgfBFwG8ENuUywXEDhKW0DJeIXoXW+P1Kwq7lfKUQF7
	0M4kMBmPVSdVZ55dIMc38GlFwZcXGAJn2GJShGOTBDpOrP7Yz6c6uCpqvcNMcpYhGH6yUL
	Jho3zEzBQ3dDC9Ts/AkZGdLT7Nl2tw/ACvTywGVx/Kd4HSNj8JAXC4eUa2JwEkbmvVG3lv
	ucVaLosjwMi5sAoR/5QoB2b7A8GvqeDv8adITbCRB/8j2s5lVrhwGxOlDtforI6mOLXMlk
	pHT/cXXZRF26ze1yW2TAs3bMxJa4rBiZ3KXbi20XAPF5RuMm+Egs18BQWXE3BA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:36:09 +0200
Subject: [PATCH v2 15/19] crypto: talitos - Remove alg settings in
 talitos_register_common()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-15-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=2530;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=Q5OMEAnl/bZliL3iiCqOcTG1zWclibaQxmiQSaH+s30=;
 b=ngELuJ8wsvTKmGYTba6aSM7iQ/QItl3/b7HlJQHvrQjbM3newibq4NX8XNRxbOMCuGlTzrtfY
 1asN9zikbysBxw3bOHOzuv5IqNVNka+irbAMfYw1fD9Uj4LStjhjoGg
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
2.54.0

