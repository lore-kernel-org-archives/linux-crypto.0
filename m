Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849104963D5
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710483; cv=none; b=jTelXhYSXDi4DyRGzo2tMr/HtI9+ovzltL1uEp0rRJOBHRx/vw2Et6T2K92h7Q0plORIe6ODVqJOK7LCcev8gaeQmkd3wG1x2YXc4VHylDT+x6pmvMznAQEuZWKeCufjpWTWXuK4XIeIbTjuFffDWgYr8+GN0mNZpUiF0tIGWyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710483; c=relaxed/simple;
	bh=UsgMeXb+xD450DlXo0sUNp1f3i6t+UL4yiUGMQwHJD4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AA0JoKPM3kwONcaTo300PBceV8VE43geezCNB2+SnhT/f3w2/NALGRES663rdEco8s+XP2mGP9hEvGkjesdISYhHVdioR/uUpfoLa1fTpccnEgFcN7HzuuAqz5B/e7IOKWYk2thXcEZ7LuIuRxxfAln4nlB2r2smpOpGkqaw1DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=UnVk9pwu; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="UnVk9pwu"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 042B04E40EC3;
	Wed, 22 Jul 2026 08:54:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id CD41360388;
	Wed, 22 Jul 2026 08:54:39 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2147511BD3A6A;
	Wed, 22 Jul 2026 10:54:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710479; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=06dy/eE9MMgD6V8DX2mp1KbEd1TIQFh8VpE1PyHmcIo=;
	b=UnVk9pwuDAm5deKgChydivdZdovLMVTNZvNgTklPgN2+CBHVGdoCpPu+zhZuKACJ/aIb9Z
	9ryG5PVGz90UsV4CdD8gr3VC41RfM4btdpWei6AWmCDNzMtu4drlB6hjI8oqs8kAN4ThRt
	HQwegNAZv5ZExEQk/treZ85Uk0QE8Ou2ZYFaHORzkh5W+zqxrICdNqsxsYiFx9b2W/aeyu
	0oOTqX70uvy11Yq7nD615f7DOY7bey3K2yJB9NJGtEB9l53jGBwkEPNtmEONLE3qrA3+D0
	34A5cljLPQdvsqRgYyN1HiCLSfYhRdV+0kgXpmOz1VaECw3C6yfYO5+lCDhAxg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:54 +0200
Subject: [PATCH v4 10/19] crypto: talitos/skcipher - Convert to
 {init,exit}_tfm type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-10-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=1562;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=UsgMeXb+xD450DlXo0sUNp1f3i6t+UL4yiUGMQwHJD4=;
 b=fiyKhAA/rgOvvtpoo/gDC71C96kgqSAQXujhiRX4jQRs/YIlfWWiSbvo1LdjvpUML+Zk5AQjx
 unSVIFiHh2nBUkvnw/5U5IH/BBCmngCrcF3nhaSwog10nwBdTbwdrYS
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

