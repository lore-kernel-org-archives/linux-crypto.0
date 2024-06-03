Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259DD5BACF
	for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2024 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717403668; cv=none; b=VE+qlvrnWIlomehj1JSga/swi4BuLbvPe8NQ7JH/Dy2i7SLLKSvMPG6MnxlawzTv1gsLBBItOMWqt531fQwHxECEiJ8KllJ8k/u2Kql9YS6a1Qcuy5UjWbJXIQDbZCAiSMkUVxPINNyMltgd43eybZVl9AtKYGb3k7TiGp0i9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717403668; c=relaxed/simple;
	bh=a3AuXZUrieP70IQpd4R+gNB1EkZH5otq06teCjaMINk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qk/FJ/BB7lTj4Ub605qmll/AVZbJmiSYueMzc4jEkJVEp8rccFQjESa+vbMgvaKDPzHPKjkojrAEvfmCviMqV905FnuBATzGz0X5IHdYH1WD5iH2IlTEwIttAOzMdt32buh1L7EM8XkreXPt7y6IuE9NI9Iak1FUcWx4zhKnHaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sE38u-0052ZP-2n;
	Mon, 03 Jun 2024 16:34:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Jun 2024 16:34:15 +0800
Date: Mon, 3 Jun 2024 16:34:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <Zl2ABxcUmNYD1DoF@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
 <20240601002415.GH8400@google.com>
 <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>
 <20240603023447.GI8400@google.com>
 <20240603082856.GJ8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603082856.GJ8400@google.com>

On Mon, Jun 03, 2024 at 05:28:56PM +0900, Sergey Senozhatsky wrote:
>
> Herbert, I'm not sure I see how tfm sharing is working.
> 
> crypto_tfm carries a pointer to __crt_ctx, which e.g. for zstd
> is struct zstd_ctx, where it keeps all the state (zstd_cctx, zstd_dctx,
> and compression/decompression workmem buffers).

That's the legacy compression interface.  You should be looking
at the crypto_acomp interface which handles this properly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
