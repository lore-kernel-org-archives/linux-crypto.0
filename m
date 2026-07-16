Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9456F333429
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 02:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784170770; cv=none; b=WaqaxwFKVCE8ca2FsdSgYda5qxw/1pu1zKlpwAQNVqD9Ouw9ogrFm5GA8mH1HVEBwke7kZBm0vdyWFKolAUMRS2IX27TBV8/Lp9AkWik5YD4l8NoXYtUjllTH+Z87aoTBxf4atM0uUDNEdnMDDwz0e3Q97e/bAoiXhagl270aL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784170770; c=relaxed/simple;
	bh=o+gcfN85LsX8ZnGSBMnx913A8Bs8vNEZFqNxdIb/HkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sxtUVRmvrieodyZCOk3lIK0co7+x/B9kCMf9pGJsksY3sBukRilS4XlHQNHAfAJUHMnG8hgC4n3MnYxczJue3zbfuqU+A7b0wPQaITUoHbL3rZysSLtb543RWLMPnRhpZ/d5vDYXhaQU2+kTZUqHIIT0Jfsfc2ayAisleK5Pc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H1tG6Ib8; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H1tG6Ib8"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f3e6cc44aso3486865f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 19:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784170767; x=1784775567; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rlb58YPR7XEeexQL53rN3fWKrWk89Y7Yin8GxLtiR1I=;
        b=H1tG6Ib84Z0a0e8rqu5taEsakau01i8X/ezrbgGZxS8kFi/CiTJptVXtiwKve6bUqR
         jxYyMXHRdTGgWmZ0NBkNmnfHlGL5se1CVzDpXCcxJVkXyNjppTQEPUMwOS7HluLmBaRd
         GqgbyXWzB4pW8h6g3xBpJT8/PRURvl1DpJkrPf4efqlOe1ic9ozeazFIA6rkGKyzImzk
         2x3uv64Ll4k/oqyE+kSzEHH8T3ssjgWpU1VxkyFdKMPddrnG2QmUKLcHfWlxs5bBx5mT
         mkLUg/eWt7azc85q39btxoCz+W2efmA7gOGZ+pjJ3lzfDM1h0wHBV6P3Yl1OMCzNlJGB
         TVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784170767; x=1784775567;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rlb58YPR7XEeexQL53rN3fWKrWk89Y7Yin8GxLtiR1I=;
        b=sYQWS8CExKB80iKtW/NJYRNatghdzfkkpBW5Zk3IFMDizwU5QVLUImgYBbZd/IqYwu
         xkafhA3BerrvzAzUWIc9TI+OtbIfDB33l/fOeWpkr10MGZhvmq312EVKG4IOQW3l8Mjv
         aGB+UqtAse8hj3NCj/sy4uu79qs0wnz1y5Ne8+Um+Wl3POSq/TSk+LcmxgxoS4fmqCjk
         RdN4gxqRqnlC2WH+0+4wGejKO301P7s+o4NNndrp6/DJ2TK3To4kWp96JnkZUrC471RH
         n6QxHbgJmK8sPpV+2VIKKnUhFt9Dr+5NizYUgLaAeFD3qr6lMqBLvERtuhMVWmpo0nlo
         M6CQ==
X-Gm-Message-State: AOJu0YyZ5Yc+4AZISlHbph1EdHBoWq6uGctTGXJ0koQtPnmT0GK+wo1t
	YIzJZLkk6jVAxyY8/nKGXYdaB5sSh4G2woKAtl0ZPnbKQTMjFXuBgLRa
X-Gm-Gg: AfdE7cmOTFB9bxwXnTnEGSq4s0Fkebq2IxOFe1UtkmV5ewHfUv+E37+56Wuxm6NZhem
	LsyukiAZdtrZL5VmIkEanfKifP/YGCuAgBhzTS/NgOO8JVX7jq9H9ik9Y51VX/FOqgxy6GW8n5/
	eQC6WMEJqSw6I69ccavvewlL68H6v74FFe6bQGqsRAJm3buGCW8u/aJZcwUd5o8tCEkhR1YVHx0
	dtO3I72sCe0/Q7HlIsGlYGmpyZLP5/mYlohMR43vuh0wxojcDwlcyQVZbwL5Nia49WHAa8Cs0f3
	eaWtXhZsfUtFW61Jk7mVNTPnkAnLWRMe4hMF+urXdPiYKL7K/blbZkrGbIC6zUHsPZ+Q6Dgv723
	Hj/L0f+TmQvrliq4k11wGu2o+wJw2uhV+giL9gBtsAl7JCcMItbnIpzjnt0wnpsiQaymE4C+aDn
	mIU0arJL0aNPrUnfI=
X-Received: by 2002:a05:6000:310d:b0:474:83d4:9916 with SMTP id ffacd0b85a97d-47f4885698emr11121743f8f.17.1784170766798;
        Wed, 15 Jul 2026 19:59:26 -0700 (PDT)
Received: from tt.. ([31.223.44.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a940sm19511108f8f.12.2026.07.15.19.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 19:59:25 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH v3 1/2] crypto: algif_skcipher - force synchronous processing
Date: Thu, 16 Jul 2026 02:58:36 +0000
Message-ID: <20260716025838.2672-2-muhammetkaankilinc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716025838.2672-1-muhammetkaankilinc@gmail.com>
References: <20260716025838.2672-1-muhammetkaankilinc@gmail.com>
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
dropped and the request is processed asynchronously by a worker (e.g.
cryptd), which dereferences ctx->iv only later.

A concurrent sendmsg(ALG_SET_IV) on the same socket can overwrite ctx->iv
inside this window, so the in-flight request runs under an
attacker-controlled IV. For CTR and other stream modes this causes
IV/keystream reuse and allows an unprivileged user to recover the
plaintext of a concurrent operation.

Snapshotting ctx->iv into per-request storage for the async path is not
sufficient here. For ciphers with statesize == 0 - which includes cbc
and ctr - skcipher_prepare_alg() installs skcipher_noimport()/
skcipher_noexport(), so ctx->state carries nothing and the MSG_MORE
inter-chunk IV chaining is carried solely by the in-place req->iv
writeback. A snapshot redirects that writeback into per-request memory
that af_alg_free_resources() releases on completion, so AIO + MSG_MORE
with cbc/ctr would silently produce wrong output. Writing the IV back
from the completion callback instead is not possible either: that would
require lock_sock() there, but the callback can run in softirq/atomic
context, so it must not sleep.

Make the operation synchronous instead. ctx->iv is then only ever
dereferenced under the socket lock held by recvmsg(), which removes the
race, and the req->iv writeback lands in ctx->iv as before, which keeps
MSG_MORE chaining intact for statesize == 0 ciphers. The ctx->state
import/export path is unchanged for ciphers that do have state.

This is equivalent to the upstream resolution: commit fcc77d33a34c
("net: Remove support for AIO on sockets") removed the AIO socket path
across net/ entirely, producing the same end state for this file -
algif_skcipher never processes an AIO request asynchronously. After this
patch, _skcipher_recvmsg() matches mainline's crypto/algif_skcipher.c as
it stands today, including the same now-dead -EIOCBQUEUED check. This
patch deviates from that commit deliberately: rather than removing AIO
socket support tree-wide, which would be far too invasive for stable, it
removes only the AIO branch in crypto/algif_skcipher.c. io_submit() now
completes synchronously, which is valid for the AIO interface; AF_ALG
async is rarely used in practice.

The -EIOCBQUEUED check in skcipher_recvmsg() is now dead but harmless,
and is left alone to keep the fix minimal.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: <stable@vger.kernel.org>
Reported-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
Signed-off-by: Muhammet Kaan KILINÇ <muhammetkaankilinc@gmail.com>
---
v3: Replaces the v2 per-request IV snapshot with forced synchronous
    processing, after Sasha Levin pointed out that the snapshot silently
    breaks MSG_MORE IV chaining for statesize == 0 ciphers (cbc, ctr).
    The v2 framing of this as the counterpart of 5aa58c3a572b ("crypto:
    algif_aead - snapshot IV for async AEAD requests") was wrong: aead
    has no inter-request IV chaining, skcipher does.

No Closes: tag: the underlying vulnerability was reported privately to
security@kernel.org (2026-06-07), so there is no public report URL.
 crypto/algif_skcipher.c | 75 +++++++++++++----------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17f..35ebc3e 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -79,20 +79,6 @@ static int algif_skcipher_export(struct sock *sk, struct skcipher_request *req)
 	return err;
 }
 
-static void algif_skcipher_done(void *data, int err)
-{
-	struct af_alg_async_req *areq = data;
-	struct sock *sk = areq->sk;
-
-	if (err)
-		goto out;
-
-	err = algif_skcipher_export(sk, &areq->cra_u.skcipher_req);
-
-out:
-	af_alg_async_cb(data, err);
-}
-
 static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t ignored, int flags)
 {
@@ -171,43 +157,30 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		cflags |= CRYPTO_SKCIPHER_REQ_CONT;
 	}
 
-	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
-		sock_hold(sk);
-		areq->iocb = msg->msg_iocb;
-
-		/* Remember output size that will be generated. */
-		areq->outlen = len;
-
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      cflags |
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      algif_skcipher_done, areq);
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
-					      cflags |
-					      CRYPTO_TFM_REQ_MAY_SLEEP |
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-					      crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
-						 &ctx->wait);
-
-		if (!err)
-			err = algif_skcipher_export(
-				sk, &areq->cra_u.skcipher_req);
-	}
+	/*
+	 * Force synchronous processing.  The async (AIO) path passed the
+	 * socket-wide ctx->iv into the request, which the worker
+	 * dereferenced after the socket lock had been dropped, letting a
+	 * concurrent sendmsg(ALG_SET_IV) inject an attacker IV.  Mainline
+	 * removed the AIO socket path in commit fcc77d33a34c ("net: Remove
+	 * support for AIO on sockets"); the minimal stable fix is to always
+	 * complete synchronously, so ctx->iv is only ever dereferenced under
+	 * the socket lock.  This also keeps the IV chaining intact: for
+	 * ciphers with statesize == 0 (e.g. ctr, cbc) the chained IV is
+	 * carried by the req->iv writeback into ctx->iv, which is only
+	 * consistent on the synchronous path.
+	 */
+	skcipher_request_set_callback(&areq->cra_u.skcipher_req,
+				      cflags |
+				      CRYPTO_TFM_REQ_MAY_SLEEP |
+				      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      crypto_req_done, &ctx->wait);
+	err = crypto_wait_req(ctx->enc ?
+		crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+		crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
+				 &ctx->wait);
+	if (!err)
+		err = algif_skcipher_export(sk, &areq->cra_u.skcipher_req);
 
 free:
 	af_alg_free_resources(areq);
-- 
2.43.0

