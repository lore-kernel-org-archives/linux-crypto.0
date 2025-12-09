Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1523E356
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242925; cv=none; b=YYlqciSmKtdyk+i3esav2HvifW1ChSWeGlLJqjgz5XGmmwpS2FhdjK/EfY6CRk1FtwoGcyYQl+Iji7mf57IA4weytUCN1t1aYUmNMSBb5LDIZEnFeZXlmeBb53x6PxhUqLLtH8t3JAd+IJxh8gGJvwJzV+seopBy4Hr5HGCImcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242925; c=relaxed/simple;
	bh=hzmr77gOPgTR+GVaoX52umr5Yk+wv25pyKRGOzuYrFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwJJMs7R5+ZF+FuXyWkvZyLCIRAQQw5NWaFgEluhdDFsODitUNaYYHVZTrghmP8d8SKO0m9eXqNdhj7r0f2ybChMBV84Ba+CVYc82mRlBWEgyFRIS/+IjODWeSUgbBTgPISu5btpNVykV44zEGe2kZGDElnwRuSIfO8A3wS2vc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ei2tDT+n; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ei2tDT+n"
Date: Tue, 9 Dec 2025 01:15:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEPBT0Xev9mXNC6uni6C9dTnCHCHjr/FCWwmgCETocM=;
	b=Ei2tDT+nWlmyhxNqRQP9tCKDJSJNCLCOatVZ4iyoAYOodCFg9onLqrMvpACATaFT+MggfS
	Pxf0sn53Wmuph5T65rMajz9B76E36PlpgJ2Ve2AiCeRrrCgy7cvzFuN0/GpLuCuUYTrX2H
	hWwZFL7hb4eqyuCUzZZ6H08IXbtaOcI=
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
Message-ID: <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
References: <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 08, 2025 at 12:24:01PM +0800, Herbert Xu wrote:
> On Mon, Dec 08, 2025 at 04:17:38AM +0000, Sridhar, Kanchana P wrote:
> >
> > I see. So the way my patch-set tries to standardize batching in
> > zswap_compress() is to call it with a batch of 8 pages, regardless of batching
> > or non-batching compressors. In zswap_compress(), I presently iterate
> > through each page in the batch for sequential processing for non-batching
> > compressors whose batch size is 1. For batching compressors, the iteration
> > happens just once: the whole batch is compressed in one call to
> > crypto_acomp_compress().
> 
> Oh I wasn't aware of this.  In that case there is no need for me
> to delay the next step and we can do it straight away.
> 
> I had thought that the batch size was to limit the batching size
> to acomp.  But if it's not, perhaps we can remove the batch size
> exposure altogether.  IOW it would only be visible internally to
> the acomp API while the users such as zswap would simply batch
> things in whatever size that suits them.

Just to clarify, does this mean that zswap can pass a batch of (eight)
pages to the acomp API, and get the results for the batch uniformly
whether or not the underlying compressor supports batching?

If yes, then that's exactly what we want for zswap, because it will
simplify the interface significantly vs. what this batch is currently
doing to handle SW non-batching compressors vs HW batching compressors.

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
