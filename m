Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570304E8DE0;
	Mon,  7 Sep 2026 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787418; cv=none; b=lHbZ4ISeezVyE49DPI7o43LSmvbBpDqbHk9IWePlFYECr8M9gZmNW9SQIN5H+DU3BeS8FiTTIungLyQgWxJp7A+ZQ8eYSrFC3EkAy7seoST5etp+/E2bYwrKIGfwcLgSwtl6xzkF5J+Xxzsvh0q7cs8uJVoQeZ5+GW0Iy0d0P3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787418; c=relaxed/simple;
	bh=tv/D1m+jWDZUaVM7vfSAa+Ud714zRZugQxwPlYEI8xc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rfEy36ylG4HibmtKoP/B6Q4A10dBQJLRcdlgk873lqMAYYrhPDKhVz/7UEU9W+kLa4JI+5ud8KelPhMX2GFAifRGDkYHHgl/DTQKFpD0/COqk1Mrp2mW2gqcPdB5BdG7xTzQoEsimZo2o4+lXOZRQCshvvd4Q2bjBAlphRoo1bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=tnvG2urF; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="tnvG2urF"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 721CF4E41569;
	Mon,  7 Sep 2026 13:23:28 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 40C3160383;
	Mon,  7 Sep 2026 13:23:28 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F01D311C7AF2E;
	Mon,  7 Sep 2026 15:23:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788787403; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=bcssHe3FUjbgo5c0WBhKNqn0JWGj8BDh2G8L/qXCQjk=;
	b=tnvG2urFs35wWX7GuHOj7KtdUSFAsLFlHzvmBfFrR3KbYxmGfC/463+fgTCBmFkQo9tLrE
	ZuYwr62508HXuHUO8fjz/v9jmUkHguTknma4LpyhfehQZBb4f2o0vNqG6f03rlz7+0Kikq
	VyjxB91BkNmBF7Dq5ZWY4Nadi5h0h9i8GoirG1fIi35a17sSAh4wxTJte2oTGHs4oExTTw
	+0080HQywxSCbR3CCxCYRT2keZ80QA0lHGpFS+7C2LW4hePo/mva3SpPZOkODFS5baMHsA
	R0RmAd2c9OTzu4HKP+jxQufAJxd/P7Zk4M5h/+2s+kBtspBPpsD9pg7rvHyaxQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 07 Sep 2026 15:22:44 +0200
Subject: [PATCH v5 10/19] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-7-1-rc1_talitos_cleanup-v5-10-860f43cd7317@bootlin.com>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788787387; l=1565;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=tv/D1m+jWDZUaVM7vfSAa+Ud714zRZugQxwPlYEI8xc=;
 b=DjiEnJzwreOppXD2fgYy8BnmmvgbP7FxjBXyE/lpi9YtOZoDOs7IHBBPZxdLPYfEzkkxS6qB9
 m85L3nQ9uyPB/d7ck85tXgofZxVzYq1Bmfd0eSRS5U6H3UFvWnYnw4I
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

