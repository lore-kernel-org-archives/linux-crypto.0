Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B831F4F5DF6
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484126; cv=none; b=FMlXrV4FhBn1CN801JDgLN4eY6koYpVYkrRPNK/FSSTeWipM0ofg/usm1TL+L+1r6Ekvftxj5NRUB6uZ/Kcg6sbIZHYUjFx+JwavCFw1C4kDHRkYK0EMi+fgaOOcegA/3v7HFPQ2s8U3JK7+Z2hQlNwhR8GeDEgPnrskS8tEKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484126; c=relaxed/simple;
	bh=su/8F93eR3DCxYd7vbyWgABeycTTutxA2s2wGzAe0DU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e2+WfjKF3uibg3nHpiGYRIKOlxMJX8QU7ipYM51BsyQzVi3JGoffuZcz8NPDIT6MiBM/mCICtFX52eXuQcAEBt1mCY/3vcspkLT03ur0SAGXxpP45TBIMREfSqtQU9mZ8wnctLslzl0+SuTbqDEV9QSVh6nNLbx63MUvZfy/MTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bZYnjuDX; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZYnjuDX"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-33e6279a1d7so3129968eec.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484113; x=1792088913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kdzJ7KNgE65fhQiH1f6TncoaY0MtDlTTwzl5EfVwG1k=;
        b=bZYnjuDXUTQcZiydIfblLC/mwZeOFfCNIPsfVr3EwfTvCUaBfPPRh4qMCfco2D8NpS
         l+I115v0sZP0idm6V6IFRwnjk6uuYikQedP+KLrGKES5opnoaQ6dVkKf8ebxQZPVCbPJ
         ZYm5yZHvKjKJ2NqZ86i4o5autIzF2ujZXfIfpY4QoGMvkHyr3P5zrDEf0TLE1MkYJCnT
         0dq9gwST1D5lXJb2O6Ach9CiWvrIzbZT18YHPU2SC92t4l9LMYEsMYZXHhYG35t/A6S9
         7pVMP1CBGzYnIyZOUM+1mvK5oV4SYPD0mHUzoM6fVMuc5F83ZTzSNeYMvOaaEG3yk+iw
         SQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484113; x=1792088913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kdzJ7KNgE65fhQiH1f6TncoaY0MtDlTTwzl5EfVwG1k=;
        b=LskIOxP7t7ALHHQwZdTJUGXlys2EhEfOZE4fqZKRjTREsI5fbQ8hBiz3m5v2zhJyN5
         8vIGsgqGIAppLjUu/LN5NM3eZsBmqrl/o8H2l+yZbro0pdBkKY7EAvKr/o2DGvr/uw9/
         CggIWWLArK1Su6trpr4EkDdnynK0hEndTyJx3pAGBCy0XcetUD6XE+flcbSwGxi/Pple
         DV1f+UmjNZdJoRCai03kS8FbPVFDA4nbjnwK1lAbRqbrKOrKZGCYffmlaXmju26gE2bm
         FWusig5Kkeg8bWxGBH3vuGzNDFBgG20Kbo2vk7dT58Evr39zTJZFvxUfAIbFJHH8i1O3
         f5Ig==
X-Forwarded-Encrypted: i=1; AKwUvBy7fAnyWUWKL6fuZxCD8aBVWkR3Wk//QKQpxEGwgdJCDfVaCEm356IwwgmC8rAZ5XfR8fX07rU76LwFjUQ=@vger.kernel.org
X-Gm-Message-State: AFuF++myQVpuHWZxSMQPRd2tKCwK0sE2xRRO3hsV70sx51h7te3C4Qso
	TEYSQpPoMsaq8ROFeHkM+cKW7xyZqpI50G6IbdaLqZo4cnINzDS4SvCXZ6r4wA==
X-Gm-Gg: AYBFou3+hjGaxbav2w7+OSBct/qHzNDYFC1h1qEf6/gluwbeAofbANtdl1WGNzARUvL
	AgLAipAbihMo+HpT1VXUUM6X8pZHr8u5nkhni1oAmKu7ATZegW6VTkbNhVnBUj2UmnbPM9Cv3dy
	kdorigH9m7uCYmFWeiEKCsVzcgK33J8ynWUlsmbGH2tmhT//p4bSpd76+7aSyiT0EmIZJESLvFs
	HFRjlZ5f5+TSDQeY9//PlcQLA1GAuLQNzYN8ab3nHZvnxeCGut0S8HQGZuFANKuIGrpkGvp9VgO
	gUPb5x/fJUaoG0Z7uoD/PFm0aXZZNFsiKzV2FnEH8q/IE5b7n1oV9TNL81hiswZU8CeHUKZ+OYJ
	23GiSw7GQideo60szT1WL8kcSWxV/84xWRCzCU9Lfh2IshNKjovHF0+6fYHzzmFHmRRWeKPfcaQ
	Xr36e5TeaABXn/TIu64Jx7r8+pzjjPDdTh8yQVVAoREX6gxn1ag0wq+RNQDRyTp6690GSso85lC
	u8ICkqNO84=
X-Received: by 2002:a05:701a:c90a:b0:15c:20b8:7964 with SMTP id a92af1059eb24-16206c264c8mr6939657c88.27.1791484112799;
        Thu, 08 Oct 2026 11:28:32 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:32 -0700 (PDT)
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
Subject: [PATCH v1 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Thu,  8 Oct 2026 11:28:09 -0700
Message-Id: <20261008182814.27450-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
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

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c         | 33 ++++++++++++++++++++++++++-------
 include/crypto/acompress.h |  1 +
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4de1a2ad577f..8c9a76073159 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
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
@@ -192,9 +198,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 {
 	struct acomp_req_chain *state = &req->chain;
 
-	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT);
-
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
 		const u8 *svirt = req->svirt;
@@ -242,6 +245,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -266,10 +273,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
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
@@ -279,10 +289,19 @@ int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
-	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
+	if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
 		return -EAGAIN;
+
+	if (likely(req->unit_size && acomp_request_issg(req))) {
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
@@ -294,7 +313,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 6462fc46f4ec..fc0665b77a8f 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
-- 
2.39.5

