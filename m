Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198B63314C0
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299326; cv=none; b=swZFiGlrgqiyEZ/f/tVglXzolRmGRW/BWfTleGQ9WNEU09bYAamMx1RxE/fIIKGzQyu7PVZM/0/1yAi96Xf4E0dWC1bBIIv0VVjtw8z0PmtX3wK0sHzfmlp1JDFzMFxuS/bDuqFtfP/i1w7hQnUNMYXzbfU/tRLkHcelNrk+y6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299326; c=relaxed/simple;
	bh=mh/zyjILbjsCNntNgfGZoNeBaNpSRL4MRocdSbuYF7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhjrQSNDytVPe7Tznhe4+l0dFSgBVjZtXX591uIGHrdtl6Zppz8Q++DBI+WXPGuJKYE9KSnojsJvutArYOwNxagf8HJU3/JeymphIowD+8YUmaM+6FRKvs88yvxH/lGqP7uLETikYXbZZkj2fWEQggLB+jViO0f4NXUzPJMYCKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LceoDyAx; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LceoDyAx"
Date: Tue, 9 Dec 2025 16:55:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765299311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AcYeadRTyF+PlQ/oEdxR8E/IWsWlibs/HBIZ6+q3Odw=;
	b=LceoDyAxpvE0bVPr0vdjrLOLViws7k3o9OHiuVj41YsvMwvWJx5R2677mjvLPQGnzRqoBk
	piEdE6iNoURc4kLO/JARESprqJVuI2UaqLGtVft3X7+D+1wvHlITPjUD24WZxhSOUpUY3/
	9uF25WZjP0noAwibUEvSCF8UpnjGOTA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
References: <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTeKNEX5stqjG55i@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > 
> > Just to clarify, does this mean that zswap can pass a batch of (eight)
> > pages to the acomp API, and get the results for the batch uniformly
> > whether or not the underlying compressor supports batching?
> 
> Correct.  In fact I'd like to remove the batch size exposure to zswap
> altogether.  zswap should just pass along whatever maximum number of
> pages that is convenient to itself.

I think exposing the batch size is still useful as a hint for zswap. In
the current series, zswap allocates as many per-CPU buffers as the
compressor's batch size, so no extra buffers for non-batching
compressors (including SW compressors).

If we use the same batch size regardless, we'll have to always allocate
8 (or N) per-CPU buffers, for little to no benefit on non-batching
compressors.

So we still want the batch size on the zswap side, but we want the
crypto API to be uniform whether or not the compressor supports
batching.

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
