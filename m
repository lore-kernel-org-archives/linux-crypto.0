Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747D539658A;
	Thu, 30 Apr 2026 07:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532612; cv=none; b=Epyvv62Y5d02rqfn+sKylCuZ86sGydY7EjBDP38B2KsO6+qrhQ4pG5p7gbSfsv7vpTJltcrzGRin/+kbGOz0ZmwPJQoi1uFvmRaEbG1m+qoVYYniciiSA6AzFHjaHPtrQSnZkIcGRRLx/0YOgDgcpEEylxvCfg+wdbeM/8ARNWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532612; c=relaxed/simple;
	bh=5yS50DCmF4JYOgA+IHxe+MvDu9T/o32vZnmBK7d5dJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4blgsmq5Zp7sktClIuV1M96wmKzaOQHxBRERrFAPC9JqM8VDz8PQdCiXH/5vh5HUYyaB/82y29ITpCoUUCT2+3p0IKADQaltm4LnCDUB62fKwowvQ7SIkYgK2u2p+L1awFQZCNdkHNyvMZ+j9E7kXJ/nkOXsvhVCMKwOVomIE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VE+Do/33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VE+Do/33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4124C2BCC4;
	Thu, 30 Apr 2026 07:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532612;
	bh=5yS50DCmF4JYOgA+IHxe+MvDu9T/o32vZnmBK7d5dJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VE+Do/33RL2KnufmnWds0g5uOzDHimYLm/qBYdwPoYomLT0C/USf97+OXtLnEjeCe
	 pd6J2M+QgG16+3dxlR4hUaF+x4vJPOCdC5Hop8iOmVOmJBVIPe7/cKVerQ4r6mjIyR
	 yeUZPmfNI+m/pwkCaIk0dAwdlPu4LsxgSAo76mSi3muqJzdj2CWulZVBfYXIHJ1uAf
	 2Z6jQqWm31LlnR9V2OKZJr0NMf1Jkj0dhTJwqftxQTkY6B5xFAiZkK84cfxHI6ec6/
	 G8LImlGJkBmdpB3Js7kzJWKIJkuud2VK/FsCQ7B3u5rkJFbhi6Ne+m17dRnvHRd4vW
	 I3IgPPjm+NUJw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Douya Le <ldy3087146292@gmail.com>,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxing Yin <tr0jan@lzu.edu.cn>,
	Yucheng Lu <kanolyc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 05/10] crypto: algif_aead - snapshot IV for async AEAD requests
Date: Thu, 30 Apr 2026 00:01:23 -0700
Message-ID: <20260430070128.219863-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430070128.219863-1-ebiggers@kernel.org>
References: <20260430070128.219863-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Douya Le <ldy3087146292@gmail.com>

commit 5aa58c3a572b3e3b6c786953339f7978b845cc52 upstream.

AF_ALG AEAD AIO requests currently use the socket-wide IV buffer during
request processing.  For async requests, later socket activity can
update that shared state before the original request has fully
completed, which can lead to inconsistent IV handling.

Snapshot the IV into per-request storage when preparing the AEAD
request, so in-flight operations no longer depend on mutable socket
state.

Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Tested-by: Yucheng Lu <kanolyc@gmail.com>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/algif_aead.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f59728c021fc..24e77f4968a6 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -70,12 +70,14 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_aead *tfm = pask->private;
 	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int ivsize = crypto_aead_ivsize(tfm);
 	struct af_alg_async_req *areq;
 	struct scatterlist *rsgl_src, *tsgl_src = NULL;
+	void *iv;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
@@ -123,14 +125,18 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 */
 	used -= ctx->aead_assoclen;
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_aead_reqsize(tfm));
+				     crypto_aead_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	iv = (u8 *)aead_request_ctx(&areq->cra_u.aead_req) +
+	     crypto_aead_reqsize(tfm);
+	memcpy(iv, ctx->iv, ivsize);
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
 	if (err)
 		goto free;
 
@@ -185,11 +191,11 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	memcpy_sglist(rsgl_src, tsgl_src, ctx->aead_assoclen);
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, tsgl_src,
-			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+			       areq->first_rsgl.sgl.sg, used, iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
-- 
2.54.0

