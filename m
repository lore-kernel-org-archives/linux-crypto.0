Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEE572608;
	Tue, 30 Sep 2025 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759240358; cv=none; b=rF9jwzcCxNRypD+4wQDWNImpp1zwEdejlXpGzTObtJLUjfK/TYN0gSafP6nfm1sNES6Y/93BqC/9KeE8iS1Kun2MAJ0gv47eMUQTyLjEphL+sIBt+gavMWH83y0QElArU/JfjppcR24Z2wgmBtOXK6X4MW4dmuXjsQZVjdu7+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759240358; c=relaxed/simple;
	bh=xMIVcGxQ32uXEOi8aAJ85V5/jD1VszcdEO5jeP+zsXs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kO4hRsp9Q5s3A6BpyPTGWxXfW7oR5NSWt8KIZpNBCqjEjP4C4eutv+Mf15f2etuPp+uaHYg9bht6M1jGKIkGiuzteVwoX9YAB2YUlj5jAz6Y/WdsHieGvluCxxj08+kKPa6ErW+acKmk37TRMlp3ED/QjuPQsnIPPMY2lye4riM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eQfg9SuH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eQfg9SuH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:MIME-Version:References:
	Message-ID:Subject:To:From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=AvMj7flbSOCr3WaSVyFFU8TqtdPZpuI2FKgwbIA6O3Y=; b=eQfg9SuHVQGdZJfSP2SeiW6LsD
	S4l1vCTtqEEQ4ExhXx7s+k2pgjTSiRjplLNXUZqM1EuBW9myU+CRw1vZuiLay28e/etAjkWWV1NJ0
	74dXvzo2xVsClhJJQKpieS/cfP4RLmyvXtDhTg3IFTAUxZXcEfZ2G7tiRZXbRFVBgH4ayplR3Hhdg
	7P9P0QQOile+tJXM/TLFE//pi19jGvBaa5ldx3gXfgBzlrecOWJO8f8L0aTa08fIgsi8l4WI6PNqO
	Glw05/sQlAkNIvgu5eYMhZaEguXQCRNVQQsKBTIIZ/y2xCAnjMLbcRYES4YBYw6BmEbr0QaWlKbHP
	2tpYQV6Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v3amI-009SR5-1u;
	Tue, 30 Sep 2025 21:52:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Sep 2025 21:52:26 +0800
Date: Tue, 30 Sep 2025 21:52:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.18
Message-ID: <aNvgmoQA0Km42hY5@gondor.apana.org.au>
References: <aNuln6SQ_VIISMPi@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNuln6SQ_VIISMPi@gondor.apana.org.au>

On Tue, Sep 30, 2025 at 05:40:47PM +0800, Herbert Xu wrote:
>
>       crypto: ccp - Add support for SNP_FEATURE_INFO command
>       crypto: ccp - Introduce new API interface to indicate SEV-SNP Ciphertext hiding feature

Oh I forgot to mention that these two commits will conflict with
the tip tree as it modifies the same file.  However, the resolution
should be straightforward.

https://lore.kernel.org/all/aM1bJqhtojdLhp3c@sirena.org.uk/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
