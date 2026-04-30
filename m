Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D5374730;
	Thu, 30 Apr 2026 06:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529355; cv=none; b=GmYRqOD0VUoVBsN04RMGi7k6GY55u+IZwMMkf0vuPmt7s9yyV3OApSEvWQ2W0OV42s9LOfUVkSjaRCQa2wtr7RP4mdN0SZXj+he00Lz7ro4gSyocAcjCreGeJ3N6lo/ajbgRU6L9UIMY/Vsx8sQrHvDkVVrhRfvkLbqcxLpn1Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529355; c=relaxed/simple;
	bh=9r9tmvOodAKZ9LmDXkwNmUXO63ENFACO0hGPGKlQtMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoUFxSX5l69ONiw2qAhm1/jWmJxrNGWa7IZE3wVU1jIJSa0rRs3YQSh7MusjRwJ4RIMuG07s605C4JHijVuW7n5oM9+glcz7muBXQB31DwOwVWd3DfzeIDBUE5z5cSy96jmo32kDe/Em55uUU/jxLkhR3mgc3GTWZVJj+B9CUCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdH/eoe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdH/eoe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3907EC2BCB9;
	Thu, 30 Apr 2026 06:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777529355;
	bh=9r9tmvOodAKZ9LmDXkwNmUXO63ENFACO0hGPGKlQtMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdH/eoe0p6eKba029curi8Nhb7Bdn4oC8pqL9VebmN+nOq1bkkLQVQKkIb7j7pISC
	 l16IrVJIzWxvJ5rb3l+XKkaInuFY9f9RHNCUDPorJgtHMvzGiN6/X2IJQYtcS+tLFr
	 XFo/pKxx10pN41lpmzQ5Pqre1I2EpE8CG6QbLLNQW8fEpjnEXbRoWyx3JeLkGJz8xE
	 YEzwZJUOroKQslVLusmb1K1Ea6OUP+Yd9jZDoMkLhcYdqdg4IOhXbP2hfulns5Estn
	 1ql3InSK3cKzJUv2a51UZXtKyJ6OGZvLthQpEixR5BYJ5qCNFSBh4hmtVOxqI4ynVy
	 1V3kyq9z5zAww==
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
Subject: [PATCH 6.12 4/8] crypto: algif_aead - snapshot IV for async AEAD requests
Date: Wed, 29 Apr 2026 23:06:58 -0700
Message-ID: <20260430060702.110091-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430060702.110091-1-ebiggers@kernel.org>
References: <20260430060702.110091-1-ebiggers@kernel.org>
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
index f8bd45f7dc83..cb651ab58d62 100644
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
-			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
+			       areq->first_rsgl.sgl.sgt.sgl, used, iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
-- 
2.54.0

