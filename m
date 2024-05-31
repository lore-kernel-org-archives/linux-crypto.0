Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632D01422B0;
	Fri, 31 May 2024 09:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717149484; cv=none; b=AzVZpfbkw8GctRNcwp1elKm98ket+/a7VGsOTpIeXY2LaF0cBQA39tz2hO983DiBzhu1LTl3I5V30Cu6tmMF0BnaEwXaHdSobmkGM9JZqzxl9e7Yh+J3H6hwXmaYUwHZJ74Z8OnlncgZG0QiizkmOJwOWrmTmY0Zh/8zYAhp/lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717149484; c=relaxed/simple;
	bh=Zx6Y43Whb6METT4CCp8/5VpHbdK4al877WjrTaNypl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3wCt1Q2nNb7+Doc6I5vtYh3a7VF/k+VXQumO3Jm8NNEJX7XVIlTpjVNJXNSTiwbEzM83+gUNRm5xurlEAceTU5gQpMcmd2mwOO6nPnSp28STGH/cNumuDPcNheNNJiuuxyJkD2/OZVEOI7IOzx0ToR9J1kdEFw7aWqUw7XrSaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCz1E-004AHK-2G;
	Fri, 31 May 2024 17:57:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 17:57:54 +0800
Date: Fri, 31 May 2024 17:57:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: Remove unused struct 'tdes_keys'
Message-ID: <ZlmfIlv3mpN_W7Tr@gondor.apana.org.au>
References: <20240511145200.226295-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511145200.226295-1-linux@treblig.org>

On Sat, May 11, 2024 at 03:52:00PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'tdes_keys' appears unused.
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 6 ------
>  1 file changed, 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
