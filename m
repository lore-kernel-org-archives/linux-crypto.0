Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA103AC0C5;
	Thu, 28 May 2026 09:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959379; cv=none; b=YQWXtFB8Qhxdb2rb0VUsoOj236qcgRrHRj/MOxr/RDsC3uwwHbZZ8k6MGPCq6uRY46cU8yoJP5YlBbeW4p/V7rCSnAB//9KQaJR3VyJxp2AxlL0V7s0J3mnjCS3M4HLm/OaM25zJBngF92rravNSuuPW++aQq+p71GuNkR2pxSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959379; c=relaxed/simple;
	bh=904WpYOHZPsExOaDAxUlwzazB5kY+aW5rChymNFlCic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kt86m+J91AZ87pC/waWHxrCu1VCgR8fehmHXiej1BA/38JlpLwNtjjga3fQvujlo/9rhO6CfBb+fSR7LkF8xTHnYUKfRKrSqTJ8tCyZs69zY+eWWZ4U5x/s32pB3PNhze1URot7fmdXktkApcvPs9Ho7VQpVFL/SnoLQNqutcOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=cGzQsD9v; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="cGzQsD9v"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 317201A36FC;
	Thu, 28 May 2026 09:09:36 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0723060495;
	Thu, 28 May 2026 09:09:36 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8B82A10888C75;
	Thu, 28 May 2026 11:09:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959375; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=NAXDwi3B7w8PYJPqZf+jnonoJaMavnNfwWf4SNnY4wc=;
	b=cGzQsD9vflxRvTwJtOp42O0rtOQzkPdtfIohXkyRCah0fGSLT3C45nLOIuITkVy5n+6sie
	tWfDuf61PDlqrq220KDnu3LLlWYF1Bb1IHOPNLHUiDmFrSmKVlx05CZZWz3nDcBKRg9EyR
	6WsrB0mDX/dvbsWO/NLpwSoDO5whTb3tJUifI3Sgbv+69mufvINUaLQ2BsyzXXX1UKXFem
	kXULJuG2GK1NhoSCus4RIMZd6AHdoM6cRX1f/fHvMEbx3p21Fvuu8LkRr16m5MEoVf52Y2
	XOyTSMpJMG1C8ID5h8S2SjuR9ierpontsM82xmBNT5PwYFguwgQgz3tIIAp5Tg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:26 +0200
Subject: [PATCH 13/29] crypto: talitos/skcipher - Convert to init/exit
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-13-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=1541;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=904WpYOHZPsExOaDAxUlwzazB5kY+aW5rChymNFlCic=;
 b=B3Y9ilcTC/x68gzURX8cTz2PxBs3fr2Ngx1cLhdVRptDxME+5FmRZJ/LPOCVHVCn+/ICyJuEB
 4cKlRHVIZ3qD/a1E7r1ohUtu/PmUq7Rv0AqE+VS0fzqT8qpBrmeaUaF
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
deprecated"), both cra_{init,exit} are deprecated.

Restore the type-specific talitos_cra_exit_skcipher() wrapper and use
skcipher_alg->exit instead of the generic cra_exit field, matching the
pattern used by init.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-skcipher.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index ff7b8f9344c4..f86a0a9a0ffe 100644
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
@@ -410,8 +415,8 @@ int talitos_register_skcipher(struct device *dev)
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
-		alg->cra_exit = talitos_cra_exit;
 		skcipher_alg->init = talitos_cra_init_skcipher;
+		skcipher_alg->exit = talitos_cra_exit_skcipher;
 		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
 		skcipher_alg->encrypt = skcipher_encrypt;
 		skcipher_alg->decrypt = skcipher_decrypt;

-- 
2.54.0

