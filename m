Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D693A2E18;
	Fri, 15 May 2026 10:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840694; cv=none; b=DVW22E9rYaWrwtyOD+ZfjcOz5Rbsb4St08w47Pt5G4BfBfZC3PJhvHBGDQbrhefi4XVY9P9IlJbD9o/aru7UXbxRigKSbDAm3Ufg6dTK0DAMKr9OmqDI7PkKGuE4t58Yl65RgSZmvVn1IKx5UWmVANg7miItp0DZgMIsoaimqEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840694; c=relaxed/simple;
	bh=890owW1P67pynW93116LjXApEXnYB7TbTOYb4d5DL9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=od7p+hNOCaMCTyZUY6CRdeCXo+vvRNvCSdHTGTMXEZ7lGjz/Zlk2Q+JN6cYcjTEsugg+1D1+a+5MHc6QlPXqezdRKwNcLLoRgS2oyvoj0nbZ0Se4R7fal+M67WRIxan6P5Gfw5xpWp5OK5Nc7przIYYgODVrcFryvNO3faiU7KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pxZUFS0T; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pxZUFS0T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Kmf2UaROYztHtXpHtAqgoxxtbknlGrFDF2ewj14ugII=; 
	b=pxZUFS0TNlgNVnbL+qEJHC033UQsyMtYKlU422TLd7o75EYY+xvfhkgY8DDZNmtpFpcXn06bEj3
	xj10JkFMMvcs7gAiWZMMw9f4q706fdpJmyplpx0DLTjsc/nyCUO62iuqU90ZHnPR+STycMxsvYO5b
	NJpgQpxCxjaNYdvxCovNF61y10KHbtlsw0xsnORz/jDDEgqKKlcC5MNaCGDplbQkyFydzdS5kIlvo
	kQwtaK9aJ0o4qgqoMEdodX2YFmes0hs8ptUSuq+HL/zZ2Ih9vH4zhY3fWsihbiYkmNaCdEcjo50rR
	nbM1PRrsBMav1gGPS8D3deKI6Ar3/fQPfJ1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpip-00EOZy-0C;
	Fri, 15 May 2026 18:24:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:24:47 +0800
Date: Fri, 15 May 2026 18:24:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: use designated initializers for report structs
Message-ID: <agb0b1laSRLj-0-q@gondor.apana.org.au>
References: <20260508105717.472043-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508105717.472043-3-thorsten.blum@linux.dev>

On Fri, May 08, 2026 at 12:57:17PM +0200, Thorsten Blum wrote:
> Use designated initializers for the report structs instead of clearing
> the struct with memset() and then copying fixed strings with strscpy()
> at runtime.
> 
> This keeps the structs zero-initialized, lets the compiler diagnose
> oversized string literals, and makes the code easier to read.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/acompress.c   |  8 +++-----
>  crypto/aead.c        | 10 ++++------
>  crypto/ahash.c       |  8 +++-----
>  crypto/akcipher.c    |  8 +++-----
>  crypto/crypto_user.c | 14 ++++++--------
>  crypto/kpp.c         |  8 +++-----
>  crypto/lskcipher.c   | 10 ++++------
>  crypto/rng.c         |  8 +++-----
>  crypto/scompress.c   |  8 +++-----
>  crypto/shash.c       |  8 +++-----
>  crypto/sig.c         |  6 +++---
>  crypto/skcipher.c    | 10 ++++------
>  12 files changed, 42 insertions(+), 64 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
