Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9601A2594A3;
	Tue,  7 Jan 2025 02:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215621; cv=none; b=cQyV/HTxS/ngeAtJz1lm1hi5sik8+BGAVzsi2aLCJY6WkNVMwf29LTMOCGSJyFgIrK7mxolJfnB+GB3mUq1bOllHpzRyui95RwspTtLRMGvzWCRrgixavsf3WWgNcHD8fJu3B9IfwMOqPS6WLbEKGyvEP8UQ1PEkwa5p4raAchU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215621; c=relaxed/simple;
	bh=vKSqlLh3uW7XyGhhcnt8ynbMxFJWK5L0Ti48aqZuD4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKZVIXWSQqEHLLKZ6Br4jVfLH5hd+YQ9oKNfUCiYouAk+iFt2lpQ57jnzkQvu8gXVqwienkozCa28UKOf3ER/lHVua+VKJ9T2rcaV/YciQev+xdXraC6I8hWXS0W4Hibtj/7W2nBDqkrGTAelsfz6AEv9WvtJy1tltDUu4FVjJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ppt5WskA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ppt5WskA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IjuG/BOSvMcwQTrLlf/kxq04qceC6aED/k0KKY8cXVA=; b=ppt5WskAFKw+Q6/U7GneokZHAp
	tUbJs8JSz7pCSJRmTS1xH8C1jExjh18udUWENVKrf3apVj4be4a1zFlfNH8iXG0KIFZ9n7rOSP/Uu
	NHLQplvghi0c1Tcy4Zx7qhzCSUOCyurKnTxE/HUEekFqBSO1umlzLOG3kdqpx4M1iOig+yuqsymO3
	Rzov4HHt8E4QmIOFPc4ptMl9hhT/Hk4cc3dBjpie+hzIxN+T3x3yd1GWHdXA8c3w/yjZlLgHLxHcy
	YUbGhlIZk9Dtg80lQY11rG7k6dAHegzQdKTmWW1AM5DbomPVv+LXgelcYYzT7HN+EkqX7DBQSW72O
	c7GIu0Rw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tUymZ-006WZf-0q;
	Tue, 07 Jan 2025 10:06:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Jan 2025 10:06:44 +0800
Date: Tue, 7 Jan 2025 10:06:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
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
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
 <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>

On Mon, Jan 06, 2025 at 05:46:01PM -0800, Yosry Ahmed wrote:
>
> For software compressors, the batch size should be 1. In that
> scenario, from a zswap perspective (without going into the acomp
> implementation details please), is there a functional difference? If
> not, we can just use the request chaining API regardless of batching
> if that is what Herbert means.

If you can supply a batch size of 8 for iaa, there is no reason
why you can't do it for software algorithms.  It's the same
reason that we have GSO in the TCP stack, regardless of whether
the hardware can handle TSO.

The amortisation of the segmentation cost means that it will be
a win over-all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
