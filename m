Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF22FE045;
	Wed, 27 Aug 2025 09:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287396; cv=none; b=duTZe270nqxz7sr3x/T7Dgjh2wi5FFedjwm9zXcInY4J2c3FJR6OBg2lGeJkoJEvkbwlOmtP+PrV6sb6viFHVP2w1W6tlfdygkRLa2YLZtTK5Dam8BCUrPZ8LZYQriAUV5TJNbwMAJv9VLPRNgfmcFgcsjbvlR63IUpyG86u25o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287396; c=relaxed/simple;
	bh=OpCBMIh7oPBhScfYLEiAsEBy7HOfgcmYTytuUj246Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7j6lNkftCLiJtcoBykljvHsnQjkFy6xlBgkZn+y7LBBjZ3jQWXxoRDoElM3pJhFgOBqtcWbEM7FhYnr/0hytThRn/F3hUA0RAdMFbdD3S0IvJl6VG1J0gGCrKNkGX0ytP8VQyDGkzdbRRv4cFV0QHBzb7QUNxq67Xk0mcdHmlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=e0wsJ4JN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="e0wsJ4JN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SEylZ2s1wsdWAWNZEjN8ZDeeCyouqfv7Du3sG3AvfiY=; b=e0wsJ4JNqUlKiFd9vMqFEo3SLH
	UDWQdQGoUkx6OV6usKTuYL1Ah1wN6373LUBQYVkiNxeRxYhSSyT28tbah8Q5zJV9/AXdpgvFGIfhY
	9cHeWw5ubnoPe8cC7rJ5rbLpBIS4HXwHEkZ73nw1+Ii8o0+u44rkBpt+MM0L2MWxumSUK5Pv9LHvK
	TiNjU5f8e38BjxjjvGcmQLqqB62M5ZKOScopj6dfp3gLqXva4Fun0HTxUMqEgc2lNbiPWPVVmJcQP
	jlTAEdK8yAnMA/vUUdDHYIwFbKImrq2LOr0G9Pd/b75NnVzs2UP54fQbniqb9IJCzVK2p0J0anMCp
	I2TKlhTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1urCKR-000B3s-0u;
	Wed, 27 Aug 2025 17:36:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Aug 2025 17:36:23 +0800
Date: Wed, 27 Aug 2025 17:36:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: crypto ahash requests on the stack
Message-ID: <aK7Rl7YC1bTlZWcL@gondor.apana.org.au>
References: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com>

On Mon, Aug 25, 2025 at 04:23:59PM +0200, Mikulas Patocka wrote:
> 
> I'd like to ask about this condition in crypto_ahash_digest:
> 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> 		return -EAGAIN;
> 
> Can it be removed? Or, is there some reason why you can't have 
> asynchronous requests on the stack (such as inability of doing DMA to 
> virtually mapped stack)?

Right, in general you can't use stack requests for async hash
because they may DMA to the request memory.

> Or, should I just clear the flag CRYPTO_TFM_REQ_ON_STACK in my code?

That would not work in general because of DMA.

> The commit 04bfa4c7d5119ca38f8133bfdae7957a60c8b221 says that we should 
> clone the request with HASH_REQUEST_CLONE, but that is not usable in 
> dm-integrity, because dm-integrity must work even when the system is out 
> of memory.

The idea with HASH_REQUEST_CLONE is to fall back to software hashes
when the memory allocation fails.  This is transparent to dm-crypt
as the Crypto API will automatically switch to the fallback after
the failed CLONE call.  IOW you just write your code as if the CLONE
will always succeed.  It will simply replace the async hash with a
synchronous one in the failure case.

However, this doesn't even work for Harald's use case because it
can't have a software fallback as the hash key is stored in
hardware.

Of course Harald's case doesn't do DMA either, the only reason
it goes async is to wait for the hardware to become ready.

So what I can do is bypass the ahash_req_on_stack for Harald's
driver by changing the ahash_is_async test to something more
specific about DMA.  Let me write that up and I'll have something
for you to test in a couple of days.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
