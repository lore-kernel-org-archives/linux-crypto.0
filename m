Received: from mx1.wiredblade.com (mx1.wiredblade.com [162.216.242.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815CBCA4B;
	Mon, 21 Apr 2025 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.216.242.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745264146; cv=none; b=ndN7WKlTQDiasBW/lo1EqVpVMZkxbEx239CDtzpefHzjrLhG2i+FRpKIYIoy9p3d4SNMpxytX96Fzcatbcyq37nh/4kQgDLD6mx6DTHpgvJFYpSNN4Y7q0D0YY28cpKiY04fU1v7/GbPF37jZQRCnQtnSInVBL0RuyeSQEozP6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745264146; c=relaxed/simple;
	bh=aaLBMNZvy8fZ7qtxsrSTeduLpEzsO2UTknbaqwRyz0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tH6CPC8Bh3+IOc75zIAXCNAWnbBlkWh4mnoM614iI6FOhj/NeKYE1jq2fFVGFgTige/oRJOk0WlT0pqcjuKujvC3CpEts/kSW1oIpyJFyGFANuWw9EKLmrpyuqsr+qhIlr+6PssVtLTyKJEXGDkSQSqNQp48WcvxKwH8t+oe96g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=psihoexpert.ro; spf=pass smtp.mailfrom=psihoexpert.ro; dkim=pass (2048-bit key) header.d=psihoexpert.ro header.i=@psihoexpert.ro header.b=YL3W8wIM; arc=none smtp.client-ip=162.216.242.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=psihoexpert.ro
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=psihoexpert.ro
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=psihoexpert.ro header.i=@psihoexpert.ro header.b="YL3W8wIM"
dkim-signature: v=1; a=rsa-sha256; d=psihoexpert.ro; s=dynu;
	c=relaxed/relaxed; q=dns/txt; h=From:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:In-Reply-To:References;
	bh=GNwNTomk2L+xH30uYfzu2FmEUpjRULKpLyKzAyLVhg0=;
	b=YL3W8wIMfPPohLo9wQMqFQwhdCH3ok766H+QsfkpxktZ/36AQVcVd6jOkLW4ADsDkE1ZdO9h6Cvj5HUPblaNQUYPYwZ41OUSHsqR9BQxp0wfOJ8d/dAtKMza1185XfUO+cO5pmo0VoCVFC30RBL1QZfoRUzQyV+2YsEJqps7YyRA066JZyh7YCUXxZ0EoUO9FPPOZLvhtjvA4BV5JTE2FHanhSWdzyPlehi8bXck8P0Zr5q+sT/SQuYBMS
	4O1/lA3MPH4REv8xDuqM4LaSRK2B4sdBQSeWCTClcGDH4oqu9yOhRlg4zxDS7vMRKROKZnO7JS7V08Y72lJY7KB8tN2A==
Received: from GRAPHRT (188-24-192-106.rdsnet.ro [188.24.192.106])
	by mx1.wiredblade.com with ESMTPSA
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256)
	; Mon, 21 Apr 2025 19:02:25 +0000
Date: Mon, 21 Apr 2025 22:02:16 +0300
From: Marius Dinu <marius@psihoexpert.ro>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>, m95d@psihoexpert.ro
Subject: Re: [PATCH] crypto: scomp - Fix off-by-one bug when calculating last
 page
Message-ID: <aAaWODz21QmhPvpo@GRAPHRT>
References: <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9mB5IbNEdNdtmUp@google.com>
 <SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9nECMZW67F8XYoV@google.com>
 <SA3PR11MB8120A474C20104FF22CCE396C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9n-OnGPK7BOdGxR@google.com>
 <SA3PR11MB81202E35C1CAF0409711A1B0C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <20250420140116.b6db3aafcc2f99569190c97e@linux-foundation.org>
 <CAKEwX=P39kvB9Ei1xt+iOcDRMr32=ujGiKKa=e947k0MyJ7xZA@mail.gmail.com>
 <aAW8E9NrKWq1Xk2w@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAW8E9NrKWq1Xk2w@gondor.apana.org.au>

On Mon, 2025-04-21 11.31.31 ++0800, Herbert Xu wrote:
> On Sun, Apr 20, 2025 at 04:35:44PM -0700, Nhat Pham wrote:
> >
> > Anyhow, this looks like a crypto/compression infra bug. Herbert, does
> > this ring any bell for you?
> 
> Yes this looks like an off-by-one bug in the new scomp scratch
> code.
> 
> ---8<---
> Fix off-by-one bug in the last page calculation for src and dst.
> 
> Reported-by: Nhat Pham <nphamcs@gmail.com>
> Fixes: 2d3553ecb4e3 ("crypto: scomp - Remove support for some non-trivial SG lists")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index 5762fcc63b51..36934c78d127 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -215,8 +215,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>  			spage = nth_page(spage, soff / PAGE_SIZE);
>  			soff = offset_in_page(soff);
>  
> -			n = slen / PAGE_SIZE;
> -			n += (offset_in_page(slen) + soff - 1) / PAGE_SIZE;
> +			n = (slen - 1) / PAGE_SIZE;
> +			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
>  			if (PageHighMem(nth_page(spage, n)) &&
>  			    size_add(soff, slen) > PAGE_SIZE)
>  				break;
> @@ -243,9 +243,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>  			dpage = nth_page(dpage, doff / PAGE_SIZE);
>  			doff = offset_in_page(doff);
>  
> -			n = dlen / PAGE_SIZE;
> -			n += (offset_in_page(dlen) + doff - 1) / PAGE_SIZE;
> -			if (PageHighMem(dpage + n) &&
> +			n = (dlen - 1) / PAGE_SIZE;
> +			n += (offset_in_page(dlen - 1) + doff) / PAGE_SIZE;
> +			if (PageHighMem(nth_page(dpage, n)) &&
>  			    size_add(doff, dlen) > PAGE_SIZE)
>  				break;
>  			dst = kmap_local_page(dpage) + doff;
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Tested the patch with git master branch on the same SBC as my bug report.
It works. stress-ng --pageswap doesn't crash anymore.

Thank you!

Marius Dinu

