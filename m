Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5787386435;
	Fri, 11 Sep 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138051; cv=none; b=cwQ7FwVdevJ09HaplZns6VDsqDDdr7SJb/jmliEFaVk/rTj41l1NabvkSlNGj5VaT6VsYWk/NapfEK4Za/RLeY3+9zI4x2xo62l++JJOUqeTWsNVJ8InTyd69apmLHTs8lYXB2h0u7fTbvlFe51SBvEzjgN4rxxHjTjK+60c330=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138051; c=relaxed/simple;
	bh=tv/D1m+jWDZUaVM7vfSAa+Ud714zRZugQxwPlYEI8xc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tOVvPQHGBqEYOnjlmHHdHyQ2uKyhEKVFNpvGxukhjTdqjhxoDWnfKwJZjPYVKaRyoMs6bETMrp04FGs7UY/w4KZ7znkNvdMsoMUgQ9CoEpnzlwv43TIJQiC5Ktmjg1B6mfbA14mEwIoYT9TOfCX072yQtI2eafC3y1kcMJmnlUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=DvXZu9Sd; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="DvXZu9Sd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id C9FA0C653FF;
	Fri, 11 Sep 2026 14:48:07 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0623F601DE;
	Fri, 11 Sep 2026 14:47:26 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E44F611C7AFB1;
	Fri, 11 Sep 2026 16:47:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138045; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=bcssHe3FUjbgo5c0WBhKNqn0JWGj8BDh2G8L/qXCQjk=;
	b=DvXZu9SdsOCmDwJs8glgf0A6D7xvDnTxow4qneXk08FyZN906gsLdnoM+WxPj8jMnz4Bu9
	4d58++BZxK9H9Pv+uqh7JyZ/nlXi9dtDuruJaLK0eOnAN8rY3ylQc87CzxwoCb57b6+DLz
	2EOmb0Ws8M4FngywYdA0MQrPHeoBBQVCUqVQy+NU2YeRaKmtDGMWdPIr2kpBwRHBOqyueX
	tcfFKo4VM0EQllp1LdKviK49X4tIa6OZrNI+4c2IGAwZR7IUoiDPPADhmS1xten9N2sn7g
	0zd5CKHofS236xjbmxr7aEg+35r7Htjg6mzqZuk0TLsQnLF1NRJbIMulxjO+5w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:27 +0200
Subject: [PATCH v6 10/19] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-10-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=1565;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=tv/D1m+jWDZUaVM7vfSAa+Ud714zRZugQxwPlYEI8xc=;
 b=GYrje5Va2nZBv0siaVSwqp/acoPrY17HjS1soYoG+Xs047J9DElPTN4gdnoa+nxy2fhEc91DN
 zQHYxbtXfOiA+AFCcD5Fk0HFyi7PiFXwXCdXOqvx4WRoS1tzFTD7+rC
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
2.55.0

