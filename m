Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85304367F48
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 02:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783823304; cv=none; b=os/dqwVrTk8nflZV1+vGG5atuwwDfrCOWdWc2gzUdzbh1qLAeeUqDQFegS8Kyjdy8zafd5hU3K8oqNRuJSLLmB7VOnFB3KZICZg8fTBF4QA9dPwSaAEDJfBOsHr5/ZEOl008XkXq47a5s3axuT67ux2HU6YewSeds0YsyNRclD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783823304; c=relaxed/simple;
	bh=ZIs4sFeCUXYO35by1FvbEMgszPCYt1zF9n8Z6Vfa+Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTpAL7+jU8bawXHUnkevu6mZg7WB6mgvK+xuELe/D19HCNn6R6CO6Sb0ccMae2nqJLD9FVYq8xwWAV1rLkRr/kXNmld2hr4+8eiqSgH0EWj5qQgYpZZIpbAweYoQLfdDsP53A+tJeGsbyRAn8Cc7na4782UMhowGWOcJl0+dr+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TiZqmoGD; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TiZqmoGD"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b779003fso9208025e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 19:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783823301; x=1784428101; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/GMZAGVnD/DhMvZ6TT4y6YCKC7jswbVPr6mJ8H7Nt3M=;
        b=TiZqmoGD6odZ8SkJFgYVTXUHU2vn1gaIP3WQESorbrz64zdVKgSsqmZpryckJNoctd
         YblpvgEwUtemZyEW/quUq4zNQH7AmccRAP1EqmPvXQdvurVcL8uPiAq6i0HSKckDTjEx
         lr6N2UX0JJ2YXMnu0KCc76VNlCOZU6EtXY/VBarR8gT9Absj7Fh/2W8eIohOchogvo9X
         IyHc8BXriiCG+hbfJ1nuzXVYbySHXooSBj7okBjHodidN7uW86CLljQZPAavwj3vo407
         CZKtWsSbclSi5MmFD0Hcb8BaDGtDJW6Ab7AYGOY0knHEWKXcpfFYzCbMBWMog7c+QLuK
         UIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783823301; x=1784428101;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/GMZAGVnD/DhMvZ6TT4y6YCKC7jswbVPr6mJ8H7Nt3M=;
        b=Uob09wQSuhi1/fkEk9m8QGa7NVN5voT5Y83llsFhcIMEfEvgNV28X5MdWpeDu55XOa
         7V3qqwLLanlml4GTRzEybi1xWZWaS0HIaVALAUZFoQ1f7HATOjoF2lMs/jo9e8aQpkqt
         nHYvOukeqJDAsCRzu+FF7S7hsBubFbdw+zH2tvH3csP2AuRyipLBtpOpEMtbT1LTDnBN
         5ba/79L8+baHzBqJv31OH1FILz3gVcWRFvORRo1ri1ZIoUVIr1CwgxQ6B5uIr1h0Gbqi
         mrx4WM+t0Xp8OtBwIVSMo/QYTH6y/xMc7Qyh0D+zQ1uDQbu8kl5sVr8TXodletnQzw7b
         PLUQ==
X-Gm-Message-State: AOJu0Yz6j666FY8S1qLtQjTA7ljlmPdSKUBw8znpkIbSfJ14qRHFn3YM
	08O9zFZ/oOQpefCenUqtQYrbNoybzSH5iflCL20TZPH/aSBLNHBr1RsxPk1ynd2N
X-Gm-Gg: AfdE7cmHpUls7Jj5tuOqny7vnVU8dfVuk9cJVbWpXWDMvPD7ogslrrPBA6fKkR524g6
	9xL4hFCusXaS9E+cgrZuPfu/UyT4qDfnDXJWOzOg9zYjppJjrJSocPmy1Gni/LCiJHcYT7WRY3s
	DBT8Ak9TFqTLzbgt/qAIdU8h1Gp3NdQQklZ+txwwNzvBDN7xzmY8uYkX9gJQMaiNwcr3TYtuf/K
	5LBxVhjjVNclWnRHdkPlP6drIGsf1bActWHmpQqZpB5mGptC9dblEQGWjjaNn1ZKdGAgl7riOpH
	kyD37Rvk1Ki6WEGj663OWeeW0PCvC2jw6mjJ50JN/GFg/wVzWiOGQoyutn2GFghK7PAUbv0NK02
	VFAykljUY1EkcDQhgtoe6akuHVG70WIkxi26Z8gkZw7LIKfwl7JPoZJA26QUFaG+2aJA2/wJKIp
	7Pb5CYrNLL7q5xTLfmOTRN9T8SDw==
X-Received: by 2002:a05:600c:4ed4:b0:493:d1e0:a4f1 with SMTP id 5b1f17b1804b1-493f877fe8cmr47384565e9.0.1783823300676;
        Sat, 11 Jul 2026 19:28:20 -0700 (PDT)
Received: from tt.. ([31.223.44.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6d5055sm252027875e9.5.2026.07.11.19.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 19:28:20 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: sashal@kernel.org,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH v2 1/2] crypto: algif_skcipher - snapshot IV for async skcipher requests
Date: Sun, 12 Jul 2026 02:26:16 +0000
Message-ID: <20260712022618.1665-2-muhammetkaankilinc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260712022618.1665-1-muhammetkaankilinc@gmail.com>
References: <20260705220112.2522-1-muhammetkaankilinc@gmail.com>
 <20260712022618.1665-1-muhammetkaankilinc@gmail.com>
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

Fix this the same way as commit 5aa58c3a572b ("crypto: algif_aead -
snapshot IV for async AEAD requests"): reserve room for the IV in
the request and operate on a per-request snapshot of ctx->iv instead
of the shared pointer. The snapshot is taken only for the AIO branch;
the synchronous path passes ctx->iv directly.

Like the aead fix, this does not write the cipher-updated IV back to
ctx->iv: doing so from the async completion callback would require
taking lock_sock() there, but that callback can run in softirq/atomic
context, so it must not sleep. Back-to-back AIO operations that relied
on the implicit IV carry must instead set the IV explicitly per
request (ALG_SET_IV), which is the documented usage. MSG_MORE chunked
chaining is unaffected: it is carried by ctx->state via
crypto_skcipher_export()/import(), independent of the IV snapshot.

Note: mainline removed AIO on sockets in commit fcc77d33a34c ("net:
Remove support for AIO on sockets"), which closes this path there,
but that is a feature removal and is not applicable to stable. The
supported stable trees still contain the async path and remain
affected, hence this minimal snapshot fix.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: <stable@vger.kernel.org>
Reported-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Suggested-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
---
v2: Address Sasha Levin's review of v1.
    - Limit the IV snapshot to the AIO branch; the synchronous path
      now passes ctx->iv directly (v1 snapshotted unconditionally).
    - Do NOT write the updated IV back to ctx->iv. v1's missing
      writeback was intentional-in-hindsight: adding it in the async
      completion callback would require lock_sock() there, but that
      callback can run in softirq/atomic context (hardware skcipher
      drivers complete from a tasklet), so it must not sleep. This
      matches the accepted aead sibling 5aa58c3a572b, which also
      snapshots without writeback. Back-to-back AIO IV chaining via
      the implicit ctx->iv carry is therefore not preserved; callers
      must set the IV explicitly per request (ALG_SET_IV), the
      documented usage. MSG_MORE chunked chaining is unaffected
      (carried by ctx->state).

    The per-request IV is placed right after the tfm request context
    (skcipher_request_ctx() + reqsize), matching the aead sibling's
    non-DMA-aware placement. No skcipher template currently in tree
    uses crypto_skcipher_set_reqsize_dma(), so this needs no PTR_ALIGN.

No Closes: tag: the underlying vulnerability was reported privately to
security@kernel.org (2026-06-07), so there is no public report URL.
 crypto/algif_skcipher.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17f..533e72d 100644
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
@@ -116,7 +118,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
-				     crypto_skcipher_reqsize(tfm));
+				     crypto_skcipher_reqsize(tfm) + ivsize);
 	if (IS_ERR(areq))
 		return PTR_ERR(areq);
 
@@ -158,8 +160,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
-	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sgt.sgl, len, ctx->iv);
+	iv = (u8 *)areq->cra_u.skcipher_req.__ctx + crypto_skcipher_reqsize(tfm);
 
 	if (ctx->state) {
 		err = crypto_skcipher_import(&areq->cra_u.skcipher_req,
@@ -172,7 +173,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
+		/* AIO operation: snapshot IV to avoid racing with ALG_SET_IV */
+		memcpy(iv, ctx->iv, ivsize);
+		skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
+					   areq->first_rsgl.sgl.sgt.sgl, len, iv);
 		sock_hold(sk);
 		areq->iocb = msg->msg_iocb;
 
@@ -194,6 +198,9 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		sock_put(sk);
 	} else {
 		/* Synchronous operation */
+		skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
+					   areq->first_rsgl.sgl.sgt.sgl, len,
+					   ctx->iv);
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
 					      cflags |
 					      CRYPTO_TFM_REQ_MAY_SLEEP |
-- 
2.43.0

