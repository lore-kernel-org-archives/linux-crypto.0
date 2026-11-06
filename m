Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949865;
	b=h0mW2cVna7R9VO2xjF3mW2drSoSdHFZH4rot4aaM9wlDBbBDVdzgw5Nf24DmeJ4kh9sL
	 2trHwwne48TDQDkJ7HnThiruAqjxNWLw+thP2LF+Ks9D1eRYMGKGhwyFg+Rp6+ugNYMRN
	 yYHDST/q9CmuzgqOVZTQjuk9feZ0o4sM7WUBZ8RkdrblPP8tmF8UP3pOf+Wd6mLaKcz/9
	 1bskyHDhFG+sEHAjL8bnBIWHbLnf26EP0RSFVPfD4mo0wKsc238N3T8O1QlhHdMDuTKQO
	 3pXoi0+gBH0DH1YkzKxMENQgYIxtAaaU+H37BCUwNQdlvCfXXjuGbkSksz8cQkAn62Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
	b=V4M1wDQvOKVMWQ2QW1wHxAxbxlK/PUhLSF771eoQwG0Iqs0LOytLTVxAa1kP3QFJEN9v
	 nS3HO13KID2psaIqGrPAiJjZcVk8nbKwyWRdNjYvIDro6hAOAq3KQdFPRV8rLkQ46ViDT
	 JiIajH/Tnk3gHwu0Dktaqu8n6b/gpVrDqu62ANxAz2gR1Zl2Txtu4IV4uJptGgAb8QqH7
	 1AF3cLs5nR+zav4+KS7BW/alwQuANXRrKE5tksD0xbDU2GFMqDdD+kF9FdCa9F9Iezrr2
	 Wg2Zr+nwyAw31XQyc7SYpTfvLnjcXrXArNSXHu+sL8hFHbRVhzE4QCNqnVc2BFxXrcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="GkWy8V/9";
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE0606A328
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 07:24:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0EE0606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GkWy8V/9
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1ae58d17cd9so72108c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 23:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949864; x=1794554664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=GkWy8V/9IkIuUIJ0UOKh3sf9MiF3+iFShtYovIYkHHJ964fSMjnjk/turbU5CfVOgm
         Q4zi40aDgpzGnNcNv1FEmbV8afaaVdEcE5rlEnC9u6HzUNlpY73k5RMrJIOsAchEQvzz
         xHwHlTJ+YDq2HrSjd5MC0dGNuN/0O3Udj9kf826B8BjIQKoM22jn4huY/dgj1W2wPxJN
         HVRUYnOvQnZDGlrqjZyecLciunxx3Ko7CUXLRXtR2mYF/TnG8FA51Wqh35OBkfEFAHx6
         4w72E9IHXoRlyPvfQjP7aawka224/V5misZL46YjwOfWVNSeW6uhkIgd3bAX/G+FC/sX
         23sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949864; x=1794554664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J0Xj9pg0Rg2jp4fCvJcvvgKONDkNxiGPLuEEZm9n/Ik=;
        b=QCO39zOI1/HtBs6vK+HYEgyJlnwUoeH/u/MG1u0EKuR/+p86kaGhqYdup4krmHE4HT
         pL9rT4KKpBccBQ7UWYcjXvDs/l4K0L50p0b60jkwMhm+iu6D1azizVvaS3sLmii8gJ2O
         fIEG6MzmQ/iYPikV1iYrHPAp+u5ppvnFzEx3F5T8gNqbRFKRJAF0INb3QJjGJrQsYYMJ
         /w+YtalIR77EK4rnp+XxtEJlJyWGgnW0se04d+jZ0H0S+G1mgw1j5940nhAoVRcAy1gC
         FE5NsGp49WMd0D8n53BLT5uSU31zrA/GDk8ChRaIwhNrCOUyyq0zZbxfLEwuljVRyiXt
         onKg==
X-Forwarded-Encrypted: i=1; AKwUvBwJDiKcIA3rZbaqLMzW3AfmKSkuCRKDHTJoRONsJ85hBZAk0kb3TXZ8BoqCz0WfdcZJAhJQXsQsEWQMfnU=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZZvz5w4F6GRgStdpIIAOLWMxAm+41/qWiY6C+w3d6RdKFHQbN
	GfISulnObON4o4feT4gKfwkkjEde/IHIXr2hNlwo34cBHie1xN5RxLaP
X-Gm-Gg: AYBFou3joDrCsL6c7y7MK/wzWMvGsFxrdQjVQ3uZLaLc0j4beQMtBSLYv2PlKAjCGuX
	TYrZ3zxLwEHUvkC2s1kp6BzIJodz4jW83t6hoJVzDcZU2Cd3eXm0Cok3T4Kra9PWFmnx4FbdAGY
	QgOzf3Tos+FRUoIEGjB09J7fk1fs4OzL0DvTekdL37JaNOvTz71lZWyRSfqOFKb3OSpeWDwSfGv
	TVVdKUWKl1MRqqNDyCpkpU7Ywn63CAtGVbhwKhbZZ4L1L0egqf5KBpUgbANlkHEmJB6Lq/z4bPG
	bGoIyMOLMUk8niTitG2h8dBTbeE7GobsAodEN6V+64ur4LqPTBLNGYWZdFe/qlAMC+W5ugu4jXz
	P2zsdyKDckzVFNE2HJxf6kHrYTyqVDlxkjJ//HA55w8lvYoBPgmaBTk+uTp0vYcjnj7Qo3X3MgS
	eOslCsHPQbMoNbhI7nwlbprUvtfY+Tk1wYLIEMI4e4R2CrcrycNlPj9LUsP6Hfb5sJmAsVAbyZm
	pV01E0lErJzCmv1H7zayZGMaI8gzLX7aRPyzbDhLqas0dWXr2r1Cybn7gOxx1gCaOka8N2Ot2sy
	mFEAy1i/FeXnxnBvwyw0Zs5YInF85kOuDg3jrbS9yg==
X-Received: by 2002:a05:701b:2905:b0:151:2e62:fe4b with SMTP id a92af1059eb24-1b25d338dddmr1769252c88.23.1793949862359;
        Thu, 05 Nov 2026 23:24:22 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:21 -0800 (PST)
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
Subject: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Thu,  5 Nov 2026 23:24:07 -0800
Message-Id: <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
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

