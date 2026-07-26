Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB08175A8D;
	Sun, 26 Jul 2026 08:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785053737; cv=none; b=q+LeMDAz9Mp9Ib/sRj5Cmy8W0SYaNJaURYJ+1M2Jozgx3DD27oY4hzruGVfAJm2uyt5oShkfHDNYpciFB5c+O257U9H2VIfVao2Y8N7dnVA6+NhOFvX0jyBQdXLqLba8UbdOyhFYMSIcCC8fwSuxOUMSLU4bEsaJ0MJE9fqYcW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785053737; c=relaxed/simple;
	bh=Zgq5KPhSq/Z9E3E2rL3Iq0hhgMf7Rf2g/ESAQD2ocVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CatAO5F1NYZ5M/bnAPZpr6eNHfxz5rESmhcTw3wRewIq5NGsBOYXE+bvwNsgaXUF5uDqliDoGLP6JQN0xSTRBdDsrGPR5eF0vEIiO//nbjfLrZ2pXmROZoDSSc3lg44B63M/FeBnYUFQTJ3PKkRGEFeiycRBPmWpaYIdanxe6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id B5B822698C3;
	Sun, 26 Jul 2026 10:15:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id LIuLv-xWzz1V; Sun, 26 Jul 2026 10:15:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 4C3C52698C2;
	Sun, 26 Jul 2026 10:15:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EunRVLkL_aCp; Sun, 26 Jul 2026 10:15:18 +0200 (CEST)
Received: from nailgun.corp.sigma-star.at (85-127-105-26.dsl.dynamic.surfer.at [85.127.105.26])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id DDF3F2698C0;
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
Subject: [PATCH 3/3] crypto: caam: Validate the protected key header in setkey
Date: Sun, 26 Jul 2026 10:15:04 +0200
Message-ID: <20260726081504.2182951-3-richard@nod.at>
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

paes_skcipher_setkey() trusts struct caam_pkey_info as supplied by the
caller, which for AF_ALG means userspace. plain_key_sz is never checked
against the key material passed in, yet the blob length the hardware
reads from ctx->key is derived from it, so a short blob makes it read
data a previous key left behind, outside the range synced for the
device. Require the two to agree, and reject non-protected keys.

key_cmd_opt is OR'ed into and never reset, so KEY_EKT survives a re-key
with an ECB key. Assign it instead.

Nothing accounts for the CAAM_CCM_OVERHEAD bytes an EKT black key adds:
AES-256 CCM blobs exceed max_keysize, AES-128 ones are decapsulated
truncated, and caam_process_blob() encapsulates only part of the key.
Reject CCM until the length arithmetic is fixed end to end.

Assisted-by: Claude-Code:claude-fable-5
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/crypto/caam/caamalg.c | 52 +++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c
index 8826797dc..d00caa9cd 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -797,6 +797,45 @@ static int paes_skcipher_setkey(struct crypto_skciph=
er *skcipher,
=20
 	keylen =3D keylen - CAAM_PKEY_HEADER;
=20
+	if (pkey_info->is_pkey !=3D 1) {
+		dev_dbg(jrdev, "not a protected key\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * An EKT (CCM) black key occupies plain_key_sz + CAAM_CCM_OVERHEAD
+	 * bytes, which neither the key size range of this algorithm, nor the
+	 * blob length computed by cnstr_desc_protected_blob_decap(), nor the
+	 * KEY command length in cnstr_desc_skcipher_enc_dec() account for.
+	 * Encapsulation has the same problem: caam_process_blob() stores only
+	 * input_len bytes of an input_len + CAAM_CCM_OVERHEAD byte black key.
+	 * Reject such keys instead of submitting a job that is bound to fail
+	 * or, worse, to derive a key from a truncated blob.
+	 */
+	if (pkey_info->key_enc_algo !=3D CAAM_ENC_ALGO_ECB) {
+		dev_dbg(jrdev, "unsupported protected key encoding %u\n",
+			pkey_info->key_enc_algo);
+		return -EOPNOTSUPP;
+	}
+
+	/* Validate key length for AES algorithms */
+	err =3D aes_check_keylen(pkey_info->plain_key_sz);
+	if (err) {
+		dev_dbg(jrdev, "bad key length\n");
+		return err;
+	}
+
+	/*
+	 * plain_key_sz comes straight from userspace and determines how much
+	 * data the hardware reads out of ctx->key, so it has to agree with the
+	 * amount of key material actually supplied.
+	 */
+	if (keylen !=3D pkey_info->plain_key_sz + CAAM_BLOB_OVERHEAD) {
+		dev_dbg(jrdev, "blob length %u does not match key size %u\n",
+			keylen, pkey_info->plain_key_sz);
+		return -EINVAL;
+	}
+
 	/* Retrieve the length of key */
 	ctx->cdata.plain_keylen =3D pkey_info->plain_key_sz;
=20
@@ -806,19 +845,8 @@ static int paes_skcipher_setkey(struct crypto_skciph=
er *skcipher,
 	/* Retrieve the address of the blob */
 	ctx->cdata.key_virt =3D pkey_info->key_buf;
=20
-	/* Validate key length for AES algorithms */
-	err =3D aes_check_keylen(ctx->cdata.plain_keylen);
-	if (err) {
-		dev_err(jrdev, "bad key length\n");
-		return err;
-	}
-
 	/* set command option */
-	ctx->cdata.key_cmd_opt |=3D KEY_ENC;
-
-	/* check if the Protected-Key is CCM key */
-	if (pkey_info->key_enc_algo =3D=3D CAAM_ENC_ALGO_CCM)
-		ctx->cdata.key_cmd_opt |=3D KEY_EKT;
+	ctx->cdata.key_cmd_opt =3D KEY_ENC;
=20
 	memcpy(ctx->key, ctx->cdata.key_virt, keylen);
 	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
--=20
2.55.0

