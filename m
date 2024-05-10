Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02703168BE
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715347531; cv=none; b=gU25HMFkZIilS3rabiwWNgl9yf0vS3LvfuiXd3Ie8QjED3lOhtiOB+qQZTdov/dAw/pAPQmz+gUGEIBi0niCr9Eoh9kgcMn01GbAJWGO0+N2ET4tXit7Fa1FXByU8v/sLCLUOMRbHprB7+jomR+DF3WqkgQElY7dFxre+JBMVVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715347531; c=relaxed/simple;
	bh=9acq+KHhX7gW7xL5vexCqr1MlAp/IK65ADlWdpcAINs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCT1gMLUI1u3DRgbLclal0mMmGi70wrC1AguqY/dBVMXpL5m7wxgIgvb1FirVhgh1oPBl0ZuZGmUgYHhezMzDH1N+0+8IbFaUFNjOTQ3vpEDl85856YBuzvIurU7vz33UZpxIb/qlAwaLcqXQEZAodTpp/jsRnhmmBkQoXQOF5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5QFV-00DSa8-2b;
	Fri, 10 May 2024 21:25:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 21:25:22 +0800
Date: Fri, 10 May 2024 21:25:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Is akcipher ready for userspace?
Message-ID: <Zj4gQlfullfvK3q8@gondor.apana.org.au>
References: <20240510151434.739fd5c5@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510151434.739fd5c5@dellmb>

On Fri, May 10, 2024 at 03:14:34PM +0200, Marek Behún wrote:
> Hello Herbert,
> 
> back in 2019 you wrote that akcipher is still in a state of flux and
> not ready to be exposed to userspace via AF_ALG [1].
> 
> Has this changed since then?
> 
> I am asking because I am implementing another driver [2] for a device
> which allows for signing messages with an ECDSA private key securely
> stored inside the device, and Greg asks again [3] for this to be
> exposed to userspace via a dedicated kernel API, instead of
> debugfs.
> 
> Back in 2019 when we needed this for the turris-mox-rwtm driver, I
> implemented it via debugfs because akcipher was not ready.

No I don't think akcipher is quite ready yet, given that the
recent change to kernel pointers from SG lists is still
incomplete.

However, akcipher algorithms are already partially exposed to
user-space through the keyring subsystem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
