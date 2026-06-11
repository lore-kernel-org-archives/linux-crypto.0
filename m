Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8E4366049;
	Thu, 11 Jun 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163418; cv=none; b=SvZ7qWlTT23jqOh8+VGpe7DnsAuKoHLvbuhABy9mL3cINQyOmGQNf3LQM47SjVQZYKijgrBhKZHi9Y5W3rTfagFXvWKaIgD2W10RWrHWYacJJq7QG8ECXXhQ5Oz6d4QYuvmHU5l96+iYAP2gK9lTf/vHgE/JSPHJcb8Uhltarmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163418; c=relaxed/simple;
	bh=PCm+/hfaLwohrAvRc5ONSp8f9KBvzp30IozA6bw/3ec=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PbsgLPCkWIsEkqmPOJs26B1m1YoJJb0owA8sG3gOqOE0c7cGPnEY6js00jK3NiaBRFqYq3qcpCgPrOsu+lIzz8fVRhRN7NVjifGr0W+2ISUx9ux1i7fFec8CskWDIo2XTOp1XCCpqk+o7Vhy6MX/0oRBRo9pDkjKKigL6ljItS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=2iXBmCCN; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="2iXBmCCN"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 463C0C49F65;
	Thu, 11 Jun 2026 07:36:55 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0A2575FF03;
	Thu, 11 Jun 2026 07:36:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C51DC106B9E55;
	Thu, 11 Jun 2026 09:36:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163412; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=fVre01GCa6nsUsOcI8TqOEm5sXAqUPWD2JB5TDQ/zgA=;
	b=2iXBmCCNZCccxO2Ajcx73T8gavLd68EG9EQ6Phj3dkQjSQc2o8HuJ7Tuk4tPb8Z3EtEMe0
	iEdnuwOn+4gMSPc8brWSJHTwUrU7Bc4McQNEf7SruJhlrRU88p5vJzS+pcNtPqoZU8OqD7
	5Wz+yu8qyZqNhhx1f6frXj4lH896npzv/OqRMFVm7/l/+GKJM7Io3JJ1MmfO5H8BYnARhh
	e9F7AfeBNz3ipGcrdi1JXY++mxit3Uj7YSH859+u+LtGh5GzoUJxFui7S7siCyOgEv4Hiz
	R5HpssA4HNClO4vJ0j7MAMFWG2KBZy7/qy1FNSBI5XKRuslIR2GlNjKQHpYUCQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:36:03 +0200
Subject: [PATCH v2 09/19] crypto: talitos/hash - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-9-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=2070;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=PCm+/hfaLwohrAvRc5ONSp8f9KBvzp30IozA6bw/3ec=;
 b=SjAQ7c/xkhNk3gqMNPFyxUZckfMKnGq39BCWINDDrwgM74s75Gu9j2lWljKvoTRgmwPTySS2L
 F30wnUyNYYwADfn1aylpRC6lSmkbXhRKX1i81MZ9CRfIZElNNO9woSM
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
index 76be6b6c6fcc..60e7f278243e 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -530,13 +530,13 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
 
@@ -545,6 +545,11 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
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
@@ -792,8 +797,8 @@ int talitos_register_hash(struct device *dev)
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
2.54.0

