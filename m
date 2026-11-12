Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478036;
	b=oDqcGPdEUHnGU+sW48RRJpbWQZq8WSHyZwDo00l38nahA9NiBbHKAfHV5CcC/L99uQB+
	 KCNKb2txh/sAtPNKP66JuLE2lVGBstW3709VbDYF9O1RuXsV2HURZUs1xmlECuvN5Iej6
	 RqRggZBxrgF74yqbscsKPlhzK8cx4ZHfTpwqBDj0yJ1Ww9161/Xb49+5AGkxARom788TO
	 kq+IjYfGz/y+3VLRbqwJ/n+6VLwSAHzFS858uF5lydnPnby+oiIROecP++jclq7caOD6u
	 JstWVfeAtNZZsGUJvDq5c7Ie8GvW5Kdiu+Wwkodi2LIRRcWbnmnUFc5gwE5hMP28ijQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478036;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=KXQboGDOZ316tEfmLs16b0X47iGRIv3wEUHclQ2svLE=;
	b=35iic+1Abnkd6JcSnUWIlDu0ztTR1/qGvnVLXI4j2qfQ+RAIDBwOTlLCPO/4wDcsDwTw
	 3q2gseSCCchsjyHI/pSkdmGJDqEwJKpBkEd2uViLmOjzsWBVqH50lwmGO0wyj8uWoB0Hp
	 pPFSZKc6XeXXHU6wS/NNtnoeK+BbAyrqV0djUw+Mt7+94fK6Tla+yb2X7ZPIGDXF+hChU
	 t8RXfv7qewTegHhBzsyONJ05jIBF/q3Bcpx+wABim/EnLEiL87sp31cdRXv+ZBLUG/SYj
	 X+uk7WjBfuSsyY7y7sUnJ6HPClsyjw8JiSX1dqAMcQ+1vjdrZifiext53lXjs5ndNBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=mfoBKurj;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F47E606A894;
	Thu, 12 Nov 2026 10:07:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F47E606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=mfoBKurj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KXQboGDOZ316tEfmLs16b0X47iGRIv3wEUHclQ2svLE=; 
	b=mfoBKurjovLJxjDap/0vZxM6EIoIEF9D3n5l1xfI2nco0uiYqXUvJDK1obgJkMr4lUn6a2RNviF
	f7/5NYtPkF6ejXLkfkOchAyXMCX/EREgHxvYAhHmPHuUCZYpZORF2fcikL9Jh8QmsC2vZRGytDGGU
	35qdI0xbrErr08Bpp+uKY/MbzDhhfkX/I+kld4eZvkQCIB3oexaP/b7KGh4oUe/9VVdDb8DmgZjSs
	u174kHGFc108ajfhgOBJyGHZdfG7YPnvl5IG2NdFBo8w35fqxsebvs2T6lRTvn4kymXI1d2WCZIWs
	zMfN8/NYKE9IfTCEWKUBSBfttf6lthBo6wGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRhy-0000000EE1k-3YWO;
	Thu, 12 Nov 2026 18:07:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:07:06 +0800
Date: Thu, 12 Nov 2026 18:07:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH] hwrng: octeon: add missing MODULE_DESCRIPTION()
Message-ID: <avWPygaJ-Gj1IPiT@gondor.apana.org.au>
References: <20261029014427.2364317-1-rdunlap@infradead.org>
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
In-Reply-To: <20261029014427.2364317-1-rdunlap@infradead.org>

On Wed, Oct 28, 2026 at 06:44:27PM -0700, Randy Dunlap wrote:
> Add missing MODULE_DESCRIPTION() that is now required.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Olivia Mackall <olivia@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: linux-mips@vger.kernel.org
> 
>  drivers/char/hw_random/octeon-rng.c |    1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
