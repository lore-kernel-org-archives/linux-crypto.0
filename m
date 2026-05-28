Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2D53AB29E
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959381; cv=none; b=X4+0rdMRHoMsYiqfHXhNOsv0fseVaGQazu9XIro6Y9HzfVSJp3TEOULmXWkejJHgUo2DHvsNxyR7Bp8aglv/sQiJ9j7WCMDh5x1cIM2oFcUuLikCsjVX9cg/YDqO2tjMnl2eA2skidVj3XD6w/vS7O1xdo3vXE5nHjFGkc+jW8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959381; c=relaxed/simple;
	bh=q7qSJQDokLdcDUwXUuBg0Al0s9oooXo2HrzO8kz3Ad8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UFmM8fesAT02If7KxP+PbA6c9uXdteBqqKCv9X/f1M1f8fcYGnXet2hYLl99HKsRhGAMb2TsIknIpRlSOeWlwBKJEv/4PHLhbP0bUtqrkeAML4U0o+zJlwgMVDm0obvOMa2tcDqvEm+Qg+uykXTqCkI5nu95b+hWu5SXTneWL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=W6MpDIvQ; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="W6MpDIvQ"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 68A801A36FE;
	Thu, 28 May 2026 09:09:37 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3D6C060495;
	Thu, 28 May 2026 09:09:37 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AD81910888CAE;
	Thu, 28 May 2026 11:09:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959376; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ViNyMDYAb1KrmKBvZFYYGVbJO0qJnR0mIJIdy3shCiI=;
	b=W6MpDIvQeXeXBM4hRTTWgJbkb2SRMxULGhhYyvPRo+S0H0xQXLoIdgcgXfUZXghjiEpMuh
	xR8ZXtkNsAm8TCNJBrbV6sH9fuhge0KfqWoPJKrNIy6bgJNPfOz3KuqOuCoQ/kMGeiI6qj
	H05udIFcBLCETTQ0lsVD7Ki6vh3UYM5tBt59Xh103uELEeuBK0P/p8NMRY+Fl5msg3Keta
	NJbFS1SgCrGRVjCE4qG6bwhO6SYoN40z8dqO3LsnFbMmlRjKNn/jyXEMWXfBcu+THkwsKi
	1xjRzpXYttloxIhe1+LHPxH3NdZ2iBGCN2FWUIV4dI6e0buSNNRkD3yB4CqXYQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:27 +0200
Subject: [PATCH 14/29] crypto: talitos/aead - Convert to init/exit
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-14-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=1433;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=q7qSJQDokLdcDUwXUuBg0Al0s9oooXo2HrzO8kz3Ad8=;
 b=71yr0AJcd7OyPXQ0wNuz/1QvNYzNRZ5KPcz6dEbEOIX5JXiP7bpKGTWomILZHZ6LdBM8lIKil
 /Wafa+rtrzGD5OddWREfJxe632BXEstMcM/2jNj3FKVYhiaVo48npCl
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
deprecated"), both cra_{init,exit} are deprecated.

Restore the type-specific talitos_cra_exit_aead() wrapper and use
aead_alg->exit instead of the generic cra_exit field, matching the
pattern used by init.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index c09ed08be2ef..38df616c9b22 100644
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
@@ -950,8 +955,8 @@ int talitos_register_aead(struct device *dev)
 		if (has_ftr_sec1(priv))
 			alg->cra_alignmask = 3;
 
-		alg->cra_exit = talitos_cra_exit;
 		aead_alg->init = talitos_cra_init_aead;
+		aead_alg->exit = talitos_cra_exit_aead;
 		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
 		aead_alg->encrypt = aead_encrypt;
 		aead_alg->decrypt = aead_decrypt;

-- 
2.54.0

