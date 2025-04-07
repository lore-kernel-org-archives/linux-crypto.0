Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA715A85E
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020178; cv=none; b=VqAU4cGtB0xASUa30RCHZRJSU5cA/Wi8d8saXIA6RoVQ8L20r+3a8aRgQ+W/1Cl5kTz7iuJFUWctZXEpeIQnXaWKM5D7aaHWqST84MHzoQDbeXamPETtXN2ztJ2WFkiZCutxy2W/Ttpxx7zDrjSlYzdFJC7h3MMZUqEwn5JoW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020178; c=relaxed/simple;
	bh=9q8CzWaDyp1yv8RNDJYAM4pd8DHVyuH2XIGOd/Y+jL8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=fAbRYb50O44HtFFsoqe35Wd83s2D8c+6nrTTsrSim9vewk5D6gsLN8CgTdWa0VeJ2qQHIrGIPsxQPqK58rgCqFpCTU3gIhxOFZKYBSKH2Pxs7fY2epfg6mz8aduz8BTK+mW4TAM19McZqYvBuh3gcnzTHyzb8fjIp0IBN1Y4EWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TFeDLg4Q; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TFeDLg4Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jjjfcrbdglAfHDZsLm4AQmzRyyIMxV2gmoAWlVJoeto=; b=TFeDLg4QjSVrIFOkdXVoUEer0Y
	TXRW7Cr1gG7Nv6IoTDZ/tw6NVzLi9iaCSzlPHQLqpZwT0evl82oFQMNlwqA1Asog6ogO8cImErn4w
	dcICk6cWZzwvEOxeejdLNuFMr9WsKFhBRV9h2ozVoJo26HVIux3mZ1nrFkLFrF0+sGkQKdnP1t1Eu
	KmFffjiRbEBIJYCZazuZRR5r6GdOB9I8XK3AMeNddqOi4F4hHGHHIlUyLQ17QybprZf9SOv43d/N/
	P3qupUEO5JByLTn86HeOwfBnJgF5+Biw3TBu6UTfvih01pvAkQLmuCUgImLmdPOd8lAvmRATIjJDS
	JSKoqlvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJb-00DTHE-0i;
	Mon, 07 Apr 2025 18:02:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:02:51 +0800
Date: Mon, 07 Apr 2025 18:02:51 +0800
Message-Id: <020d0876b0e76511fe0317069d32dac87416ac06.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/7] crypto: api - Add helpers to manage request flags
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add helpers so that the ON_STACK request flag management is not
duplicated all over the place.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/algapi.h |  5 +++++
 include/linux/crypto.h  | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index ede622ecefa8..6999e10ea09e 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -272,4 +272,9 @@ static inline bool crypto_tfm_req_chain(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_CHAIN;
 }
 
+static inline u32 crypto_request_flags(struct crypto_async_request *req)
+{
+	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index dd817f56ff0c..a387f1547ea0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -476,5 +476,29 @@ static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
 }
 
+static inline bool crypto_req_on_stack(struct crypto_async_request *req)
+{
+	return req->flags & CRYPTO_TFM_REQ_ON_STACK;
+}
+
+static inline void crypto_request_set_callback(
+	struct crypto_async_request *req, u32 flags,
+	crypto_completion_t compl, void *data)
+{
+	u32 keep = CRYPTO_TFM_REQ_ON_STACK;
+
+	req->complete = compl;
+	req->data = data;
+	req->flags &= keep;
+	req->flags |= flags & ~keep;
+}
+
+static inline void crypto_request_set_tfm(struct crypto_async_request *req,
+					  struct crypto_tfm *tfm)
+{
+	req->tfm = tfm;
+	req->flags &= ~CRYPTO_TFM_REQ_ON_STACK;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.39.5

