Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8547143895
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749059583; cv=none; b=A9g1hCuZ5QgRnlJbM0+gWY7W50XfdVzbIObpBbJIem/28vysDf2JtmVxOf1KnnqUWHtLBn1FMNHm9N51nCw6xZmvYBTTcQ5H7q5itnJfHteJ1NVcIER8j4tGSWnGgZg2nCP5zQLLwwvUiRYJ4/EcB2vBDe+uodZQ5tAw9UoJcXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749059583; c=relaxed/simple;
	bh=GSwHGeOTi8L6igU4mRIYZm24LI4S0emqniOA80aEzFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxEAqR7t3e51MrsxSAG2ewHU80LO7QvEfX43D07JIogAimZ456xEUznkPPTfvd9Ns/BZizdYRRjh4N+lJQxHYVPQAwlyNgln+omYDOnhF2JUi80k1Ky+Mz2ZayQV79qtamMVk4yn8iDVQpgaOM9pTQzRu77BWxZtu4uRjT1KZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nfGDFa/7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nfGDFa/7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZOoYvB+fAB/JfKchjdQMRiOE3imv1441r4WMAS9IYdg=; b=nfGDFa/7o9L+a0NF22S6GOBneA
	gbnYhqJLTKaTEh0FcsI5pb16LC4rk1W/cNWxIeodCfOlCYQEjabMNmCfvTJUTmC55xhRUUI9un4FN
	06JNW5OU/+qEOiqemzYTFqvqfzVd0GR2knmn8sdgzhW+XUj3Eq1+wbBjrFdEEVLIYy6hc9fVvV8NC
	qagekgFYB3WzJ/IhkQONdksVVm361gdhtJ8TgzSUjWANxCuUu1OgWzhpBGqzhl46OZzmrGt8k4cl+
	7GRxvlbY2WO3HuAQM114Lwwic7Z1RYaTN6fXoZy4ZdjPz/F08gYusoVKxHbdTv6JC4L5O9Pnpi2Rx
	sEHBHILQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uMkpV-00AnTk-0l;
	Wed, 04 Jun 2025 17:54:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Jun 2025 17:54:41 +0800
Date: Wed, 4 Jun 2025 17:54:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: [PATCH] crypto: ahash - Add support for drivers with no fallback
Message-ID: <aEAX4c2vU46HlBjG@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
 <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>
 <74ae23193f7c5a295c0bfee2604b478f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74ae23193f7c5a295c0bfee2604b478f@linux.ibm.com>

On Tue, Jun 03, 2025 at 03:49:16PM +0200, Harald Freudenberger wrote:
> Hello Herbert
> 
> I am facing a weird issue with my phmac implementation since kernel 5.15 has
> been released. The algorithm registers fine but obviously it is not
> self-tested
> and thus you can't access it via AF_ALG or with an in-kernel customer.

So the issue is that this algorithm cannot have a fallback, because
the key is held in hardware only.

Please try the following patch and set the bit CRYPTO_ALG_NO_FALLBACK
and see if it works.

Thanks,

---8<---
Some drivers cannot have a fallback, e.g., because the key is held
in hardwre.  Allow these to be used with ahash by adding the bit
CRYPTO_ALG_NO_FALLBACK.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index e10bc2659ae4..bd9e49950201 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -347,6 +347,9 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	if (crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE)
 		return -ENOSYS;
 
+	if (!crypto_ahash_need_fallback(tfm))
+		return -ENOSYS;
+
 	{
 		u8 state[HASH_MAX_STATESIZE];
 
@@ -952,6 +955,10 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	    base->cra_reqsize > MAX_SYNC_HASH_REQSIZE)
 		return -EINVAL;
 
+	if (base->cra_flags & CRYPTO_ALG_NEED_FALLBACK &&
+	    base->cra_flags & CRYPTO_ALG_NO_FALLBACK)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
@@ -960,7 +967,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
 
 	if ((base->cra_flags ^ CRYPTO_ALG_REQ_VIRT) &
-	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT))
+	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT) &&
+	    !(base->cra_flags & CRYPTO_ALG_NO_FALLBACK))
 		base->cra_flags |= CRYPTO_ALG_NEED_FALLBACK;
 
 	if (!alg->setkey)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b50f1954d1bb..a2137e19be7d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -136,6 +136,9 @@
 /* Set if the algorithm supports virtual addresses. */
 #define CRYPTO_ALG_REQ_VIRT		0x00040000
 
+/* Set if the algorithm cannot have a fallback (e.g., phmac). */
+#define CRYPTO_ALG_NO_FALLBACK		0x00080000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
