Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34A433C8;
	Thu, 27 Feb 2025 01:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620866; cv=none; b=cBYMnqw0hRwvWcOGCnwaTUcSLyaSO4jahU3ErPCDfv7P6GKSTOK1HY2s0NMEzusYEbCyO+86eI/Or8ecOTOGlI/bxLZcfCMofgDS534LScB/lROdHTE0rWslHEn4H9tWWk29B+IVKkmMWBo7QMceAyN8ZZVQNh8/Xf54BN0y4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620866; c=relaxed/simple;
	bh=3sQJq6CYQLdni3LUYx9d2dSzB80G+qZE0uXv++5jG2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qE3DAb5dKzR4fapgPT3qDLIP5Vp7zKk0HmSk8zvEBKu07U69KZ0F7Fx0Segck+Kc9Z1ND8sLIRCGw2RfSRq5Iq99thGa1CkqmIl2WnRTgJsbClzfkd3g7QGOACLiVEmKldDh+ccfOKXKuONVJ0R18lO85hqk50Yo9aGWfg/gYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=l3okgVhD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="l3okgVhD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cIvXkiXZmjNPdr+LIJkLqCM/SUgxxM3fIuCK8mjUuGo=; b=l3okgVhDPL3+K2/KYwxBggZ7Te
	azsC+cNZUzQOXjWEv8xQgUePIAIhqUawKcDXOhzb69gKSkpgWQfuZAITbEzuHEIzJ5mtvYUe6DCeU
	KSzVkKdShM1zBkQNh7jZ6SuHM2b25cS/i77IuuYJ6sXRG+RBR3c+Sxlkf2hDIMaMBvFmpWVi0jxV/
	Gn6Vc9wD/1IVHJr9+Ne9S+DigphkMgZ9n5gVFKslFefU3Fp+ZpAcDrEhQufJJiSxIncYAaHiosLu7
	qWaLhBi1mEvzWZpqYgZ+g/NSWBW+b69mH21Dhb2a+EvvBZIM4BSLrun4GXBXtZIDLb6KJqukiqRoE
	fqKSrpGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnSzy-0028Fi-0q;
	Thu, 27 Feb 2025 09:47:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 09:47:38 +0800
Date: Thu, 27 Feb 2025 09:47:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <Z7_EOjyoC64HbiKP@gondor.apana.org.au>
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
 <hymyvszwshcvqngjlomeyltmpghx6gges76muaz23a6cit5oe2@eas2xjgfynnu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hymyvszwshcvqngjlomeyltmpghx6gges76muaz23a6cit5oe2@eas2xjgfynnu>

On Sun, Feb 23, 2025 at 05:40:31PM +0900, Sergey Senozhatsky wrote:
>
> A bit of a pity that NEED_OP() with "goto output_overrun" is only
> for decompression.  It looks equally relevant to the compression
> path.  I'm not insisting on doing something similar in compression
> tho.

I thought HAVE_OP looked nicer but I'll switch to NEED_OP for
the sake of consistency.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
