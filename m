Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C243F1DD0F2;
	Tue, 13 May 2025 08:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123454; cv=none; b=OqgvrLWQZPQKv4cAvopNS6o0ay3LaHZwpHzBfGRIq2l1MJKOLtmdIOiMZJG28JLtrH+tzqWvFn2nr3r085K07TPz2vUm6tpAEAu9mYslhyZN0fbhLOwB6YkXCx20M1zev6Jkx7dRixHCFMoF3+cxX7JEw1d5CKLjDAmAPnt7oHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123454; c=relaxed/simple;
	bh=uSbcxShINHYnSQx8wO/+fvnyfkSVNITyw0n0ZpsI574=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFWvcfRDolmbE42ZJDwu5K8hfAR3d9Srn3fucPzMyJHFzFxXhbhRQ+f4V6KzRqjD6IV37EcZ+M6L5szKsmEdcD4V7SvVFvlK7JQ+XYQzEnlgH5wOixzdof1I22bs+w28MBg13nfhWSwzCUoZmhzlAXFILTxCcv1I6/h7k+/xj0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RagQYqKr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RagQYqKr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tU3l2c07mvndmmHAYvuNdlNfXRDo6nfCCiXpFFqIq3Q=; b=RagQYqKrzdLqzAv2P/FxPi3WBt
	fdNGmGxw/EL3Y/nw8P/jcHVeYFc9KYBL+MqiWl3dO5WrVc8VOzk8ocvbV/kxQex2b+IVazwap2E+b
	ixaX2yMkF9RpAPUjfy+v55jbHSRAEZMKubQNifOmxiRbN9uOIM6UVGiDyqavF74fDm9V6VyiTmsjx
	1DQ4aQKWs74YEvVZ10Y6nGxogJXAR9RE/ZCHTsc1AMa5k2bWKgtcei+ZTlSaOjeA7IDO2CVwAkkO0
	nYA6qzbN/jUBCNkWeQ8A7mY4j0/SyVN+GU0FPXqE+jbvQJCI3J7ZvIwmYSMVoCzEkh8O8Dg3bIjQn
	ZB+suTNg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEkcF-005hQZ-13;
	Tue, 13 May 2025 16:03:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 16:03:55 +0800
Date: Tue, 13 May 2025 16:03:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Message-ID: <aCL86_v0jaqW8jxS@gondor.apana.org.au>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
 <20250508194134.28392-11-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508194134.28392-11-kanchana.p.sridhar@intel.com>

On Thu, May 08, 2025 at 12:41:25PM -0700, Kanchana P Sridhar wrote:
> This commit adds get_batch_size(), batch_compress() and batch_decompress()
> interfaces to:
> 
>   struct acomp_alg
>   struct crypto_acomp

An array-based interface is not acceptable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
