Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C66A385D6F;
	Fri, 22 May 2026 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452985; cv=none; b=L58rhRKQ3XqTsJ22kDwBZr5dZ0V2qSRcmKMd0Y/jbTG7GYYcfVotcP85tKC9B456zM36DMcbF+5O+oQYolq8JS7ZDuy7FBPTlXh8x5VMhs0yS6UjgpANWvatoItAAHX2rYDAtPPuCx4lPFP5VExgQNNM7ZmYSkCVLXtqM5JqX3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452985; c=relaxed/simple;
	bh=bfP3ppGvrRvAAPkLZfZZbNVX0zfbX+gpBVgiazTqtVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9TxC5tpcZtasiDR66uz6oRa0IrJX9MzRByBg5KvALg31QEmaImiTjwa0WgfcVui+h6O/LwDrV1NMgG3I3XTdw9vgyBfEwoBgqW9q/6g44GYw6e0DRawFGF+M86mswwVOv3VhfcKtp6E97KnExRpPD20t0IgrYQ8coicHwqaBPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rlGJcw8i; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rlGJcw8i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WK64VzlL8RZWVqvOu2cRYGGldJxTaVMQJcAV2DOHcjo=; 
	b=rlGJcw8io3gljky96duGSunAKRQnaA/o3eAvxEHzhoFsj6HU3zwislXMlyzy4q61s980Kp2tfxx
	nlROF30t25rtWBgdI9aJjqU7LwNB1yuWNhuIGHKdmKoczImDaKYSj+zJTjLAgimWvLK6zLGkqXmn9
	wmtDaX22VwDOQ32i9k1WJTBsfwkmyuYNPFfL8tvwQpy66qK4ETRwuE3op2mGUzgHKYaTBol08aLzH
	FdDdFbtWDLDiApmNDqt3ixIxeH3VOa9GvMfyMeQsQmVD0vex+w+RqJ07mBdO9rvH/MnAwR5aIVK8j
	u8ILrbGdPmGjWhRcqU6nVZwJ8UmOSgcC9MJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP0B-00GSLV-2e;
	Fri, 22 May 2026 20:29:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:29:19 +0800
Date: Fri, 22 May 2026 20:29:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ecc - Fix carry overflow in vli multiplication
Message-ID: <ahBMH5jT-kraeN06@gondor.apana.org.au>
References: <20260513105741.55534-1-sv3iry@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513105741.55534-1-sv3iry@gmail.com>

On Wed, May 13, 2026 at 01:57:40PM +0300, Anastasia Tishchenko wrote:
> The carry flag calculation fails when r01.m_high is saturated
> (0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.
> 
> The condition (r01.m_high < product.m_high) doesn't handle the case
> where r01.m_high == product.m_high and an additional carry exists
> from lower-bit overflow.
> 
> When commit 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
> introduced crypto/ecc.c, it split the muladd() function in the
> micro-ecc library into separate mul_64_64() and add_128_128() helpers.
> It seems the check got lost in translation.
> 
> Add proper handling for this boundary by accounting for the carry
> from the lower addition.
> 
> Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
> Signed-off-by: Anastasia Tishchenko <sv3iry@gmail.com>
> Cc: stable@vger.kernel.org # v4.8+
> ---
> Changes v1 -> v2:
> * Rename add_128_128() to check_add_128_128_overflow() and let it return a bool
>   indicating whether an overflow occurred
> * Rewrite an explicit if-else statement using constant-time bitwise arithmetic
>   to avoid a timing side-channel
> 
> Link to v1:
> https://lore.kernel.org/r/20260508114844.29694-1-sv3iry@gmail.com/
> ---
>  crypto/ecc.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
