Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575201;
	b=BgZirTRsn4TXSl+JWEYPkGK60De+DSRzyMq4G2dvNXApdYvFbcfrXOmKpElfPMTznioL
	 jUqA9kv03iWZPswSEfSui83WQ/O+HuOHqEsl2b20AHlMFeuCX+kCXfu5RZlRTw4jjEXbA
	 S+qeRdWaA2dNnVwe77Ay+YzBdDjM6PaCBSMtOZuP4zAqYJAV/rMX73Fo3EMDAnMNCAvuL
	 aTgbg4sW4aM4nAT614vQogoIthQ6k2P4H3ee1OoGAUGzAAZ94p/RlfU5alzm9nOKR4Q10
	 LigcZGmnmFof2IbZ+ibMzbdShcugA3WdnlWxdnB1/tPYpP6P/n6JShBcOpwQoo9Eo0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575201;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=JvZgrdduzGGr1rTuXooGMGQr7qfhEsqW+hF4UjoV+Dc=;
	b=sDtge9APoY0QRBjKIV6kzWFqoNtFc96PZkc1bloPFdzUQmLVkpoWJADCReDgjbLv4uCd
	 FMcM4Uu28aQw0wi6iiTWLHMvLPc7VILtc+Bc3rhoISmD4FIEi4AP5+5miUQUZHAAoKPto
	 ltJsRXeToY2ZHMl7N1Z156Fn5bF2/mxHywDnulr1xP8OF7kg9l/edh1w7ElC08i+bI6de
	 D2QyKVqiohzc52+XEUCGDs+0S4QKFl/ouxoL1DL1nSg6JzKxVUnXMqrKFO1qQ5CFsX+Kj
	 tiYue7mDTG4eZaLEOUnvmcEBZreAGFZeeOAU7l2tXywctBDg3EYX2IgWpCzOoWWKj7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=sdwq+9RH;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F36D606A89D;
	Fri, 13 Nov 2026 13:06:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F36D606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=sdwq+9RH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JvZgrdduzGGr1rTuXooGMGQr7qfhEsqW+hF4UjoV+Dc=; 
	b=sdwq+9RHcxPeX7XKZEk/ZT5A0s/DTR8ZHNsVQQoOuBOCHLJjao/jnDeWKzTxTfdGtMG4Yh3xw6E
	Tt/HPZW8x+Vqz/hEsysPFv6J4FcSK5AEWU3IaKDpUQO85yAeY9iMSyleqqqcNRnpZytlJLAq2s+QK
	Nd7Mwo6zxOfWpa4nl+Pugfa1HHZ3AD7TG98/iGWWhosENyCCn70QBIG4c44h6RezSqw847Cu1XflM
	UwqtTDcAUCmCEoi9HRi5E0bCG4aexJTv5T3Vq2z8i8tKpdG9KpR778EfA9+diXbOMhxueYZjZjmHP
	EiEo1lQoliX1LOGhh8iZ8sO/xV5U0EKoYsHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqzF-0000000EfJV-3pD2;
	Fri, 13 Nov 2026 21:06:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:06:37 +0800
Date: Fri, 13 Nov 2026 21:06:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>, virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: virtio - simplify probe_common()
Message-ID: <avcLXfYmR6raRZlN@gondor.apana.org.au>
References: <20261103165026.454333-3-blum@kernel.org>
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
In-Reply-To: <20261103165026.454333-3-blum@kernel.org>

On Tue, Nov 03, 2026 at 05:50:27PM +0100, Thorsten Blum wrote:
> Drop the redundant NULL initialization since vi is immediately
> reassigned. Drop the redundant index variable and use vi->index
> directly. Also call ida_free() directly and consolidate the error
> cleanup paths.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/virtio-rng.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
