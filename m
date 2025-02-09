Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D326F06A;
	Sun,  9 Feb 2025 10:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096549; cv=none; b=on5PEoF8wixJs5oVuTkV9Ub/1L7UJE0wOBfjbmRA7H5fiFXX3ku0A9hgf4v7J5BPmlP3bx4AZUfmFFakYbSe032qlQ2uZ+SXWiT+mQ+CkuylGRKYhffolx/lby6bvFl62qXk1IGVv/ZA/jeFqGY5xUY36jOlaQ5c43whe1/gFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096549; c=relaxed/simple;
	bh=0/nTc9NBXF4pZuqFLOxJPJbJbhAW7vr/fh8co0ILyf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMW2Nep4FTDtIAu2/XY7+Agc1Xk6Of4x28w/nx3UDrtdPDYLqZXOtqsZ+p4/9BTzHseG5O4KqyIlUw+ZssAagEnqEzWirSK2bdDtcrjJHmZpAJ8kNs5L22cTH2bYJGRBMbZU1UBDG3jKnMb7jAO81N5mj3fibEbEzSrd7sxokww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XC/vFlEV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XC/vFlEV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4riV8G/E57bRsausdiY532IW6h5oFzbpaeL2CjVkiZ8=; b=XC/vFlEVBClXLxU3t/9nsNCk6j
	LCHQ0eu+wEloNTqH0hVBXrt6+wva+C8BPeWMpW7SCm9rfP74hcYTeoqzRIek4Fc8vF8yfrSTnbKus
	RYdqo+cAsJCQTuMyVOM4ShHIA1Pnm4Xg+F2cLPJJT/yQ8aivelgz98cKpm1eprX9ePlJNM5DXijbi
	eBJjNDlwS5hf/ipjOtMthcDdFNXDFKilGDsy0isI2dq4sKjjhaa3WWYKvJygzZQZNmsY05LpcMFyL
	Ow9eznKaNQpoS5QNChuGZlf+wz78q+v5ud/S5XOoh3EyYPWnWKLbRpjKkUit4xJ81Izyp6twbSPGc
	ehLvBwJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4FJ-00GIkx-0B;
	Sun, 09 Feb 2025 18:22:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:22:21 +0800
Date: Sun, 9 Feb 2025 18:22:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dragan Simic <dsimic@manjaro.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	olivia@selenic.com, didi.debian@cknow.org, heiko@sntech.de
Subject: Re: [PATCH 0/3] No longer default to HW_RANDOM when UML_RANDOM is
 the trigger
Message-ID: <Z6iB3Z_hxqHuJNP4@gondor.apana.org.au>
References: <cover.1736946020.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1736946020.git.dsimic@manjaro.org>

On Wed, Jan 15, 2025 at 02:06:59PM +0100, Dragan Simic wrote:
> This is a small patch series that makes the already existing HW_RANDOM_*
> options in the hw_random Kconfig selected by default only when the
> UML_RANDOM option isn't already selected.  Having the HW_RANDOM_* options
> selected doesn't make much sense for user-mode Linux (UML), which obviously
> cannot make use of any HWRNG devices.
> 
> Along the way, some additional trivial cleanups of the hw_random Kconfig
> file are also performed as spotted, in separate patches.
> 
> Dragan Simic (3):
>   hwrng: Use tabs as leading whitespace consistently in Kconfig
>   hwrng: Move one "tristate" Kconfig description to the usual place
>   hwrng: Don't default to HW_RANDOM when UML_RANDOM is the trigger
> 
>  drivers/char/hw_random/Kconfig | 84 +++++++++++++++++-----------------
>  1 file changed, 42 insertions(+), 42 deletions(-)

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
