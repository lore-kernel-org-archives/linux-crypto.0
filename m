Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953792F9DBB;
	Mon,  8 Dec 2025 04:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765167879; cv=none; b=sYQe4L0G+gzDwIeVI/sc6DhzNX2vqKoVdXu5eoA3RL/TpIc1NTjvf14nkXUInmrpxo5/W5zV1OPxVNXzlK43AgEe2AJisC1wa6oWGu/u0iMbtJh/8rCFSadbbpu7uqydZslb9sK6giHi1wjHoqThKY0d5hzS74u/AlCHn5K262c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765167879; c=relaxed/simple;
	bh=6herNMuZTor5un6Pe1zJujVuYvn9aRbQGlltUYfp6Nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCbLN03YPP2n57ycuOBcjtr1l3mtbPCpOZnksKP1E0qi+Jm9upmHBBBP3se9PJCMW0WEUCNY8Ap0g0GF8pWtbqG/I8GdhxFplgMWAWHptfDaR0hiLIdhrKBnwBaTrbW99OlSS3tMw/8ctaaI8bD3GeL2Ti206UuoVuADEAvNT9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pAX9BWs5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pAX9BWs5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=i/loCMcRK3SHcozV/rrXZo27ykLob1cEFT8/fXdhGbo=; 
	b=pAX9BWs5XC3KEOmZeupzQOtI/cj30E3YtWBMizDnBzLV1sarSrYDYsJqJYYnMbIw9f0Ha3KsfQg
	SOzxnTJEdldqQC7ZGLp/jd9Nllq5DOHdFVoTj4qIQkV3YXr0r9uYFvf1XVyEQsaezaknQ+6gTIYz3
	atXO4C/0T5iqpR510EsZ77iFDjXRdN1kqRGkOMjJmfsDYrRXtOGoIdDwsv77rwk68W9/R8g0Nh6al
	sEsynd2C4MIFRaKWnzXsnB2oABqWTOhxxCsuXaohy0bwpxygmQ6UGNEOExAiirUgI0r2ck0yfu4I3
	6GjUZoz/GMUyNtJEbtTy4uf8KbJJkzSqDqQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vSSn3-008ihW-33;
	Mon, 08 Dec 2025 12:24:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Dec 2025 12:24:01 +0800
Date: Mon, 8 Dec 2025 12:24:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, SeongJae Park <sj@kernel.org>,
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
Message-ID: <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
References: <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>

On Mon, Dec 08, 2025 at 04:17:38AM +0000, Sridhar, Kanchana P wrote:
>
> I see. So the way my patch-set tries to standardize batching in
> zswap_compress() is to call it with a batch of 8 pages, regardless of batching
> or non-batching compressors. In zswap_compress(), I presently iterate
> through each page in the batch for sequential processing for non-batching
> compressors whose batch size is 1. For batching compressors, the iteration
> happens just once: the whole batch is compressed in one call to
> crypto_acomp_compress().

Oh I wasn't aware of this.  In that case there is no need for me
to delay the next step and we can do it straight away.

I had thought that the batch size was to limit the batching size
to acomp.  But if it's not, perhaps we can remove the batch size
exposure altogether.  IOW it would only be visible internally to
the acomp API while the users such as zswap would simply batch
things in whatever size that suits them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
