Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD9E1714B2;
	Thu, 24 Apr 2025 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745505779; cv=none; b=L20KjtNCD/mPIOZ0VxdfjrbENXpQu8BM00JekMKI5xUSO5tnsxv9H8C2a5n6+BWphJEpljEFG8HwZBS3YNZw0m0aWKxQadP5QN0EFVpaza5AUCRTuOTBq1ZmUxKaa00vzul61bZ1yt4yoYCkfuyaoCL/sRLebW7Vczy+3tCVPMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745505779; c=relaxed/simple;
	bh=BqsuEfLmVQ54d1yAO977vIaq6YQIN3NLcabuMfK2m7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M2224r6fyp0oIFE7NsWVqymHJQMLuS8wxQiF6r5LvRX3rZ5k8cNxtW0h75F7Vcj7A73QkhxZxWiArYmdeTDAEYEgmvsmuQIVLhSYxGpOARMD2sxN4Kn8KfnetcxLXBGfeTsX0QTX+bvRy5je11BlDbDkF3IpRVdREPquf/JfH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=s1eDrVde; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="s1eDrVde"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zLdQVHzL4FKXauQ7XSb6g2ClL/VZ30PE02RIuDCShDQ=; b=s1eDrVdeXGZfcZJpDgHNd0dzRn
	f4lr9y3xBO1jffoVZzgim3+2DqAObzJeB7KVWiZbplr0RB+fWRyaC7vnpMLuOCDHVVJyfqnVV2Tr0
	eC0BTD6knf4EVvGu5mHRh0Qx5lB527snAQR0IqT5/U5OWnzHAnQzVmuEq+sOrmcyTM7/IqWJhEO7Q
	BOmMFXYxgOuymMZBtDzmJjTobhRl1AXIZGPhCgCszcfPvgsalb5J5DS3QWmSEfh+y2uKuXmAlxgK7
	3PRJmD4KqiqG4+M7ya+qckYghkeEWabjplpnRoj/mYKCj/6676kfmVnDpxHiPir8I2q4toaG6eCca
	nNRLT0gw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7xmt-000jRp-2o;
	Thu, 24 Apr 2025 22:42:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 22:42:51 +0800
Date: Thu, 24 Apr 2025 22:42:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: Remove CRYPTO_ALG_ENGINE bit
Message-ID: <aApN64n7i15ArnX4@gondor.apana.org.au>
References: <aAop_uMhxVh2l5Fy@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAop_uMhxVh2l5Fy@Red>

On Thu, Apr 24, 2025 at 02:09:34PM +0200, Corentin Labbe wrote:
> 
> Example on x86_64:
> [    4.637589] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [    4.637822] #PF: supervisor instruction fetch in kernel mode
> [    4.637931] #PF: error_code(0x0010) - not-present page
> [    4.638166] PGD 0 P4D 0 
> [    4.638359] Oops: Oops: 0010 [#1] SMP NOPTI
> [    4.638808] CPU: 0 UID: 0 PID: 64 Comm: virtio1-engine Not tainted 6.15.0-rc1-g63dc06cd12f9 #1 PREEMPT(voluntary) 

This patch should fix the crypto_engine failures:

---8<---
Remove the private and obsolete CRYPTO_ALG_ENGINE bit which is
conflicting with the new CRYPTO_ALG_DUP_FIRST bit.

Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Fixes: f1440a90465b ("crypto: api - Add support for duplicating algorithms before registration")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index c7c16da5e649..445d3c113ee1 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -23,9 +23,6 @@
 
 #define CRYPTO_ENGINE_MAX_QLEN 10
 
-/* Temporary algorithm flag used to indicate an updated driver. */
-#define CRYPTO_ALG_ENGINE 0x200
-
 struct crypto_engine_alg {
 	struct crypto_alg base;
 	struct crypto_engine_op op;
@@ -148,16 +145,9 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 	}
 
-	if (async_req->tfm->__crt_alg->cra_flags & CRYPTO_ALG_ENGINE) {
-		alg = container_of(async_req->tfm->__crt_alg,
-				   struct crypto_engine_alg, base);
-		op = &alg->op;
-	} else {
-		dev_err(engine->dev, "failed to do request\n");
-		ret = -EINVAL;
-		goto req_err_1;
-	}
-
+	alg = container_of(async_req->tfm->__crt_alg,
+			   struct crypto_engine_alg, base);
+	op = &alg->op;
 	ret = op->do_one_request(engine, async_req);
 
 	/* Request unsuccessfully executed by hardware */
@@ -569,9 +559,6 @@ int crypto_engine_register_aead(struct aead_engine_alg *alg)
 {
 	if (!alg->op.do_one_request)
 		return -EINVAL;
-
-	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
-
 	return crypto_register_aead(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_aead);
@@ -614,9 +601,6 @@ int crypto_engine_register_ahash(struct ahash_engine_alg *alg)
 {
 	if (!alg->op.do_one_request)
 		return -EINVAL;
-
-	alg->base.halg.base.cra_flags |= CRYPTO_ALG_ENGINE;
-
 	return crypto_register_ahash(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_ahash);
@@ -660,9 +644,6 @@ int crypto_engine_register_akcipher(struct akcipher_engine_alg *alg)
 {
 	if (!alg->op.do_one_request)
 		return -EINVAL;
-
-	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
-
 	return crypto_register_akcipher(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_akcipher);
@@ -677,9 +658,6 @@ int crypto_engine_register_kpp(struct kpp_engine_alg *alg)
 {
 	if (!alg->op.do_one_request)
 		return -EINVAL;
-
-	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
-
 	return crypto_register_kpp(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_kpp);
@@ -694,9 +672,6 @@ int crypto_engine_register_skcipher(struct skcipher_engine_alg *alg)
 {
 	if (!alg->op.do_one_request)
 		return -EINVAL;
-
-	alg->base.base.cra_flags |= CRYPTO_ALG_ENGINE;
-
 	return crypto_register_skcipher(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_register_skcipher);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
