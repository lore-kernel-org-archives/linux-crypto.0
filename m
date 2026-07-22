Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7B148C3E6
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710482; cv=none; b=aeoF3ZUWbs7q0UDjSvM1Kwjs+lOoN2RJlf2AxkEQjyYqAEpNdBTGkGnlO3zC0xHMj2o8sHEenqC5wH8LbRFPpfxWzYeym94IkiEIiJ8OzD0KxDyTGwbBqqQspTO3HMWabnMr5ZMMEiCzqhBHlha1NaXmUkB9SZ+rWcPrLhzDqck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710482; c=relaxed/simple;
	bh=gQQct22VEiGx0OPikJLnOEIUFwPsuYOwFUbJuzM6wCg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YxwrOENAGWO+cNIiAIdjBaybwysAwNB+IRaUCe6r2bxO1IgyuSW9VaV2L9as8/O3C6g1f4DR0LWnP+BHg4nZI7t05CM+9i7gn+SUYx2JOZZkD39DOKoTmiuZnp9HHTJ6TzeephLY+RUUNtbjbuY4JCsIZPHG8lYi/MHHlSZtLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=I7a7/FYj; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="I7a7/FYj"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id B838E1A116A;
	Wed, 22 Jul 2026 08:54:38 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8DF866038B;
	Wed, 22 Jul 2026 08:54:38 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 063E411BD3A57;
	Wed, 22 Jul 2026 10:54:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710477; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=qgfi6JtQze4/q0h8uvvpVk9cVZVg4uq1WhzVIPVs950=;
	b=I7a7/FYjVU34NsLSH8tlrLrVFo8c4JAUjh+jlyBSOJ6IY4oDhcT6r1RmhTkFnVUYH//Lsi
	ZkzfjfLyJw8Xc+77HY4sx4w8PmAeGntDMNvqWpQqfF5bpdsScqH3OMrGPMSqtQZXNMMNjU
	RoPjBiNSWCcmX8PJgrCl6fLnnkn5kLPK1qYR6MK5PaedCRig7ddjlGjy/VuppdwkwodDVF
	rspPXnTcmaxP6b8knF8TFCrBf8ZBHp4H5s3422C7iTg+v6edF04oV0uwGCZMGEQfSsQEzB
	OjIW93ffNCtfLIpBygDiDguE8EnFpPuJIu/jwN3irNhXVh6ahxhZJ7qHAbP3Iw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:53 +0200
Subject: [PATCH v4 09/19] crypto: talitos/hash - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-9-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=2070;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=gQQct22VEiGx0OPikJLnOEIUFwPsuYOwFUbJuzM6wCg=;
 b=bRYG1R9+7irV1A2/rmG34Zq1KJai2vnekPqYSSD3xTwYMmS0Mt3BX1sSFS9R/X+h2OfWYtdJZ
 GFCSEuDlsb+CDgjZAmLjRWljfNAZX3re203DPL2ZF2tgvtk3eiC28eo
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
index 619c60c07525..c8d9f795147a 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -537,13 +537,13 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
 
@@ -552,6 +552,11 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
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
@@ -787,8 +792,8 @@ int talitos_register_hash(struct device *dev)
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

