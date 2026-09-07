Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428914E8DE4;
	Mon,  7 Sep 2026 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787423; cv=none; b=qTQRho+SJfrHRne63UMvHFrPOlWAniCf8hLLmAUScG5vrbI0QSPSjTYPv2fqh0sM40d8wC2kQbdfkJRKMi3sYhAhBCQBYwMhVat/GlMKoUsUSzkJeXwgEVpPNfwh5STxjIDmOMbsJobMKsa62L00DFGDMvga93qFNpqG3PxITZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787423; c=relaxed/simple;
	bh=vQcKrYP6k0j5wNodab0zb0g+Xj+k54TiujSaCIm7m8g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NU5rESdUzCTSsLHFag9YrzObayjcWck7J1WYhVP36G39Onlvs0fZWio2fUsQospiI0/OhvhZqkg1UW4bk9azB4NNDpKuO4ljRNBesJzb/Tjj5YgZti0LxGjB751QHwoqpETB7rae2iZkBN2y5iLaqKeOHRFBDEg0CMVIjXHOpZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=uO2oPj7T; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="uO2oPj7T"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 76D231A1A0C;
	Mon,  7 Sep 2026 13:23:33 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4B83D60383;
	Mon,  7 Sep 2026 13:23:33 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F0BB011C7AF31;
	Mon,  7 Sep 2026 15:23:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788787408; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=HlsWSVvNlE3rAAAwzxFjv9sOhP6ooQFClSUhAwaPBys=;
	b=uO2oPj7TiCkECbuZVecyWZL04j2WqDVkvoIlVerd9Y1eKHSfQsMZGVWX4rmHEdfIxYSJkS
	VbsMHiea1teg0uRqe4T7qGFu99DthG17+L01HPTG+aLtFE0d5ak3qMxcIzlKTdS+o9DFBu
	ym1C3+wF9mgflpA2Xs6r8mWTbj0nK3inZsm7MFd2LzCn3My6LFoCrOMsSeOVsaiJtdcTpb
	TQXbQz6MnHZ5x7HPGbD4jRil6Me3IOjGP+uomY9fcG1FPbNFmwv141nmJkNQpqJV9u2+gb
	69yrBZFhw5lR+xNf13wIqPiw860++TlhJ3HGVETECXVsz8o08Gz2GyB4k/xbzQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 07 Sep 2026 15:22:45 +0200
Subject: [PATCH v5 11/19] crypto: talitos/aead - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-7-1-rc1_talitos_cleanup-v5-11-860f43cd7317@bootlin.com>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788787387; l=1453;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=vQcKrYP6k0j5wNodab0zb0g+Xj+k54TiujSaCIm7m8g=;
 b=OFhapBktKO965rh/uftg63zxMJx6ZbSRh4yD+LRiTry1UFBJjjReBtaxyr6oK3lqbls2qeyMP
 /GvWGWSbQl7AssoZcwpmBPR4c9UMhGcYY9spC29vD2C8joFjGy7paUv
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

