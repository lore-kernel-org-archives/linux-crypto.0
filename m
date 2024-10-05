Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED9B231CB1
	for <linux-crypto@vger.kernel.org>; Sat,  5 Oct 2024 05:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106683; cv=none; b=njIm+gmgTSD26QFsX06GzsFDoNlk1SU7C6s2WJADfwSbrHEoMeme67KMvmwR9UeYEwirjZ8i+aBDh4C2QPBoGYGvhTVAM4zggscTG+4s3m2h+o8bZYa8unzrGLkxsutXwBtH2kaAzkKJFUbIh/xDxBwl3RDQwSXIlFA/lJjgbs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106683; c=relaxed/simple;
	bh=Gq4Imn97tYB+ZU2P/W2GCXtC5ctGOxAT0xx2nlO6jgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVHBT3BIL74L1qdMuK7i/IuwQRTNKW0TCRH+Hjs2hgOggUeAzTMI1HIF9MwM6unmZ2O5zcA1pdGmDhOcvj6U1O1faMWK+b2/QUmL56pE1OxRiTQt8qgiw1xof1QW2k07q+dtJlBrYlhTS/O4T5Lq6kic9vgGpeN56aW05dMW9H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZcjrCqJU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZcjrCqJU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rbGLYOoM8VoWEHZilj+r/p7P1edbCgRw9KSEUnQjt88=; b=ZcjrCqJUA6vyFDubkif972c88a
	2BQhJhcvbXfsp6vzBnhFw70d9FE8+vaoggcIguKUB7o2YI9KnpdA9kVP0l+7AbvxWQdjf9PzTelBd
	UnyyHuLVTpU5I7cuLZ9CRYWIZedycz+/9eM9NUsRRPnp6yG6MJSIAxfcHj5UleYhVMoiNu+cjktVU
	0DvMRC9O2NJGYHtFUuG6ImODL6NOrxAPnW1UdI81QZOjuynxp3tdZO66wLjnJ4MxMKN2PrLCmwBOi
	MfdrAcKMEPQJXFpp3v5+f7xRhbjfHvhoV2J+/ZBbOG0JNdP5G5rclpIgG7GIoIjxOqPLLdlL8U+e1
	7hFRBxfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxKR-0071cF-1e;
	Sat, 05 Oct 2024 13:37:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:37:57 +0800
Date: Sat, 5 Oct 2024 13:37:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harshjain.prof@gmail.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>, h.jain@amd.com,
	harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Subject: Re: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
Message-ID: <ZwDQtTaETTKQo0hJ@gondor.apana.org.au>
References: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
 <ZvEasINIFePe1tE7@gondor.apana.org.au>
 <CAFXBA=nKkV8tviqpzYFCqY1rjOKKDD8Z_T=poqjStWTLcP1Kbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXBA=nKkV8tviqpzYFCqY1rjOKKDD8Z_T=poqjStWTLcP1Kbg@mail.gmail.com>

On Mon, Sep 30, 2024 at 01:08:37PM +0530, Harsh Jain wrote:
>
> Any idea when multi buffer ahash related changes will be pushed?

The mbhash code itself is almost ready.  However, I'm still working
on the ahash interface for virtual addresses so please be patient :)

In particular this is going to render lskcipher redundant so I want
to make sure that doesn't get in the way of this work.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
