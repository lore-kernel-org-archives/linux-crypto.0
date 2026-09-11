Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D363A388860;
	Fri, 11 Sep 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138055; cv=none; b=Tka1v0uq9y482aNTIrXBpH0EpYf+E/GgvMnr6Das6c88t+67jUxp+bp8p/OGRpeHne6qNUV0a9aJGmN2Qtfwz/1pt3jdzW8yKQ6qgihQgwHal+xji86nKQVsg8PlEe7bqzUmX9OXvxa6JxLvQBapxXpd1ohgR5f1cmeK8WQDJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138055; c=relaxed/simple;
	bh=vQcKrYP6k0j5wNodab0zb0g+Xj+k54TiujSaCIm7m8g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bpTXOKby2BLZHugY9Iqx0BeJcLUDgwJ1PQLQGQzrjuIyVXwRfYzmshI/GEgY9W/hYJL7FMWHyTZmf/fbi3W6wIEFhiJGgndvHzpNnzxGlLH4sCA2caIn7iy0P1qQZzkprkJvKY2tDPDml00vSNEtxPBLC7jChzzBT2ERC+Jd3kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=IVQNecHc; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="IVQNecHc"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 124521A010A;
	Fri, 11 Sep 2026 14:47:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id DBFCC601DE;
	Fri, 11 Sep 2026 14:47:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C98F611C7AFB5;
	Fri, 11 Sep 2026 16:47:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138046; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=HlsWSVvNlE3rAAAwzxFjv9sOhP6ooQFClSUhAwaPBys=;
	b=IVQNecHcReAAwn+BCILIq96TCvqU1EihXDs/mb1TYzCEj8UiAp1FDaL0bDjFmA6P8RuCyX
	ttBn2dujLTxfiNwKPKFjNZMcrBt/dQAu+sH+Q7oWTQn+Z5zW5AGwu1Mr7CafSzHTHL3wi6
	na7HRBlUcAPyo69gliuY27MNZPtTwfdY/dv12FbyQ9a7aMpQquXnfVn/OUiQWowWJRHLtp
	bvqC4Dhd9OclBk9WCSHn8HKKx1PiifpoblNxYlw5uWxEmXEGPS9935tFq5Z4tE7W/D1kOM
	KVzanrhqlfbL15g+IMxb4YWsRSBg8dFx4SVwhBY1Seabo/VGS8uMTfUCdnRV5w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:28 +0200
Subject: [PATCH v6 11/19] crypto: talitos/aead - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-11-4215f347c97a@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=1453;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=vQcKrYP6k0j5wNodab0zb0g+Xj+k54TiujSaCIm7m8g=;
 b=H1A+wqM6e6c7lDzGWQp/iCvPRRLQqfGuaeXwA850bifkGYeYNxMJFJFcLFM4ipwbPfcwcrt09
 B1r5NNNOxlCDGGAjxtaOUEVvjCD1+/PJsJiBEaT9dCF1/WBIE/yLS/Z
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
index 0236f152743b..40d048de0502 100644
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
 static const struct talitos_alg_template aead_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -878,11 +883,11 @@ int talitos_register_aead(struct device *dev)
 		aead_alg = &talitos_alg_template.alg.aead;
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

