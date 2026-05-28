Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5D53AB5C3
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959378; cv=none; b=qbARHSf45ZubVDelgC7iYFjNxwpomNfVFVGbJSePQ3UIvE1i+B503Y0bdlWC213LmiNk57PF2+1/qeEZTh8fkv0B/wvJy8CGbC/Qtkw/6/vIrFYZ2MWAF9A2UCT88Y4BdisF456N7jgKMMa3gkBjYpe3AJmzmSnX8s2bdEyGnIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959378; c=relaxed/simple;
	bh=ZXe65ajiA2xhqUjYaTc5+KBF2tDu7XgEiIFo9uwwF0w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cPgE4nqRHbuYkqZVnKhs0pIDd77inD24qKqTccs+4+vFDRdw4BHFJC/5GDUFY8mvSrwmXdhHob/i2kTDz7kXw9hulfXCB1CekTTB3Qgmw5xMwV4oGsxl/eXlLzbGmmYMUmWvRvh/8pxQ5ExEVt3ldH60EZZ0H9QB7YlCMAd3rtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Zv9m+Qs+; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Zv9m+Qs+"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id C85D34E42D78;
	Thu, 28 May 2026 09:09:34 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9D75260495;
	Thu, 28 May 2026 09:09:34 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5DEF410888C9C;
	Thu, 28 May 2026 11:09:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959374; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=t/XyCD+6bs97zFnYzJuari1Ec9xU05fRhaIvDYXeox4=;
	b=Zv9m+Qs+Ju5JVYF7Dcl75xPN8vrLC7MWIcm2TDudb7ys2tEzZNBhH8BFP06dViDY92s4nZ
	92MvLQtwTJm2gWr42tmCptqY1yCdfPw3p7SWgcTX4Rcivy49rf/KJrRcHZFrP6/Xl5HvZA
	0D0eNZkguXgWMKIcNoFyB0TnDfun8UK/NWcTwu0UEWTqlasiluvmxI4MO22xIAv2qZpUgB
	nZAJt1NDdjQj/tvZbQTeoFBy9fhXFva9fJ+pwhowkbVL+x9dzRlG+VLG+XL/XQTmhngvAn
	uqhxdx0sM7jcNM3wFFY8qs3/NgDDCN61eWy7BorxnWhVssSBJ7aVJrOqBOGo5Q==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:25 +0200
Subject: [PATCH 12/29] crypto: talitos/hash - Convert to init_tfm/exit_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-12-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=2096;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=ZXe65ajiA2xhqUjYaTc5+KBF2tDu7XgEiIFo9uwwF0w=;
 b=HmLNBoBBiIH/SSeHbun3kOZjlXsVQNGh7yZJMT4aD+nSr+uvDH5BHEgo96FmvwgvIOd3fem42
 eHUuZd4KfrEDFLftAZaTILspES9fnsw8KLaj5+6loflGlaKimpcqSn3
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
deprecated"), both cra_{init,exit} are deprecated.

Switch hash from the deprecated cra_init/cra_exit fields on crypto_alg
to the preferred init_tfm/exit_tfm fields on ahash_alg.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-hash.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index 3793b6fd5b75..f7f6f01cfddf 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -531,22 +531,26 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
 
 	ctx->keylen = 0;
-				 sizeof(struct talitos_ahash_req_ctx));
 
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
@@ -842,8 +846,8 @@ int talitos_register_hash(struct device *dev)
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

