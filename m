Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EEC15A85E
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020181; cv=none; b=qHxtNc/+097KSV5l5j6KiyQDdG4UrRQWCg/eil0wrnMkDPms6KPiF6tvUVMyS+rEbc52TxdaoFNUs7YJIoftQpn5WSnEmtL7A3cXr3Ii/gHJtCHfoX2pkFuaDtJNJL03JgB8YD1joOTum6FRcAXlXjjDUZ6KTO31Kzs1oqrRz2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020181; c=relaxed/simple;
	bh=XpuuRPgbvR58NLjRMrzeBkcnaNmZgVRVkUL3MOUl1w0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=qLiFiKW3aXWb2H8vXfJbZc8l/nmHrzxKgXHbw3fOl47fS/MKwDOU/7NzEKAmgw6iqEByuTgXo6DwM9kAjT/AiK7S/RgT/N+9eU787xpKUFSnHlfrV6lX5Dc3MVgteDcu3+X/tS3qPjURRShSAOBenKox4bMnsNHuk0boje6acbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kvqWVnof; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kvqWVnof"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=px3+EGYGgRRo3dZvAyJd19b/rdB7wjeF+foH69J0xUM=; b=kvqWVnofxY8Ql7MAJB5VGmgnlt
	ihOroNEz5pgNDZuDC4vVYKDG/ZnMrpgTyTeF3r0BS5Ujq113UTIypJ3GSmEudHavpJMLz6heJ/6OD
	aHalESuBjxnc1S3K3MJxliJjCnyON22UiXH9CYlvMXlyMhESfrH18cGzQ5sJPT72/ztAycqJJQhZT
	QpHusWIhkhmVDqoI4mYPFgP70wZjLpDV7pjbUgiLGXgaRhMx7IULQHEoeDYa+q3WZkCWW1pf7FcdW
	o8cHhnud90AWj4SGvi5jJXQdC/6BNZ50x4dgiozMgFKAg4V+tAZtN6QhKMd2Bd4emS46GGXDpwo7X
	q2lC5v3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJf-00DTHb-2k;
	Mon, 07 Apr 2025 18:02:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:02:55 +0800
Date: Mon, 07 Apr 2025 18:02:55 +0800
Message-Id: <5a8593a858c0531a61933ebf3cfe7cdd87ef0b2c.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/7] crypto: acomp - Add ACOMP_FBREQ_ON_STACK
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a helper to create an on-stack fallback request from a given
request.  Use this helper in acomp_do_nondma.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 14 +-------------
 include/crypto/internal/acompress.h | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 7edf2e570bf8..85cef01bd638 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -253,21 +253,9 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 
 static int acomp_do_nondma(struct acomp_req *req, bool comp)
 {
-	u32 keep = CRYPTO_ACOMP_REQ_SRC_VIRT |
-		   CRYPTO_ACOMP_REQ_SRC_NONDMA |
-		   CRYPTO_ACOMP_REQ_DST_VIRT |
-		   CRYPTO_ACOMP_REQ_DST_NONDMA;
-	ACOMP_REQUEST_ON_STACK(fbreq, crypto_acomp_reqtfm(req));
+	ACOMP_FBREQ_ON_STACK(fbreq, req);
 	int err;
 
-	acomp_request_set_callback(fbreq, req->base.flags, NULL, NULL);
-	fbreq->base.flags &= ~keep;
-	fbreq->base.flags |= req->base.flags & keep;
-	fbreq->src = req->src;
-	fbreq->dst = req->dst;
-	fbreq->slen = req->slen;
-	fbreq->dlen = req->dlen;
-
 	if (comp)
 		err = crypto_acomp_compress(fbreq);
 	else
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 5483ca5b46ad..8840fd2c1db5 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -23,6 +23,12 @@
         struct acomp_req *name = acomp_request_on_stack_init( \
                 __##name##_req, (tfm), 0, true)
 
+#define ACOMP_FBREQ_ON_STACK(name, req) \
+        char __##name##_req[sizeof(struct acomp_req) + \
+                            MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
+        struct acomp_req *name = acomp_fbreq_on_stack_init( \
+                __##name##_req, (req))
+
 /**
  * struct acomp_alg - asynchronous compression algorithm
  *
@@ -235,4 +241,24 @@ static inline u32 acomp_request_flags(struct acomp_req *req)
 	return crypto_request_flags(&req->base) & ~CRYPTO_ACOMP_REQ_PRIVATE;
 }
 
+static inline struct acomp_req *acomp_fbreq_on_stack_init(
+	char *buf, struct acomp_req *old)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(old);
+	struct acomp_req *req;
+
+	req = acomp_request_on_stack_init(buf, tfm, 0, true);
+	acomp_request_set_callback(req, acomp_request_flags(old), NULL, NULL);
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_PRIVATE;
+	req->base.flags |= old->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->src = old->src;
+	req->dst = old->dst;
+	req->slen = old->slen;
+	req->dlen = old->dlen;
+	req->soff = old->soff;
+	req->doff = old->doff;
+
+	return req;
+}
+
 #endif
-- 
2.39.5

