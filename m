Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52E3595A;
	Thu, 31 Jul 2025 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753926135; cv=none; b=uZACdU4ELK0iWqMVJiAYlUgsZDmCAMVKY1GsR/HXpdgP16VW8tuXjlU0tkWNY/Os0mQEU2F1+BHTcYMg0PoL+o62dH6rRPWGuzs4P1ATlutWq2/I7+FjbvH+H2/mDL3cSwSjqqsI5gDHhkTCrj1igj4Tp/mBemK6jXzPMaWKfkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753926135; c=relaxed/simple;
	bh=3ttz5uf+eDkagQqPoLMNabz0qD9G+K3casIipX6WcuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpfIsUeB5AgfQk0SoVFkg1onUqf9FGrmx0Vrf4I5j3kxsrJNdMC0wrkOWdrvAtOK37EjanTWxY1FPCEq7vyV97VbpTwCZNs5NVZ0oKqoDR1Xides0ubr5OfjvGOyN+2c3OnkQI5vqcJL4J25BzhHhIhEt73jFItSy3NKqEsT944=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Hcgq9ySW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Hcgq9ySW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CeRqajgUWNorO0Vmb4GutWh6yayHq5Ee251nk0JN5Sw=; b=Hcgq9ySW0bdco9MiSGZFeOyqqW
	nRuNlYqR29pan7DbUc8YvFseLLMVH3Qm8nUCHFVCE9PvrV4FpRak3JTHmEgv52cNfp9oKe2IE6Ybv
	o3PKTwpvak03jJKZXejUbPFyPFQNYs/yMu9mjRo+7x13xT9UFFvBSyyXa1wL2GWXrT/Y4s/s2rVus
	kT+nLZS7492AEzu9RWfvxRMRUF5UYuqrsbw2EgyxyzIuaphGsG3oHp3HPjry+7e04RV/aUH+IhKh0
	1YVDOZsMVoTpPPEoSGI1xEMeplIIm+aEkatc1v8SjhQ/sF156fcgw4tqTE09QKtt/w6rEwHz/9RPn
	0592Y7gg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uhI3L-00Arbb-1G;
	Thu, 31 Jul 2025 09:41:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 31 Jul 2025 09:41:47 +0800
Date: Thu, 31 Jul 2025 09:41:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH] crypto: hash - Increase HASH_MAX_DESCSIZE for
 hmac(sha3-224-s390)
Message-ID: <aIrJ295o-9zlRX6H@gondor.apana.org.au>
References: <8b954aa1-ce73-4f3a-9c8a-5667fac602c9@linux.ibm.com>
 <20250730161149.GA1162@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730161149.GA1162@sol>

On Wed, Jul 30, 2025 at 09:11:49AM -0700, Eric Biggers wrote:
>
> I haven't touched SHA-3 yet.  This is a bug from the following commit:
> 
>     commit 6f90ba7065515d69b24729cf85c45b2add99e638
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Fri Apr 18 11:00:13 2025 +0800
> 
>         crypto: s390/sha3 - Use API partial block handling
> 
>         Use the Crypto API partial block handling.
> 
>         Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> That increased the descsize of hmac(sha3-224-s390) from 368 to 369,
> which made it exceed HASH_MAX_DESCSIZE, causing it to fail to register.

Thanks for diagnosing the problem.

---8<---
The value of HASH_MAX_DESCSIZE is off by one for hmac(sha3-224-s390).
Fix this so that hmac(sha3-224-s390) can be registered.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 6f90ba706551 ("crypto: s390/sha3 - Use API partial block handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index db294d452e8c..bbaeae705ef0 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -184,7 +184,7 @@ struct shash_desc {
  * Worst case is hmac(sha3-224-s390).  Its context is a nested 'shash_desc'
  * containing a 'struct s390_sha_ctx'.
  */
-#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 361)
 #define MAX_SYNC_HASH_REQSIZE	(sizeof(struct ahash_request) + \
 				 HASH_MAX_DESCSIZE)
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
