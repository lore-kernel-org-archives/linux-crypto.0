Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799AD340D86
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766157989; cv=none; b=p8nxfBonJlmtCWLqOEpkBpqecWdM1wm4VzcTn7+0HDIvAhr7JeoZUCk9uISbV7Zh0aj+Y71B1xPiTJMnWqLaYuBzmCYH+pjp4Aa8lL4oblkQJhrj8OdjuWQ0lcQvoR5+7L9DGJdAXXO3fFb3W1LaOJDOHQHhiwuoquQfY13eGsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766157989; c=relaxed/simple;
	bh=wlXqp8KfUthtA6YHPBmwca3I80pTZ/s2jvPFev9qqwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7BRA9FamGwfM8scqJECAss+aAJMqpUAdTzXlPMlgbSZvU9kh4GMeowJZEoXCUdmmQVNdErPRW7BS+Ea3oQp1E4ZgHJlHiGuSSGXM8q0FPQQokph55WSeCvrJQ4Sk6/sCXpssrd8WUrJdYexNBej2/rnF3jaSEQizsdWofx3plo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R3/X1Ce3; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R3/X1Ce3"
Date: Fri, 19 Dec 2025 15:26:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766157974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AV6l+3QPJOj+3ABXPS+GUdyLpMiv6Gbs09n7zqVMbwA=;
	b=R3/X1Ce3qK0UY2cGkwZriN0mfPxH7BKu3e44uRo1xI2IeUOmIIQ/OHYjE17tya25yQ16fD
	EVaqs/Rb2QvpXVI0fWgrlr5x/wta6dnXtWIJMgQMbqHaku2y1+RHbC0nGQW0Wlw73BK2ev
	irSs4A8Ao67m4tnsTzJYxkz0cJiNhFc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <uqznqihjuyfk3ifyxsjwp6x7nvk2vloinody6fomfuqepfu64n@25yboetztah3>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <vc65dxjoledwtojbcdgyxh2xt3hhlqrzgxcnbgufji7sgnhkus@fqkcflhwbags>
 <SJ2PR11MB847267511A5B6CF9EBFA1A0DC9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB847267511A5B6CF9EBFA1A0DC9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 19, 2025 at 02:29:15AM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 4:46 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> [...]
> > > > > Architectural considerations for the zswap batching framework:
> > > > >
> > > >
> > ==============================================================
> > > > > We have designed the zswap batching framework to be
> > > > > hardware-agnostic. It has no dependencies on Intel-specific features
> > and
> > > > > can be leveraged by any hardware accelerator or software-based
> > > > > compressor. In other words, the framework is open and inclusive by
> > > > > design.
> > > > >
> > > > > Other ongoing work that can use batching:
> > > > > =========================================
> > > > > This patch-series demonstrates the performance benefits of compress
> > > > > batching when used in zswap_store() of large folios. shrink_folio_list()
> > > > > "reclaim batching" of any-order folios is the major next work that uses
> > > > > the zswap compress batching framework: our testing of
> > kernel_compilation
> > > > > with writeback and the zswap shrinker indicates 10X fewer pages get
> > > > > written back when we reclaim 32 folios as a batch, as compared to one
> > > > > folio at a time: this is with deflate-iaa and with zstd. We expect to
> > > > > submit a patch-series with this data and the resulting performance
> > > > > improvements shortly. Reclaim batching relieves memory pressure
> > faster
> > > > > than reclaiming one folio at a time, hence alleviates the need to scan
> > > > > slab memory for writeback.
> > > > >
> > > > > Nhat has given ideas on using batching with the ongoing kcompressd
> > work,
> > > > > as well as beneficially using decompression batching & block IO batching
> > > > > to improve zswap writeback efficiency.
> > > > >
> > > > > Experiments that combine zswap compress batching, reclaim batching,
> > > > > swapin_readahead() decompression batching of prefetched pages, and
> > > > > writeback batching show that 0 pages are written back with deflate-iaa
> > > > > and zstd. For comparison, the baselines for these compressors see
> > > > > 200K-800K pages written to disk (kernel compilation 'allmod' config).
> > > > >
> > > > > To summarize, these are future clients of the batching framework:
> > > > >
> > > > >    - shrink_folio_list() reclaim batching of multiple folios:
> > > > >        Implemented, will submit patch-series.
> > > > >    - zswap writeback with decompress batching:
> > > > >        Implemented, will submit patch-series.
> > > > >    - zram:
> > > > >        Implemented, will submit patch-series.
> > > > >    - kcompressd:
> > > > >        Not yet implemented.
> > > > >    - file systems:
> > > > >        Not yet implemented.
> > > > >    - swapin_readahead() decompression batching of prefetched pages:
> > > > >        Implemented, will submit patch-series.
> > > > >
> > > > > Additionally, any place we have folios that need to be compressed, can
> > > > > potentially be parallelized.
> 
> [...]
> 
> > For example, you should remove mentions of ongoing work and future work,
> > simply because things change and they may not land. Just briefly
> > mentioning that there are future use cases (with maybe an example) is
> > sufficient.
> 
> Hi Yosry,
> 
> The mentions of ongoing/future work were included as per Andrew's suggestion.
> Hence, I would like to keep these in the commit log. Hope this is Ok with you?

We can keep them, but not in the detail they are currently in, and
avoiding mentioning what is implemented or not implemented yet because
it's not very relevant to the patch imo.

So maybe focus on the fact that the compression batching can be used for
other use cases like batching decompression in zswap writeback, batching
compression in zram, batch compression of different folios during
reclaim, etc -- without going too much into detail because these details
will probably change when these extensions are proposed.


> 
> Thanks,
> Kanchana
> 
