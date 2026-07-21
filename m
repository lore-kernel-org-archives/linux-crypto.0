Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F400C39280A;
	Tue, 21 Jul 2026 13:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642400; cv=none; b=KXEeyA9whZzw9Ypb6AgfnmXs5VDCgRG92rW1vuTZ7ARxhKY36oHCfudRemuK42quWm6HahCgAjCl40o326Fgx9Hv9WnX6CLRKVb7R3X+sFpghATKKE4/Qw7/C/73DGFhKvUSpGY+uvV0ZojtqknrLu1xwqDdg9a17iJzAwigi6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642400; c=relaxed/simple;
	bh=dH3V5FzEunV71NpnVP0ViObSQfSyFk7jQKfBkvAUnWA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mTjxnMu3r63TuIAg4P/KcEUV0S8L/hKRugVbQRWvYc030Zz6KTHAXvieYZL6W5yLS3YDBzNlgRk8vf/bOYTwn/3B8a7Smiq6e1IAGr2KbRH/XdWZ+ddSGjmLLOSxVbdmqK3BNlJhgP6V0z6ETNY1c08UDiN5u2E/QW7mkUicpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=iRTwioIs; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="iRTwioIs"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id A34A81A113F;
	Tue, 21 Jul 2026 13:59:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 786F860368;
	Tue, 21 Jul 2026 13:59:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 243D011BD3A55;
	Tue, 21 Jul 2026 15:59:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642396; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=/tIL/35xhzaQ98GIYg8OANcAB6TmHi6jm7IH4IqH7Xg=;
	b=iRTwioIsc5lFirUM3XVHqJqsOhrDbD/TQh4JRNqaqzdcOGN+K7AXG9fAf8owbaj2omTy4J
	OIfeHmL5dLHue0orlaMa1VXsudc3XDUF59/dK4jPez8S1VSJNxKSy8tEz060+KDTybup28
	r1LNA4OVGmZyYMsRPYHbALvx/hJNvynGbRw0VP0Sxr0s+tFFge4ncIHP4Df7LQm/lp0L/S
	RXibgA134W4d9cTPL4A/d/bbO5NAPYvxvTYID2cAJg4H3hiWmRexL1YRrYK39G3Bs5bHLK
	dWcEcBBgNvhiJgvOk1QQtjEfjxHYSMjVVoDxfDe9NTcOZ+adlP4ZECkn2CheRQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:38 +0200
Subject: [PATCH v3 11/19] crypto: talitos/aead - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-11-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=1446;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=dH3V5FzEunV71NpnVP0ViObSQfSyFk7jQKfBkvAUnWA=;
 b=0MPLTWx/Insa6ZU+UUzlkfTq1MQ/d+WHrSXY3Vr7aRp4akTo5lj6Sm+x1cOLZtKoSYp5w6uO7
 yUokLxPz7cnDnQELjSNqEffI25lJY6vKw66/LvKImRoQ1IXr2ltSI13
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
index ced314a645db..5537f2b6317f 100644
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
 static struct talitos_alg_template aead_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -875,11 +880,11 @@ int talitos_register_aead(struct device *dev)
 		aead_alg = &aead_driver_algs[i].alg.aead;
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

