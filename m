Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FD14A3E
	for <linux-crypto@vger.kernel.org>; Sat,  4 Jan 2025 01:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735953625; cv=none; b=bEDPMaEJwZ31lQHi2V2AfnDgOd9s+r4Teto1tQMfLOAL+SbGaBY9Zn8cjtKF6GdDxMd5A73CiSVq2eypEJdLZry61RwMhD4rIXTRDSkUCGUAd3aYisFUZ83MktHqwc41hvcvX1Frzg5tGIEDENx+n2UkxCGJHEUgNsAAb0eqlyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735953625; c=relaxed/simple;
	bh=JgfKiH3a2lqzmN43wunnTxp08P3IxLX8mJAxRKiu18o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=IAca6ph0+p/ibEtLcUeOfp2k7VzmOfia86aCMcszoNbOspxQdGmS8+cuR7DLbNs8EwwuBlQ3fwQQ3lk1bhVFLZuSgP4vdF6SS62PyqjYFBbvc6dpAWDvm5on85cG8kboHYgavKw8yZPwuu0+vTqZcxc/imTVQdkKb1TMs3bVPsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=h5cB0SU6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="h5cB0SU6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/1BHP3L8V/clycpqAJzY6OoQ0XikcLwf/wgHZFX0YOo=; b=h5cB0SU6BfRlBGr2MKO9Yr8fpc
	JL/IT3peNp1BEO6lkm4lW/5uWN7OrTukoQ4MsoWwRymHIGSkm6AdQX3XrY+qCT6J2GHgYZV3YX1Nk
	+1ryPfPwd7Qd2wrM+5J7gckXVM70XXMDKkO9QIE/BjFZG4YujiM5+WBjsXjricNejjIxpclctqScU
	MI6dQ7YpFlJ0PFhKemenwpT/OSm7JtC7xImywo5PQzg0RjCn1yv5q9tvW6FM3J545K4Hm81hnuoSM
	WRdOY34hzK9zuo8y0fXUwNRjJzh34n5CD9mkM48C1O7unrMljuBEJjhbIfOXSa1iwVC8D8C63K7eu
	yB7lRrGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tTsd0-005fbu-1y;
	Sat, 04 Jan 2025 09:20:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Jan 2025 09:20:19 +0800
Date: Sat, 4 Jan 2025 09:20:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ahash - make hash walk functions private to
 ahash.c
Message-ID: <Z3iM03cJNznWskB-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241227224829.179554-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Due to the removal of the Niagara2 SPU driver, crypto_hash_walk_first(),
> crypto_hash_walk_done(), crypto_hash_walk_last(), and struct
> crypto_hash_walk are now only used in crypto/ahash.c.  Therefore, make
> them all private to crypto/ahash.c.  I.e. un-export the two functions
> that were exported, make the functions static, and move the struct
> definition to the .c file.  As part of this, move the functions to
> earlier in the file to avoid needing to add forward declarations.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/ahash.c                 | 158 ++++++++++++++++++---------------
> include/crypto/internal/hash.h |  23 -----
> 2 files changed, 87 insertions(+), 94 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
