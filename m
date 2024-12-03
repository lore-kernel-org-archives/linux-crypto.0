Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA4F2500C5;
	Tue,  3 Dec 2024 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733212861; cv=none; b=tuSIMWuJvSAQUlDz7LfSzOPc4KFNypOpmdfkmDYixZKp0cNfVM4HNEzsFKvbamIIakZ8pBPReKkgyxchEsXh0PJUKlNgIJZr1zRYn87b9Jl1R83jnJLQBCV5gLWK0JmCVT+Ob2ncCG09zNUiLf1zhn+mjJTIqoioV/7ii6Ciav0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733212861; c=relaxed/simple;
	bh=DxK2elVr2TglOMSfmiZzWk+c4ZqpAytERfWqpaeH6M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXsGnwyl+/xXhRb01L+xpckQ49biwqAEWU3VoeuUIVr7R0ecGrTle6nyGzaVAxXqp+JgYTz10N08oP8v9tEzZUxZiXg6FcDNWexcOhrE6wgjoZhVcVzZcpdhYmIOr305jvbnlkPSY4SsnEKmVpMOJ5+XXQOunqjPe9czwXr9/24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OjrM7Fi/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OjrM7Fi/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z5W6TzUmpOT8OeMseNLRswu8nLNRFfWLwSH5h9kFvf8=; b=OjrM7Fi/UEJfixgHY/bJ7qvuaS
	uRZMYNuC7UUE8nRW/QDiIfMPSbGVy5KTBnWolMExU1WQkVIfRMHIB3qbwfqMoiPBkqgivlMjeihti
	EFn0epR7oq9NhGUDRyxUKIEI6VL5VXd5Ujun8GjfO1rH0SFybeM/cWhgh6ZL4D6E1l5oRkKdqG724
	gmoF/8tFpUmsHcQ4Fh940aCHfIlemY4UhyuY6eB3KfUEM8j5g+2qDSDhN599sY6WsmFw3TSMpaTV8
	sfdZhfv1hRJYVWyV1T1at8kFyzpbeVsMUnVGQ+J32X6m9HsxTzF0hm8rVSHmPtg80pUiN7svPZ6Qx
	070tpn8g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tINpn-0037jd-0I;
	Tue, 03 Dec 2024 16:00:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Dec 2024 16:00:39 +0800
Date: Tue, 3 Dec 2024 16:00:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosryahmed@google.com" <yosryahmed@google.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@intel.com" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Message-ID: <Z066p53LoISwqkmX@gondor.apana.org.au>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>

On Tue, Dec 03, 2024 at 12:30:30AM +0000, Sridhar, Kanchana P wrote:
>
> > Why do we need this "can_batch" field? IIUC, this can be determined
> > from the compressor internal fields itself, no?
> > 
> > acomp_has_async_batching(acomp);
> > 
> > Is this just for convenience, or is this actually an expensive thing to compute?
> 
> Thanks for your comments. This is a good question. I tried not to imply that
> batching resources have been allocated for the cpu based only on what
> acomp_has_async_batching() returns. It is possible that the cpu onlining
> code ran into an -ENOMEM error on any particular cpu. In this case, I set
> the pool->can_batch to "false", mainly for convenience, so that zswap
> can be somewhat insulated from migration. I agree that this may not be
> the best solution; and whether or not batching is enabled can be directly
> determined just before the call to crypto_acomp_batch_compress()
> based on:
> 
> acomp_ctx->nr_reqs == SWAP_CRYPTO_BATCH_SIZE;

With ahash request chaining, the idea is to accumulate as much
data as you can before you provide it to the Crypto API.  The
API is responsible for dividing it up if the underlying driver
is only able to handle one request at a time.

So that would be the ideal model to use for compression as well.
Provide as much data as you can and let the API handle the case
where the data needs to be divided up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
