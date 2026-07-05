Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECD930D405
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jul 2026 22:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783288882; cv=none; b=p6WWDCrqE4Deov6M8fXzh6RdMY7Z2vDrm5QJup+wAOJBnDbNHkY5FQC3zz9HJDrn5x8lGp0QRvIveu1pB61itGC43cLE4ahoAYffqRwJIA6pMIBH///nyRtLZZO+023nPJe+z+AVEz6sDvoJEiBMUg4T49FqqPlg8wicMIexEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783288882; c=relaxed/simple;
	bh=J4FjOshJ6RBO/3MOt+VmllNZWiRL7HFHiixP5bQuZpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5iLNTkgmqONgQbc09P9W/xoDO/uhxwZ0WZM0QYGQkhdZPs6wTYNQonJmDiNWLelaHXfeUD3cGW6kHl36DjA/D/QdeMemo75nqTSFnshnibznfjK+qUJECz0XALbk/qqUJCIEmaZMpHflhIC9Yx2KtnPWkcIyVPRzNa8Py0SpNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CSVja2Qd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSVja2Qd"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c2c0b9a8so21376485e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2026 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783288879; x=1783893679; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YvlYxiNAfYjqJ5SupCEKeoITyZXsujlTXQzFGXeco6M=;
        b=CSVja2Qd2GVOBY8yspmioTVFtOKkhfQDERDH08vdH/sskCSTGK53XUr9g4Y3rY50/h
         ipwBnXRE/OjGi9nQdRmHp+f5VwdzOsiF32GElB54z6GvYwTGfkkMAc/m5xlQAQbDC6/1
         bBEaSBUyeYbd8hJqoL3zGJhr9aUDAcdYsBIkw4nhdcohNhjWq7PwxFEVkA9lBM6Qm+Ur
         BgGmmtRy1Uflo/zXO2Zxn1IGfR7V3rXJmOv0+DVESiirWUFmSVcjR2Nlo0QqJSPMByT5
         9fDWW5td9iuFzD0zD2FJJB6e0S2STpycg3LgsRYjcOa0oPitIY9UfpxQiJ4odppQ1PZc
         Ld3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783288879; x=1783893679;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YvlYxiNAfYjqJ5SupCEKeoITyZXsujlTXQzFGXeco6M=;
        b=lmJDupE7iuAsYoc7K0Da84aeeeCHVjaB6Cf7P22o53cGWlD2Pc2K5Fj9Azds5Pg33C
         r2Kvs7elY6AzE7hhsTzBFPTPCg00dPXGbSUDmevsfwX+JW5Ip9GSEjNnzu5k0xDBjsQM
         JdHyKrxEMx/96oiQnq+3BLnIrfLpJBjUmADwqHgrJPcUTS619okZSo0apLIikhkOmlja
         b1/Im/eiUViZRNUu1dbXr0WFafgJ2g7nSBY9kD11u0hFV7Gd2ojvazGQFmfn4InFwuNy
         lbdYfg95sctbdBaH7ri8+vOVEep7oABCMHSgVs7patAUs3Qqohh0YUIjmka/lMsP6D11
         PJ1Q==
X-Gm-Message-State: AOJu0Yw4Gmo4ia9AWNPAZiFbjq26SZyTpUqcJZz3Y12JjOZaJhH4nLxC
	9CQBQEKUr65gURTjgakjCJGon3heUy35Pr+mH+50W2Aw0xoYusPzdVjp
X-Gm-Gg: AfdE7cn/q1aUWgn/0sQhaQdR48c+rqduG7dklbTwuN9sPgReuO3bLKnKPue/1L5V+jQ
	nesMorFysSWoRLmthor7PpFKWUrGHMgyHljgmEIbnYWxYe7De+tz46W1+WrjBOx4U5MHZ3sG/LD
	tjOmvAvhy49DbnDrwXuCdGsmBGEqieaWv/NL3WUv+zHRjwMGnFiolJCjq2AN7ykp8SnvoWWSHAD
	WB19l6KiP4D1gUDsuBV6plRJXc3m30A1HMJxi+zb6Cv7zDV206Zron5QQds2NGKhlSJsTa3gqgH
	9VhWh/0YZJfkeXZxlVTBKygX+tEtT/Q/j6wo4LiQ07Tpqq/Nc6VXVaCN0IakDSBXU37QIvJLVVa
	o9YLo68OS7DUi+ykpOAdrIb8b5BS20luJZsmqFljchVWm0LM6CHDff2WeqK7H0DTKoix+WTW6wV
	X3dTC1NXd40vfGFY1SONfoM6Bpvw==
X-Received: by 2002:a05:600c:190e:b0:490:469c:556b with SMTP id 5b1f17b1804b1-493d4ee52d9mr64705305e9.12.1783288879237;
        Sun, 05 Jul 2026 15:01:19 -0700 (PDT)
Received: from tt.. ([31.223.44.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63172fesm544853265e9.0.2026.07.05.15.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 15:01:18 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	sashal@kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH 2/2] crypto: algif_skcipher - force synchronous processing on trees without ctx->state
Date: Sun,  5 Jul 2026 22:01:11 +0000
Message-ID: <20260705220112.2522-3-muhammetkaankilinc@gmail.com>
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

