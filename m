Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE2338422E
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138049; cv=none; b=EQRrUdpTZBcZU/taqkYYpawJBklMWOGrBwuNlOtPK/hP3mJUDZ66Gq3GfcNQwKfNNPSUiDZ+MxYPg5f066Ue1VspW2GBYmArDK5j+IoDyaNTYXJEnO9tfgwiNwA1UOLO62dywYR1RQezv4vtpxvo2piKqIAA7ERni6KsCdCT/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138049; c=relaxed/simple;
	bh=QPB30l6pOTb5cjOFkBtVbtlMonRMr6cNSW6KB+4/k8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZN1G/yrXaonrSq/b/2481Rvd3U99qsUCdrFmE++eBbK8mX0x2+JWrQaFRHj5vl0D4lW2Doy4TZenTq8v8xkabb804j1ebp2N877FP0n1M9cWcsIn6mHrMmspebShm9sXkrOamx+pJRgxNop6QiZGSIRSrsIGIEvXwXxSaIleDJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=agbDLgIC; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="agbDLgIC"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 64FD84E4022B;
	Fri, 11 Sep 2026 14:47:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3ADEF601DE;
	Fri, 11 Sep 2026 14:47:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 13FA311C7AFB0;
	Fri, 11 Sep 2026 16:47:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138044; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Wg/hbB/aevRwusQ+tbFfw+UWBx2z9HVCOk8V2JP2Z38=;
	b=agbDLgICC5peYVwf0hLQ2PFiWtGnCWC/EwQbrC6QRXKPW9uyy8OKN7V22GfJJ/F4z5kdGK
	zGiIr5G6diwZ3fACgbLQQ8WZSF06WJb03Y3A1rpkcLvHpw1ABjxkT0eRsMiKwDMDv63s4O
	QC6dzL1mQAXzL2uDZQXkTo4/c8v3MLPFWhNaQG8CHntDiCX+6wXyB3K2GSk9wuX1QcHtnD
	B6UTsWjqNT3WytV0HFAHikxVKWApcw3wzoQ/K6tsfE0OPCfChR2QXPgdKqqYudtbn8llbd
	Kb4DQ0KP8e2ZILEwrSijXDlkZI1iSGDodTyc6rtgFECbxRz9qoWLJYj8InBt3g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:26 +0200
Subject: [PATCH v6 09/19] crypto: talitos/hash - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-9-4215f347c97a@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=2077;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=QPB30l6pOTb5cjOFkBtVbtlMonRMr6cNSW6KB+4/k8I=;
 b=QKDBUeOROdS6i1aBWBIenPVBehKJEdphNcy+AQtuo9pqfQvRWysXQ3rmYQIBdc8ypJ/uGXWqO
 QbO6YfJ3KhaD0kYZlaXy1jIGQcOKKduU9Zfo0fDQdVDaXwMnVdRdz4i
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
index fb4af03bec69..4224563ac701 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -541,13 +541,13 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
 
@@ -556,6 +556,11 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
+static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
+{
+	talitos_cra_exit(crypto_ahash_tfm(tfm));
+}
+
 static const struct talitos_alg_template hash_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
@@ -794,8 +799,8 @@ int talitos_register_hash(struct device *dev)
 		ahash_alg = &talitos_alg_template.alg.hash;
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

