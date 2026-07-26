Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A627837B02E;
	Sun, 26 Jul 2026 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785053741; cv=none; b=KcjxPeX0JPRs4GKeh4hgAN4hdTwd5sgE0e0dlE4ROHL0MT7oMQb5ZbyNqkQF5hySwYe19qX/Np4ifJByyxb3o9uMpw8uB05kUmaMLPgh9IBrA+3qBPjPwJQT/0wOyg+BEXZFPp+pWTrJjFNSo1dAkOr+bkjcbDshTp+RIgmLSAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785053741; c=relaxed/simple;
	bh=qFDTchyUHpjS4tPMT1rg6kIpUKJsEwRkeOwrIUhd1j8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CgQN3BypXt3CdpihCRhblHnHhshD4ZDR4fWSI4PvD3nkGoBO610xzQBkPEtlsWmpNkifoedGGpy93zUrEz3vcK1iXEUVxk8TEq9FFHMPSQL6dhYGxTKei8McoH6fcpCSUjrlXzy2MkhEqSulqR9qkj4+dAZPsJw9BgO1F2Ohoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 0C4382698C1;
	Sun, 26 Jul 2026 10:15:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id UfAQ8uz0xiIN; Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 85AA62698C2;
	Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jzb6PTqNa37D; Sun, 26 Jul 2026 10:15:17 +0200 (CEST)
Received: from nailgun.corp.sigma-star.at (85-127-105-26.dsl.dynamic.surfer.at [85.127.105.26])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 1716C2698C0;
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
Subject: [PATCH 1/3] crypto: caam: Fix DMA mapping leak in the cbc(paes) job path
Date: Sun, 26 Jul 2026 10:15:02 +0200
Message-ID: <20260726081504.2182951-1-richard@nod.at>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

For a protected key, init_skcipher_job() maps the second job descriptor
so that the blob decapsulation descriptor can jump to it, but keeps the
address in a local variable. Nothing can ever unmap it, and the buffer
it covers lives in edesc, which skcipher_crypt_done() frees while the
mapping is still live. The mapping error is not checked either.

cbc(paes) is reachable through AF_ALG, so an unprivileged process leaks
one mapping per request, exhausting IOVA space or swiotlb buffers.

Store the mapping in the extended descriptor, release it in
skcipher_unmap() and propagate mapping failures to the caller.

Assisted-by: Claude-Code:claude-fable-5
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/crypto/caam/caamalg.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c
index ddbd60cf3..c83d28509 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -983,6 +983,9 @@ struct aead_edesc {
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @bklog: stored to determine if the request needs backlog
  * @sec4_sg_dma: bus physical mapped address of h/w link table
+ * @desc_dma: bus physical mapped address of the cipher job descriptor t=
he
+ *	      blob decapsulation descriptor jumps to (protected key only)
+ * @desc_dma_bytes: length of the mapping at @desc_dma
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tabl=
es
  *	     and IV
@@ -996,6 +999,8 @@ struct skcipher_edesc {
 	int sec4_sg_bytes;
 	bool bklog;
 	dma_addr_t sec4_sg_dma;
+	dma_addr_t desc_dma;
+	unsigned int desc_dma_bytes;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[];
 };
@@ -1037,6 +1042,10 @@ static void skcipher_unmap(struct device *dev, str=
uct skcipher_edesc *edesc,
 	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
 	int ivsize =3D crypto_skcipher_ivsize(skcipher);
=20
+	if (edesc->desc_dma)
+		dma_unmap_single(dev, edesc->desc_dma, edesc->desc_dma_bytes,
+				 DMA_TO_DEVICE);
+
 	caam_unmap(dev, req->src, req->dst,
 		   edesc->src_nents, edesc->dst_nents,
 		   edesc->iv_dma, ivsize,
@@ -1313,9 +1322,9 @@ static void init_authenc_job(struct aead_request *r=
eq,
 /*
  * Fill in skcipher job descriptor
  */
-static void init_skcipher_job(struct skcipher_request *req,
-			      struct skcipher_edesc *edesc,
-			      const bool encrypt)
+static int init_skcipher_job(struct skcipher_request *req,
+			     struct skcipher_edesc *edesc,
+			     const bool encrypt)
 {
 	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx =3D crypto_skcipher_ctx_dma(skcipher);
@@ -1365,6 +1374,13 @@ static void init_skcipher_job(struct skcipher_requ=
est *req,
 					    ivsize, encrypt);
=20
 		desc_dma =3D dma_map_single(jrdev, desc, desc_bytes(desc), DMA_TO_DEVI=
CE);
+		if (dma_mapping_error(jrdev, desc_dma)) {
+			dev_err(jrdev, "unable to map cipher job descriptor\n");
+			return -ENOMEM;
+		}
+
+		edesc->desc_dma =3D desc_dma;
+		edesc->desc_dma_bytes =3D desc_bytes(desc);
=20
 		cnstr_desc_protected_blob_decap(edesc->hw_desc, &ctx->cdata, desc_dma)=
;
 	} else {
@@ -1377,6 +1393,8 @@ static void init_skcipher_job(struct skcipher_reque=
st *req,
=20
 		append_seq_out_ptr(desc, dst_dma, req->cryptlen + ivsize, out_options)=
;
 	}
+
+	return 0;
 }
=20
 /*
@@ -1933,7 +1951,12 @@ static inline int skcipher_crypt(struct skcipher_r=
equest *req, bool encrypt)
 		return PTR_ERR(edesc);
=20
 	/* Create and submit job descriptor*/
-	init_skcipher_job(req, edesc, encrypt);
+	ret =3D init_skcipher_job(req, edesc, encrypt);
+	if (ret) {
+		skcipher_unmap(jrdev, edesc, req);
+		kfree(edesc);
+		return ret;
+	}
=20
 	print_hex_dump_debug("skcipher jobdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
--=20
2.55.0

