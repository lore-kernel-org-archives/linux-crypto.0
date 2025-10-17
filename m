Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB1023E355;
	Fri, 17 Oct 2025 04:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760674226; cv=none; b=PP07EIeK0unxq0Et2NS/98b4f6NrvRaXu9i7ZKsaKiSTQ2CsOBYJknpuIvKYgzvJGMxmVHLnLN8Vz5iWl2EKPh+gvLjUOTs9u8S8iroByXo51m4Y1Bp1tXGkO8JcyuvdpbEbcLLfRvYykQ0qT/DPEhdGk6n7i5pVtydJG5zyHJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760674226; c=relaxed/simple;
	bh=3D22VFwjh3UKRkTib78wEtIvOg05dSqsoXPJcUkrEFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsKaTYdnTRh3J8F8kux+fRc5HTe/pTnzCcbrHKYwT0hW8RwVCk7B4iJNpY5/ryIMI2Wi7XHtiJ6SyM7//HBH1WeaWOhtVidmCt3lVT1ehZ836/DJenn6zIl12jnG7TPaIsrdOf8Nqwhl4jLnvkoKR8Ka5hOjRPFQC/imF6JEMyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DMrvuDlr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DMrvuDlr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EpPlT+7SwkvzqCG91Lt33LnkHbmeGe8CImCIda8ktbk=; 
	b=DMrvuDlrhgie7oLUABRNt2ck14BU8ZEPSCPhfeMdGIh187lS070UcAVGKYFmMnoCO3Y4Sixl4Cl
	eKM4xVsWoNP2jlCwsOyNGkBgZ78ZXOuitTZpidSju80v8I12GnvgrHqCBOsehqDF2D55W1VmAN0vM
	X0sSv4JQF5nd+TPEXpQOnbD+ctw0xe8gJI6hIG4ZUe9dLHsirW5To1YQpEBMbG18r1+HTrYYdVl6t
	uTUyBr8FQ1rAym0/rCcxYOW4DML4Etz5szruhZs4CUoGczu/muqv3h8YguvzHmDdFAmjWUnKIqRFy
	NunefqaHlhdDEKqZsGb8Cd4kQ5Tatm6I2ysQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9bmp-00DKDa-0U;
	Fri, 17 Oct 2025 12:09:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 12:09:51 +0800
Date: Fri, 17 Oct 2025 12:09:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"sj@kernel.org" <sj@kernel.org>,
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
Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aPHBjyWMTddVNnwl@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
 <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
 <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>

On Fri, Oct 17, 2025 at 04:04:56AM +0000, Sridhar, Kanchana P wrote:
>
> These are for non-crypto users such as zram. I plan to submit an RFC for
> zram that enables IAA as a zcomp backend with batching support. These
> API will be used for this purpose.

We should be converting zram to ahash instead of adding this
interface.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
