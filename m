Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7631370D70
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342173; cv=none; b=IqIlToh6IuNtpLh04z7UbgWX0Er+6IQVKE5PlLDxRfSiB8KIytMSGR5uZPTvZoux/QUJL8eZ3I/XnQEz3PEqBNksIPvvmCNM07LMxVQ9yYZ65wGBT4iw+EYWwimnkdwKNHcHMMnwK0pjxKvUjAt7TdwGa7z+eZFDx4xFbQBDLug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342173; c=relaxed/simple;
	bh=svjmAHPOo637dqrXsepIyWpJZfmSdpIwDwayLAfPTNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVZH8lSyPQJczRz/FheN7EoCgF/l2Ss2jWXEV7Z3RWadRGZ7g+aAAk9/Ky0s2FNQ0m2nGgALmrP1vgG5BJ/BXXh+zX0WlxfVPe1DurH+Ruf/UE7hhHCCJq1B0EngTzoZSDadGh+narY7cLKxYvCU9uufmLFWFmLo1wtL/V9yWy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=InTctHNj; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="InTctHNj"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9155183b42cso206600985a.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 12:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780342171; x=1780946971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgKM7SFpYHVInuovDxALO/eeMfBo+t817eXB2nW30Kk=;
        b=InTctHNjNVlM8JRogMx3rDRhmN8sxEUWPzZ1U5M7eYGWw9mRSPO25K2HVQLeGDeu59
         faWFPwOYZ8cP8R/uXKxPMC2LlR5Dfv5TOHV7YnXYrV7OFZyJyv9pifnw0fTiYYGYk1IY
         H4cJceJVSUCBZsy7n/i3sco+JBGJEG+J+lKs3F60FunlcYNp6H9BqHvVt9lcc7pwmMM9
         LHu7/Byq2qeVojd45i99g3fibCYSDUKp4F4pg8OE1M6m2SKVU/ywsT1pLY3LfFHOuhIu
         SeNrVwNNoMk9QLBDjiBqXanI/TT0MNyg4mfuRJWPUQbSjNwMXiSSeKUln8ew+7Wpupyq
         JYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780342171; x=1780946971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lgKM7SFpYHVInuovDxALO/eeMfBo+t817eXB2nW30Kk=;
        b=OOMp9KGSkHzZaYEvghenZANl1olke8y4I0xAQOtRh78sD8JBMJqfcJac/ckD9Elfr+
         gkOCFSf6Ye92PpvqHN2O0CPMHhC12VfV8HSdpruDjQo+yiHVpqgkHIu387LVSamhELrZ
         YeGUbFZnHLHHDJzEvt00/jjAnOwQpDW38JP2mR6D7l7OC8WIu3+r7MMyY2mT/eFac7Mu
         hIMrqEweXMYC1IhREknZ5TR97f8wVbyZq8QNcCNdbq35Agplq8eQMITqSGlF5AxPKBc+
         8OA9kHEy9iAFvwEG9ylqvMRNBQNWY1udxW4rWEY2mG7PLKKcNDJXxF8Ijo5jQNYFJo3r
         zHbA==
X-Gm-Message-State: AOJu0YzzfcwF8HMEj2n4dStAEFeJny1PgRIEITBur2jxRRw8sKR3bdaz
	tBMFLPaQ/Pp25ZiEcepEv4bQDxsfwC4EYCrn3EejyWIrunsc/gHi20CekrQ7jCKB4hM=
X-Gm-Gg: Acq92OGnuWkdxn678ulvvWZSU52/F2SgdEfCC3YVyxdKPX4uVEoJccnMlxXhBiSBNHv
	jQvYzWRIh8ZwMJluBAzNS/E25Euk4TyS3odU8n3AJdiUUyMmveILDZe8xiSpIUVASBc5o7bEq42
	4Y9m8lUnk7YUtfuqqvIafnA/bx9pGoWin3oIwGnR5NsK5VZOzhsK8cKwZ+aUNE1JoU5ELAgQX15
	F6+N8NaGBPon+MnIYamv19u4ffI5/TvDS2RwcGYtl31jyT8nrIFhnvP8v5aXANK4720nZYnUkhw
	ICuyTjeCvyfuW1YqRGf0pAK8fN9j2krqONeBrqscbrxNsDdpei+3v0YhbDhdoR5dgZuQOpRQoCx
	dFEQqom9lGjQAA53kIN+vSbHn8iJUUkIPoxcg/n/diu/jHMGUGLM7rcOyhI+gbywgKQCCSmInsq
	b07YRyD7Xe0oOl0DZGlkD7hlqBRQ/QKBvhjB+Hp6CSCV5j2Kn3aYPti1KkIiFFb9NUb/a0uNPub
	pRibzDnSS6xf2mE07nFyrHZ99pdxlECpdCwXaTm5v9SHWg0rR/tRqL9tWDekUUszBtPw0BVY5K0
	l7RcMC+N1cxSk2YnA2naBB1XJS9SG6X7or5lMA==
X-Received: by 2002:a05:620a:25c8:b0:913:e5bb:3db0 with SMTP id af79cd13be357-91577ebf04emr141478985a.18.1780342171489;
        Mon, 01 Jun 2026 12:29:31 -0700 (PDT)
Received: from maxbox.tailad2ea6.ts.net ([2603:6081:16f0:a980::18f1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915790a787bsm25035085a.29.2026.06.01.12.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 12:29:31 -0700 (PDT)
From: Max Clinton <maxtclinton@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	gregkh@linuxfoundation.org,
	davem@davemloft.net,
	security@kernel.org,
	stable@kernel.org,
	Max Clinton <maxtclinton@gmail.com>
Subject: [PATCH v2] crypto: algif_skcipher - snapshot IV for async skcipher requests
Date: Mon,  1 Jun 2026 15:29:27 -0400
Message-ID: <20260601192927.1095129-1-maxtclinton@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518233538.705966-2-maxtclinton@gmail.com>
References: <20260518233538.705966-2-maxtclinton@gmail.com>
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
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Max Clinton <maxtclinton@gmail.com>
---
Changes since v1:
 - Drop unneeded <crypto/internal/skcipher.h> include (Herbert).
 - Rewrite iv pointer computation as (areq + 1) + reqsize per
   Herbert's suggestion.

 crypto/algif_skcipher.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17fd9..5b5bc1204 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -103,9 +103,11 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
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
@@ -116,10 +118,13 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_skcipher_reqsize(tfm));
+				     crypto_skcipher_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	iv = (u8 *)(areq + 1) + crypto_skcipher_reqsize(tfm);
+	memcpy(iv, ctx->iv, ivsize);
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, ctx->used, &len);
 	if (err)
@@ -159,7 +164,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sgt.sgl, len, ctx->iv);
+				   areq->first_rsgl.sgl.sgt.sgl, len, iv);
 
 	if (ctx->state) {
 		err = crypto_skcipher_import(&areq->cra_u.skcipher_req,
-- 
2.47.3

