Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B63AD526;
	Mon, 20 Apr 2026 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691990; cv=none; b=aMjITaboSr9KndwjiT4r3aGZXiJOWNdEabJ4XZnHmI6A6Ev2o43C0wowBrrzfOcEj3Jl9++HsQB/XwV/qvWzoektg3mdB9olEC4I6icP8g2YUHf0lDzq2W8gr1E5mBTi7UmnJTpvLL44HJNuL4bqaj9lzlRSfRjLbuCFK62BP2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691990; c=relaxed/simple;
	bh=Z7VG+RndpYxqggv6SUIxMzyuRoxRIcw2HC5uN/l7rYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBFAfeJYuR+cc26Do2vkau/5UlZdF4ACiyKAb8zt6Xt8Wy63paAdAQrCo0IFq5i3anoq9wHVrNrly3FD3l+0qahWVVoCClFOyVXdgj3rajEZkRA7YVbhIr/j+92fL3tA9A9Pskf8wetPqBR3ZFlNU8kS3W8F5hO/ZbFtDrNE+R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dm875wzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dm875wzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58B4C19425;
	Mon, 20 Apr 2026 13:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691990;
	bh=Z7VG+RndpYxqggv6SUIxMzyuRoxRIcw2HC5uN/l7rYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dm875wzQgvVVXM5Dfk5dpJggw9UwFqvt4TFyGcwkVDNdCRRIgJPiDlwMaYMZiWuKX
	 g/+sDwIpCVmZPZXqQzSMnwfzxL3fVLQEE8mFlX7R0zgr3btt9pY8IzlCcqBcVy98ys
	 Mvf0QHzjR4lhXa7NH197PrZ3hnZGDxrdz9Y8GzKUAJ/jmYHbMvEoZxSLCrnkbaFOlP
	 SaMukWIya9EX/5rGXZYoZGxQCu0SR4uU+fUQYHzsFaoqBgHhnPZyvAQ5tjTMX/mmS9
	 KUWdy1mhnPx5dfZhHrKqwYq+ijflGLL+VtCpXpVpPO547gZ5BmhgJm0iSmz/ib8fLH
	 eUZQat+xx9asQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Douya Le <ldy3087146292@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	smueller@chronox.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] crypto: af_alg - limit RX SG extraction by receive buffer budget
Date: Mon, 20 Apr 2026 09:21:43 -0400
Message-ID: <20260420132314.1023554-309-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Douya Le <ldy3087146292@gmail.com>

[ Upstream commit 8eceab19eba9dcbfd2a0daec72e1bf48aa100170 ]

Make af_alg_get_rsgl() limit each RX scatterlist extraction to the
remaining receive buffer budget.

af_alg_get_rsgl() currently uses af_alg_readable() only as a gate
before extracting data into the RX scatterlist. Limit each extraction
to the remaining af_alg_rcvbuf(sk) budget so that receive-side
accounting matches the amount of data attached to the request.

If skcipher cannot obtain enough RX space for at least one chunk while
more data remains to be processed, reject the recvmsg call instead of
rounding the request length down to zero.

Fixes: e870456d8e7c8d57c059ea479b5aadbb55ff4c3a ("crypto: algif_skcipher - overhaul memory management")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 crypto/af_alg.c         | 2 ++
 crypto/algif_skcipher.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 3236601aa6dc0..6867d177f2a2d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1229,6 +1229,8 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 		seglen = min_t(size_t, (maxsize - len),
 			       msg_data_left(msg));
+		/* Never pin more pages than the remaining RX accounting budget. */
+		seglen = min_t(size_t, seglen, af_alg_rcvbuf(sk));
 
 		if (list_empty(&areq->rsgl_list)) {
 			rsgl = &areq->first_rsgl;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 82735e51be108..ba0a17fd95aca 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -130,6 +130,11 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
+		if (len < bs) {
+			err = -EINVAL;
+			goto free;
+		}
+
 		len -= len % bs;
 		cflags |= CRYPTO_SKCIPHER_REQ_NOTFINAL;
 	}
-- 
2.53.0

