Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2C12D3A7B;
	Tue, 26 Aug 2025 04:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756181719; cv=none; b=li42f3wT/EXr3ikyc/d1GH94psLOd0ox8BxXC3gwNevFpmXD8eMVLbSyWl2G54a5+R68EI4FmT8gS86c8flKOrGdORtlvMthMMZCm9xL/YG53B5dlYdcWZlNH9z8a+TohQhv/T+bfky5oByZRbdQ4UMbGHrDO77EOycQh3BHP0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756181719; c=relaxed/simple;
	bh=fczNbiCT2Uje0IOvL2yy//lCqjb3lkrzhUOqVvwLfbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYLbxsFbhR2vOGqK0l46bpWCdM+d91RtA0czQV6C9fi7MRfeX5a0B8ObwtIqktTOU6NdV+DvHbr/nC2Y/xtnaXFyPqHVVJjUaIBBUlxI9o7H+YAV5IMEUxPzfjG7cSk/aZdzg1DyjKpN/ZfuYX4QxkLrPrlgPOJg/O6Yw556fw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=orenYixY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="orenYixY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ertIYPEFECJ0bvh76dRuNtOkYGLs+05loEH4MTifk1A=; b=orenYixY1R7z+wDwcpNDDXjvLl
	Zs9EOdg4bUD8MnprbkzgLahp57QL/LL+E4y2b5dmQ5xIcuPsGw7Bj55ZlOcjdf2oy7lH+jryamLOF
	8vdBASxwlFMoSzUYxpGgXEBzAUGZwc5T2nAtyRZE2RBalBVgsz/JBH+z0QdWf29XcedjF89WD/hjF
	tWpIDwa/Rk12XgjMNLWPn1ENLC1XMuvOhjmRn4Bedoa+vAYgT4wPz/rfF/NDSWVPkVM2DErij2GMw
	yxEjf1YfcTxrbMhEZx9XcRfjoGPlEQYWopyqNuY5nezXm1V1Mjjf/LRkoa5IbKoW8EOoQcAsgMW3Q
	hPNSbtpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqkpf-00HHmm-1S;
	Tue, 26 Aug 2025 12:14:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Aug 2025 12:14:47 +0800
Date: Tue, 26 Aug 2025 12:14:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
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
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aK00t9ld3YOWJo1I@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK0KNAmQh_JVgnML@gondor.apana.org.au>
 <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>

On Tue, Aug 26, 2025 at 04:09:45AM +0000, Sridhar, Kanchana P wrote:
> 
> Thanks Herbert. Just want to make sure I understand this. Are you
> referring to replacing sg_set_page() for the input with sg_set_folio()?
> We have to pass in a scatterlist for the acomp_req->src..

I'm talking about acomp_request_set_src_folio.  You can pass just
a portion of a folio by specifying an offset and a length.

>         for (i = 0; i < nr_pages; i += nr_comps) {
>                 for_each_sg(acomp_ctx->sg_inputs->sgl, sg, nr_comps, k)
>                         sg_set_folio(sg, folio, PAGE_SIZE, (start + k + i) * PAGE_SIZE);
> 
>                 /*                                                                                                                        
>                  * We need PAGE_SIZE * 2 here since there maybe over-compression case,                                                    
>                  * and hardware-accelerators may won't check the dst buffer size, so                                                      
>                  * giving the dst buffer with enough length to avoid buffer overflow.                                                     
>                  */
>                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k)
>                         sg_set_buf(sg, acomp_ctx->buffers[k], PAGE_SIZE * 2);
>
>                 acomp_request_set_params(acomp_ctx->req,
>                                          acomp_ctx->sg_inputs->sgl,
>                                          acomp_ctx->sg_outputs->sgl,
>                                          nr_comps * PAGE_SIZE,
>                                          nr_comps * PAGE_SIZE);

I meant something more like:

		acomp_request_set_src_folio(req, folio, start_offset,
					    nr_comps * PAGE_SIZE);
		acomp_request_set_dst_sg(req, acomp_ctx_sg_outputs->sgl,
					 nr_comps * PAGE_SIZE);
		acomp_request_set_unit_size(req, PAGE_SIZE);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
