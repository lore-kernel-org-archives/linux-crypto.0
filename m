Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF754A33EA
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710484; cv=none; b=bXS9Cie884FkpcJU1AHAmpEXO3IOPBJBhttsZLTpbr6sXuYGSD6o34QmogGUAfCEHB9sZIRvq3rrmootQvU2rLwBrk9PM0n5YllBuFSFD6horTxBZVXIu0e5BpkUU6C/Y3RSwqVgbIVCBQGKf1SDiTW3FNTC/02NVItHLRu8bqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710484; c=relaxed/simple;
	bh=dH3V5FzEunV71NpnVP0ViObSQfSyFk7jQKfBkvAUnWA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NABJw4Jb27r4rDI0dh3Wuok9AR/hY0nXMH8dfh5/7tmXutiZvM9I2/9AMAVOjWpcPYwA5eEKCmhHpAt8I4UTKoqaVUBdZhHGVBQ6/89FY0+L+XsT0ddWbSynB8syD9iIDSDwKyQX2uv3Ff4Lt0E2A9d3lu4C1pqSwGJ9T+J+wgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=uh/5r7QA; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="uh/5r7QA"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 2181B4E40EC4
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:54:41 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E3C5360388;
	Wed, 22 Jul 2026 08:54:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 77F6311BD3A98;
	Wed, 22 Jul 2026 10:54:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710480; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=/tIL/35xhzaQ98GIYg8OANcAB6TmHi6jm7IH4IqH7Xg=;
	b=uh/5r7QAJkg1+gBsksgByGEWNQTtlouB9NPDcJ1YBJPxMZpXSzZAmFC5sF5C5wzC7cXbUx
	zSZ4y6JFpePALDVVLIM/d3yZCATg7OqOt5uR3WTcebkqZEaR7un/DwZALUfe1egWQyMPE+
	souUl7yORD+DGJmZPiUqNoBWu0O5el+Bi//fXmSVEXfMf2SckMj8AA8z/iUVXs2jvUKiaI
	RXj9ZOSLDqePhLDuEjkeJIYUy4g2MOxQMZ5NvlwALmu18dHm4Ms9YoVgu9qWe1fiEeAz1P
	ob/y2emEFmpLjMKWrwJDvvKZdi1Nvu0mhxTiBCunwT4wI2IsPSQkagOMrzI3sg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:55 +0200
Subject: [PATCH v4 11/19] crypto: talitos/aead - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-11-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=1446;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=dH3V5FzEunV71NpnVP0ViObSQfSyFk7jQKfBkvAUnWA=;
 b=SEPwQtKvjBbsOvLOVoE0TqKsh4I5z9l768wN8cNWfkPJ4/Q8ZziXIEGABsYiV4NQaiZriGU1i
 C4W2q9GL+nLAFKZgXlGJEb/gsoDSR1I5o86naOx2BtKBH6zsToHD26o
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
deprecated"), both cra_{init,exit} are deprecated.

Use {init,exit}_tfm instead.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index ced314a645db..5537f2b6317f 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -400,6 +400,11 @@ static int talitos_cra_init_aead(struct crypto_aead *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
+static void talitos_cra_exit_aead(struct crypto_aead *tfm)
+{
+	talitos_cra_exit(crypto_aead_tfm(tfm));
+}
+
 static struct talitos_alg_template aead_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -875,11 +880,11 @@ int talitos_register_aead(struct device *dev)
 		aead_alg = &aead_driver_algs[i].alg.aead;
 		alg = &aead_alg->base;
 
-		alg->cra_exit = talitos_cra_exit;
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
 		aead_alg->init = talitos_cra_init_aead;
+		aead_alg->exit = talitos_cra_exit_aead;
 		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
 		aead_alg->encrypt = aead_encrypt;
 		aead_alg->decrypt = aead_decrypt;

-- 
2.55.0

