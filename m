Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7111F1CEE96;
	Tue, 26 Nov 2024 11:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732622031; cv=none; b=h7iuSZLyrZAmtdWnNGGReXWpe5y5A/91Mzdtm5lWV/be2IglYicwvgJOhx8ID06SNhSNASLsPYXrs8XPiYcIMB7Dk7e+/WW3H0RgLfEspBufoY+oJowiEEgyM2mcyMZBAVfxzhm2itOy06yNXLk5JlYzPBRiLgAoSLLPdKjuVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732622031; c=relaxed/simple;
	bh=nRw0Q2eCkZRmRqOAMmms9ebsxwr4Ra0SwEep8FSTy8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riYk9vpgYualWhenJ61LPTYep40t8iFi5FZ+W2dNN0CxYtLWSjNj+m4shBfCbit1hpKxr53KLRIc8nIHlHlYmPwKSKjGw5EhY+A9/ckkdf8mrEXVxStGmoMGuLzSj3RZRhZJy4SNGM/U7XRojEptZ+nkQ15N9IxeRQvk2merD5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AwTnH4oE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AwTnH4oE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Rov/n/htbpCtkTf7LDBD/uiaRq4hrTCKXxxOe7YPc5w=; b=AwTnH4oEquEvKwP86PdtWcPbyF
	moqAVK0vuz5ho5Gjsyqr+BnNt0El7XV35kpBLU6z641Bs35xwsuhy8HpLfI3QUmN7Gcz/CdJkIMMl
	j/ed6Z7yrQ6rFdDKdR/ALEiQvYnDJ/m4pWjgrn7bl50sh7LLP7MeNjf4Eoi+sjOEPiScQCLtWcHMK
	0wYcKHRk+ZFOJLHtB1aXfBI3wCBdbLcUkcIo/HQFL0tMZt8FrsI0PwZd0R0dj0sFZofQUjToSLadx
	LpCCfzzmPdRtRzGv57QvX1aNgUuWU8mDStuOGP/FS5oYv4zNwxoD+iojhAJI7qBZNfVgUTHHw9FJq
	fMECz2BA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tFu8I-001lIn-1l;
	Tue, 26 Nov 2024 19:53:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Nov 2024 19:53:30 +0800
Date: Tue, 26 Nov 2024 19:53:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 3/3] s390/crypto: New s390 specific protected key hash
 phmac
Message-ID: <Z0W2uqE3v53fFi1a@gondor.apana.org.au>
References: <20241122143427.135682-1-freude@linux.ibm.com>
 <20241122143427.135682-4-freude@linux.ibm.com>
 <Z0QUl_eSUwEANb4s@gondor.apana.org.au>
 <079dc622ca9f4b6883c62025adb336b9@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <079dc622ca9f4b6883c62025adb336b9@linux.ibm.com>

On Mon, Nov 25, 2024 at 02:00:52PM +0100, Harald Freudenberger wrote:
>
> Well, I fear the paes implementation is similar broken. The EBUSY
> is a reaction of the zcrpyt/AP bus when no eligible crypto card has
> been found and a ansynchronous bus scan is running. In that case the
> caller should retry in the hope that the bus scan detects a eligible card.

So this is a rare event, right? Can we expect this to eventually
succeed? Or are there situations where this can legitimately fail?

> Please note that the sleep only happens in in_task() context for the
> paes implementation.

That's still broken.  There are situations where in_task() is
true but you can't sleep, e.g., spin locks held without preemption.

In general, you cannot determine whether you can sleep safely.  That's
why we rely on the user to tell us whether we can sleep or not.

> For the phmac implementation - didn't you suggest to wrap this with
> an asynchronous hmac to be able to sleep in the wrapped synchronous hmac?

I don't think this is a viable strategy since these are not short
sleeps.

I think you're better off making both paes and phmac async.  However,
they can remain synchronous in practice until you actually need to
sleep.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
