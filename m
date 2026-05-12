Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2BD3998BA;
	Tue, 12 May 2026 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778593697; cv=none; b=quBI7iUGjsFOFt9N942L66E1+hwePQREeBqphWPA7GWxkVFviA/0Wj1zqlaR+T3u3ERdhd5zeM8OjJCSgGt3hDwcmMcaSalUKkEKJw/RI6wgegIqPXk5lPF2/gCCFOOLClRaCaTpn9yHB2IPeOUcV2JrfnyoTtAN1j7ZyR9Vqqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778593697; c=relaxed/simple;
	bh=ROhebuTzRI3+x+UVCMTkjzsAgIsB6GwIzYS6u/P/bKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8kxH064Bifiyew5LN7QNhEc2wUlemmTgGLGFzDDiaostswI0z92rGhYrrcraA0pourr5mMxUJcsy9ANGNtA/8rL08H4hODky3eMpFXFK2V+fkQxcCwPAlRCn2nuBRhvkTHXS3hMiHIlU45sMbIwqXWzKMvqP5AzpCWXbTI9E1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id B3281C8B;
	Tue, 12 May 2026 15:48:11 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 8D2D6603572F; Tue, 12 May 2026 15:48:11 +0200 (CEST)
Date: Tue, 12 May 2026 15:48:11 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto : ecc - Fix carry overflow in vli multiplication
Message-ID: <agMvm_bA-OcDWhbc@wunner.de>
References: <20260508114844.29694-1-sv3iry@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

ICYMI, sashiko's AI-generated review alleges that the if-else condition
may cause a timing side channel vis-à-vis binary arithmetic:

https://sashiko.dev/#/patchset/20260508114844.29694-1-sv3iry%40gmail.com

You may want to address this if/when respinning your patch.  If you do,
a code comment is probably merited to explain this subtlety.

Thanks,

Lukas
