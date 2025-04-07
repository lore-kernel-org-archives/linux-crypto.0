Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ECC22FE1F
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020190; cv=none; b=bDm1te8zE+2DIxyYDBZ/oYvwrAQ4beOuhMuL5Kk9385tLGQ7ky0fm639kM0ySfTaxvb56C4kGcWi8zB59pt5AFeOJauQln7MSVuhygxOy9M6YYBbKW7H/NbqWGTcQh9G0P5WuWg3Kmxz1K9kSj68L272gNNviBPsgFsM3Mvz9CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020190; c=relaxed/simple;
	bh=Pykj9h6Tt2E5OuwDw3zOYT5CYEfrFx2Q27tJTW3JzYk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=cQ0SoOg1l5ZE2jAs74sWPyThj38X4RAOGxYdMej0aXt+skdNZnc4Tqwmn3/URH5FUfmfTcXuXOQfn9td+jVlbekfzpJ8Xew4ZOIO00MZ+rl+qc/mNNu9CLZdst0UAh9IRKK9jdqEO/3nP+jrMiUbGCAXx4k2Mvr2wUjPl5M1Ulo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=me+FtLn9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="me+FtLn9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RmqAi0FnR081KEUwLh7HrYLW0oIEOru0MTzQ3KJf5O4=; b=me+FtLn9b06FFkn0J0njGSX85L
	S0kMUIZN+uf32JaiIjFKYgRkZ0rVM+kd8ii5M3JgEatzwhBPsvkcb9RHPcUq/I/bKngyCj3fFSCTj
	5HeVYcMC57cUziT0V1Hszd1qM8VkAN9+UzlTFbvN6N77a9H2LUBHMjvkMh+Nu86K3RTmAw7KPPfH2
	Dc7dz35YA6LV+1nnmiInr0fn1JSSKhBI6/ZF3HTJz6jdhpeg4fDrSWLlcgUtm7riB6kSU8lx/sjZq
	UW9mRjvKZfce1mGJD4lwzCA+iBmhuHL+OlXweuv7fur4irIA5SwFn6mDmfjlZOW9y8eUaBaNEn2GS
	QaMWAimg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJp-00DTIS-06;
	Mon, 07 Apr 2025 18:03:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:03:05 +0800
Date: Mon, 07 Apr 2025 18:03:05 +0800
Message-Id: <92b18f60721e79d1f51da2a80abe3827b0115781.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/7] crypto: acomp - Remove ACOMP_REQUEST_ALLOC
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove ACOMP_REQUEST_ALLOC in favour of ACOMP_REQUEST_ON_STACK
with ACOMP_REQUEST_CLONE.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/acompress.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 93cee67c27c0..96ec0090a855 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -48,12 +48,6 @@
 
 #define	MAX_SYNC_COMP_REQSIZE		0
 
-#define ACOMP_REQUEST_ALLOC(name, tfm, gfp) \
-        char __##name##_req[sizeof(struct acomp_req) + \
-                            MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
-        struct acomp_req *name = acomp_request_alloc_init( \
-                __##name##_req, (tfm), (gfp))
-
 #define ACOMP_REQUEST_ON_STACK(name, tfm) \
         char __##name##_req[sizeof(struct acomp_req) + \
                             MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
@@ -580,21 +574,6 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
-static inline struct acomp_req *acomp_request_alloc_init(
-	char *buf, struct crypto_acomp *tfm, gfp_t gfp)
-{
-	struct acomp_req *req;
-
-	if ((req = acomp_request_alloc(tfm, gfp)))
-		return req;
-
-	req = (void *)buf;
-	acomp_request_set_tfm(req, tfm->fb);
-	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
-
-	return req;
-}
-
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
-- 
2.39.5

