Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4741548C;
	Fri, 15 Aug 2025 05:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755235694; cv=none; b=Ctu017W8AMJHOeVcuOdYuCim/nGNry3dXHteR8DJePt3vq533/MLDfiDnWHowlCGCCr9qSSPe5g7BC0uREehRqSF4bnKPZRTiRq6mqXaBq30NyVVhhbGnJ7BCra2dxWLcBi9Zaaj2gMfH4vqiSCT2+yjRMIVSgJ+Nb02gJYIcCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755235694; c=relaxed/simple;
	bh=KazDKBICrXtV75odgrNMBAXSnSzflp28EnqPkDX6/4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czoXK6VbpfrqsokCX4v5lVQk2Yr1qyS3ZS5ddWtA+em5F2LsBY4oek3CwO9gHf3CH4Jn7U+U94yfZ+cJ2Ktvkc7H2gKjI3sXQkZnv8GHsgmNc/Iqu1uxKpa8nn319AGB+snnqkxOckQ8F9JW2BHcRhm0StwYclX0M9NWSIzAdk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=j0CBVXJf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="j0CBVXJf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ekkS1ZWS+pzycnB1GVKq4SzJlmTvcVcs3EVUltOGUlY=; b=j0CBVXJfcqI74bfbvH0tEreTBg
	uGXoDBgkX2iFqTuj8sNfCHcw5GWQ2DBDZodIUtmym1xP63ToEoWUDbMyHd+ZsHwAIn9+Zf3W4ZilS
	QzGz7UbITEWnb8/8jhmKXtdHhIco4MOqwCZujOJs1IGeo+FpXa6nBQxvF5PHTovRUvnOhIlVn+Rf6
	lU9QCxj3L+6Ord18B/C+iW/yqUDyB4kwzgn74XigyN/8Q7f+O40a7NQm0tsdWjT7Aj0EsAmFYUzpb
	307jsIMlm9iLhSk537sPKFOqWkjpn0kyg6E0M9byB8IjFZmgB97+NblQ/D3rNEkhiXMri7cZ6T/ej
	tMsjNxZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ummj6-00ETY7-3D;
	Fri, 15 Aug 2025 13:27:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Aug 2025 13:27:37 +0800
Date: Fri, 15 Aug 2025 13:27:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>

On Fri, Aug 08, 2025 at 04:51:14PM -0700, Nhat Pham wrote:
> 
> Can we get some comments from crypto tree maintainers as well? I feel
> like this patch series is more crypto patch than zswap patch, at this
> point.
> 
> Can we land any zswap parts without the crypto API change? Grasping at
> straws here, in case we can parallelize the reviewing and merging
> process.

My preference is for a unified interface that caters to both
software compression as well as parallel hardware compression.

The reason is that there is clear advantage in passing a large
batch of pages to the Crypto API even for software compression,
the least we could do is to pack the compressed result together
and avoid the unnecessary copying of the compressed output that
is currently done in zswap.

However, since you guys are both happy with this patch-set,
I'm not going stand in the way.

But I do want some changes made to the proposed Crypto API interface
so that it can be reused for IPComp.

In particular, instead of passing an opaque pointer (kernel_data)
to magically turn on batching, please add a new helper that enables
batching.

I don't think we need any extra fields in struct acomp_req apart
from a new field called unit_size.  This would be 4096 for zswap,
it could be the MTU for IPsec.

So add something like this and document that it must be called
after acmop_request_set_callback (which should set unit_size to 0):

static inline void acomp_request_set_unit_size(struct acomp_req *req,
					       unsigned int du)
{
	req->unit = du;
}

static inline void acomp_request_set_callback(struct acomp_req *req, ...)
{
	...
+	req->unit = 0;
}

For the source, nothing needs to be done because the folio could
be passed in as is.

For the destination, construct an SG list for them and pass that in.
The rule should be that the SG list must contain a sufficient number
of pages for the compression output based on the given unit size.

For the output lengths, just set the lengths in the destination
SG list after compression.  If a page is incompressible (including
an error), just set the length to a negative value (-ENOSPC could
be used for incompressible input, as we already do).  Even though
struct scatterlist->length is unsigned, there should be no issue
with storing a negative value there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
