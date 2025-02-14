Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D9B41C85;
	Fri, 14 Feb 2025 03:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739505060; cv=none; b=JMJTtZ1pQ275eKv0ag9glybn2E6jbHw1e+VJfVRTkq+SA+KIYCAn0wq+8kSiJHb5JVWmH3AKBV5Ju7os40iLe3UYsWlDQBFXj+owYW9TXz+58C9BQiQGG3UDc7dRWZ1wg9EoHvXgWmyacVAfU8mrogWmHj+E8Y2ATByxegT3fYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739505060; c=relaxed/simple;
	bh=MASPfQyzOv9tcobGZFbxLBmds7u/iccI0/qeVNXfHZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izQwitVCFm/EwwvGyF9HBaoR600TKwodaT2WDYqImKLv4bpibKvmoCkE+clqsS+UHif63Eq4Ii+6S2WuR1937U+Ra+piQQXa6Tvavb0YFTqFXVxUkWfsf21Sthzx+Z238vniIgTY8YjEAjF+4g8Wtf+vxHldpC5rs+2adGbHV+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dW5AinHJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dW5AinHJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dSVMhfzPHKYPcVMTMnZqyr4OBSa7KstYIVuVF6WaaZE=; b=dW5AinHJmfj9B8vPIT+PpH8p4X
	E9tbjwbP/7wkcyLd+7sXxX58tjMwHxgdYqCUnjCq2y3EV6DvI5dHMmIqBJx5RcbPC41sPPB/qHzqD
	DnXPfplfBE8Lzcj92BjefT+OSoF1ac4O+emS3L0bh1SW6GZIkLEK2h7cxO62cRc+WruGGmtlpsp2z
	cd/cOJUlID0579rcCEtdaJxHwHa3T86WicSQUzIUC5qqpLFqyk8mHG6kJFzVVjfYyNSYkZeWHQlf+
	nw9tUS5yUsXxq/inwkcvsEtiiYaSg5osggt/GuCvCF1XgUlTTuhqu80zPRD+6i0bhuByHydOalCwH
	YAbom6bQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1timWA-000DqF-1W;
	Fri, 14 Feb 2025 11:50:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Feb 2025 11:50:51 +0800
Date: Fri, 14 Feb 2025 11:50:51 +0800
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
Message-ID: <Z669mxPsSpej6K6K@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <Z66uH_aeKc7ubONg@gondor.apana.org.au>
 <20250214033518.GA2771@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214033518.GA2771@sol.localdomain>

On Thu, Feb 13, 2025 at 07:35:18PM -0800, Eric Biggers wrote:
>
> It absolutely is designed for an obsolete form of hardware offload.  Have you
> ever tried actually using it?  Here's how to hash a buffer of data with shash:
> 
> 	return crypto_shash_tfm_digest(tfm, data, size, out)
> 
> ... and here's how to do it with the SHA-256 library, for what it's worth:
> 
> 	sha256(data, size, out)
> 
> and here's how to do it with ahash:

Try the new virt ahash interface, and we could easily put the
request object on the stack for sync algorithms:

	SYNC_AHASH_REQUEST_ON_STACK(req, alg);

	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
	ahash_request_set_virt(req, data, out, size);

	return crypto_ahash_digest(req);
 
> Hmm, I wonder which API users would rather use?

You're conflating the SG API problem with the interface itself.
It's a separate issue, and quite easily solved.

> What?  GHASH is a polynomial hash function, so it is easily parallelizable.  If
> you precompute N powers of the hash key then you can process N blocks in
> parallel.  Check how the AES-GCM assembly code works; that's exactly what it
> does.  This is fundamentally different from message digests like SHA-* where the
> blocks have to be processed serially.

Fair enough.

But there are plenty of other users who want batching, such as the
zcomp with iaa, and I don't want everybody to invent their own API
for the same thing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
