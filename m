Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11502481AA;
	Fri,  2 Aug 2024 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604605; cv=none; b=TBcZp+y0VvdLc/vGuPsnJbRsjfZsltv0Yo6VqF5LEaQ/ZLag1sk7m2iiMclUE/id6QTiqp+pll0MY/Ny8XmueqXOw3M76+H9Fqi+KqxblTa8xFFg7ivqsZ9rWw0RnAVv9UgSsIFsIobENvu2Ym9SynT5ZlhwGH2qWrtp5sVHB8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604605; c=relaxed/simple;
	bh=yHtXCl6+7QrXyYoqLnMtZDY90XNXf9RCP5XPXZZRNLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YI9GiYgtjTfJQDMyTE6FHZXTw6LnwCfx8tNn3kvLYTml6Y+7js/bpPDhWrchpiFB7kAxX8cmbZlPCscaTErxYgRHOUcVQG+M9l7pQxuK/5osQ8QLwtmLasXRytXUk69CAJbPkdBO0opygB+370g+9QnP8ZOuUvZo1dB0r7YYnBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sZs0Z-002053-2i;
	Fri, 02 Aug 2024 21:16:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Aug 2024 21:16:32 +0800
Date: Fri, 2 Aug 2024 21:16:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Fix potential use after free bug
Message-ID: <ZqzcMBtKQDI8QHUc@gondor.apana.org.au>
References: <e049271f-41f2-4d04-ac69-80186f2eecd9@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e049271f-41f2-4d04-ac69-80186f2eecd9@stanley.mountain>

On Wed, Jul 24, 2024 at 11:09:43AM -0500, Dan Carpenter wrote:
> The free_device_compression_mode(iaa_device, device_mode) function frees
> "device_mode" but it iss passed to iaa_compression_modes[i]->free() a few
> lines later resulting in a use after free.
> 
> The good news is that, so far as I can tell, nothing implements the
> ->free() function and the use after free happens in dead code.  But, with
> this fix, when something does implement it, we'll be ready.  :)
> 
> Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management along with fixed mode")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
