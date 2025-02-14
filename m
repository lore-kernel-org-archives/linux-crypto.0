Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B441B16DC12;
	Fri, 14 Feb 2025 04:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739508986; cv=none; b=tDhSbt5PhjMlh9cqxUxaLQAU2RLCu4gyWKXEjah5HakChjNQLoIFhWRfwp2OuTfYJRN+apSAmw11xMtSZ6t8XGMkM4UhQPxGZjcUw9Sh3Arxtb2xNwThLXYJHgq8rVkhb/tWDd7WlxVd5wUpanfbrVgrsfjWR07qekq3tlTZnVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739508986; c=relaxed/simple;
	bh=QBmPfSziU7mcj2ePBONzWfy0ZaFhuiN/7Gh7sGOqkLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKxbCvp7M54tL87sRmRZMZDcgnlhoOt5r6GAgHtjch2NOpsZOtc2G/0BpglyU5MqSKUVmVApZZpO12PwFu2Of0SVcMMJH/LIf/64aAcnmrBSe5HEjFbsTcRtXvIjP1WMdgfYUDY0jbSbVA6BRd4JVk31xFtYXj0DsghPC7pHcyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c1/zVKRk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c1/zVKRk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=krJe8yV8IQ5q17uTwD2a+k61avLmokiZ6lpNbWzhrlc=; b=c1/zVKRkjdwM1WpA0c5enod/bf
	+yxkYSufqwlKCAjaDrBf0ozX89Gb0qwUbIhRMpyaTch+lg/+KPTbNVtpf6kDGqT3xsGffRue7wEdo
	CAaz8vRA84F04vnFZnZnPQ7IQxIXLl6q7YWpMaLFOMJ4dbGPhfabx1V+D5A/mjD7itFRk7kMCpCGV
	KgwDk+WjgYS8BPgxrRHEoUAl5uvbI2LN7m62lWq8uN3RxdqTzR1mPo9RM8wW/U1yjyHQvt39Qz28z
	9LVCuz3yoqwsiRs1EDZy8O5gsTZAFpDb3lQZd8Cv0NpfWbw2yAWlNm5NNHfW6l0kHXBkIyiJ/mKwn
	ziT7ok3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tinXO-000EO9-0Y;
	Fri, 14 Feb 2025 12:56:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Feb 2025 12:56:10 +0800
Date: Fri, 14 Feb 2025 12:56:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-crypto@vger.kernel.org,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer
 hashing
Message-ID: <Z67M6iSoMyvGwkAF@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <Z66uH_aeKc7ubONg@gondor.apana.org.au>
 <20250214033518.GA2771@sol.localdomain>
 <Z669mxPsSpej6K6K@gondor.apana.org.au>
 <20250214042951.GB2771@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214042951.GB2771@sol.localdomain>

On Thu, Feb 13, 2025 at 08:29:51PM -0800, Eric Biggers wrote:
>
> That doesn't actually exist, and your code snippet is also buggy (undefined
> behavior) because it never sets the tfm pointer in the ahash_request.  So this

Well thanks for pointing out that deficiency.  It would be good
to be able to set the tfm in the macro, something like:

#define SYNC_AHASH_REQUEST_ON_STACK(name, _tfm) \
	char __##name##_desc[sizeof(struct ahash_request) + \
			     MAX_SYNC_AHASH_REQSIZE \
			    ] CRYPTO_MINALIGN_ATTR; \
	struct ahash_request *name = (((struct ahash_request *)__##name##_desc)->base.tfm = crypto_sync_ahash_tfm((_tfm)), (void *)__##name##_desc)

> just shows that you still can't use your own proposed APIs correctly because
> they're still too complex.  Yes the virt address support would be an improvement
> on current ahash, but it would still be bolted onto an interface that wasn't
> designed for it.  There would still be the weirdness of having to initialize so
> many unnecessary fields in the request, and having "synchronous asynchronous
> hashes" which is always a fun one to try to explain to people.  The shash and
> lib/crypto/ interfaces are much better as they do not have these problems.

I'm more than happy to rename ahash to hash.  The only reason
it was called ahash is to distinguish it from shash, which will
no longer be necessary.

> never use exactly the same API anyway, just similar ones.  And FWIW, zswap is
> synchronous, so yet again all the weird async stuff just gets in the way.

I think you're again conflating two different concepts.  Yes
zswap/iaa are sleepable, but they're not synchronous.  This comes
into play because iaa is also useable by IPsec, which is most
certainly not sleepable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
