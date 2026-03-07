Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A9533DEDD;
	Sat,  7 Mar 2026 05:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861291; cv=none; b=a6bQvgjjiVp0yFYN1/Fi1gED4QZ/N3CUwfqGHVk7u23zhSbAI6jkMvkAEc5KHkSf6nt8C2DGmtF19Rvzd+hBBpU9AdNk9cljlBjbz6tBqBaAAFU0cC2dtv6pqz3R/XszZtyGHBwb4xSnynQFl6W5s3wvGlAVcvOXpug6+MLdFds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861291; c=relaxed/simple;
	bh=OC7UWih5bcnN3NVCWzgwYqTkZDFJrrUXCSMFTQrr+MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zcfj8S4FKZ6+j7XSph6mj3UFYBvUSElo4R0aK4VXvB5IC2lfAHB16j0mV/wairPrgPQWd2HAl2Wkc2vnRhQlwUALwHbp4YPJsXYUSA3piKMPknD63KoZXm/fUBjLpm4MtFOhFgRYtfwNyJgdI6ZNNMEQoyzvVOHWNuoegZcxP1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lEdhr9lU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lEdhr9lU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=mlVnUlrFboTfEtgtrQdjAXUIsnu2sj62UeY21lZd1io=; 
	b=lEdhr9lUeukVnmdt2yjMiwJqxWT/PEeXucxsprZ3lCbrYtirTdOf9H1stm39XQAw/nGSAtTta7N
	nu0UrpDBfb5SkSP6XihXINZXeRxwQlZYAH1+edskIKdebYpn07Iu1a+lynWe4YOvHmpUvKvKVjjkf
	magjrMVD5qWJ79KSEK3Nli+78VIxMRdRc6CTu5js9BBM4cu7clH1gWaspPLIYY5Gt85TbUZsOMjqM
	vGC1zWHn8HwLWzkkIwGSVuV2x55h8vecjaxwvkZcuEVNSEmXLZTEUexcFmgyeJs9BDomlrIwwRwL0
	dVjehVdoCPyjjWo5oEm0p1Ha/Va+M03aP4NQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykCp-00CJSr-2G;
	Sat, 07 Mar 2026 13:28:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:28:03 +0900
Date: Sat, 7 Mar 2026 14:28:03 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: vmx - Remove disabled build directive
Message-ID: <aau3YzVAaCY_4Kg2@gondor.apana.org.au>
References: <20260223075612.322388-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223075612.322388-2-thorsten.blum@linux.dev>

On Mon, Feb 23, 2026 at 08:56:12AM +0100, Thorsten Blum wrote:
> CONFIG_CRYPTO_DEV_VMX has been moved to arch/powerpc - delete the
> disabled build directive.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/Makefile | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
