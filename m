Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756339;
	b=smjzDVFNCrBjpdu64iLwMWDH8d8pRz70OavULxM0QRbJvf9DinuSfW8QNiR7kHT49Fb1
	 uKfLa0JiZTaCO0eEMZIGUg88qlGvOrxUtxbzjLX1+pb2kSEq7xBr27TR9tncm8Ds1VtbY
	 Nn4oDhfPPf7xrqf8zQ3eCtRYZfphQ1X/Oiv9zr/Pvvaw7NRFp9dswndsJsRA47pgiAKGf
	 k6fVbOY4roa3tj+aFr5uDpnqHP7FzMt7WC6KWCXVOHnTc3Caeem23lmsebe3+gwq/qxdR
	 P9FdhOoIhHfJ5WTBpTq3mfbLPJf8tsfLN6NQDO9RlSTYiQO5LVEkffl/+AymnSpF9BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756339;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ko00/sxS5Ua7W2XgZHvA3b6Ar4OxEUeUGZAJ3MfBxyc=;
	b=y0ATmJKFKBKC+vASKgYDIaJWcAPsSff9caC6Q0mOd5S3GODks/PFdVLSchPYUCvvL3EE
	 4v0IXk0SHhXiSb1IEpOrtc4s8jAY89VC0KonPeEQ52nlPzPNzAZFTL8DRTZqiUJnKI7DH
	 RWP+3381+5GkFKJFAWisL5A1d3cHfdO92mnvsQVPUHJ/TSfIWeg5S5NEMQpYTToT9yZD/
	 BQGDhlDnnljEhJDxSffZQFKswJRq05tThKIyVFVvwnnoxQaEH040mC6tk1mHNHKnuaIWz
	 yImd1FxP9t16CbgBEig/AfJEucbxaXy6/4rFDz6N9FSZMjsmMsCxhiu0Df2IxZ0lg/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=heq344Mq;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2902F606A31C;
	Fri, 27 Nov 2026 05:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2902F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=heq344Mq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ko00/sxS5Ua7W2XgZHvA3b6Ar4OxEUeUGZAJ3MfBxyc=; 
	b=heq344Mqt+atZjlx8zoW+xFLY1eluOVkjLATH0vSp6TzSPlnOJX5CSVHnJ29Hb1MDGNnc8ki7ae
	YeIrMZR5hgrcd3aWzNJQHIyiWykrNW4vfeu9coXAWcrBz/rtvRXZtXbfT0kZhTitj8UtpyOkJ0+mB
	vpFSxZcM+OVPEdy6cYJLjUBAyjIFlfw/BUKYtr7r4kiZe6yM5u7N1LJREPm8HZrhen+mfBy3RvnHb
	l0q56930Gv7kQQk7VrAzWrgKM6xQeMBnNGh7lE6mnFYpcs5ij9WUx4P6DbH2G1EomE9Crg4BnSoFL
	/9l7pimmDbNvU9Pz3gAJxt78OXdDB7brQbBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoFm-00000002VUQ-1683;
	Fri, 27 Nov 2026 13:12:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:12:10 +0800
Date: Fri, 27 Nov 2026 13:12:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haoxiang Li <haoxiang_li2024@163.com>
Cc: olivia@selenic.com, kees+treewide@kernel.org, sgoutham@marvell.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cavium - Fix PF register mapping leak on probe
 failure
Message-ID: <awkRKl_xdES-SUKI@gondor.apana.org.au>
References: <20261117133844.1410587-1-haoxiang_li2024@163.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117133844.1410587-1-haoxiang_li2024@163.com>

On Tue, Nov 17, 2026 at 09:38:44PM +0800, Haoxiang Li wrote:
> cavium_map_pf_regs() maps the PF registers with ioremap(), but the
> mapping is not released if devm_hwrng_register() fails. Call iounmap()
> before returning the registration error.
> 
> Fixes: 680efb33546b ("hwrng: cavium - Check health status while reading random data")
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
> ---
>  drivers/char/hw_random/cavium-rng-vf.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
