Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B47568FD1
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176775; cv=none; b=VDFAi4bj9Wgnv6y83CYNc6BRvLjhkFVJAI7ur0XQPjrktpoc1ACWLkfxegCY2UVlyCbsl085w3RZrWYN0zIo9+Xb9dmFt8tqWIbaOksO0HzIbMwRoN2JABoEV6q9XD4aX4tNRm8e7H9NCSGjawm2SF/TVsEXL5Ddca+JyN4LApg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176775; c=relaxed/simple;
	bh=tv/D1m+jWDZUaVM7vfSAa+Ud714zRZugQxwPlYEI8xc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sKwN3/xckmVSdFqN3pOF2Ou1LXyHMNvrSNlQCmKXLkZE9HtZkg8iSMMzkaJBnc7fXCnMf5WDsnYOqyA+6UbsC+U0ru4cAtk2nqI0KUCpMPy3vrs+Fe7bPpya5baeFAMI/S40+G2V3UiiHfAJq6D6YYbh4jiUm+uMpHRHpg1DytY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=vlt+7vmN; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="vlt+7vmN"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 481E54E41048
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:19:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1CC3160580;
	Wed, 23 Sep 2026 15:19:31 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 56CBC103292D1;
	Wed, 23 Sep 2026 17:19:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790176770; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=bcssHe3FUjbgo5c0WBhKNqn0JWGj8BDh2G8L/qXCQjk=;
	b=vlt+7vmN55In1Fn6BDdLA/ndT2MZJGnZEMy+YSLOnK2RlFsXQv18FaMSl732mjUN8p4kBo
	f+yfpOCKYLtmSFGwwZtVfvnNqKf5jEX/mIIcKQTNKit8oYqqZh53QvRH6S37R3mq9Oidx3
	p1gSVhPRMApOY8XA11dYBYi2x7vT0gNaLv8mcxLIQIGg5f/9VeeiiDeKXPWV5jcgte8jB+
	kvr2UWqp78/8+c7QzYaKIcszS9RvwTYb+eDAPz00KGBUKDePFaONgoHE+YatEreD/W88Ga
	QeetzmP5KqEEYapwqMDuqNg5BmqxLrHpQbjnxcC0D2EHjEbqSAXWa7mSV1NUBQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 23 Sep 2026 17:18:46 +0200
Subject: [PATCH v7 10/20] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-7-3-rc2_talitos_cleanup-v7-10-9a45261fc097@bootlin.com>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790176746; l=1565;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=tv/D1m+jWDZUaVM7vfSAa+Ud714zRZugQxwPlYEI8xc=;
 b=ZHV9j03CQR0jAjlwzOSqDtgBVrLJ7p66O9W7joDX5V7ufXejTBfNQOXbbMDdxunq4WJuFAsc0
 75acFTL5m/FCqo89iu41oojXHHwmgMySn0EcTk0XMyoILHzp7Qg1DeK
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

