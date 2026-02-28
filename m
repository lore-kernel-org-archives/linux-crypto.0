Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6903F3E95AD;
	Sat, 28 Feb 2026 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772269035; cv=none; b=gHfrLOSjv1mJ4oPyB+tdH07Jj4H1UFzqK2gmv5lVDkCb64dLg1NB1i3MMBRSeRMfXZYcOFklpIKFWDv10JsnVHjn36X6D1+nS08GxjRTeNSGejtoj5Fz/FBlCPA0H1I5JBw+Xs+JuOh41z6RsiE3ONtbjX/IKMTCtmhyRR5R6zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772269035; c=relaxed/simple;
	bh=wHrQlekLTej7MxYn9H4su1nlZFrSUp5o6RrOcDwyuYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEXIsw6+MLhsI2gNzeu+KP6RNI59JNf/9mM6rHxx2+RQEaGLRDxwUZFITgbFAGsNTAMdj/xxO+m0TYhq5aZK+NsZUgv/fsJ4SXCKWgN1IXHwzuaKu/vJKJRjhRCmj/RLvjHyZQ8jWdQvOoy3BaMdkPoxQUBHeKFG07MGDKZFP5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f+ETSCiP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f+ETSCiP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=D0OLv0rMh/lHV5pn6AIxNiBVM0NjCrHfD01jvogvUwY=; 
	b=f+ETSCiPld6uMKVotwPuHd5HuG8X8vemB4uiuxvA0eL6rA/vcdOeDnKA6uN0j0rUl1eMz+8sAzw
	J3HksdvnA9PGQs+p+wMvIc44uYTkhXV0MFZl8o8TH/E93PIuSKDedgo9jjzGwBCQDPkTX38X9+0+A
	uqNkYLzLElsjCE87xrIS7uFSKRiqKij2z70Gp6duWZtSTa4dafWSjpMGrrlroBfIAl09YTiLxRNfT
	ApCx6rqY0c9RW11Iw8DQEXQ9iwp79HRFlWkg9gnu0NNmqYUMvPq/sA5E16kFf+0wZjVvwEctmMssg
	ZxRGJDyz8diYx0Q2TycQC4OdkP03Efk2ZVhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwG86-00ADwk-3A;
	Sat, 28 Feb 2026 16:56:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:56:54 +0900
Date: Sat, 28 Feb 2026 17:56:54 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix OOM ->tfm_count leak
Message-ID: <aaKt1lTAwjsOMzz6@gondor.apana.org.au>
References: <20260218235358.973341-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218235358.973341-3-thorsten.blum@linux.dev>

On Thu, Feb 19, 2026 at 12:54:00AM +0100, Thorsten Blum wrote:
> If memory allocation fails, decrement ->tfm_count to avoid blocking
> future reads.
> 
> Cc: stable@vger.kernel.org
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
