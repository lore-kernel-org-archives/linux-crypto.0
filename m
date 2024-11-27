Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED402A41;
	Wed, 27 Nov 2024 05:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732683872; cv=none; b=ck7kvyXnx8+NSzW5jqmKvMqXCXOSONKvCY9SH1YnUq8mtGIYZ6cQrlzlJdr4DMZRduxJaOXa56dBSRTZyaW4W4eiuMLa/nepH3WXRFkxqk07X2L5CM1a29eBDsQov6SlUndMdH7pocEvvD8FrYPmESKqcvtyCA8JArkQhAQpTEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732683872; c=relaxed/simple;
	bh=CISUtfWCm4tjxNrlN5TMsdIt0AGlDDEfV6NsCzRG1UU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6ZFLDu0gY9MKAq9K+HQ0eJOu779SB/T2OYREeoxLZngm2eMDdmWgXYCDW8Kx9/XakB71RvnUpTEl19M1Kspund5n12RcAt5IjE/xTPpqDrjKcREqEr9C6ezzUsr/kGqsVHfQMh8MuKLxY/KyBzGtpFEO0UjX0aEfZQn3DcLEE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CdrpaBcF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CdrpaBcF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TpuBupC/Fg/kWCQSyEvFDOLqB6XQEy0ZHOzE4WezImU=; b=CdrpaBcFHW3j+PlyM327Vb7vdq
	S9p1cAsBs+aMB3E+u5RC9BWsuOJutEzaFcpZwm7rcPh4RqFbkvZcR5xYy0YGxvCtFfHljq0gDhsQX
	8kPUmHejibdKfQ+Q7g10lLXeZR684lYx1MCZ3NB61cebi4V5gylSw7B8tR0q1jM+JwF75JeP/2PmL
	Ado2QPyVV9hkIJrQYmp3L0cWzaftSPXEVngfYgiqYUq532nuJY1k5CMjhIZ+d05Dc75NR4DpRxsHH
	HBFbo7PkHfoFDJCjXKEQie9QsXCYxsIBGou043ga91s7wPJog3DH52CS4V6I/qgY1Nwi+KwGfzQM6
	5BWJV/IQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tGADd-001umI-0J;
	Wed, 27 Nov 2024 13:04:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Nov 2024 13:04:05 +0800
Date: Wed, 27 Nov 2024 13:04:05 +0800
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
Message-ID: <Z0aoRT8Dc7REMa36@gondor.apana.org.au>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
 <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
 <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <SJ0PR11MB56786BA58DA2E5C83824CBDAC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z0UvACaa5wwtTgQu@gondor.apana.org.au>
 <SJ0PR11MB5678654768005E5DF6542F2FC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <SJ0PR11MB567871A712CE2E971B909D93C9282@SJ0PR11MB5678.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB567871A712CE2E971B909D93C9282@SJ0PR11MB5678.namprd11.prod.outlook.com>

On Wed, Nov 27, 2024 at 01:22:40AM +0000, Sridhar, Kanchana P wrote:
>
> 1) It appears a calling module like zswap would only be able to get 1 error
>      status for all the requests that are chained, as against individual error
>      statuses for each of the [de]compress jobs. Is this understanding correct?

No, each request gets its own error in req->base.err.

> 2) The request chaining makes use of the req->base.complete and req->base.data,
>      which are also used for internal data by the iaa_crypto driver. I can add another
>      "void *data1" member to struct crypto_async_request to work around this,
>      such that iaa_crypto uses "data1" instead of "data".

These fields are meant for the user.  It's best not to use them
to store driver data, but if you really wanted to, then the API
ahash code provides an example of doing it (please only do this
as a last resort as it's rather fragile).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
