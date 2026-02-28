Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C901F4C8E
	for <linux-crypto@vger.kernel.org>; Sat, 28 Feb 2026 08:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268442; cv=none; b=gQUPxo1BC9AW4aQWuojQmqW1Fus24fIjh1sxcoy2+MwekDllcKldb4OnqTjx+VuoPK94Fu/r9+rgUubO6vi58POTaj0s1o7ZLK0otBt7ASqLAaCGyp81YY3GFwGShB48KObm+ftWageZEIH1mPNNvBzUBqhGmfOaEjmJTq38xVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268442; c=relaxed/simple;
	bh=BqG3zP7awXj8OC/gEfaeLVh5azBEkJgtRB8MEqZRagc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/U+uTryf3JvIwglr3sOhu8Vw4T7OwNK6eMRS8066EPzG9yONuwIJ7+Ap6Ss8ch537jQJuNgTNGpNCgwJ+TZc/KVj95EeD3DBzub7hQASihR6R04J+svC+ix8uKYKYC7XJuIJYPp5LEOraddpkobhTfiDrxXzCkXoHCQzcN9NNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rxZmUWun; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rxZmUWun"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/eGLWk7d3y7LngKypN4CHtgQsWAthQLSQMgUuTcN9pQ=; 
	b=rxZmUWunJ4diuDm1Bnu7Z5EMxCw/AoWX9AbXzpSe1yHg6dMl78ksU8PwosKQ5hpHMfxybe2K8RG
	L/2+uV1UIB8ipZJrH3DiZ56FyIrqyksp2SKZyS/ncmEcpD256s0JV8f1toxnlIWTMPtv0grs/b47f
	RY0E8KWF1+dosD0rvi2neHReXxw3Hv2H21wA/En/MoIhLzA1wIzJkpFyGd1N6eF49BLIAoMA9d1cd
	Q2321VmuCgW2/23IYce1t18JTI6vKar5K96TtrcLq2stvik7W0+oD925EyTSzrmGQCFsQi+epis9h
	vDYVBRkR8uROUx9w6fKYBK62akgu5wpRgY3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFyn-00ADrd-28;
	Sat, 28 Feb 2026 16:47:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:47:17 +0900
Date: Sat, 28 Feb 2026 17:47:17 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan Wanner <ryan.wanner@microchip.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
Subject: Re: AFALG with TLS on Openssl questions
Message-ID: <aaKrlc8lpzRNs0EE@gondor.apana.org.au>
References: <25e13e64-f39c-44b4-9877-1e3b6caed458@microchip.com>
 <aXw8-J2KRklumOa8@gondor.apana.org.au>
 <6768ba1e-8051-4623-8d9a-4c3835011755@microchip.com>
 <4b44aa36-cbee-4f19-90d7-0591d8e4ae90@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b44aa36-cbee-4f19-90d7-0591d8e4ae90@microchip.com>

On Wed, Feb 11, 2026 at 10:20:17AM -0700, Ryan Wanner wrote:
>
> Is there a optimal priority? I have tried setting it to 4000 and 300
> both give the same behavior.

An algorithm just needs to be the highest in /proc/crypto to be used
as the default.

> Another qurestion about af_alg and algif_aead. Are these supported by
> opnessl? I am using openssl 3.2.4 and only see aes-*-cbc supported with
> the config that I mentioned above is this correct? And does af_alg

I don't know about openssl but it should certainly work with kernel
TLS.

> support hash acceleration?

Yes hashing is supported.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
