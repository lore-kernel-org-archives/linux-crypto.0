Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64369367B7B
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 02:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783823304; cv=none; b=sJqyHTfRK5hOregf8OuMPMQZpWDEPGQDJOBD/Rq2L706w4oCzVPRnam4R62Ob8S+ZJCzLxvdh2UxsLOk8QrsvbTv/qPNBd9BObeuTthoVzMOlZd/sD4mqnqDuiiC1vhZTgL3xsJ79KR0uLVaTEKk5dHGYvZ8PI70xK23bf58flM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783823304; c=relaxed/simple;
	bh=ZpMFLJiqrhcFSt8yy5JXsEr01RNW+/tA3fnjzKWxS0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hf4d2oESmHvXah3t3o1ZbVMI6reSLRrgHRbBSC9GdwgTA6xF3EEarm4fuesEPPgeFlAv+dzyBrwTOCDLe0T7nAI9e8Zxp7SD6lc7B9lgLVAkPPWrULdcroAZHMscEYF+i8pEIftK9it4QUQDFHFH26JUPC0I6LDW5PisJ69+Pw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=shhcpt0O; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="shhcpt0O"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so10159625e9.0
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 19:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783823302; x=1784428102; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7I3scjHBFy/O665lusuBOf3dhgU5aJvBdDuTYr3CQ4U=;
        b=shhcpt0OqBfBU4TLtKD2G9YBKGl19ey5golK30I0b0C/jU9lrMk61yOS5N1BmHHFAA
         zmTQYSEc1Nk+h2Re0pYo2dV5tb9kSDEle2x01dfX+p9S/IN5hJDlzKa3w/Cpgv1fKKvP
         +XbdilKK2fL2C5qF1TL3HCTO12eSBomOcI6zz2p5U6r2Ze3phhD1BbSkcbn4nD/mXpE9
         qygMBe7mveEVRmzT9qDXQDaxT6y7yCE9sLII1CfPfXuG/C/4XJyoAHfZ83YzsMJEk1kW
         dTKOol4pkwkM05jPMXrAfxSHmg0BMKvWrzxbOrLal9U6XIcdb1X9Wy/8Y2kzzr2m75sm
         AO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783823302; x=1784428102;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7I3scjHBFy/O665lusuBOf3dhgU5aJvBdDuTYr3CQ4U=;
        b=DiAbPfmCZ5nfCkuXWkdLFAjxV90fWWMfla7g9Pca1ae3mr+aT8bryni+shND1ftMfV
         n1pSEeGKnGdJgmF1zSTrv1UOf4FDsm/YtUHMyIewhqL1OUIjzGCQh4ieFZQtzgKGyGx7
         pZfcJZyLYKkNpUKB0BdaTZbDPD0Tv8UXyWfsLPJul+iMNI74hb5IVgdOkkOZsxrPTEA+
         K2/aivt8S4JRAF3CJ6+6qMj1JaR5Y2pG43OSYBSv6VZdJQBVRC0biVHHe6x25c6Awm4U
         iTCW0H/sTqKHGbwxlD0GldUw/9JztwMsUiFKNccnJSyC6NCKMqk2j1TTnnaMwA37ZLEu
         izzg==
X-Gm-Message-State: AOJu0YxbzOArIzpYcc9znb8hrfRLzfVchDTKwq/gOPq2SlJm4KVBs/sr
	DnJFpm1ykYdw29WYY8bjWsOrKcm7KNkUE1G+BQ7uwS2wCoLmj6a4+Rqa
X-Gm-Gg: AfdE7cl2/0F0n7LReYk5M3ElGFBhIYmIDmwqp3JGPtt+OgIfcKlyw4oYagV07YbQ1mZ
	LtIrQyur5mty0W9SGMPSYBOVFHDwjjwVq/Bto8lD5Lrdy2lX4DfOdLtj7XVm2xfj3PFLLcSu9xw
	75gilTT5SbM953nquazubMX+YmYSUt5ZZ3v6kq8tH3RxzsugLsDtWsh/gJfL6T2YSrX0RCwC/zh
	JGt3pRu9SftppEAtfSGhLHfmkCyWrBHG0xwjRIGFRtn8SOcnBUqUKdvMEj6bI+yJa9UvpTyyX+A
	zr3VJTEmwttYEaGwKhriuu+7XSeNTjoUHtOgFp0Xs/MimzOD4SlDkUdrlFUVmd8lEd3Jce1pptS
	jJVp9NWUsulYC/LCqcoe1yiqAyzCDjN4nFspgu8pExEGGbYnGawDtP5p2oUNf4yJELJEKFLZ14q
	NhwhP/B9haURrwp5xhGldjF8sIsg==
X-Received: by 2002:a05:600c:608e:b0:493:b03c:5650 with SMTP id 5b1f17b1804b1-493f8820806mr38379845e9.19.1783823301653;
        Sat, 11 Jul 2026 19:28:21 -0700 (PDT)
Received: from tt.. ([31.223.44.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6d5055sm252027875e9.5.2026.07.11.19.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 19:28:21 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: sashal@kernel.org,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH v2 2/2] crypto: algif_skcipher - force synchronous processing on trees without ctx->state
Date: Sun, 12 Jul 2026 02:26:17 +0000
Message-ID: <20260712022618.1665-3-muhammetkaankilinc@gmail.com>
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

The AIO/async path in skcipher_recvmsg() passes the socket-wide ctx->iv
directly into the skcipher request. After io_submit() the socket lock is
dropped and the request is processed asynchronously, so a concurrent
sendmsg(ALG_SET_IV) can overwrite ctx->iv and make the in-flight request
run under an attacker-controlled IV. For CTR/stream modes this is
IV/keystream reuse and lets an unprivileged user recover the plaintext of
a concurrent operation.

Newer trees snapshot ctx->iv per request and rely on ctx->state
(crypto_skcipher_import/export) to carry the chained IV. These trees lack
ctx->state and chain the IV in-place, so a per-request snapshot alone
would break MSG_MORE chaining, and a snapshot plus completion-time
writeback would reintroduce a race on ctx->iv outside the socket lock.

Make the operation synchronous instead, which removes both the IV race and
any writeback race. This mirrors the upstream resolution, commit
fcc77d33a34c ("net: Remove support for AIO on sockets"), which removed the
AIO socket path entirely. io_submit() now completes synchronously; AF_ALG
async is rarely used in practice.

Tested on 6.6.y: attacker IV injection dropped from 2296/200000 to 0/200000
after the change; MSG_MORE chunked CTR output bit-identical to single-shot.

Reported-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: <stable@vger.kernel.org>
Signed-off-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
---
v2: No functional change from v1. Independent of patch 1: patch 1
    targets trees with ctx->state (6.12.y/6.19.y) and uses a per-request
    IV snapshot; this patch targets trees without ctx->state (6.1.y/6.6.y)
    and removes the async path entirely. There is no shared code path or
    state-detection logic between the two, so patch 1's v2 change (snapshot
    scope) does not affect this patch.
 crypto/algif_skcipher.c | 49 +++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index e31b1da58..b12df4544 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -109,33 +109,20 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
-	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
-		sock_hold(sk);
-		areq->iocb = msg->msg_iocb;
-
-		/* Remember output size that will be generated. */
-		areq->outlen = len;
-
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      af_alg_async_cb, areq);
-		err = ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
-
-		/* AIO operation in progress */
-		if (err == -EINPROGRESS)
-			return -EIOCBQUEUED;
-
-		sock_put(sk);
-	} else {
-		/* Synchronous operation */
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP |
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-					      crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
-						 &ctx->wait);
-	}
+	/*
+	 * Force synchronous processing.  The async (AIO) path passed the
+	 * socket-wide ctx->iv into the request, which the worker
+	 * dereferenced after the socket lock was dropped, letting a
+	 * concurrent sendmsg(ALG_SET_IV) inject an attacker IV.  Mainline
+	 * removed the AIO socket path in commit fcc77d33a34c ("net: Remove
+	 * support for AIO on sockets"); these stable trees lack the
+	 * per-request ctx->state used by newer kernels, so the minimal safe
+	 * fix is to always complete synchronously.
+	 */
+	skcipher_request_set_callback(&areq->cra_u.skcipher_req,
+				      CRYPTO_TFM_REQ_MAY_SLEEP |
+				      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      crypto_req_done, &ctx->wait);
+	err = crypto_wait_req(ctx->enc ?
+		crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+		crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
+				      &ctx->wait);
 
-- 
2.43.0

