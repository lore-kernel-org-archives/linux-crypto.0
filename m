Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90726339A8;
	Sun, 12 Apr 2026 08:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983898; cv=none; b=cPCVQktlgRihMq0jCiZZ65vSGzg6DQA4xVgMInec0m5BIxUaBbq/71oQ2NaNYc2+nm+wnU9Vy9U8OKuEs5xVVf3BeZDmsYtt/N2F0eDQLbDhaXQRD1yNnN9Bzl5ut3QzvLpWf+O2tSziAifm3xERShkbJot7/vZVpaD+OMsTg1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983898; c=relaxed/simple;
	bh=Z9wIywVRIZWoftJWvwElydZX4DX32cBWWlgqRhpS5vU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPuY0bdZB/27FZtwE8Xtjv6fuzxRmB/sD6+TRWkDprrU7Xt1NH1TWz+rn67IapDq0GkzJhJh0dr8O7KuAv1uvQWdvyR5nnyH7xZyGsyguVpEUNdfwO98kOEyyhSCOU4zT0qyRK0n7NYBYkOrJcbXoPTzdEzKfUSslbGKnuTBTAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EUTXYd13; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EUTXYd13"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=g5yQxSxIxWjzGa+hwyPA0Gz+zWDvoE4kUJk3kx7BBeU=; 
	b=EUTXYd13biQlsz2D0/wIpz2b3OxA/cQfeYu+sqnjaRSrYsnqVo2DRr0yBpYky8mm64QrkmxjRXC
	RbDeo5InnPLff3Z+3oKpfvrX3XCyW4n1RldwrN5/h0PssUqp/LwVPo0bjnjKyBXmW7usY9pP44V6d
	z4uk/PPq13M2lqpcfGuW2VVGatwsXQeV+QRLKEZ97qJWNl0I6s5avqiCG+/ir5vmBvhMxFCOMzt2B
	9CY5aNtG9Gza6PanXlCihN+OT1IHLu9yEjssyic9lLOQAt7cwSfcjz61SOheab0Y5Cc9JYO29Aym8
	nM7TuWEe2cHqM0PeFYmYgiXOGigfbE10iLgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq7z-005UID-2A;
	Sun, 12 Apr 2026 16:51:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:51:30 +0800
Date: Sun, 12 Apr 2026 16:51:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 0/2] talitos SEC1 ahash 32k request limitation
Message-ID: <adtdEkWyJ7-hbYrk@gondor.apana.org.au>
References: <20260330102820.29914-1-paul.louvel@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330102820.29914-1-paul.louvel@bootlin.com>

On Mon, Mar 30, 2026 at 12:28:17PM +0200, Paul Louvel wrote:
> Hi,
> 
> The first patch fixes the ahash request size limitation of 32k in the
> talitos driver. This limitation is due to the fact that the driver was
> using a single descriptor for the whole request, which is not enough to
> handle larger requests. A change in the crypto core introduced the
> regression. The patches split the request into multiple descriptors if
> needed, allowing to handle requests larger than 32k.
> 
> The second patch is just cosmetic changes in order to make the code more
> readable and consistent with the fix.
> 
> Thank you,
> Paul.
> 
> Paul Louvel (2):
>   crypto: talitos - fix SEC1 32k ahash request limitation
>   crypto: talitos - rename first/last to first_desc/last_desc
> 
>  drivers/crypto/talitos.c | 254 +++++++++++++++++++++++++--------------
>  1 file changed, 166 insertions(+), 88 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
