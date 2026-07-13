Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098D22D063E;
	Mon, 13 Jul 2026 02:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783911376; cv=none; b=FGukwPBiv0uchO+SrE9pQ5iW/YrL9pFko65GzBhK3GFHst8y6bm/81PtgL7WRyJHYV3w/JvHVp8Bkq4zezv8HJNDB3t/zedzf5e6zpb6xCt9Gzy5Mpi742bHQZCfZPZxAiJRzK6nX3HYVCQL/9HbdvMvxcROCl4jw8vW4IqNmyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783911376; c=relaxed/simple;
	bh=Q3VWxP2Aosr38s+o78mvDbTOTJjPSbzrpK8aDT7fTqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/088iotdP4cJXCSJgHJz8+/NMkOOROuUNA3OeVJCiNybrGMzuKDWHVRv983mOGnZlv5iAmz6tEnjXRHz7oV5vZ4aKBJafc6/vQf0IXCbeA2LcOJtmaG/JpNBq3WKenJnlP8KNQocyoD/rZZEi0UCA+bsmfIHyQC/8KQpUo/qtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iMR60PEG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iMR60PEG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HTHF4UFEv4mimtOWDGeAgbcciT0GXjtdrHlVT3qzmBk=; 
	b=iMR60PEGodnvL5dNrFJbQIusp0RKmOj8ribL12jP5h+o0Odo7pQl1tIfFiACk4lbi1vpOkrivMA
	Rvb08q1HvJPDU1Ad4ADY4UYhrXorULumSWZQEWcwxMK8mLisNmw29yBKcxB8qVlQahnmltWv5sOlE
	moR2OTtO2pSggJH5LUo6xoUzZgjFF7cFfW4oYtfPDlv+l970KP9Z2b+E6v1eLBuY5L9H8opnRma8e
	n0fB3H9A/2Rk/aGpqXNpPkOp/EiJfnpSgd3o8LaRCe5DR/jmL4gK9xLi9Md+nmeoMEUWC528XLzBL
	IpXQXXapMTixr1WpyBjrUP4fJ5ZDC7FgOBpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj6pw-0000000Cxlu-07QQ;
	Mon, 13 Jul 2026 10:56:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 12:56:04 +1000
Date: Mon, 13 Jul 2026 12:56:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] crypto: pcrypt - Disallow nesting of the pcrypt
 wrapper
Message-ID: <alRTxL8UaKaI4qS4@gondor.apana.org.au>
References: <20260701143947.944593-1-thuth@redhat.com>
 <alRNusgXIT06hTow@gondor.apana.org.au>
 <20260713024654.GE4362@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713024654.GE4362@quark>

On Sun, Jul 12, 2026 at 10:46:54PM -0400, Eric Biggers wrote:
>
> Could we just delete pcrypt instead of continuing to try to fix all the
> weird problems it has?  A web search for pcrypt just finds CVEs and
> advice not to use it, e.g.
> https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
> 
> What is the rationale for keeping it?  Who cares about it, other than
> people looking for vulnerabilities?

I wouldn't object.  Last time I tried it the start-up time was
about 20,000 cycles, which is just pointless these days.

Please send a patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
