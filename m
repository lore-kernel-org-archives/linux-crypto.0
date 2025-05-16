Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9BA22FDE2
	for <linux-crypto@vger.kernel.org>; Fri, 16 May 2025 09:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747387389; cv=none; b=fh2yaINig+29xlpD0Gprqb3mrnw/eXPgyEDgLvxbD2LUsaNNe35MeuUoIbHeNVRfdcNLF2OXMmVzYbqHUWd6zbwJPGRnbi2BRfUTWo5bLjixfXMKaHgOvjEOujEm8qQYEFYZwyusumQnALSxZPD8gXlCevUjZc1k8EHgh6kakhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747387389; c=relaxed/simple;
	bh=gqBk9ON4u82i3X+nzrvRnbUckf5MyM/Vq6hs1y9SBUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkqrSXguS+c7OEFzXVnL1WPtodAxRlnU5/uegqahQm7X2YOOuj7imZowClzLoAtH2r7SLjehyHCY0QjiC6f4/o7o/2KIscJvYCDbqb2JYdyxoV7gN+ACJCrY2c77Y0Ze+iJi0kj8Sbx8O4pMaT4A0mgMRmq2e+qLVvqXJWzXB5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mw0OpLXm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mw0OpLXm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kTAosqpAl6FLogyQV51s+4b2ZS0cR3AJLyT0QsqJJjQ=; b=mw0OpLXmurA41pIq4M9UGwurwK
	88SpKQXiNNdeBQQPsX5KYfFhl2jiE47BcueJVSdQN6ralF0oL7xoL8GseeICmjKrITlc0wp/7eE9X
	dFmUAS3n7gUEPnWrsa9dNy5MeQO4JIG5O77sheJbRz26uIuDvRKMIFbKuAvBILO9Zhlv4y3XdjvOZ
	ef41okKwghlbRsGmgi/D0Q78O1RkorRqOKyZEjbSBgP1Ef5DmYcs/YsR3k1jTKgFapo7g2YOHFHKA
	KDvASOHWMa5JLpFDmxbM+dbmk4dz5iZOy3MtSe1lMQ3wqeZ/vcFG2Z6oKvbKW9nU1K7YItUwEMhcK
	ze3pjXOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFrHT-006Y4Z-0M;
	Fri, 16 May 2025 17:23:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 17:23:03 +0800
Date: Fri, 16 May 2025 17:23:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <aCcD92EWd_8oxlEU@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <20250515193529.GJ1411@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515193529.GJ1411@quark>

On Thu, May 15, 2025 at 12:35:29PM -0700, Eric Biggers wrote:
> 
> That seems backwards.  The shash one should be the regular one and ahash should
> be special.

That's how it was in v3 but because of the switch to ahash in
testmgr this blows up due to the quirk that the API cannot allocate
a name such as hmac(XXX-generic) if the driver name ends up being
hmac-ahash(XXX-generic) because neither the algorithm name (which
would be hmac(XXX) nor the driver name will match.

This coupled with the fact that shash will be removed anyway is
the reason behind the switch.

> Still lacks any explanation for why this even matters.

I've explained it many times before.  The point is so that you
can fallback from async to sync at any point in time by exporting
the async hash state and importing it into the sync fallback that's
now allocated for every async ahash.

> As usual, missing a base-commit.  (Use the --base option to 'git format-patch')

It's based on cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
