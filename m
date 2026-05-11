Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067462727FD;
	Mon, 11 May 2026 05:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778477471; cv=none; b=VIRUJfAn5ab96fAjrNWm9yQDRK8zereTUKhDLl8NF0IhqoRiSXZhccZtOnJk3+qof/2+ITrf3hnwgZaeVXBQbkjCcscL9f3Fj3rvEtROYxqC+ug3kXjbzaz6h2XFplmRc1BHp6wOz6+DSyPbhf2ktRpHpzA8KYajvoZjmyrmYJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778477471; c=relaxed/simple;
	bh=h1DhVC/QqsZKK/KVgdS4+aNFest26/KYjvR8P+YJL9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=memV7NTLVz0bf47JUt8WvsLpS/ykMuU6ha4YR5ZAh9LIZlt7uHxB0W+G7nYpKMKKGoffE1snTZjJfKCqRTS6sKPVw4kfn5mshMqtq1t38m51Vd9SbwEkLMBhS0cu+gEnj3kiK7FXM8IsXDSSQwlWsFUWiC2TNwQXXX0qpi/JqUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 50C24380;
	Mon, 11 May 2026 07:30:59 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 3BFC5600CDB5; Mon, 11 May 2026 07:30:59 +0200 (CEST)
Date: Mon, 11 May 2026 07:30:59 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto : ecc - Fix carry overflow in vli multiplication
Message-ID: <agFpkxrqtPVA6PrR@wunner.de>
References: <20260508114844.29694-1-sv3iry@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508114844.29694-1-sv3iry@gmail.com>

On Fri, May 08, 2026 at 02:48:44PM +0300, Anastasia Tishchenko wrote:
> The carry flag calculation fails when r01.m_high is saturated
> (0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.
> 
> The condition (r01.m_high < product.m_high) doesn't handle the case
> where r01.m_high == product.m_high and an additional carry exists
> from lower-bit overflow.
> 
> Add proper handling for this boundary by accounting for the carry
> from the lower addition.
[...]
> +++ b/crypto/ecc.c
> @@ -427,7 +427,10 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
>  			product = mul_64_64(left[i], right[k - i]);
>  
>  			r01 = add_128_128(r01, product);
> -			r2 += (r01.m_high < product.m_high);
> +			if (r01.m_high != product.m_high)
> +				r2 += (r01.m_high < product.m_high);
> +			else
> +				r2 += (r01.m_low < product.m_low);
>  		}
>  
>  		result[k] = r01.m_low;

Thanks for spotting this.

crypto/ecc.c is derived from Ken MacKay's micro-ecc library and
that library has always had the check that you're adding here:

https://github.com/kmackay/micro-ecc/blob/master/uECC.c#L403

When commit 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
introduced crypto/ecc.c, it split the muladd() function in the
micro-ecc library into separate mul_64_64() and add_128_128() helpers.
The function names suggest that this was probably done to allow
moving them to include/linux/math64.h and/or lib/math/div64.c
in case they're needed elsewhere in the kernel later.

It seems the check got lost in translation.

However while your patch looks correct to me, I think the overflow
check isn't very obvious or readable.  And I don't like how it leaks
outside the add_128_128() helper.

The kernel gained a check_add_overflow() helper relatively recently
in include/linux/overflow.h.  What I'd prefer is if you could rename
add_128_128() to check_add_128_128_overflow() and let it return a bool
indicating whether an overflow occurred.  Then r2 is simply incremented
if the return value is true.  Optionally you could add a third parameter
for the result (like check_add_overflow() does), but that's not strictly
needed for the callers in crypto/ecc.c and would merely be in preparation
for reuse of the function by other code in the kernel.
Does that make sense?

Please add these tags if/when respinning:

Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
Cc: stable@vger.kernel.org # v4.8+

Personally I order tags according to Bjorn's preference:

https://lore.kernel.org/r/20171026223701.GA25649@bhelgaas-glaptop.roam.corp.google.com/

It would also be good if you could include the backstory I've outlined
above in the commit message so that it's recorded in the git history
and doesn't have to be dug out from mailing list archives.

Thanks!

Lukas
