Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF0A38CFE1
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642398; cv=none; b=dC4HdOTxvYx/QkafbekqmiaFT0nnObJg3b5usFG43rYqvjrw4hk1qdpfPs5YvXBUNnpn3/R7yV0RlUP99GeduXs3ftSo/Xp3NF4LT9g6RxwoIHIoiXBLWiz0Qiv2TYa5r39yFMxra7gM9Adx3j0atrl55gsN7wpWYbamDFGIKQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642398; c=relaxed/simple;
	bh=tcAsVIEP0WA025bFHEQ8n008ZR3mLAJNNfU7TV6DG4w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VnF+FXt7DiBIsvBFhQIVp9zOntaqbyjSYTQ83LWjYzCCdmdYrb/XLvsqarVRWlOBG4Z8pmvdin2apRs3jgPhWugm7Czry/E1S0rV+H2FktrSCty+oV746LTocr4Ej43Ilwbi/3HUHRjnK01tJkV3dB7L1qpyeRdpbF/A5lo7EF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=nrz643OK; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="nrz643OK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 8543A1A113A;
	Tue, 21 Jul 2026 13:59:55 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5A61060368;
	Tue, 21 Jul 2026 13:59:55 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0801711BD3C87;
	Tue, 21 Jul 2026 15:59:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642394; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Hu8d132vLTIeGU/ZnMMsO8UYo1IBLj/ZtJ1suo/onNc=;
	b=nrz643OK+C7gIYkWzm7QopeZZK2Erl1stmm+OOuSHTtuTarAxKgi3ooWGjCFmteoLXWKUb
	WFXHnarrVAbZ+MOS9Lt6eEF8A9nx5r7iYG9lT7JTdV3wyQpZwrTV1AiLM2ry2a3VbatN29
	8otEX4b2p+Eke4VhWv+EDjHvjLRzf/amMi7bHERqSoDVYL0zcKlSJirRTuLG/GZMtKxR3q
	1mE3nf4nmTW4nUj7zPQJvuUbf7fN8K/YmTm6jYXFqmK+m2/etliqP58qS4w4dQvTpzBI4C
	TW61EpqAoP4V/ZVC796lWVCYf8Qi4IU0DP2Lmt35/J0fWG30rW7FK5/P0/nsDg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:36 +0200
Subject: [PATCH v3 09/19] crypto: talitos/hash - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-9-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=2070;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=tcAsVIEP0WA025bFHEQ8n008ZR3mLAJNNfU7TV6DG4w=;
 b=U88ujpGXgngfYo/OqDTea7QU/11vgx9k4CpkfQxSZKRGsqQdW6noNS3kIj2PWp36dbb9eX1aT
 SVPF4d+fiUPDld9RXbqdRtTgbQA9rm4T806aF+a6sBiTGeJcT/IBqvV
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
deprecated"), both cra_{init,exit} are deprecated.

Use {init,exit}_tfm instead.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-hash.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index bce9f9901ce8..f9930f6e9291 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -535,13 +535,13 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	return 0;
 }
 
-static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
+static int talitos_cra_init_ahash(struct crypto_ahash *tfm)
 {
-	struct crypto_alg *alg = tfm->__crt_alg;
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct talitos_crypto_alg *talitos_alg;
-	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	talitos_alg = container_of(__crypto_ahash_alg(alg),
+	talitos_alg = container_of(alg,
 				   struct talitos_crypto_alg,
 				   algt.alg.hash);
 
@@ -550,6 +550,11 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
+static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
+{
+	talitos_cra_exit(crypto_ahash_tfm(tfm));
+}
+
 static struct talitos_alg_template hash_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
@@ -785,8 +790,8 @@ int talitos_register_hash(struct device *dev)
 		ahash_alg = &hash_driver_algs[i].alg.hash;
 		alg = &ahash_alg->halg.base;
 
-		alg->cra_init = talitos_cra_init_ahash;
-		alg->cra_exit = talitos_cra_exit;
+		ahash_alg->init_tfm = talitos_cra_init_ahash;
+		ahash_alg->exit_tfm = talitos_cra_exit_ahash;
 		ahash_alg->init = ahash_init;
 		ahash_alg->update = ahash_update;
 		ahash_alg->final = ahash_final;

-- 
2.55.0

