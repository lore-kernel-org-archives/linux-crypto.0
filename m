Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AFA50C292
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897151; cv=none; b=LF6OimNvSM0+oOcNe33blBMy6s+g8oK9SUl9GlcxVkLCIuJJbqHgAQ9RyXzAjvWOvLcd7soVFWQjGHv151yFi2sWLqPe0XfHEjwwzymZmQvQj4HkH75H3kcudHNxVMQdYnMmfnXGX+BojjSUJB4Smty6BXJk6XOwXl0zNiG5ykI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897151; c=relaxed/simple;
	bh=pSnJwVw23zg6ENCkVijR4/iIaGZVb+AHZV3xP0YD9H0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tnQqXh0dCVXV6GJWLslHSHu5Bj7wEgi77st8CIzo86zpPv4SbZuI69oDWXM2G+jlZdWAqh2XrpHXAGnieRFkvzoxa0ABcWaCux1Lkw8O6+d2pAVhoJSmP7ognkAyg/mluKPuj7TwScvP65WpMErzhp3PDQ+CL7mIoJzemNqCEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=N+VRq7kX; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="N+VRq7kX"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 85ADA1A1216;
	Tue, 13 Oct 2026 13:12:28 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5A33E60362;
	Tue, 13 Oct 2026 13:12:28 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 635D011D713A9;
	Tue, 13 Oct 2026 15:12:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897147; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=KvbNYVMvn7QXrnz7nG4eAcnfIHoonoaqc4AFxR3eqa4=;
	b=N+VRq7kXWIq10k1qan9K+NCa9kVx3SmLUx07ESQl4Zi2f7nRoewkMpd+X6PyyLwqIM+jaS
	ghaLuCU0rPsNfM2EHEua7LPNoOJBsd2+BGNBkzX5YYOr5mLx2Xge5qdKxDJhHEpml7Oin1
	gieMUAfB+5CadKPrc8XqiJfQu6f+OAyMy/mWZ8pfpxaI4X6DUeaIGh0AHj5zxvUpf4VrhO
	NMegcNlaD+r9Bfswx+Ot2XuVL72nwbpNyP5BOVhbS3n8bQT5yYSMBsPWIng7Es/LeMY0yG
	QQj8kcass+nol/TKbRy1NcnuMtjWNz5ry6VgYZDSHvQ3cFWSLWpmGsrSgUc1Ew==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:36 +0200
Subject: [PATCH v8 10/20] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-10-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=1565;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=pSnJwVw23zg6ENCkVijR4/iIaGZVb+AHZV3xP0YD9H0=;
 b=V6sGlZOl4C2cs5PAI+veEtf65pccmS61/HhsVjdfpjzdiLt9AQXONIDRtwfxAHTlieSr75PNg
 60sEjP4WIjXBEhxhIW22Bupc8+0btvgDXcRxQwwVFYKsb5A2LdA/oZo
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
deprecated"), both cra_{init,exit} are deprecated.

Use {init,exit}_tfm instead.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-skcipher.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index e4e8bebdfb7b..6c60ad6aa9be 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -232,6 +232,11 @@ static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
+static void talitos_cra_exit_skcipher(struct crypto_skcipher *tfm)
+{
+	talitos_cra_exit(crypto_skcipher_tfm(tfm));
+}
+
 static const struct talitos_alg_template skcipher_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
@@ -378,11 +383,11 @@ int talitos_register_skcipher(struct device *dev)
 		skcipher_alg = &talitos_alg_template.alg.skcipher;
 		alg = &skcipher_alg->base;
 
-		alg->cra_exit = talitos_cra_exit;
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
 		skcipher_alg->init = talitos_cra_init_skcipher;
+		skcipher_alg->exit = talitos_cra_exit_skcipher;
 		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
 		skcipher_alg->encrypt = skcipher_encrypt;
 		skcipher_alg->decrypt = skcipher_decrypt;

-- 
2.56.0

