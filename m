Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92930B517;
	Sat, 31 Jan 2026 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828258; cv=none; b=ic6iHO4qgDhiGlOl47dDbMpUMN3AybMS3XREKoxipV8HHmFIhRHGwBuK1840PqgciLM1Md9Cna8CQ5D5Pd+kOjLU/9aWPR4jSgBIjYHCo0vOm9WfbshqG+S4vX6QefLDm8xO0wTLYQenrFB0HLRf9aKmE+WOeH5Ot/0g6lPCYZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828258; c=relaxed/simple;
	bh=oyw4qxQ9aKEeO3I4dGus8c5TMQkAHI6aL0/Yzq07Rwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oz2tIrFd8+u+RIlHuJ6QI7/T1rorBv9AG+BDhiKtB6TOOHMgvnGNqUhHCH2VJfLhrr0wt3cKfXKspaiscsCyxTUiTJF5Tsit4J4RS56HWn7v8ZOHE9aXUGvpfgvF2H2eVTT30w1dpAm3CfdqRFskZ5uSg0voRpakE/Pzuzp842A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Zoh8m/D2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Zoh8m/D2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PbmHJi7+ZZdhmCHdlTxWH9iRruNjhuV0J18meGymZFs=; 
	b=Zoh8m/D2FnzcNVgaT+gYOxEyw+5CcEijJDMsodVtumj8d8E3UmwaoKwb9aI/OmNFM4q7A0PuoF6
	i6zH/jWiHmc2UL0HzqxOw9VYWh9VpmTDzOAcGhwL1ECgIbUqaODD5lQX89ontraSGkAEYZEmDVOgy
	2f8kXP9dQPvxM/Sx7Zwfb2WklwyPv+IUCKHdt9w7ddCOFremSQgBQX911/LlHZrMyBzx0w0jIuDhk
	lGxDQ708G1/KxSiEHG0DScqUbmP6NfNgZutLs+iO2zXy4IkOsIdKIF4CPcjhdN/SyvJbUU1XsHwim
	CpmXk5wp+hNAz1l/QaGhslseppuM9J10+nfQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm1Az-003S1o-2R;
	Sat, 31 Jan 2026 10:57:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:57:33 +0800
Date: Sat, 31 Jan 2026 10:57:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: Re: [PATCH v2 0/4] Paes and Phmac: Refuse clear key material by
 default
Message-ID: <aX1vnU06JiY1q0ua@gondor.apana.org.au>
References: <20260115120026.4286-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115120026.4286-1-freude@linux.ibm.com>

On Thu, Jan 15, 2026 at 01:00:22PM +0100, Harald Freudenberger wrote:
> The modivation of these patches is to disable clear key usage
> of the protected key implementations paes and phmac by default.
> 
> With a new kernel module parameter "clrkey" this behavior can be
> controlled. By default clrkey is 'N' but for testing purpose on module
> load a true value (1, 'Y') may be given to accept clear key tokens.
> 
> Note that during selftest clear keys are always used and thus as long
> as the algorithm is in larval state indicated by
> crypto_skcipher_tested() clear keys need to be accepted. However, in
> this state there is no way to establish an instance of the tfm other
> than for selftest reasons.
> 
> Changelog:
> 
> v0: Initial version. Request for internal feedback and review
>     Please note I assume that patch #1 goes via s390, whereas
>     patch #2, #3 and #4 may go via Herbert Xu's Linux Kernel Crypto.
> v1: Sequence changed and feedback from Ingo, Holger and Heiko
>     integrated.
> v2: Integrated the feedback from Holger and Ingo. First version
>     going out to the linux kernel crypto mailing list
> 
> Harald Freudenberger (4):
>   crypto: skcipher - Add new helper function crypto_skcipher_tested
>   s390/pkey: Support new xflag PKEY_XFLAG_NOCLEARKEY
>   crypto: s390/phmac - Refuse clear key material by default
>   crypto: s390/paes - Refuse clear key material by default
> 
>  arch/s390/crypto/paes_s390.c       | 93 ++++++++++++++++++------------
>  arch/s390/crypto/phmac_s390.c      | 29 +++++++---
>  arch/s390/include/asm/pkey.h       |  8 ++-
>  drivers/s390/crypto/pkey_cca.c     |  5 ++
>  drivers/s390/crypto/pkey_ep11.c    |  5 ++
>  drivers/s390/crypto/pkey_pckmo.c   | 12 +++-
>  include/crypto/internal/skcipher.h |  7 +++
>  7 files changed, 110 insertions(+), 49 deletions(-)
> 
> 
> base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
> --
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
