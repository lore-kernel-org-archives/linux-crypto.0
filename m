Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF1231E82B;
	Tue,  5 May 2026 09:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973341; cv=none; b=ixwPQDecPu6GGVJBtLZ5Gs2JQUuxg5Rsa60QHwk9du2qj10xjOMqtRrRbQ1HbKcI0aYO/rhYYTKEDCqM6CZeaFoPuVnpst5vi8I570VIVhZcbzmn9T3l9kSPtV/MFwupHuBkhRLh/6lNyCimH1xm58w4OhGZI1NU9InTpoP0oP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973341; c=relaxed/simple;
	bh=oLhVaXyL9MTjy6KbF1ZaUjgqGKqDxQHUgjrNNwbcAGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7LOK15LY/Os4H6Gqb5fFOBe10wJvovHCGSB3uUcDhrYOrbC+xNn+V7utnmeWe6yNwpBXxQcaA+rtpMQrKyGdNXQbwwEFKxIqYEbVnH4uBN9PjC++61SwP7ccazpbtMvVpTG/ZiH1ckkcWZ3YRg38AkcCVuAbo2RBdMcSgpyWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=M9Gc7BSb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="M9Gc7BSb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AJ3IT5krG8flJ0dD3QnWrPNJRFvlVr4qKiaiB8sp/PU=; 
	b=M9Gc7BSbshp3KGTBnsjOsUdSnOiSY1OTzZk3gVa9ifj3bDUOFFZDRIZMFtR1B4uPmuIpWtioUrj
	GM0KCZhbGbDGz6VR6Y8OXMfmKLdG9WUP8lJrEe2bdn/2Efz+8jIBGoUKSM5zZxNG+Dd4NOyuMDl7w
	ks5wpryhIiClvF+z2nmDVhzfR+oPNBydhwHzifCB5/dt6hN/9Mw2L42ltBnw5JKPQ0LFgwY18h+Ot
	PFd2fsZNXHtOEs17GrBQ5yyq/iuAPC4D07IoLa0KlwjRMSdNG454qbd4Nt9TIISel7OwgGjhfqRQ8
	eoWM7ZNftv9oDJkgiO+EBHNRmWKKJoruQmUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKC55-00BNwE-1I;
	Tue, 05 May 2026 17:28:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:28:43 +0800
Date: Tue, 5 May 2026 17:28:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: caam - use print_hex_dump_devel to guard key
 hex dumps
Message-ID: <afm4S8FhUTli5Sc5@gondor.apana.org.au>
References: <20260427163937.337966-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427163937.337966-3-thorsten.blum@linux.dev>

On Mon, Apr 27, 2026 at 06:39:37PM +0200, Thorsten Blum wrote:
> Use print_hex_dump_devel() for dumping sensitive key material in
> *_setkey() and gen_split_key() to avoid leaking secrets at runtime when
> CONFIG_DYNAMIC_DEBUG is enabled.
> 
> Fixes: 6e005503199b ("crypto: caam - print debug messages at debug level")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/caam/caamalg.c    | 12 ++++++------
>  drivers/crypto/caam/caamalg_qi.c | 12 ++++++------
>  drivers/crypto/caam/caamhash.c   |  4 ++--
>  drivers/crypto/caam/key_gen.c    |  4 ++--
>  4 files changed, 16 insertions(+), 16 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
