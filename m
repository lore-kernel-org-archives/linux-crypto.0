Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D8750C2BF;
	Tue, 13 Oct 2026 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897152; cv=none; b=bdRKkzM0ajEzAUiGHuC9xd8HJq+egTgUQ6DhqftDzVRD8exiA1+lEQoW3wN05I/dN4F40kmo9dE87d7KZrog0xP4vC5fIr6w65JCm70se9RYY6hB2PEjl/JBE/hzBzYjohi6qAXuMpOvBUzqWAjRlgZCzo5YmYbNlFIWIyxJT+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897152; c=relaxed/simple;
	bh=De9eulecX/w4WARa4+gc3RHmV5hI1aw3OZHiZRlNV60=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FFgSqI+xzGjMvX7XqWenO7iOAZaMPWXcf0/fdErFO38nOQvzSZr7TCrxKIleJZo7hGYjbA5nmMnjpDhV167dLbKrKoUJjOhxeUPVl7Dubv8RhITwXXKOI1ngYsXL7/PtkYlghe5sSwN+cDhXDqk3Vdo+HKUxrtJyD9RucTcyLTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=w58V960/; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="w58V960/"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 67D1BC653F3;
	Tue, 13 Oct 2026 13:13:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D69A860362;
	Tue, 13 Oct 2026 13:12:29 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3833511D7134E;
	Tue, 13 Oct 2026 15:12:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897149; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=bj/aDTFY4aAMV7YfatoWEf/HrkrzNN6ENAu6aBLme8s=;
	b=w58V960/JFuOEShlgMIUmE+L6CG8Eq5ZHt4xnY+PfG4OPEmyYZqMawzQpkFWLLlqs3DTp5
	o2LwZDduVTx2RD9ggDGwUCkruLeGj7svb8STy0jL7RyZeAXe61pItj87Z02EudlBJzIAr2
	j1pbNFokZWDNE3BBHt/bNFKFwpbytOd9hH5v3q2lFt+SnPgOId6R1nVv47yXzKq3LWVTbb
	8zpeSfpkSGIV2++61wYXcqlOxriy3zAcsMtrXgNSr/1vEvaSeCGPB8aheYWrkyTPwa1/RK
	tuxZvjb8BajGj3uHPtUD40gZn1DiOSCZhgneSIShxJsen40UUYTHLA1YecHqAQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:37 +0200
Subject: [PATCH v8 11/20] crypto: talitos/aead - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-11-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=1453;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=De9eulecX/w4WARa4+gc3RHmV5hI1aw3OZHiZRlNV60=;
 b=ROew81PtoGTZh2b/jC+7kCrT6tqGb0EzJb8eQX+ijCqCi1Q3/jFBPVZxkYPkLDTTw11skXbET
 AX5ybITyuvyALbtoo/F3P/0K3Xv84pd7XC1EJIRdTwi+tQp7I96de/m
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
index 0236f152743b..40d048de0502 100644
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
 static const struct talitos_alg_template aead_driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -878,11 +883,11 @@ int talitos_register_aead(struct device *dev)
 		aead_alg = &talitos_alg_template.alg.aead;
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
2.56.0

