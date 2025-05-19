Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C73B27464F
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 10:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747650590; cv=none; b=ccqY5Vw+kgbcUYqW81DCre7NXLOX+pK629NxIt4eB76Uk7JYYlPk8No7c0gtQ2TPZWtdIkda7d8Rr7XG1/hDIPhvyHuc5vhJeHRo2AUky1pLuj2GnpYk7xj5pxtjokhB4zFlfH9xOQZ5HJtrDzjBAQIsSYSz0bDRmn6Yb1+x/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747650590; c=relaxed/simple;
	bh=Dy/kgsQUUQR1q3ZhxV4DMytPBr572ofBV25/FfMssd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjPUGkVCb2ai/d0DGEk34WjjRRt989Tn1XeM06bwZ+M79RtpZKgxRJ9dixUYBP1voNY3rDLM/JDnP9MiPZ7mWDemZMKurj+vU/OrC+7Poc8x+HL/urx6vC8cS0uxYreqIUXODCvi2D/ArDycRWjvxiwACUnAFUrp1OUElqOXRyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VdJTZ2HI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VdJTZ2HI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nbJewJzc0g/TQgTZVFFdgumG8uS15IY8zDp/CcGsDGc=; b=VdJTZ2HI5jsgTAyaYNxlfjVt+n
	+e6D4IghayMk5a9MKQ4fXTD0qBJSNfUgWcR7cjlhw1FG5LRPew6fdt2fl1I2CwEFHQo+XT8t8jqHA
	Ls2fTcfyZ/n0QTjruVsJ4Bdiha/TsDdtD+ENNoy3j0HUvqoqVClRY4VLPYFIoAQHZuIY+szv3Crnk
	ixBbSLAhkkfmdI3JlWv2FszEG4hAMVgIp+5+n4xQ76y3EnYBHx9aC0Zh8vvD5uL+zs/U7ySi6cthC
	u/oBZl8rkDuupY9P7mam9GZ/Nar6n6hGkR3y2IHXmabULbcKWAeFK12q2kWQ8cZRsZa0zeez5GL1B
	y5ZR+2dA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGxkY-007DRZ-3C;
	Mon, 19 May 2025 18:29:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 18:29:38 +0800
Date: Mon, 19 May 2025 18:29:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: api - Redo lookup on EEXIST
Message-ID: <aCsIEqVwrhj4UnTq@gondor.apana.org.au>
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>

On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
>
> During this weekend's CI run, we got the following:
> 
>     alg: aead: error allocating gcm_base(ctr(aes-generic),ghash-generic) (generic impl of gcm(aes)): -17
>     alg: self-tests for gcm(aes) using gcm-aes-s390 failed (rc=-17)
> 
> Last week, we had a similar failure:
> 
>     aes_s390: Allocating AES fallback algorithm ctr(aes) failed
>     alg: skcipher: failed to allocate transform for ctr-aes-s390: -17
>     alg: self-tests for ctr(aes) using ctr-aes-s390 failed (rc=-17)

Please try this patch:

---8<---
When two crypto algorithm lookups occur at the same time with
different names for the same algorithm, e.g., ctr(aes-generic)
and ctr(aes), they will both be instantiated.  However, only one
of them can be registered.  The second instantiation will fail
with EEXIST.

Avoid failing the second lookup by making it retry, but only once
because there are tricky names such as gcm_base(ctr(aes),ghash)
that will always fail, despite triggering instantiation and EEXIST.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: 2825982d9d66 ("[CRYPTO] api: Added event notification")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index 133d9b626922..5724d62e9d07 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -219,10 +219,19 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
 		if (crypto_is_test_larval(larval))
 			crypto_larval_kill(larval);
 		alg = ERR_PTR(-ETIMEDOUT);
-	} else if (!alg) {
+	} else if (!alg || PTR_ERR(alg) == -EEXIST) {
+		int err = alg ? -EEXIST : -EAGAIN;
+
+		/*
+		 * EEXIST is expected because two probes can be scheduled
+		 * at the same time with one using alg_name and the other
+		 * using driver_name.  Do a re-lookup but do not retry in
+		 * case we hit a quirk like gcm_base(ctr(aes),...) which
+		 * will never match.
+		 */
 		alg = &larval->alg;
 		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
-		      ERR_PTR(-EAGAIN);
+		      ERR_PTR(err);
 	} else if (IS_ERR(alg))
 		;
 	else if (crypto_is_test_larval(larval) &&
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
