Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA1127A107;
	Thu, 30 Apr 2026 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530583; cv=none; b=OLeja7cmHy1dPX7j/S6iFLdISRGHSgHHcf7T0pMAUI0vUbinx9KaEo2SLkGeyaVYVGqo+gOcS36BYWQWTeUZb1Bt/IyKqk5qoUuSn/aNtUxEbuSh+qeSzelpe3z0nOqZyvOxB3VHwGbI3s+gAAYXUSoL8A+stUGh5KXXdshdLzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530583; c=relaxed/simple;
	bh=5yS50DCmF4JYOgA+IHxe+MvDu9T/o32vZnmBK7d5dJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWlqT56hEXPHH6/0d8sHwWldlZeTrAZt2NnvuUEb666uHDZC0KOJ6g699e3sloCQUSHibcanfcS5DVGYTmH4ETqh6MGcBvKh0VaUKU6wq1zCEzyqiLUpp0NPLqv/66LU5q2857HfBQEoWTXU9APbPpljAbz99kiH/mxrBm0X0wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTRwJTZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTRwJTZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4452CC2BCB9;
	Thu, 30 Apr 2026 06:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530583;
	bh=5yS50DCmF4JYOgA+IHxe+MvDu9T/o32vZnmBK7d5dJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTRwJTZ4cAnSUxWc+Zz7i0MNNvhDjgLDpgP7kqqtUoJhELM8YQrXmrsqsY2YncccC
	 AgtNxN3re58Mb771dKa5uEquG/YQV+FnGnHOrA8q+CLfqYLZCI31GvtjrYw+Kd5Y4L
	 9kyz64rtCaN7KI9M9M9o4ZPjWGwy/6CU121UpWfIfUUBRCMnKM7xK8HicV5UrvRfBx
	 nhr/JuOoPaWlUjF/pmUbuxiU34dX5a1gWX1Yf+uE6uEYAzm/eA6ecRKu4qeBMZ7CL7
	 KxZcPY/Y3K3rLPnhw/+qCuRQ3pKoFWgIVa7URQE4Z8zUZOEokI/y3FRugtNkmM6jtr
	 2y2ql8G5W8syg==
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
Subject: [PATCH 6.1 4/9] crypto: algif_aead - snapshot IV for async AEAD requests
Date: Wed, 29 Apr 2026 23:27:26 -0700
Message-ID: <20260430062731.140497-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430062731.140497-1-ebiggers@kernel.org>
References: <20260430062731.140497-1-ebiggers@kernel.org>
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

