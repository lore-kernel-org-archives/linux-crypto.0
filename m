Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148363;
	b=lLhw7iS17FSsDUq2EkBPV79Ng+cPGW4CE/x8M49aOxWanwLUAz3OkBaPr/hSprCmwDac
	 ON1+CGUuNb7ZwZQTF5+E/otWHt1RER7UoJLkh5rMUs8NePQvT1c+PZFIrptD3E/jvXllF
	 lkxyRSMdUW3jJZm+5k6bXrvaAblQyPeZtESUeEqKRql68wJTaPG7RB7Z74emEplUEzxx0
	 N+IqWl1GuSn5OA4JUYwpcp8zaN+pnDPZLQiPCq5YMwOg+Bpsgl6DAsO82UULgSHxpOPpk
	 1TKRTuYBF3eHUEAqlUEWjx8bP9tzOjKRlTVJJOHswDC8qFlUCJFlLUTWneRISeaBbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
	b=UV0nLzUMo0xkZuvZcwt/zzcqdyWniJuIRA/Z7MlqKee998qRahxfKEcmA5o/iztjla0S
	 D1NkeATGdkWpbmQg/RKffL/GDGYGLzEQFC+Jctsc5y6viG+icadJkthCpiP+tBEss+xZO
	 1tVd8oqIdCBB9I3ePoFd3q9n1f0vALm+FUtSyiv+ERgHuI0pwQJ4PgZLfbSxNY20od4tR
	 ksqNdHzAmoUQX55m4fqI20nE0UKTW1Ak1fnr2ar0iKiSQZZmfowUXHoaEuZpIQZNVPlMS
	 KfZzfZyRuGlMR5VgVfuTAnpgDxmzegoVr/u2Y+DMx0u2YHWtMUredaWyGwPgUWSfnpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YJ4hTO4U;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1496F60A2623
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1496F60A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YJ4hTO4U
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-14394530ec6so797493c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148361; x=1795753161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=YJ4hTO4UcEkpYGjYOpZQFbtJ+5FibUrZFg8XPDI8S6PYglbrAL+bj2PzNcdNkeN4mx
         uEwmcT2xG88d7b/HHEMM/YT8XC+b8dhYX3E7YWapxgofYRwG81Utv6NkuxXHrvlaQBBc
         qjPyfnjpffB/wzYMfO++MvxpjpIv/R9+/OoDdlxBfkgOVYAiHHU/tjjuODxbWw+5iMkR
         KJqRo2jfOXb368A7W24gVmiFibRBRa1gRKs3WYNymIBDlrlLun36kaK7tM+9VhsmfWSz
         szCabj1wNKBIDZUNUIo1LaRS8zrpMHCy/hIed8x80vpKAvC6H49Don29QYam0tagUos9
         yRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148361; x=1795753161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=jkitj11uWnEChxbIHlqEYs8OxK3KZEHx2uJtIjnwxcQJnpa/yACEIkryFvywjw/+H6
         +2ecM71ckzRWO3hChs1qFtWHXW2rLg2L1JIVxmpTQJDjZPf7MqjZ1K//Kw1rYfgzAxb5
         TdR+VhMsKrMagGCD1B5/iR+BTogi9clBsJzmCIC2g3E4PEsCwdAEy6QJEoElMA074cJw
         J+CRel/JNLkYl3SfV0uFJwLQwHUftmwN+7zczXNT45Fd28JjSwCr+hJMBybyWBCBr5g/
         XmslOR5/zHCAdjBFvjYWImOxZr3PCZMIeh7RMtnR8xva+FKR/57gjVZk2hyG1xqMR+zC
         n89w==
X-Forwarded-Encrypted: i=1; AL+hErErsf0qx6eDBmqCyMHw4RNRQdegB/9CT8AsiJycAixiUIemp9A2WKVKtLjT+BzkFZmxiispkW+GID7CUf4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+zxQVBDGxdAYAy/bdsBdAjXflG6alDToyaao2U5LOSC5xfEp9F
	uIVPgVvsLHoDqVin/yPRPc+Kf7rxWCm/etWOdyeXAkRyNkeNiYKggqsG
X-Gm-Gg: AYBFou3XvLrNSCdgB69wOU+nfegge0K8tuWNC2xKP1QWL8GWjksnuB28HHP2uVxHI2i
	3lrUfmFeflnTv39C9lKNJ88hm3rGWZXG5RLaYoSbhniFkK7bZH4r7GD7QsF6QzeuJe+8rQkxwAd
	rEbMyy6bCb60Uj7EEbL2C1OpUDlCHqQAl3DVxdqXGJx6D+1fjucgyhCtCU6/u4UHhAzRjVfchiF
	rnIjCle0DX+zIFogt41kp248UsS7c8faZ6DmWlLoswectIbueat2qNkgQNy7QW36qywcV58QtGn
	JHmLvex+dHYYbOmlEGJYc0QT9BYKA4p7eUsDe08hfhuk157Qvq7PqHR0EBsNVFgRc5OXBTjCc3Y
	uKcObIBqeEhgHYjXrQW0PUUnxRsk9RMSciyJqunCtLFAhzrsqqByiWQT5dfWCm3P/s+v3pVszNq
	WEYUfmyYVyNYuINhzQd9RafGJGRFGy7Z6lGqT/x8rw1wJiAzOcd7Hh/PQonTK4ntke9QP8Zsj13
	tA89vv3DO8Yc30FNNAHMHD+D6qHN5Qi5UG+WREaVJIjC7jU5GXDVri3lwn9fZ0bUUOJHDTLzxUO
	dEJm2khbgZYphty4W2RbWFPj0t1xHxw8KWYhg+3N/w==
X-Received: by 2002:a05:7022:3c07:b0:1b5:514:6a23 with SMTP id a92af1059eb24-1b55689e9b5mr1438994c88.13.1795148361171;
        Thu, 19 Nov 2026 20:19:21 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:20 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v4 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Thu, 19 Nov 2026 20:19:01 -0800
Message-Id: <20261120041906.5785-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch provides a wrapper for existing algorithms so that they can
accept a single segment while returning the compressed length or error
through the dst SG list length.

This trivial segmentation wrapper only supports compression with a
segment count of exactly one.

The reason is that the first user zswap will only allocate the
extra memory if the underlying algorithm supports segmentation,
and otherwise only one segment will be given at a time.

Having this wrapper means that the same calling convention can
be used for all algorithms, regardless of segmentation support.

To gain latency in the zswap_store() hot path impacted by this patch:

1) The most common code path is invoked first in
   crypto_acomp_compress().

2) The helper functions used in (1) are made __always_inline.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 34 ++++++++++++++++++++++++++---
 include/crypto/acompress.h          |  5 +++--
 include/crypto/internal/acompress.h |  4 ++--
 include/linux/crypto.h              |  2 +-
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index c8b4b8589769..ac4dc52668b8 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -166,14 +166,18 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+
 	req->base.complete = cplt;
 	req->base.data = req;
+	req->unit_size = 0;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
 {
 	req->base.complete = req->chain.compl;
 	req->base.data = req->chain.data;
+	req->unit_size = req->chain.unit_size;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
@@ -242,6 +246,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -266,10 +274,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
 	int err;
 
+	if (unlikely(req->unit_size && req->slen > req->unit_size))
+		return -ENOSYS;
+
 	acomp_save_req(req, acomp_reqchain_done);
 
 	err = acomp_do_one_req(req, comp);
-	if (err == -EBUSY || err == -EINPROGRESS)
+	if (unlikely(err == -EBUSY || err == -EINPROGRESS))
 		return err;
 
 	return acomp_reqchain_finish(req, err);
@@ -279,10 +290,27 @@ int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	if (likely((req->unit_size == req->slen) && acomp_request_issg(req) &&
+		    !crypto_acomp_req_seg(tfm) && !acomp_is_async(tfm))) {
+		int err = tfm->compress(req);
+
+		req->dst->length = unlikely(err) ? err : req->dlen;
+		return err;
+	}
+
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+
+	if (req->unit_size && acomp_request_issg(req)) {
+		if (!crypto_acomp_req_seg(tfm))
+			return acomp_do_req_chain(req, true);
+
+		return tfm->compress(req);
+	}
+
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->compress(req);
+		return tfm->compress(req);
+
 	return acomp_do_req_chain(req, true);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
@@ -294,7 +322,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 6462fc46f4ec..93fa02ce818b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
@@ -199,7 +200,7 @@ static inline void acomp_request_set_tfm(struct acomp_req *req,
 	crypto_request_set_tfm(&req->base, crypto_acomp_tfm(tfm));
 }
 
-static inline bool acomp_is_async(struct crypto_acomp *tfm)
+static __always_inline bool acomp_is_async(struct crypto_acomp *tfm)
 {
 	return crypto_comp_alg_common(tfm)->base.cra_flags &
 	       CRYPTO_ALG_ASYNC;
@@ -294,7 +295,7 @@ static inline void *acomp_request_extra(struct acomp_req *req)
 	return (void *)((char *)req + len);
 }
 
-static inline bool acomp_req_on_stack(struct acomp_req *req)
+static __always_inline bool acomp_req_on_stack(struct acomp_req *req)
 {
 	return crypto_req_on_stack(&req->base);
 }
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 93ae59623f13..0c0d3fc8a9fc 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -146,7 +146,7 @@ void crypto_unregister_acomp(struct acomp_alg *alg);
 int crypto_register_acomps(struct acomp_alg *algs, int count);
 void crypto_unregister_acomps(struct acomp_alg *algs, int count);
 
-static inline bool acomp_request_issg(struct acomp_req *req)
+static __always_inline bool acomp_request_issg(struct acomp_req *req)
 {
 	return !(req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
 				    CRYPTO_ACOMP_REQ_DST_VIRT));
@@ -189,7 +189,7 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
-static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+static __always_inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
 {
 	return crypto_tfm_req_seg(&tfm->base);
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 78c699ac3f82..0628b62e4946 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -492,7 +492,7 @@ static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
 }
 
-static inline bool crypto_req_on_stack(struct crypto_async_request *req)
+static __always_inline bool crypto_req_on_stack(struct crypto_async_request *req)
 {
 	return req->flags & CRYPTO_TFM_REQ_ON_STACK;
 }
-- 
2.39.5

