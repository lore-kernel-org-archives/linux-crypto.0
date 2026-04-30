Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6775B377EA7;
	Thu, 30 Apr 2026 06:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531075; cv=none; b=diBP78qfhlb3DaYrfbmuP/qZ9VZcae24s/3sWkcecqsi+owxdUxfVoskIwi7b4xemwgTW0tofkzysplaSWYzwsQ2+q9QRmEnK1mRbrHjfyF2wgzxcUkbSBsL6bKtwCq0oNUa/ozZMlTawkUxMs3euhlAF+VSthyvsVLunMZmuJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531075; c=relaxed/simple;
	bh=5yS50DCmF4JYOgA+IHxe+MvDu9T/o32vZnmBK7d5dJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7jmkmMzBeuuCv/uz6GITwK7jzLSdGiBTd8Jpu5u/2EoPdTB7qngeEOpQGasStkyZDNuk/GaW8h8rYFkyDbR5Lq5+Aun/zDxA2PU9rokzU/y6OpXC9FwmqwCDC0JeH3pYJ9mlkatHNhSvBt7kmvBVulLStmKHLrUebfWoEfc2Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWYqo0kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWYqo0kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E12C2BCC6;
	Thu, 30 Apr 2026 06:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531075;
	bh=5yS50DCmF4JYOgA+IHxe+MvDu9T/o32vZnmBK7d5dJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWYqo0kRs7bVFn3Qs+5u/jazvPxpR+6H3O2oT9Fmw3SoZx63pybphtLo8KMH6lh60
	 F+VLimB806vOU0Mg1AvA7VMy5gXnWOy6pRMLhfZkBVvq1jplU8yZjc0ypP2xL7gZne
	 lFjE6dP7v1/d7Ypu7i3Cl/Xj8smaVIHgmHFq1OclnGcthCQF5DZcztcIeFOuSokdno
	 FOruCGU5LXiBQcxYwqcfYtRoyIeIzAgQKHxUdgH2FhPsAzyxQ9mXk/Ht4QlZnwSajS
	 M1jhmM5P/MsuxtGtKejEX68V50PCgTmoz6yCNNZFCqe2RypPpdPMZ0O+ZqdRpQSxRD
	 UVnH4QYOICrTw==
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
Subject: [PATCH 5.15 4/9] crypto: algif_aead - snapshot IV for async AEAD requests
Date: Wed, 29 Apr 2026 23:35:59 -0700
Message-ID: <20260430063604.173525-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430063604.173525-1-ebiggers@kernel.org>
References: <20260430063604.173525-1-ebiggers@kernel.org>
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

