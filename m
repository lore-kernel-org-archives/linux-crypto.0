Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F6136998F;
	Thu, 11 Jun 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163423; cv=none; b=scrDx4Xqhpzo7ioWy21eWpUpXq+/1tAXFDQQgdIfKbPxVLTtIHq2PJjFq9kq/B7v5G20PHFVG+jkrex2mbeBhRAWvpqljfrOL1q24DoJvABY4yJwJ2noOb3bGIKf+asbolAwS2St+tcNBJXX3bQzZ2CXj0tUnCicLXJKI/a00V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163423; c=relaxed/simple;
	bh=/aOt6ilKvs2Xn3al451wtes+y+ROCFB98cxB+u770XY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GbB51wPth/ch6bXa2lPalyySxrPtsS0DT+j8gLobNPdbrAsAVOwCbgsf2sxnbALItCdaSIqbb+rqOhriTeCdEoqDJCt1IsAbJVaDTSXzkLZOr6SGKmkgiBACmnWSZ29evj/wOf/NhMtE2FpiRl/uHSHs9WMyngcPTuBuL7vi3m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=f7M/yVCN; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="f7M/yVCN"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 1F08F1A38A8;
	Thu, 11 Jun 2026 07:36:55 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E7D105FF03;
	Thu, 11 Jun 2026 07:36:54 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9DB73106B9E51;
	Thu, 11 Jun 2026 09:36:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163414; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=QsAI9MzXVbQabqOwQeJgMBcD/ieloKhi8svZQnWEADY=;
	b=f7M/yVCNIjmZ/plef6hqJ163YC1rOliM+1RJldozjpoWk8L3NPpCQ/NQVyUv4zh3Lv6crd
	USnt0VApqkOwWX7Sg182dlEvqcUhw4Wpqunsvp341dYfv37Qc6fONfZ+r3kp9BKyYFKRgl
	Eh8oUxPTRXuTbtBo6M8OlZcwOdEX2nYQOXRA9GzCCCR5DRPF2uDpJmaVUT0eIyWp8erBII
	bYwHb8fLWT5ji8b5Pzth957By5U0momREkt5vPpz7a7TSom3GpZTyaSXxHZBywuSkmxvNj
	xrThdLVxWAQM6skh/YXMlX3c5QnhOat0VmjT2PKYzqQd4l6zDE8avFUHORbvEw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:36:05 +0200
Subject: [PATCH v2 11/19] crypto: talitos/aead - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-11-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=1446;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=/aOt6ilKvs2Xn3al451wtes+y+ROCFB98cxB+u770XY=;
 b=k9bALbJR/pZM80C9oXByQlXXIEWkUr9SFSGIvYyXWspjG8xy/JZ19ZChe+27n2WXVQaa4z4uF
 9OR3WGPnSVhBkArQGD+UrXbjC1R016IZBQ9hHQEiuMhKj8mojyrWuTI
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
2.54.0

