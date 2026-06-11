Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9443655E9
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163418; cv=none; b=Xim0SRKsqQCPZAtqOMEVxf0/YQknbEcm5EC5TuIrZb2wFGrCNtrNzSlGzrqGQyUzFAqVV3ENTl/3A70KdHSUKSpuE5LcO0bgf+/6hwLA+sZHPHFmaSBB82UpTi+QRp06rIx2CUVR6bfvVgOzKY2y1kYopu0NmumG8EJ0VE/+RPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163418; c=relaxed/simple;
	bh=UejnX9Pin+yT4V22urOfMFmOlcGGliOwuKA+6ZhJMS0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=REbZWUtPQ1IlxT4u0fG33xv15GefLEO+xIHdij8GK7dH3zMO4qIsdy1SCvurkxOFKPriSaYoeU5goUEYJIf24X8NhkH/8SUb9VCrB3y3/mJEhP7yvMpb/sLMSTYCM1xfzvt8gKZC9NO+CdUM0CcYYQcjoeoKMQP7H8EubxCbgbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=YiGKM7hg; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="YiGKM7hg"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 137C24E42E16;
	Thu, 11 Jun 2026 07:36:54 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id DD19F5FF03;
	Thu, 11 Jun 2026 07:36:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C5668106B9E54;
	Thu, 11 Jun 2026 09:36:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163413; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=zPu+L7NALdnBFGYxiIERs6XyteONnwsG0/uMJabYvOc=;
	b=YiGKM7hgLOOykUpGOkPFfxGtdBlGMmSjIu8D5RiJzL3Fk7tirLWg5FZgjVbU071F1RqXRi
	bJEpK9EhBD02CZ4oZwc5SyfrWdguiZeBAdJ7x8rCb0qKmCg/44KSRqgIS3YIFADzpnVzD2
	V1OtG5icBrSRT36dlMtqgayWGqZRRLTA8pr2k2NWCGH+641t8GkbGmh/Dp2cjZN4tXvp+U
	VJiSTKPBSrXD+3+TiBw8I1lvUomGTghdexuh2bTh5UyGEXa9Nr3gvBjEpGyL4Ix9j3VlIo
	kJ2dFR4GwWLmlZl0ipSVxB1hnG8vog6x9LsCaMr3+3ntOezictaIb2v6CHsn2Q==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:36:04 +0200
Subject: [PATCH v2 10/19] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-10-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=1562;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=UejnX9Pin+yT4V22urOfMFmOlcGGliOwuKA+6ZhJMS0=;
 b=UUYZ+o3AU4ARSSw8QcV4ySlUsI2xlIjDY/yWf6nU/Njv7H8UPViDSRm53nct1OrR17I2O4WSI
 ZlF+Q5MW9KYDCirAz52R/Dp9gf5KoukQvsvKImJZZ1KWxgGBZAFX51Z
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
index f80373610aa4..4c03573efb0a 100644
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
 static struct talitos_alg_template skcipher_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
@@ -375,11 +380,11 @@ int talitos_register_skcipher(struct device *dev)
 		skcipher_alg = &skcipher_driver_algs[i].alg.skcipher;
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
2.54.0

