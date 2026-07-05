Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318AA322533
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jul 2026 22:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783288880; cv=none; b=WwpqSO96WS0bNP1hIhRqGcgI8PrmhpbtqFpmeliD93RoHVv9RCOaPI5kzu5GiwJuTPDTe1V9ZeXtN4ktGwZI4K9EHiHogdOlACI2OEPiIHEOaI3ui/+4zuVPOMNE2JMWPX1Zve39imbG0NaeNbw1HNfWh3HLFt8hIBthSY4CGEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783288880; c=relaxed/simple;
	bh=YBLWlmkz8MAr+fcpyPf2g2hrag7YkqU7UMeLYQH5Bnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jlvRIZ4kE87d0JhsO7lY64oOjHA9zHPV0fBaQ3IyOc1yU5Wc82GlAkWNaDLIY1JBUsg/OvF3uG6EoRWD9nv24Re4W0V5JRljrGxIcaTqnt0fT9JwHwMXthd8qm5vDJnWptE8xyzQN9nVg7o6PEAdKuz7qa0iTjO0ZaFVlT0V9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KSLVn0C4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KSLVn0C4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493c486f012so9341705e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2026 15:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783288877; x=1783893677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4LU1xtRi518enKtD2p1JuxpUbP2c/j6STisIbXZNeg=;
        b=KSLVn0C4OY0AQxHUXVDQ0Y2rDo93z8uxq3aNVRLK9v4AXyYB6YIk6tgXEdrrKNm1yf
         vmMavncWa25p2v1sgz7o8G9VZYHDrAbZhYzIjntDbx+mW6F3WqdvAGytYjQDv4Irp8GP
         KFekpTaspqCvhUZIL/LF7+4rRDTWgH15niuj60nX4UbTgKJDvogh4kiZcSKvNDXJWhVj
         1YS5POA86n+0KyV//20pKSslKnMdI5WuSIWJq4/dLLCdkSdprwYwNTTXrheFZtRRicLZ
         TMvHN0cwYYR2ZSPi0CqhWsRZAhMPmYpJHVYuUDsfgvEUD1qXVEvFvljLED50p21Gvd4B
         uJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783288877; x=1783893677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f4LU1xtRi518enKtD2p1JuxpUbP2c/j6STisIbXZNeg=;
        b=s0drMCy8jRQJnrtox+FQ9bugPJKkDNhyM6acKNv9MFagN6LFQELgiX980VN8ZRZ/iL
         a6uu2eUtAqEJNw6+3aviGnI8MaCVg6y0vLEY6MwW31fRCm4rV8WJlckFDo+a3TVUxsHT
         97VbbUcCtU84VGd64pby1SaxyqY+clcMtr7uIVm8+PEZ2dp0vddl4sdQWtxzW2c+DlA4
         pTvXAn62TIM/asiveMwMjUmXl5eMh7rdbyA2ANIAmBqnX5DclR66xuG4kbhpP1KaqaFG
         iJrIiisEZ8ZGIwngzQITBAo10Ji4bqgnuy5phetY74U8iK0kEb5zKzoqTY86DxiJSihV
         aKyg==
X-Gm-Message-State: AOJu0YynY4hXm1KVVVDjbYlmOB46M0VGJa08We0aK79JVrkqpk4niwRL
	Y9GSL4sTOtEakilnEdA2fTJcOfcDuemFC200BZF3KWgvmncq/1ecbZPx
X-Gm-Gg: AfdE7cnprZdLmTfhLXLKDgibS0Tfvue5hZ+8z7pxU7dqxJh5jlhBNuHldub4Hd5jcRS
	vdWOweplEjvbs2uhvTf2RLOWPMx/eRbB50X870XtqWR2n6tqIWGtZ4j6j9kyG3cC+Y0wtBl6NaJ
	sBQMfXmomwWqg5nv3e4eGwgOiHCVTfaf4FPoYDCVmfTt2b7DF0JYfmK3mIjnRczwNtpVVp4DcZC
	s9Mnt42yfho3opPfE0WsFyaPmJ5IOnN0RKcpA/DiuYbAp9G7J0xXz8j6aSuD0vRlBgMd/z3H7ea
	uydpMM2Qw9fw7vk8511Ile0zX3+jNhyKCNMYqC7UVtLs8VqgN6Rs658WUzTafzke3unlMePhiJz
	qe9d5GjyWB2P+A+fXmrZ1EbNG1I80tS4HRA4S4+Uyelb0ZQUn3gxDTxOraR9NYDUbAbmtaIFSKu
	Js5L4YmGOehV3pgHKB/2Z+eh5zNw==
X-Received: by 2002:a05:600c:5704:b0:493:c9b9:415f with SMTP id 5b1f17b1804b1-493d11f37ddmr64095345e9.25.1783288877620;
        Sun, 05 Jul 2026 15:01:17 -0700 (PDT)
Received: from tt.. ([31.223.44.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63172fesm544853265e9.0.2026.07.05.15.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 15:01:17 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	sashal@kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH 1/2] crypto: algif_skcipher - snapshot IV for async skcipher requests
Date: Sun,  5 Jul 2026 22:01:10 +0000
Message-ID: <20260705220112.2522-2-muhammetkaankilinc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260705220112.2522-1-muhammetkaankilinc@gmail.com>
References: <20260705220112.2522-1-muhammetkaankilinc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The AIO/async path in skcipher_recvmsg() passes the socket-wide
ctx->iv directly into the skcipher request. After io_submit() the
socket lock is dropped and the request is processed asynchronously
by a worker (e.g. cryptd), which dereferences ctx->iv only later.

A concurrent sendmsg(ALG_SET_IV) on the same socket can overwrite
ctx->iv inside this window, so the in-flight request runs under an
attacker-controlled IV. For CTR and other stream modes this causes
IV/keystream reuse and allows an unprivileged user to recover the
plaintext of a concurrent operation.

Fix this the same way as algif_aead (commit 5aa58c3a572b): allocate
room for the IV in the request and operate on a per-request snapshot
of ctx->iv instead of the shared pointer.

IV chaining via ctx->state is unaffected: the snapshot is only the
starting IV, and crypto_skcipher_import()/export() still carry the
chained state across requests.

Note: mainline removed AIO on sockets in commit fcc77d33a34c ("net:
Remove support for AIO on sockets"), which closes this path there,
but that is a feature removal and is not applicable to stable. The
supported stable trees still contain the async path and remain
affected, hence this minimal snapshot fix.

Reported-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: <stable@vger.kernel.org>
Signed-off-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
---
 crypto/algif_skcipher.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17f..6f6335f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -103,7 +103,9 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned int bs = crypto_skcipher_chunksize(tfm);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct af_alg_async_req *areq;
+	void *iv;
 	unsigned cflags = 0;
 	int err = 0;
 	size_t len = 0;
@@ -116,10 +118,14 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_skcipher_reqsize(tfm));
+				     crypto_skcipher_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
+	iv = (u8 *)areq->cra_u.skcipher_req.__ctx +
+	     crypto_skcipher_reqsize(tfm);
+	memcpy(iv, ctx->iv, ivsize);
+
 	/* convert iovecs of output buffers into RX SGL */
 	err = af_alg_get_rsgl(sk, msg, flags, areq, ctx->used, &len);
 	if (err)
@@ -159,7 +165,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sgt.sgl, len, ctx->iv);
+				   areq->first_rsgl.sgl.sgt.sgl, len, iv);
 
 	if (ctx->state) {
 		err = crypto_skcipher_import(&areq->cra_u.skcipher_req,
-- 
2.43.0

