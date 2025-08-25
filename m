Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4877619309C;
	Mon, 25 Aug 2025 05:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756100369; cv=none; b=SBDC/dWpoFbd9BVcCKqXoztc45YvlPL7YCtoxLalmwNiBtuvQJyp5YkN1LgWGhyFFDK2guWPGQ+I+hnz8XljSybuCWqcH2omZN69+xQu8TnFqG6r38sxhxQXBkeonwFtBHrN1Cd0YNRQ+AwJJdXFmlFZQXpgl1XHV3+2DkZ+1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756100369; c=relaxed/simple;
	bh=WSJ4Gse9ryeEUTdsZ6WZfUn3IxNCRlYwK27R0occaRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SxZ6tOO0F9V/Q/znJwyO3LMiwX5JJdl0Tp3UtLgrpH7B1R55PdILrXhytZ0pyMMolIlsKKM6qE50gtvLzLcgZB+5D/9P4ouD3RyApt2/1xuhV4d7huxX1axQq0x+bU/knmcV5ol36rrMkWgV6DRXdcKMNaauHC7hmZc+Eedf8W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fafnno6i; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fafnno6i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LE7zGxWMAH8njov+JwT71yg831S+C58Rr2jhVSVOVZg=; b=fafnno6izLAUTtnGjIhzUHVapl
	NMFmtyRJEWADdP5q2HvCBsDGi5VuS0pqxt11KxOCtG1S9nE9DeZAn9iihgZGvynS7VToAf2XJqild
	HL4Tq64QcDzT8Fa3y56csOcpC4XttkiO87m404Mk6jKTxkEHBdqq1Dr78IS6JKJGM2aVZl4VgEfCW
	NTJABJNNeusue/cCD4qEfnc9mfgluYbCvFGrY6ZoHiWPIy7HtEMH3Eihlt7yXrlRaO9krQEXOG3wR
	3OEwb+xFdwIKzbFOs804ccj+CjpL/t4+NXOdlwEw4veKkUYMTLWLeYU7m2Qo9TpU2CdFmz3AAAMyi
	cAQ0hYWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqPfZ-00H0c1-1Z;
	Mon, 25 Aug 2025 13:38:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Aug 2025 13:38:57 +0800
Date: Mon, 25 Aug 2025 13:38:57 +0800
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
Message-ID: <aKv28XTvAITuq-p8@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>

On Fri, Aug 22, 2025 at 07:26:34PM +0000, Sridhar, Kanchana P wrote:
>
> 1) The zswap per-CPU acomp_ctx has two sg_tables added, one each for
>    inputs/outputs, with nents set to the pool->compr_batch_size (1 for software
>    compressors). This per-CPU data incurs additional memory overhead per-CPU,
>    however this is memory that will anyway be allocated on the stack in
>    zswap_compress(); and less memory overhead than the latter because we know
>    exactly how many sg_table scatterlists to allocate for the given pool
>    (assuming we don't kmalloc in zswap_compress()). I will make sure to quantify
>    the overhead in v12's commit logs.

There is no need for any SG lists for the source.  The folio should
be submitted as the source.

So only the destination requires an SG list.

> 6) "For the source, nothing needs to be done because the folio could be passed
>    in as is.". As far as I know, this cannot be accomplished without
>    modifications to the crypto API for software compressors, because compressed
>    buffers need to be stored in the zswap/zram zs_pools at PAGE_SIZE
>    granularity.

Sure.  But all it needs is one central fallback path in the acompress
API.  I can do this for you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
