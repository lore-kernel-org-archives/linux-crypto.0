Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF6364024;
	Sun, 26 Jul 2026 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785053736; cv=none; b=H9MOnit1EIapIXphtYxcJoFoYfJwkf3oJnwdV2Yc8kocCwV2loCtIgtd/vh0M53Pl4C+icp+L/eOHy81fADcogNnTMFx218U4VU8vnhe7npescKnpTXl3iuql0k2lw3bsVZUItCc8kgnzUY41FKIdqjzqCmCNPIIUmx8I8e7/PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785053736; c=relaxed/simple;
	bh=AnzrU0GLecXQKXN1Rxhja6TknYVVrk7BRPHrzhrn/Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6oPVMhoPX/uLAZ8w86py0BSWguzf2Gazj3GjdpcnNnw9LwOoYeekJuioyegc1Qp1DtUwZLjZtxNrwTX0hPpcVy2iQVGuteeXC2VZuSthsM8z1WwwDC2r8GGiBwPv6Vepa2BnvzwENc9Bf9cdVTowvg+wQOrvMSdzSWeqizbYIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 65C352698C0;
	Sun, 26 Jul 2026 10:15:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 3NfMJODKZMM7; Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id DF6282698C3;
	Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EbUY2Z9MJbWp; Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
Received: from nailgun.corp.sigma-star.at (85-127-105-26.dsl.dynamic.surfer.at [85.127.105.26])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 78D2F2698C1;
	Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	gaurav.jain@nxp.com,
	pankaj.gupta@nxp.com,
	horia.geanta@nxp.com,
	ebiggers@kernel.org,
	upstream+linux@sigma-star.at,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/3] crypto: caam: Map the paes protected key once per tfm
Date: Sun, 26 Jul 2026 10:15:03 +0200
Message-ID: <20260726081504.2182951-2-richard@nod.at>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260726081504.2182951-1-richard@nod.at>
References: <20260726081504.2182951-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

paes_skcipher_setkey() maps ctx->protected_key on every call, without
checking for failure, and nothing unmaps it: a later setkey() overwrites
the address and caam_exit_common() only releases caam_init_common()'s
mapping. cbc(paes) is reachable through AF_ALG, so an unprivileged
bind()/setkey()/close() loop leaks one mapping per iteration.

The buffer is a fixed-size member of the tfm context, so map it once in
caam_cra_init() and release it in caam_exit_common(), bidirectionally as
the hardware writes the black key and reads it back through the KEY
command. A new is_paes flag marks the algorithm needing it.

Assisted-by: Claude-Code:claude-fable-5
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/crypto/caam/caamalg.c | 60 +++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c
index c83d28509..8826797dc 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -98,6 +98,7 @@ struct caam_alg_entry {
 	bool rfc3686;
 	bool geniv;
 	bool nodkp;
+	bool is_paes;
 };
=20
 struct caam_aead_alg {
@@ -823,19 +824,6 @@ static int paes_skcipher_setkey(struct crypto_skciph=
er *skcipher,
 	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->cdata.key_dma =3D ctx->key_dma;
=20
-	if (pkey_info->key_enc_algo =3D=3D CAAM_ENC_ALGO_CCM)
-		ctx->protected_key_dma =3D dma_map_single(jrdev, ctx->protected_key,
-							ctx->cdata.plain_keylen +
-							CAAM_CCM_OVERHEAD,
-							DMA_FROM_DEVICE);
-	else
-		ctx->protected_key_dma =3D dma_map_single(jrdev, ctx->protected_key,
-							ctx->cdata.plain_keylen,
-							DMA_FROM_DEVICE);
-
-	ctx->cdata.protected_key_dma =3D ctx->protected_key_dma;
-	ctx->is_blob =3D true;
-
 	return 0;
 }
=20
@@ -2013,6 +2001,7 @@ static struct caam_skcipher_alg driver_algs[] =3D {
 			.do_one_request =3D skcipher_do_one_req,
 		},
 		.caam.class1_alg_type =3D OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.caam.is_paes =3D true,
 	},
 	{
 		.skcipher.base =3D {
@@ -3746,6 +3735,8 @@ static int caam_init_common(struct caam_ctx *ctx, s=
truct caam_alg_entry *caam,
 	return 0;
 }
=20
+static void caam_exit_common(struct caam_ctx *ctx);
+
 static int caam_cra_init(struct crypto_skcipher *tfm)
 {
 	struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
@@ -3775,10 +3766,43 @@ static int caam_cra_init(struct crypto_skcipher *=
tfm)
 	}
=20
 	ret =3D caam_init_common(ctx, &caam_alg->caam, false);
-	if (ret && ctx->fallback)
-		crypto_free_skcipher(ctx->fallback);
+	if (ret) {
+		if (ctx->fallback)
+			crypto_free_skcipher(ctx->fallback);
+		return ret;
+	}
=20
-	return ret;
+	if (caam_alg->caam.is_paes) {
+		/*
+		 * The hardware writes the decapsulated black key here and reads
+		 * it back through the KEY command, so map it bidirectionally,
+		 * once, for the lifetime of the tfm. Mapping it per setkey()
+		 * leaks the mapping.
+		 *
+		 * All requests of a tfm share this buffer, which is safe only
+		 * because the key cannot change while requests can be issued:
+		 * AF_ALG refuses ALG_SET_KEY once an op socket exists, so
+		 * concurrent jobs all decapsulate the same blob into the same
+		 * black key.
+		 */
+		ctx->protected_key_dma =3D dma_map_single(ctx->jrdev,
+							ctx->protected_key,
+							AES_MAX_KEY_SIZE,
+							DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(ctx->jrdev, ctx->protected_key_dma)) {
+			dev_err(ctx->jrdev, "unable to map protected key\n");
+			ctx->protected_key_dma =3D 0;
+			if (ctx->fallback)
+				crypto_free_skcipher(ctx->fallback);
+			caam_exit_common(ctx);
+			return -ENOMEM;
+		}
+
+		ctx->cdata.protected_key_dma =3D ctx->protected_key_dma;
+		ctx->is_blob =3D true;
+	}
+
+	return 0;
 }
=20
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -3795,6 +3819,10 @@ static int caam_aead_init(struct crypto_aead *tfm)
=20
 static void caam_exit_common(struct caam_ctx *ctx)
 {
+	if (ctx->protected_key_dma)
+		dma_unmap_single(ctx->jrdev, ctx->protected_key_dma,
+				 AES_MAX_KEY_SIZE, DMA_BIDIRECTIONAL);
+
 	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_enc_dma,
 			       offsetof(struct caam_ctx, sh_desc_enc_dma) -
 			       offsetof(struct caam_ctx, sh_desc_enc),
--=20
2.55.0

