Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F08235C14
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 11:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581947; cv=none; b=odptwwltOw4Wv1fU6AJs7sIHppeFLJpqrwSycTGiKSCdX9Ry/m2mZyMFbHWn0bVP6apAAciJOmvyyXrgHjScpesFbXgjkobExTRwE0dkj/JqLqM0QWnt8quAsg2ElLp86zUY6B3N/A2kwb+zbw0WX2cbWR+gh1STufW9D9CvQzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581947; c=relaxed/simple;
	bh=36i29YTk41IV6ul6cJykFukvYBNWx8s0ZZOlt45XEKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzSHR4QzNN/fQTT2iLNbmpShMvhngr2EALAc/iMgc1qqNgIOt7UWa4IOXZrJbYwU7h6NDd0b2OVZwn1G6uBJAUPgZ/uOA8FLbC0G8g6qoGF7VBp1EHnv5L6U+cm9TA14Ch8kCfdEa6jZnXSVBZmLoLsgT6s7bkPVMN0jABG4aqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rmo2Qb8N; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rmo2Qb8N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VvvRSKoAElj2ICWf9yoWNlbeSuY/7lTD1BHFmLbq6TA=; b=rmo2Qb8NTGS8098EEPNzBmN14f
	T6n93WR1RLNLTo04xHEt5tmNyWRMQubRmIryF61xAe0L1Zpgctbo7mR8/b+7yb07t/jdnfJyctD+o
	g6j/z5vJmGp/bc3k84MfHz3bFbhy56K3tG1JqbA4gBJ8anKLWttppzYcSZadhoNxbI2/Q/YEK4p9C
	mkRa/Z+HrRW30I2PAB+TXv06VddaIg4wuKMmcI6kWaLuI4q32TMKSDWoRrbcvMNneV4EIS9gc8xm5
	Qv8LTdGRv6gRpUc5m1/q5SMCQXT+oo6npI4olsiYYhqd2EZmd3AfE0A57SXmhcIuATjy9+t1C82zl
	vhHWnpow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8HbQ-000ydi-1W;
	Fri, 25 Apr 2025 19:52:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 19:52:20 +0800
Date: Fri, 25 Apr 2025 19:52:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/15] crypto: lib - Add partial block helper
Message-ID: <aAt3dJDylNNOLDVs@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <20250424161739.GF2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424161739.GF2427@sol.localdomain>

On Thu, Apr 24, 2025 at 09:17:39AM -0700, Eric Biggers wrote:
>
> Why aren't the POLYVAL changes in their own patch series?

Yes they really should have been part of the previous series
since it's not lib/crypto code.  I'll split them out.

> Touching SHA-256 (which again, I'm currently working on fixing properly, so I
> keep having to rebase on top of your random changes which will be superseded
> anyway) also seems to be unnecessary.

Sorry about that.  But sha256 happens to be the only other lib/crypto
hash algorithm that I could take the code from.  It also turns out
to generate x86 code that's much better than poly1305 (I actually
started out with poly1305, but switched over to sha256 after I saw
how horrible sha256 looked with the poly1305 partial block handling).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
