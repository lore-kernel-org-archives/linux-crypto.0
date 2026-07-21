Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20A738D6A4;
	Tue, 21 Jul 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642399; cv=none; b=IXORTglBULeb7uAajzr3pqC1VT3WvwG/YvUdy+wLDlLPQ6EOTze5khoS4e6Rl4PHBUOJgZoRkYOttVHHuEWMnUVPkQQ68fO6Hkv+nspBz5PTwXjq6Kk3ZtELrds6brhTywmbNfK+7A3/by1WQGnPLcjQAH6QriTZ6sCCTbkFlUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642399; c=relaxed/simple;
	bh=UsgMeXb+xD450DlXo0sUNp1f3i6t+UL4yiUGMQwHJD4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kou0QF8p4GZOxkFrieGjHpS7Fwb3hGLSyDu90HS0Y+fhvFID8cTbVNYOAW3rcJzJusM1K0hHD/bZpoE+cG9PR4pFMCyQ+vJMCMcKM0I+JDkmP48nVJjXmmnfHEXlQA7bAjbcIgwd3jIxfwAHnlKbAnaYqzlcvYZgtfa9buX5DAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=TMyYvn5r; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="TMyYvn5r"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 979F71A113B;
	Tue, 21 Jul 2026 13:59:56 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6C9F060368;
	Tue, 21 Jul 2026 13:59:56 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0C0EE11BD2635;
	Tue, 21 Jul 2026 15:59:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642395; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=06dy/eE9MMgD6V8DX2mp1KbEd1TIQFh8VpE1PyHmcIo=;
	b=TMyYvn5rLS0Pzhp1kOjjKYMW3vHoagR1/RmOUkkvPpde6QE2uP7yln4vjvGiyRX69nD2yZ
	1rxBQ1PxDSIVvBkSY6+ltI2TorG5nRqtDkZkl2Ys6o8G+daiqztdibzMRAPK+8CVUm9HU0
	EhpUyRnhL1DOXQPHk4uxZmbs/SRVC+Jg5l3VWEp+v4YlKfJzxH3/+Rmt/ti4+bo2oe4oCG
	PVZ8dn8n36uyY61P85L9XdRrPQDeXg52uU9m1dplmVrAtGk5nNfAMgqe+H/5B3IyKx9HxU
	NaUUpSh1c3GGZ7Vvntj8p593S3/sHMuJvT0l8D+XObVB73NxcgCB7WyM8dhFQg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:37 +0200
Subject: [PATCH v3 10/19] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-10-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=1562;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=UsgMeXb+xD450DlXo0sUNp1f3i6t+UL4yiUGMQwHJD4=;
 b=OcHvFHmKLvhv4Sjc31raqurISNwwczeb9/v0sHNgvRr+XEvD85r45zw9o0l1S7i7Ipc+nZOG/
 40RZXi2856CCVkRXqGJm5XLn51N/xxlKlnUWc+I1GWvMbeq3N00vY7A
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
2.55.0

