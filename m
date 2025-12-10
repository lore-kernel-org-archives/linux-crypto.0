Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2F317DE36
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765382036; cv=none; b=IxJ8B1wnXjp84FWZ2/rEZfWXF5o3V4HP3hQpbWiggL4+0V56C1gvj9eX4Ntp5bQy0ws4Xt3zpEerDzMKKOnMxqsYXuUhuvGI+tv3L8xYaDhKajgvzrj/kT4ajmGhLT6JC5UdIC1HhXQ1t/d9sjkiKSoTDhBL7GqgYFElDlsP374=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765382036; c=relaxed/simple;
	bh=2g02028C+zVsIvxOlXZSkhlJKt2dbs0tu/qd95vxLEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTyiseTJbebhzGpabBFMIy01Yn0xpKvm/sygDzqZqbxhUFG4L5+2QjdDuyQaT6JWE7Eg+oK5ZM0dB4LUDGIXH21AMPntjZRs+ya1MCFLkewNOIC234Spu13S+Hmc4Y1LGlZybQuPCqHrdq9+xsq1+6O9T5ikVBskfQRHemj/Ajs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=npvABpqV; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="npvABpqV"
Date: Wed, 10 Dec 2025 15:53:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765382032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gu+cBRcg8tNEeGl6figbDsVmD/cE7Gdc4leREM0GO3I=;
	b=npvABpqVopgh0Tb2BbPoLJjsiS6VzvhLSo9zzDMMgRMDd0+McGQsjc1RdJan15mQdPLffd
	4DBIOwEnLDBM1hrhbaHETg2ZoKYaHat25tEurPfKB873eqWr7GQiF6R6SrAOjQ23Wo+ruG
	B9Ee+P9Bdx0OF5wtiJzQIUpzvk7g9BI=
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
Message-ID: <ysfladvqa2hkprl7teggrxbr2gzxvvt3sfdpey5jz4wfrxdcrh@gznyrek6pzgt>
References: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
 <aTj22_idykAfpDNw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTj22_idykAfpDNw@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 10, 2025 at 12:28:11PM +0800, Herbert Xu wrote:
> On Tue, Dec 09, 2025 at 05:31:35PM +0000, Yosry Ahmed wrote:
> >
> > Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> > compressors.
> 
> OK so the consensus is that we're keeping the visible batch size
> attribute for now, which will be set to 1 for everything but iaa.
> 
> So for now I'm going to just provide a trivial acomp fallback so
> that non-batching algorithms conform to the batching calling
> convention for a batch size of 1.

Thank you!

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
