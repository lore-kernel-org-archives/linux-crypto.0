Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B243002DD;
	Thu,  8 Oct 2026 08:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448303; cv=none; b=cS0d9BL/VvtHab5c+uLm3QBVCNH+cWyCSqr+KDMaifcBFgA7TpWiLz6eF1Ik6Uk2K+iggiyPZCxoOwhfHPxTmQ6WE9ArUmwqTiIMmdvdulsCKFt3IicilzhbETHw1JY3h3u4PK3AH65mc7HSJBkAKRYPz6+f5TNVSU4k4oZpq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448303; c=relaxed/simple;
	bh=6EnbuwYbcjuozKONZXP3xWvvAvOvVyEpnFQDlOhhdl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEOe6yMoiq9W36+E6MpiBXsTWdTOXkiRC7EYjd3QxsuZ6CJR5DYzPxXJiyTtqwGSww2dkeKeeu0iY0F/tKkkHh44tZBKMrt9/g5BU1xnEUUW7UCBtDFRT0Xy2aLpS+KAlHyiDjuRtkeVCmevwak9doqJ5acQSsvis42HmkR+hds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ljdnrFhp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ljdnrFhp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Esk5fXnrPEEn31pIrwlHjBwRy+AdMKNFnic6mp3T7Is=; 
	b=ljdnrFhpr/TWPcOSjjJ+EyQZfqw1oYAWI7T3hCrsMhW33MHVBqnPzjX/9VKJwOT8ijrue98bKcy
	y7g5I4j7IzqJcb+ZZaI9VASAZn9hjDes74nw5B45mCf9KO5n8xZJ8feKDnTcw0YU/U1vg+VbIPEAu
	VWz4rqzGGj5oVmFqwrfSEkThJULZerR8psDwrDvzPIJlmZoXstwE9hd5aeYalJacLGQZPi8Xd/YhJ
	RhhYCxdRiOXWbO7Hn9UFzxI+n3zardkYxRE6k/Rj5jZBJGWtcz0EISmJtx20LFNISKzsN9+SqKC67
	ohbRxL/0O+gu8ZYRPLMzDCR9ToiW4JdBOAmw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjXD-00000001o24-2frE;
	Thu, 08 Oct 2026 16:31:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:31:27 +1100
Date: Thu, 8 Oct 2026 19:31:27 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Can Peng <pengcan@kylinos.cn>, Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: stm32 - use swap() in stm32_rng_probe()
Message-ID: <asdU3y_WRb2-PShe@gondor.apana.org.au>
References: <20261001210450.37467-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001210450.37467-2-blum@kernel.org>

On Thu, Oct 01, 2026 at 11:04:48PM +0200, Thorsten Blum wrote:
> Use swap() to simplify stm32_rng_probe().
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/stm32-rng.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
