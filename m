Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3101F9403;
	Thu, 14 Nov 2024 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583043; cv=none; b=emUmOWpijVv2STP6sR491ut0SMvj8/+Xnb0sqN0wbE0AXakFJIjD5KMboOu2etvQrrSRsgp97LwbY4ipp0v8EkCIjn1UmNtnssdMrzQwjpRx46e8jNgbXcM5/HLvo1jfI6QLgEL2M674X8t1eo1NKO++e7oneKfJsHaz+xdON+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583043; c=relaxed/simple;
	bh=bx26Wne9J/gleTdN6vd7L97fhvjjt1afdQNg1c4FV6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R65zQ/Hm3d9WT57Wzq0Tftf1yBEURQBMVAAjuAvBQI6Mw3oqNkAS1Od179GH1RGfb+RNU5rXtr1h+MZQe+8PxTnjF+JrtvWXoYkyTYQxysFc8yTDCjPk2fmP8711BvHL8HA/xTEqhECPPtztjA7y/nUOo7HMa5Sf9NqYb60c2YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XqZYTKwh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XqZYTKwh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oH606LSb0d3e7eUN6IdJB6b2VsHIS4Y58C5yG2pNubQ=; b=XqZYTKwh7qqZh/O6HpUd72b4rd
	W9dVI7Zd6uT1sMZI/PuBHl0/UV3PYDzirAPmKEDudO7t/WOJ4z+6RQGMQpQSDYOI7WcKOVfM1Lip+
	TVW804KX6RlxWq+zDpbxGb1YB+JYD8IaotFoP7HwXAOZGEZyF1S7Gdcdmms1wO9hC5GSygDEGlkQe
	lqnGNPvFQohxb5efyJdbCbFRnwn3Lwhtx/KwF7vqcRFrHJS51r0HanIYYVUzHoNJyEIogGlFJAzqm
	X0XikhIw8+Rx6nouggCekTSUrqBYEUFLTX/doaye9Enik8X3PyvVqgW74SYQcNVvHI9YcE0oPWTRD
	RLghdGWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBXqQ-00GmJf-2e;
	Thu, 14 Nov 2024 19:17:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Nov 2024 19:17:02 +0800
Date: Thu, 14 Nov 2024 19:17:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, davem@davemloft.net, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/3] s390/crypto: New s390 specific shash phmac
Message-ID: <ZzXcLgY3WBuQ460e@gondor.apana.org.au>
References: <20241107145521.424769-1-freude@linux.ibm.com>
 <20241107145521.424769-4-freude@linux.ibm.com>
 <ZzKxrKpSFCdz8LPp@gondor.apana.org.au>
 <619dd7a11549a1b33827c5a8a680c371@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <619dd7a11549a1b33827c5a8a680c371@linux.ibm.com>

On Tue, Nov 12, 2024 at 01:45:53PM +0100, Harald Freudenberger wrote:
.
> Well, we had a similar discussion once with paes (See
> https://lore.kernel.org/linux-crypto/20191113105523.8007-1-freude@linux.ibm.com/)

Thanks for refreshing my memroy.
 
> Why not convert in the setkey() function? As of now this could be an option
> as the invocation of convert_key() in the end within the PKEY pkey_pckmo
> kernel module only calls PCKMO to generate the wrapped pkey. However, long
> term we will have another path using a crypto card for this action and
> then we are clearly in a sleeping context which must not be used from
> setkey(). So make it correct now means to delay the conversion from setkey()
> to later: the init of the hash context is the next chance to do this.

I'm not sure I get this justification for putting it in init instead
of setkey.  If you can't do it in setkey because it has to sleep,
then surely you can't do it from init/udpate either as they too
can be called from atomic contexts?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
