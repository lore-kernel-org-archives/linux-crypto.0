Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7139924C097
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581374; cv=none; b=HJ2elX2gXZ/hV7YmuX8ZG7FPuDc7MZ3Kcdgp/xWCb4qtuS0KaDUXxBXBmVZqcz+94GkDDQCuGXzBFJN7h856/dNfUjcREWaUzt0YAugr8GS16f9Jm3dCLBBr1YvtiBDOTBsIfDunvJ2GiDZHxKp+/TJHqqzw3bwVJTsooWZbQzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581374; c=relaxed/simple;
	bh=xmf+4lFQVA5F0WoLRK5UvBNHC1pzEJ+O7NKuTIyZYS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQpvgY3pvi6iJ/8fWkTwNbcfBlsHKIr/DHj8NaFeqamnAl6f0h+679WgtCErm8U29TNDn7iZ5H/53gxABRZGU5V/HAHF7rmdExjkZTRbovmAaNB7OmU0Ksn+unL/8HJNJ2QTofpQZ00BSp2f5XXC17+dQ9vPSU6yIIUsXbfUTc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Zy+Nassm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Zy+Nassm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LwVOgyzpjyRTBbZ49j/D6VVInj9Wl+Mtqhi7gWZz2+4=; b=Zy+Nassmpy2oxk3TTWzwFCwcwH
	qVT4E4P7zYAgYD04gdRO/I1wBrjDQs1tsdYy6oMLT/vxPjxkQefm1Tl6AN36TJUMxPrH+AfgyOqWr
	8B8vHFVP1ZC03W70uKLxdRypk7xDNdg5417ZvBL/GYNGV+OJo5VtshNtEoDAtm3vMesCQfTMCkRnc
	Fjzcdb4H8dPyzynTHssDoFovGb5ovtvJzMZHyQaxM29qDjN4MKJ9CDeYM9zowqHnTsU+xCbgCoNKx
	rrrqZgRXtfa/X0DO6OW1OiqlW8cVFxBt+LK6RVMAirg3jK4GZgb/Muuk3EOZfMDFoAvbbIdQBMcJc
	j3i/nn1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8HSC-000yVc-1p;
	Fri, 25 Apr 2025 19:42:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 19:42:48 +0800
Date: Fri, 25 Apr 2025 19:42:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 01/15] crypto: lib/sha256 - Move partial block handling
 out
Message-ID: <aAt1OPBJLsRznAH0@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <c57b8d9aa2c314378791cc130b7651d9a18f2637.1745490652.git.herbert@gondor.apana.org.au>
 <20250424154119.GB2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424154119.GB2427@sol.localdomain>

On Thu, Apr 24, 2025 at 08:41:19AM -0700, Eric Biggers wrote:
>
> Do we really have to have this random macro that obfuscates what is going on?

I tried to do it as an inline function like the other library
helpers, but it turned out to be very messy because each block
function takes a different type of state.

If you have a better way of doing this I'm more than willing
to change it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
