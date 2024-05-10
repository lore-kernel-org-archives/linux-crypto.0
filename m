Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1828D5339E
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715347589; cv=none; b=fFVkfmdFnEK1v/V5Vg7f0RVxiYyUfnn5TvYflH4feKgimiKS8vHHyCJxM/Q6KKynPPaO8HGWYa6X+P/CFSYLZRDnezy1AX3q4HOKMLItg1/SSZeCy+WkAiZnrBKlRK6y1qcJl6C6IRAlGnKTWcFgxaPyYHrZDUuahd+4wGYBTrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715347589; c=relaxed/simple;
	bh=2RiT8skfUlc9xQNUP9gy5e4t9oJFMwAygoCkS7AQkMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEznF+UEiZSvOqgywMau3sAfjal6FrW1OcI4S5EwZsKEsQbRyxKM5pZ28XPer4l9cU27YJGcBr5aXW+NBPrYhtrbA4o/ejP1GOu8VLRFhe+GxLFmFJP8WLcWqn11D4hj4lBG2TgbEZedGjOG/IjzOOJMfbqnhMikvRkxg3xRC8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5QGS-00DSb5-2f;
	Fri, 10 May 2024 21:26:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 21:26:21 +0800
Date: Fri, 10 May 2024 21:26:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v3 1/2] certs: Move RSA self-test data to separate file
Message-ID: <Zj4gfShvzZ_j7uoG@gondor.apana.org.au>
References: <20240503043857.45515-1-git@jvdsn.com>
 <Zj3XtsHcwRAv_EvT@gondor.apana.org.au>
 <3303fb03-a2a7-4a2c-9b87-bb349b219d39@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3303fb03-a2a7-4a2c-9b87-bb349b219d39@jvdsn.com>

On Fri, May 10, 2024 at 08:18:41AM -0500, Joachim Vandersmissen wrote:
>
> Just to clarify, you'd like to see FIPS_SIGNATURE_SELFTEST_RSA automatically
> set based on the values in FIPS_SIGNATURE_SELFTEST, CRYPTO_RSA, etc.?

Yes just change

	bool "Blah blah blah"

to

	bool

and I think it should be all good.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
