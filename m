Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A78F32D7F1
	for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 23:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779147436; cv=none; b=TMcoycrFjS1ILMnoJzGL50N91HuBAahX/NipEV94k9yK0ii7KNkAiVkhJOP2o19PfVxmZ+6wa+6y8leQ8QzNQYSXbas5VEsvmXCZI/1BGF8Xz1cuwKeXHHYXOm4bGxPZO4qmGsrVtGM8zMbhGnLW1BXY35eeKBOY+yC/FdLGpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779147436; c=relaxed/simple;
	bh=8TFc2YzkiapobSvWzVIWfZppi1wPCviN7yRGOLE1gB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8XjWbmBlrGtT+wLmfVCAd+1UR8kRu+cRRZwowxI050aliwS+eHVSNEJx3j8zy7qzQTWMTRy8aIAbkcsn1QTyGqgTjxwQaeOz276FyVitHagZ8+dzPX7rX/cogkRAo6gTR9JRCzby0HPI9/SJu6MdjwSjI/ZB0lniRlrUtQ2W7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qN7U3jbB; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qN7U3jbB"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7bd6f65c781so21972767b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 16:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779147434; x=1779752234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rd1rj9mGSGdgZZkSdF/f3J82IFvafL5ag4QbFxUPAis=;
        b=qN7U3jbBGtJQuaUe5JqfeWN9ftZfxYFYZNhLOt6VkIv81puK4/B4u0iclx/1mEaUR3
         +nAoY9AzVegyRDY4Uatnjuvq7sZ0IHKQlefe9YSiLJd8wOYazqcvSLMU/vsMDWmzovEh
         zfx2Om/rHWVvUSsGHODP0MjCUOqNm8bdG0WauEKYABdhajJI1pqPx0X+LV8z2N+wC6i5
         uUNCS2jexwMXf+6DeJyDsKy8JhQQKM3UH4ugb+TykA2BRLZV398QnypMa+DmY6x3547H
         RaKmeTb8LNoTM6GEmD3SS0pU+k30xM0qmIvC/re13DtANzobKrImk6ck7zZWUYlkpElZ
         GJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147434; x=1779752234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rd1rj9mGSGdgZZkSdF/f3J82IFvafL5ag4QbFxUPAis=;
        b=DUBsBFXSNEPQb9pmKZpoKTlGWklLrhlfLGEJ+i8lS8PeRITwOQuRnhLKW1e3wderko
         UpwGE187goQqr4rZsvawTPbVF9Ph2TSBYuxcGHkNG5Y5H9+AVvPJtJ+ws6a27LfFM4Ru
         bdYRJxfkEeoTQyfhDp3sE4/NS/u+B2mUH7mTs9jjwXwb6LeJA6H3M7W22/HBC/ZjnfmY
         1MPmqXQn7bj/5EO4hadyt0eiEZea6XtBoPwFcrXSMrsCtlJeod7DgI7j+xkP2z/yr+vU
         dVmAmovYekMK981f87Z/5zktMxdOgdGq5pBmYD4I3QUohNsb+YNpHoT/VH19p1QymLuD
         yZ3Q==
X-Gm-Message-State: AOJu0YzOO4cM0BOYdWVUuFo8c1R24LXycX6Yr03WoUbiRY3sT70+3sJ+
	QbzgQeh8zB7WOnwMVYa2VRJ2eqkbrocMCojOaQaS7TsD2OjkXSN6tVLXynjDo9dgMjI=
X-Gm-Gg: Acq92OFs9DxmIDEz4Eiu9urFHpsG6NI2z+2EsrwII1akXFZTMzgiwFfz+CBJ3P7tuE0
	DyndHIHbFvckf1DgrdrSKcW+Kg2nsDYBcZni9BPnsgshx2LpCRd7yy63xc/A8P99GKDaCZu1I/E
	FuYd3zHjZy8K6PaUcwgb8wGuVQSo45GvzH5umTYkos0fYrhjSwDnBFnoJB3IcEPhptZsU17qABH
	M5osFqvkZAIzSkElu8m8jrWtaigPpu2j0GoKo/hrbGvXuzqr37yglWk7f3FM0lqjqtN92o2ErmE
	Nha4A3wObSlgKqqcpjiOUOSTdTo+io2vstio0Kj+LKYx3J/nouYstoZFbaR1ZofFSKFjZOSGpl3
	EF+0NSD/qt1Em2jixkKmHDuyJUzcwLqY6w3KYlEjq3Axh0T1dOaYQmXGCcFFcv8Bmt2bv9RGeBD
	IcmYXY3/ZE3QfhDYzjgN7xwvmEHg3My0kT7bAZThBX0cpe5CbTxOfrLm6K9UVHUGv8wN6oCWaVw
	IOZqV8IKCrgn0p6enbfdQCk4BiYsYcekdX7QsBcPaVKBNdN4IiXT6YhsSEtJUjnPv4n9+GEkmou
	l223kqlgQIqRjYhVITSTMTZd/Fo=
X-Received: by 2002:a05:690c:397:b0:7bd:5cc4:2fa9 with SMTP id 00721157ae682-7c948ff04a2mr138475307b3.20.1779147434325;
        Mon, 18 May 2026 16:37:14 -0700 (PDT)
Received: from maxbox.tailad2ea6.ts.net ([2603:6081:16f0:a980::18f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc991c9b64sm29058637b3.1.2026.05.18.16.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 16:37:14 -0700 (PDT)
From: Max Clinton <maxtclinton@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	gregkh@linuxfoundation.org,
	davem@davemloft.net,
	security@kernel.org,
	stable@kernel.org,
	Max Clinton <maxtclinton@gmail.com>
Subject: [PATCH] crypto: algif_skcipher - snapshot IV for async skcipher requests
Date: Mon, 18 May 2026 19:35:39 -0400
Message-ID: <20260518233538.705966-2-maxtclinton@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <agp9Hc71Z3lGF_zu@gondor.apana.org.au>
References: <agp9Hc71Z3lGF_zu@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AF_ALG skcipher AIO requests currently use the socket-wide IV buffer
during request processing.  For async requests, later socket activity
can update that shared state before the original request has fully
completed, which can lead to inconsistent IV handling.

Snapshot the IV into per-request storage when preparing the skcipher
request, so in-flight operations no longer depend on mutable socket
state.

This mirrors the algif_aead fix from commit 5aa58c3a572b ("crypto:
algif_aead - snapshot IV for async AEAD requests"), which addressed
the same shape of bug in the AEAD sibling subsystem.

Tested on Debian Trixie 6.12.74+deb13+1-amd64 (unpatched) and on
v6.12.86 + this patch via virtme-ng on the same host. Reproducer
results: 10-14% race rate over 50000 iterations on the unpatched
kernel against cryptd(cbc(aes-generic)); 0 races at 50000 and
200000 iterations on the patched kernel; 0 races at 200000
iterations on the unpatched kernel with the synchronous
cbc(aes-generic) driver as a control case (confirming the race is
gated on the async dispatch path).

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@kernel.org
Reported-by: Max Clinton <maxtclinton@gmail.com>
Signed-off-by: Max Clinton <maxtclinton@gmail.com>
---
 crypto/algif_skcipher.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17fd9..519ff8d17 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -23,6 +23,7 @@
  * the RX SGL release.
  */
 
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 #include <crypto/if_alg.h>
@@ -103,9 +104,11 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned int bs = crypto_skcipher_chunksize(tfm);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct af_alg_async_req *areq;
 	unsigned cflags = 0;
 	int err = 0;
+	void *iv;
 	size_t len = 0;
 
 	if (!ctx->init || (ctx->more && ctx->used < bs)) {
@@ -116,10 +119,14 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_skcipher_reqsize(tfm));
+				     crypto_skcipher_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	iv = (u8 *)skcipher_request_ctx(&areq->cra_u.skcipher_req) +
+	     crypto_skcipher_reqsize(tfm);
+	memcpy(iv, ctx->iv, ivsize);
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, ctx->used, &len);
 	if (err)
@@ -159,7 +166,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sgt.sgl, len, ctx->iv);
+				   areq->first_rsgl.sgl.sgt.sgl, len, iv);
 
 	if (ctx->state) {
 		err = crypto_skcipher_import(&areq->cra_u.skcipher_req,
-- 
2.47.3

