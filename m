Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8E527C866;
	Wed, 26 Nov 2025 05:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764136053; cv=none; b=kH5IWtMij0z1JI0nGVXUjTtMpeFXzO8xqOTVHHpsxjgg94tqhhnFvEfltEApTr7CAEImWSkx1mSbANy7pehriq7/mxaacVLfluIVXSC+S+Pk3388YHBb9foj90QR1IBui3GUx+9JXrAQb2sEaQ74EiGHfDrZWjLurLXLUIAMm9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764136053; c=relaxed/simple;
	bh=4e9fJgM/AcuN+PxARP5O6hVNt81YlR97wwI0sVV0Zh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPn4OKLaH8bvLIV1RBjXdSYHZG0y8tld270OZ01AIiqFr5nRp1tpGkvj16Y+SgnLDthK+k4RLzyX0gQSwuuzW+hKCFA+1PTLTDZ+9oaOP4kzVFZh5uv0AJwr0MqUlPfw+xl2iC36lZ59oFKp7b9PilsV/WW+UOH0l4poqCLRLpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=OmplT/o3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="OmplT/o3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9PiYG7KzQVU+BI4qqMtLKL4MJUBO1mej6VwEgS9g1DM=; 
	b=OmplT/o3NoKdujgRPehU7WFnzGjw6UlLogxLX6ZT+wVn1fexz00OjlJfqi0e+sLmKR5JWAMljWL
	GRmtRDshOqShheEHV0aPQe5YVY45kdzZcB8tWqG9uVscBfDAG/pQ0s9yRoGC5i4HOaUkEN6olnwme
	zKNjshGsQZ1qg3KHZkfKIEk8VU9jaGP0QynZ1ysHrC3XZib1oKmdKR5BYgYIFZr3jIipJ4gnoeTlv
	CbMyRJDhpSn2czokfIXV+RLm/DeSbk4eWOpQkbRUHVhZFeDBGl6OTWLfP3noGIixVXGULtNFBDS9i
	T0F2GRiyzKNtrwoT1Xb1p/iP2AHYuTbQou7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vO8Mj-0061xd-1y;
	Wed, 26 Nov 2025 13:46:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Nov 2025 13:46:57 +0800
Date: Wed, 26 Nov 2025 13:46:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>

On Fri, Nov 14, 2025 at 03:37:53PM +0000, Yosry Ahmed wrote:
>
> Thanks for the clarification. I understand that the error code has
> different sources for SW and HW compressors, but I do not like using
> errp as an indirection. It makes the code unclear. I would rather we
> explicitly check err for SW compressors and dlen for HW compressors.
> 
> That being said, I thought what Herbert suggested was that the same API
> is used for both SW and HW compressors. IOW, either way we submit a
> batch of pages (8 pages for SW compressors), and then the crypto API
> would either give the entire batch to the compressor if it supports
> batching, or loop over them internally and hand them page-by-page to
> the compressor.
> 
> This would simplify usage as we do not have to handle the differences in
> zswap.
> 
> If that is not doable, at the very least the API should be consistent.
> Right now the error code and length are propagated differently to the
> caller based on whether or not the compressor support batching.

Yes we should only have one code path in zswap, regardless of whether
batching is used or not.

The degenerate case of a batch with a single page should be handled
by the Crypto API.

So I will change crypto_acomp to take care of this case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
