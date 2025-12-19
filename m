Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059E9284B26;
	Fri, 19 Dec 2025 07:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127858; cv=none; b=DnWToI/aOJX1mMC48gzh6LwzKSn7Vxyf/JJIYyMbVbb50YRLpH7fBkJyAaUrS4s92k3W8kDlQ/068ZpW3wZkNcpB8sqrZg5ZFQfwY25O5K0sT+0+3Upm/E3PCCrYJshTC0rh77uY5t0Os7vRK04v7VKlbmlIwYoYm1g/lsIeuq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127858; c=relaxed/simple;
	bh=7L6MK6i4jHd1xx90LyXa+Yydwd6ICBrWRKfm8KQJI78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwhWGTQEeYsOq/RypM3yQycTbI8Wb3GggPAw5mbeuVekAOGXpaLW0x0bB0/j853ldO5lCxeu7/u8fu7p2NZ4jD6VcN7ZRyoP/ERMLV3Axn6OYLibLqA1xUpM/kyL+QSHQg6GPFIPbXXpShzS6ynggFA3L/yNP27FHAPQ2DyoPZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=p8GWdMTx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="p8GWdMTx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OEDoZC3E+AkfuupFKtegylgp6bztRcznGl39y+cJ0NQ=; 
	b=p8GWdMTxypqX6MLZd0TVPMGGAW0fD+WYiR0cljgXpDG/7WCjNS8qErjBl/arhXMa9jc/Dh7PB+W
	B7O/jeIbUvVVCWFGvLJI1jeTZxcWbtMCJiLoMMxKR3KL+toSNdv6BXro++V+57fpdbc1u5wlZAkpn
	d9UArbXZTn2TAx07lBymJ0+yo/Ti2aSN+o4l8RSo8G8+DmCMhW48f+KmZkNjzdDhM8iyl2uJoAP+L
	s0VhTEiBJUFIhjWfHzFc6Q/SKo62MtSj/pd0nGxxnDvcJ3wzw36sqXu7/hF8x0twNteKYJKCA9NJr
	nxNwUaeP50sFMD3kHnwqxn8kgc0bMVkG6exw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUWu-00BEep-1p;
	Fri, 19 Dec 2025 15:04:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:04:00 +0800
Date: Fri, 19 Dec 2025 15:04:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Zanussi <tom.zanussi@linux.intel.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Fix out-of-bounds index in
 find_empty_iaa_compression_mode
Message-ID: <aUT44MU1ehlRsu3m@gondor.apana.org.au>
References: <20251127140158.173840-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127140158.173840-1-thorsten.blum@linux.dev>

On Thu, Nov 27, 2025 at 03:01:57PM +0100, Thorsten Blum wrote:
> The local variable 'i' is initialized with -EINVAL, but the for loop
> immediately overwrites it and -EINVAL is never returned.
> 
> If no empty compression mode can be found, the function would return the
> out-of-bounds index IAA_COMP_MODES_MAX, which would cause an invalid
> array access in add_iaa_compression_mode().
> 
> Fix both issues by returning either a valid index or -EINVAL.
> 
> Cc: stable@vger.kernel.org
> Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management along with fixed mode")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
