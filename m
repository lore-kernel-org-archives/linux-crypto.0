Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48291C36;
	Tue, 26 Nov 2024 02:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732587288; cv=none; b=B06jLeOhYJfklC1p9a/pl9lMDQ1fP9XnbJYDQeVrFYpZUrvI8MkgsbTL/jC+GDhvr/n//YDanGYItemh/o32Q5g1Z+I3uw2MkJ7AqQdTFsQS7uZjDXdgWm9ngoeSa7GQiWCyJev0RYsfFzkocNiokrru94jpsau7S7ZXv9P4UDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732587288; c=relaxed/simple;
	bh=zvaVNLe4eWP6v8pf+H7+p7oAOEfZ/FdaecNBcN5k6q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBbjwmB6um83vtvaTU1ciqUJokdApb29FjGYZhtW/A4W6IUdmPm8hME8+cmxm+Y92D4aVMMrdPbDU5iX8OcQNTVeGMQSw4tDO6hN2WVMqqeDdh0SsftHFhXFRdycbYhYhJZTr+XYxCSGsz+SjZQ2X3+4LIzTC1uyvAF/iB5FxU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fVfsXJpx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fVfsXJpx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HW5bmkfEsEO4afm6N/ouLvyCq8Tlnrv48uhiKUCKCEU=; b=fVfsXJpxOmIX0z5K6Ls2We3sRT
	ULTySncUn3DOO/EEwfrXwU4iq88ssRqJ3jSyD5jjvPfktfkufIZC9Be+hK3UQojTCVAUPb2UYWM6e
	W7ITnV4txDIjIg9F1zoFh5Fwsmdp35AOXYa25aELrbvjkUKGj0CZjphKDTdj6QsHRaKorXIzxwxzX
	UilLntjhaP6NernHlD22YNyX4fX9hthpXLF3YFVi+mArqdrgHqLXJA4lwKYWE4LME+iQQTg/uBqAN
	dl9fxiFr5uosITMmH0gYNU06OD80ybP34mZMoTN23g2jeOaQVKdTOjDh0t3S2trMKTA/Tukn2MKV5
	jMJ5jKJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tFl5s-001g4K-24;
	Tue, 26 Nov 2024 10:14:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Nov 2024 10:14:24 +0800
Date: Tue, 26 Nov 2024 10:14:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Message-ID: <Z0UvACaa5wwtTgQu@gondor.apana.org.au>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
 <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
 <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <SJ0PR11MB56786BA58DA2E5C83824CBDAC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB56786BA58DA2E5C83824CBDAC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>

On Tue, Nov 26, 2024 at 02:13:00AM +0000, Sridhar, Kanchana P wrote:
>
> I wanted to make sure I understand your suggestion: Are you suggesting we
> implement request chaining for "struct acomp_req" similar to how this is being
> done for "struct ahash_request" in your patch?
> 
> I guess I was a bit confused by your comment about rebasing, which would
> imply a direct use of the request chaining API you've provided for "crypto hash".
> I would appreciate it if you could clarify.

Yes I was referring to the generic part of request chaining,
and not rebasing acomp on top of ahash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
