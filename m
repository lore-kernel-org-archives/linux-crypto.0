Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5B4568FB3;
	Wed, 23 Sep 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176773; cv=none; b=mu4jatxxKGDd3rdAWM3FZVMco1cxCx2q0MKQFuNtVGhOATl2DLrdLPYj/uwHL42dd9B+rSZREbGExswbtDYrNZ7yvXGz5Ojy6kdb8qbCcILp1xGqTdwmdhxTR8VQpWBTZ1dnmWyOZArXLwRCpwuhauYtBJ5cfepl29HYKTnLGgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176773; c=relaxed/simple;
	bh=cFvsG8eCjUgT2nbFx8V91OE0dxvivNp44m7kLEBtKtc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WPVSdVBhDNBkG/bVsbDH3/8fdRBoDhjVv61Gv902rV+rZ6tvrdveSN5Pu7Tp4w5ywZKUQb9GwF+ZGUdQdq0CLD6qoH9AP5YUcN9Aa8MJXCnF0YC91oYdWZgAbnUt9oIyoXXu8NnOuX5cEc9jzqVZAyEklTaFwdVzsFRY0kK8A3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=KZ+FE4py; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="KZ+FE4py"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id B51BA1A0FE6;
	Wed, 23 Sep 2026 15:19:29 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 89F8B60580;
	Wed, 23 Sep 2026 15:19:29 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2642410329217;
	Wed, 23 Sep 2026 17:19:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790176769; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=C6DQNv0+LZVrJwNDxVc3/0BqftE1SZpqze//+6WBsAE=;
	b=KZ+FE4pyYOelp/9Gy2bfPM0qh8BN8mEiieywiSJEcKr5WB9fA8Zi7MHVtJa3/NF9WXw3wY
	tbj3eQMFzw7W9Z9PpLfIStX1sDjBhyBcKerTh6H3+VGCTEK4T5Foa3edU1LggXWJy30wzZ
	7F6yJgKvJkm5FaBMImJoXvY3oGnTXkH8I77wI+yMyPTP3UiIczKZCbsxrMXqPs93+fQJFm
	15VLfsbZ/Jo0xKZ6TU058nf1ySeLDrrJ4V6p48hS1Uy15dHG2cYS8DOMXEQw8Z7cKkRuPl
	3FgQMrXQfH+UA+vWtVvbNUB9mIDN/6cvspl3ne9pV3Bxee0Gf39FwRTWaI/vJw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 23 Sep 2026 17:18:45 +0200
Subject: [PATCH v7 09/20] crypto: talitos/hash - Convert to {init,exit}_tfm
 type-specific API
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-7-3-rc2_talitos_cleanup-v7-9-9a45261fc097@bootlin.com>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790176746; l=2077;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=cFvsG8eCjUgT2nbFx8V91OE0dxvivNp44m7kLEBtKtc=;
 b=1WtruxYIZq0vCCC38iYlbMU3Wvw686xhSp5FVB2w10RhmwUxAQc0PTqBWzIaj+r/jzD6N7jv6
 x+lR4CVqB5pCeONpuSXYtjPxVg6dkbM5T32kyo6AC7ekouNt2xTU3QK
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
index 7ce4e68dd7a0..97526c1ffbfd 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -544,13 +544,13 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
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
 
@@ -559,6 +559,11 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
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
@@ -797,8 +802,8 @@ int talitos_register_hash(struct device *dev)
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

