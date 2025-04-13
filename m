Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B82BA49;
	Sun, 13 Apr 2025 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744560188; cv=none; b=oN2ge5G4AHITr+eUX0uT/FxHT2LXSWtCuU5OzTdSHVqewYuKerPM7NGHxu2qlRAhIbXfdHu0HyrHb9Tkqyc2XNk2Kh9S9lowYUaU/AfK7DkRxw8AMsTHsQhdY36qCU2lxP8PXHILALZ6zhJh4ImJjMXW6L15sEr9EBZ61+kolhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744560188; c=relaxed/simple;
	bh=LJMAcaB9uv4pKcfvn9rYBhkO/F4n3Ykao6J6HwCADsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqrBH5FpZcdfIGiS07Gzr0rHD+ryumtHRCHyLxsFfTakJSjHOitRK8Hec7hW4cB82VsADM/FEW7wD2RwFuMD9yymlvRMgg8pYhtVTou+L3Syzf12gNV7uPGkl7LxF63ERXMX5sgFlGpLfJth0fY0lv5U5/zlJS6s5BXAJJOL0+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CmJpLCQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CmJpLCQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8531DC4CEDD;
	Sun, 13 Apr 2025 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744560188;
	bh=LJMAcaB9uv4pKcfvn9rYBhkO/F4n3Ykao6J6HwCADsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CmJpLCQW1pnja/50ryz6OQo90/dDV+VipQfhdaXXNPcLKKJ/jj+2x8JScAez8hcNY
	 YffzhtFUGRux4fp5YjYl+tP9ZV1ofA1r3WCUfJXm7rGhpu8jTwDHIxChJ1w4exW+3V
	 K+FoDgPwlC32R9TOBE8JAi3PhS5VRDGv7FjfUb16oNaVEj2SOjVI9RzwtGdPuxVH3u
	 dmLY3dEsg52I2i/9eK/YVOrl6q6U6K8MXqEOkzKszdCPuH4bT8ANCOBDmiXPVfHShr
	 rgTn3uq8YFleQhH0GfQzM0IB+eLA/zGfLNLCIGccg/epxpELBo/DIVI+Qg3Y8DKBGR
	 c4s86OT6D5WAQ==
Date: Sun, 13 Apr 2025 09:03:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sean Anderson <sean.anderson@linux.dev>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: Re: [PATCH] crypto: api - Add support for duplicating algorithms
 before registration
Message-ID: <20250413160304.GA16145@quark.localdomain>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
 <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
 <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>
 <Z_XpfyPaoZ6Y8u6z@gondor.apana.org.au>
 <cf7e20a2-dc30-4940-9abe-bbf5ea1ac413@linux.dev>
 <Z_hyG816TRNGoSaP@gondor.apana.org.au>
 <Z_n3O_IZhbgQE02q@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_n3O_IZhbgQE02q@gondor.apana.org.au>

On Sat, Apr 12, 2025 at 01:16:43PM +0800, Herbert Xu wrote:
> On Fri, Apr 11, 2025 at 09:36:27AM +0800, Herbert Xu wrote:
> > 
> > The patch goes on top of cryptodev.  But it won't do anything
> > without a corresponding patch to caam that moves the algorithm
> > data structures into dynamically allocated memory, and adds a
> > cra_destroy hook to free that memory.
> 
> Here's a patch on top that allows drivers to do this easily.
> Unfortunately it still won't help caam because it embeds the
> algorithm in a bigger structure, so the duplication needs to
> be done by hand.
> 
> ---8<---
> If the bit CRYPTO_ALG_DUP_FIRST is set, an algorithm will be
> duplicated by kmemdup before registration.  This is inteded for
> hardware-based algorithms that may be unplugged at will.
> 
> Do not use this if the algorithm data structure is embedded in a
> bigger data structure.  Perform the duplication in the driver
> instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Why does this make any sense?  The lifetime of the algorithm struct memory
should be the same as that of the owning module, and drivers should ensure that.
In which case hacks like this are not needed.

- Eric
