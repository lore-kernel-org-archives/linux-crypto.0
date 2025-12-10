Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AEB1A238C;
	Wed, 10 Dec 2025 04:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765340928; cv=none; b=jtFzjv99SJ2KOYjW1sNi1Qq0+yk7QwIoit6x0diKhj1pxKU5lHdEmD4k4bbOAs+cVLq/1tcNMIR4lj8uDhxI9WfbQO7ub8fQHsoxdDR+Declq2BQjwjSzjb2ybmI+hrM/sbgMmmACSZgp7HJsHotyHcCxfJv/tdfwMzoiC4ukxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765340928; c=relaxed/simple;
	bh=6CM4F46MgFVj+IAUwJx1StxTG2QH6cDSf5deviCIHiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/+A6kP80qCqwOyQhrXSK/fTLnjp2N2807j0HQ9/hQ/7oYMK0Yaq1K4BCaxvicTI+HMLwFOKqGP0izPjeCPZvOFw9JLrozM85YDN0FaO3np+3ynjUpd3RmTORrqeAVs0nRFY5WfCh7F/du2woToJ7fmHKhpBl3FBVc311E/vk04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=o5UKxnlY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="o5UKxnlY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OQfWpBVkXWRGjFGQWDDm62eANx/f67q4RwxOcophSOU=; 
	b=o5UKxnlYep7lSUUwWim+bLfjwfHoogk/yS8buh8k6PyJYw1yI5o6xGQ9xBQJDxaxqQANVQFK9MS
	505DVNridkct6fi2LwX+dcbHT8Zq4RsmktcnEUAPY3riX3DBGZH7Ai/GcTpRKQy0Mi00E0yi5iH4f
	p93hlXyZI+84CNmdpT0aQeXxiOHQCTm1OI6FTDYurbMnxQiyRk69S8QsxiikKc/9vf9jAZufSJ2bP
	TmGRNBGWpDmHcaMRlezqlqasklsa5QitG7FAfkkEqVYQD+AnxHXVxQqU93AFSElFdXBpuKrNqakad
	pA+tUWzUMnBJfYiaNNefDxgrZU6Zoe9o5blQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vTBoB-009Bre-0u;
	Wed, 10 Dec 2025 12:28:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Dec 2025 12:28:11 +0800
Date: Wed, 10 Dec 2025 12:28:11 +0800
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
Message-ID: <aTj22_idykAfpDNw@gondor.apana.org.au>
References: <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>

On Tue, Dec 09, 2025 at 05:31:35PM +0000, Yosry Ahmed wrote:
>
> Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> compressors.

OK so the consensus is that we're keeping the visible batch size
attribute for now, which will be set to 1 for everything but iaa.

So for now I'm going to just provide a trivial acomp fallback so
that non-batching algorithms conform to the batching calling
convention for a batch size of 1.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
