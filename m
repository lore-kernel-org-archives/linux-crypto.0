Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF342DC79A;
	Thu, 11 Jun 2026 05:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155157; cv=none; b=B0mR4hZmFbdKtEv9O0PhT+yxHmOcyHliOuCDcKDeQX+YARPW8cOCJOkJDfStCYreZdF4YXfkp8rkRyiArqds1b6UC5/tbpOaFC36ECc4otBs3IBy4plxvl36qgTtsjB6WhuB/gqQfJSJzCe6tfc7Myda0001VVme8qUJpyAa2Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155157; c=relaxed/simple;
	bh=0/531jh9w7N2Jito9faCI6Owt85XSLYEop8eaUXTl1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxxyNapAZdicAzAGPohBdKp2Ss0ZFgze9YgsfwSCHdz87v8b0dplwK0AQBuN8sO6bGKZDMISP0vNKqrcd/PowbQyxZ9IQdhKAgWcUPMCaAfhkBCayZpdmaDbj/FMpF53hbZgBUofLnUxSm+ahHugcA3av8Fy4qplGPEb0KhQ8Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ju31wBPV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ju31wBPV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=d+ZQbaiZa9tC6Gx9PX/6bcUSHoQNHgKzJypHg3mzfYM=; 
	b=ju31wBPVuIek8MIbLXDzLlbV9CJ6b98CysCIeWaiy4kkAOV5x55iVMEdRjogPu9c+6DAawr7DYt
	CdoAkyFVeiWI8p997rilBJXv2GWkT2Rnt+NRnms07LuEZE1G56jridQ8K6vEMMJTdCOday85pWUqQ
	DejzNpn/tu5hT93o3RDFn7rqd8PTvwqbRMrVQo8g4OpLNYQQRaKOqm0XhSg0IGBBMAd1HaumRD9ne
	+rBg52/Ag0qBvyzMRSXkFZ+92xDDsXpEm86hZBSv8fgcymxizv9jxySHOcymagVhgqRCR5JqIGLXm
	WS+yxbdWvbLXBiGtFqNaWNmi1YU72xIqzWFQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXXos-00000004U1y-0Pmt;
	Thu, 11 Jun 2026 13:19:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:19:10 +0800
Date: Thu, 11 Jun 2026 13:19:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Max Clinton <maxtclinton@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org, davem@davemloft.net,
	security@kernel.org, stable@kernel.org
Subject: Re: [PATCH v2] crypto: algif_skcipher - snapshot IV for async
 skcipher requests
Message-ID: <aipFTpbPrnp9YStI@gondor.apana.org.au>
References: <20260518233538.705966-2-maxtclinton@gmail.com>
 <20260601192927.1095129-1-maxtclinton@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601192927.1095129-1-maxtclinton@gmail.com>

On Mon, Jun 01, 2026 at 03:29:27PM -0400, Max Clinton wrote:
> AF_ALG skcipher AIO requests currently use the socket-wide IV buffer
> during request processing.  For async requests, later socket activity
> can update that shared state before the original request has fully
> completed, which can lead to inconsistent IV handling.
> 
> Snapshot the IV into per-request storage when preparing the skcipher
> request, so in-flight operations no longer depend on mutable socket
> state.
> 
> This mirrors the algif_aead fix from commit 5aa58c3a572b ("crypto:
> algif_aead - snapshot IV for async AEAD requests"), which addressed
> the same shape of bug in the AEAD sibling subsystem.
> 
> Tested on Debian Trixie 6.12.74+deb13+1-amd64 (unpatched) and on
> v6.12.86 + this patch via virtme-ng on the same host. Reproducer
> results: 10-14% race rate over 50000 iterations on the unpatched
> kernel against cryptd(cbc(aes-generic)); 0 races at 50000 and
> 200000 iterations on the patched kernel; 0 races at 200000
> iterations on the unpatched kernel with the synchronous
> cbc(aes-generic) driver as a control case (confirming the race is
> gated on the async dispatch path).
> 
> Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> Cc: stable@kernel.org
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Max Clinton <maxtclinton@gmail.com>
> ---
> Changes since v1:
>  - Drop unneeded <crypto/internal/skcipher.h> include (Herbert).
>  - Rewrite iv pointer computation as (areq + 1) + reqsize per
>    Herbert's suggestion.
> 
>  crypto/algif_skcipher.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Given that AIO support has just been removed this patch is no
longer necessary:

commit fcc77d33a34cf271702e8daafb6c593e4626776d
Author: Demi Marie Obenour <demiobenour@gmail.com>
Date:   Sat May 23 15:43:02 2026 -0400

    net: Remove support for AIO on sockets

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
