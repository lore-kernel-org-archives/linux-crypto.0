Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90C15A4AF
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722940536; cv=none; b=Tu54ON1kkbgWtpZKyp5QiumOLmF++gD+4w7DT/FFFHVDpv0sReICSv3Bu/3pFB0yp1Fr1ugtHGPDCrOTcQs/vxknzfHy3AWO4YZzmDS34suWu7ZPaUPHajSempAnu6vTwZVKUv6o1UA8l81a/T2ZBdBDbDcJBnYmhREozepQ5t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722940536; c=relaxed/simple;
	bh=FCPz36zNstf3QuGxb/UiqbwdeeXj4F/03SfqXvfmAS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b28HeGbMDIeVxttDaBu7hBfQIuKBq1cx6a8ZYSHTs/Kk0jPxBRvLS7EaZdOd9XsEleEB5g8S/efBlVAyxEFRhe6ok4rPhkay9z/AXqR0o/mCivb+N5bmEVhKF3WNKy9+80OCUVK4aUPS7//1ztH8c/0tFX00IUsUAfbPYsbBtRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbHOW-002lHy-01;
	Tue, 06 Aug 2024 18:35:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Aug 2024 18:35:05 +0800
Date: Tue, 6 Aug 2024 18:35:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [BUG] More issues with arm/aes-neonbs
Message-ID: <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>

On Mon, Aug 05, 2024 at 10:42:06PM +0100, Russell King (Oracle) wrote:
>
> We get to the __cbc(aes) entry, and this one seems to trigger the
> larval_wait thing. With debug in crypto_alg_mod_lookup(), I find
> this:
> 
> [   25.131852] modprobe:613: crypto_alg_mod_lookup: name=cbc(aes) type=0x5 mask=0x218e ok=32769
> ...
> [   87.015070]   name=cbc(aes) alg=0xffffff92
> 
> and 0xffffff92 is an error-pointer for ETIMEDOUT.

Looks like something has gone wrong during the instantiation of
the fallback cbc algorithm.  I'm looking into it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
