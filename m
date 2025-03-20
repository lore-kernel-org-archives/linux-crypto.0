Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2761CC8B0
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742458464; cv=none; b=TPyz8mNT0ZUsqU3dbu1TtaA90EdSI/XGwGtBfzaO8+OvFM5jayWc/QkABvh6W3I43AGvxQTJk7gde0RrKSppnT8xUZYcoI6G/eFq+34rlWAN1X86J2QKDgBCkyBC99+mOCvXmIjbfhOLnS5U1fmlRMrXsh6xidtfoXJxctz4MNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742458464; c=relaxed/simple;
	bh=vEWwgINp3YIrOQZyUMn0yBTyJf9GdZsgswUbqjXXGiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWiI5ZQkns8hdctToKy5lAsM6C6TFiii7P9MKhggsuzniNCJwHV+IyJaEiqdoZJFJcNqImjOPF1iR3Q0Bb8TBKujfbl8KuNER6cyl45D4m3FKuZEWoduwHuBUGs8ugGbEhMT84ldQL0xS5OY7Q9Z841nirJgB9ZbRtwURFLXHZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hKlrBJvT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hKlrBJvT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4LNoPnuv3CGDskaddoRLtwJmcTbgV6cdnTYyUrPknTo=; b=hKlrBJvTvnJcV22k2XR3DrPLfx
	vgV4M0lyj0Oj+SUJzuiKdMDOf/aIoDdwSwLscpjRlWyl+9r70Y0dENFj0FW0MLRkaKdSWIVYK6KmA
	rX7C6S946FJdOtjx/ikLERdBUwS6tTqQR8vPIfiIg8/Q0UriwrguLLTh6EcGJOjLh09uR4XjNVCDW
	COS0Ww/LIaXO6ZPnmCFyz0GwT8txCSLptQLO73wwGATT+CvAUO1Yh1eDvMZKPU9iykeiMCRVr34xC
	pSJcpCC5bm40N8ggpA9fBbr3WRjUjBrsM2ba5LyHqjz4J69y1wmI8CDzRfU0QVckvYCtldkkd9Li+
	qHDJaIQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvB2Y-008eQx-1X;
	Thu, 20 Mar 2025 16:14:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Mar 2025 16:14:10 +0800
Date: Thu, 20 Mar 2025 16:14:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	YOSHIFUJI =?utf-8?B?SGlkZWFraS/lkInol6Toi7HmmI4=?= <hideaki.yoshifuji@miraclelinux.com>
Subject: Re: [PATCH 0/3] crypto: Add SG support to deflate
Message-ID: <Z9vOUut7CWJK0kVJ@gondor.apana.org.au>
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
 <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com>

On Thu, Mar 20, 2025 at 08:51:40AM +0100, Ard Biesheuvel wrote:
>
> IIRC Eric had some feedback at the time regarding the exact behavior
> of the zlib API, and I notice that the code no longer deals with
> Z_SYNC_FLUSH at all, which I did handle in my version of patch #3.

I didn't see any feedback regarding this when looking at your patch:

https://lore.kernel.org/linux-crypto/20230718125847.3869700-21-ardb@kernel.org/

Do you have a link to that discussion?

I was going to add the original USAGI workaround but then I
thought perhaps it is no longer necessary as our zlib has
been updated since the workaround was added back in 2003.

My understanding is that the workaround is not about Z_SYNC_FLUSH
but feeding an extra byte to the decompressor.  The only difference
between Z_SYNC_FLUSH and Z_FLUSH on inflate is that one would return
Z_OK while the other returns Z_BUF_ERROR,  both are treated as an
error by crypto/deflate.c.

> Do your tests have coverage for all the conditional cases there?

If you mean the scatterlists then yes I have coverage for that.

If you mean the USAGI workaround then no because I don't know what
triggered the original problem.

I do note however that zcomp which also contains deflate does not
have this workaround either.  If it was really necessary then zram
would have run into it and screamed loudly about not being able to
decompress a page.  Or perhaps nobody ever uses zram with deflate.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
