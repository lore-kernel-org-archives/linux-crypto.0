Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463003F54CA;
	Wed, 29 Jul 2026 23:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785368083; cv=none; b=utSmlI4fHLP3jPMrUkeyU+FY0b7lGFlzLaxysShQL9FP8csE2nP5VdR06PGIEohrmN0/ObxjaTa1jyFFvIBHkHBXdc2fAoFFVrItdeR6TaPEmcRUnX93Oe83cVDBcslzGhFam/cA5SgwfnItmBCv9W3+9KuKV/G5eYJ/7XDiFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785368083; c=relaxed/simple;
	bh=9TA4Q42wPeEoztP/oR9flftoIXiwM7xwDJYKVApotxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKWpfpx3IWrNPup4cBxlNF33IV91yH/PVAHHcSInb6G10LdbHg/MDkL7WgSmJgTaJ15Ar3JerDn54psxAoQxnwAML4m390Ezlqn2TFKBNTG1vqpPKHycJPGd3D5VF1dW6miF+dVmG8dFE8XqHfCpdUb4jId4ooTQDltpGdauSTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UxAOJa+0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UxAOJa+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=p+E3OqcuAO+Ary9QIeZJCfzT1RgDNranH4TRL6oY18Q=; 
	b=UxAOJa+0qn/DxXSmRY+SeXg8+9yWQEpDs+4z4vbT+i+rvvzwy+/lXsMdJdvHOoH1hEB00JoQQxx
	ih2lVyQW1QrAJg6Y2DDtz6i8H7U9aJBhckiyYZ4JrAptXIOgCIvTuh3EZv3HHaz/IFxsn2vs2NuKK
	O9RQlXFZxskVDgtNR+ix1IP4LiVj8uAykqHFc55vn9ZeZG19/j8A2IFNcJPn2kkbgUak6h6BrWGC5
	kcvMbfj2lvIk5MOwle/26ByyWz8Hm0G3hIA99rmAKJB9BfP3FPNElividVinveJYzLxRXvTfj9JR8
	uNUtS2iQETZ8Q59yI1/Zbs7wr/gNwfA5+2Wg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpDn0-00000000MMx-2Gzn;
	Thu, 30 Jul 2026 07:34:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 09:34:18 +1000
Date: Thu, 30 Jul 2026 09:34:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Changwei Zou <changwei.zou@canonical.com>,
	Martin.Kepplinger-Novakovic@ginzinger.com, davem@davemloft.net,
	ignat@linux.win, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, martink@posteo.de
Subject: Re: [PATCH v3] crypto: rsassa-pkcs1 - Align DMA buffer to
 CRYPTO_DMA_ALIGN
Message-ID: <amqN-vSF0ZmWBNJ8@gondor.apana.org.au>
References: <20260729004156.11925-1-changwei.zou@canonical.com>
 <ampT0ZVFqOgxKFa6@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ampT0ZVFqOgxKFa6@wunner.de>

On Wed, Jul 29, 2026 at 09:26:09PM +0200, Lukas Wunner wrote:
>
> That crypto_akcipher_alignmask() doesn't exist yet, but can
> easily be copy-pasted from crypto_skcipher_alignmask()
> except it invokes crypto_akcipher_tfm() instead of
> crypto_skcipher_tfm().

I don't think we should create crypto_akcipher_alignmask.  In fact
alignmask is being phased out everywhere else too.

The general rule is for the driver to ensure that the data is
aligned, possibly by copying if necessary.

Even when alignmask is used it's still the driver's responsibility
to copy the data when it isn't aligned.

So the bug isn't really in rsa but it's the fault of the underlying
driver if it didn't check alignment before supplying the buffer
to the hardware.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
