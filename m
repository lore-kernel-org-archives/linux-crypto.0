Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000972222C9
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 05:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003673; cv=none; b=UzLnn1ViMnPmWu4Q1Yr7BN+4OrQT3UdaYKC1Hlfywnj7LadB9FbMkReqhkAJfwN9wh3/SeZR8UTUG3IYdpkFi0xvwjwY6b3xdLXXnxZUMChuW0Ts2Mw//Oh+yhTiZrPVzfS7U0T0sK/n4g48ukU4u/kYidMjaRRWm43eqmV5guI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003673; c=relaxed/simple;
	bh=7uhQcK3bIWvLpRjoiluTPk9QLo1oCLGJw2cuEnLxT+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uC/GTDqNBy0YqaCHkr6jQbjWZsQUQYfIVNBtbnKesJPHnhVzMLkwF/AqdmTXntEHC4iyUx6xIskTGTFfp3Ii+0ekicf5a95fuyEvGMTJX92znIhjHDVyD7qCrUssfFrsuKHWz7fKbaoCkGXwct0+kRqTZ/qthXnw7fRxujZRzmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TKJCRGVG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TKJCRGVG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QuCXxemOwzi+daSzhgNPUWipNAarADZvuPuX9JnARXw=; b=TKJCRGVG2bB4Yr1Ejq+Rqc7o1w
	ZlloVXACk9ldkGz92nj6T4DjN/ATD8L0wihD0Ux5UvnmI4iQsNw5HZkEXnc586wDhLxU3ESYTn8vn
	St9/SmfcBGn6nIuntaKGOaet0Ok/CssBg2AgpPP9Gq+G3kaIsshtrciO3HWmazIbtgNNRj4HuIKpP
	FGrY40axzskgd5zAOO4O1OsO1q3gtBWCzcEjDazAmhQPZxfVeEV7mwcXyk2FhJ4R8j9h5ZbyoD/OV
	kC/rf6y6B0Hstz0YJVPK4FTuJjqYnXVj1UPz867jpLR4+a2QVelXyK7pXwWCuE4XZxzvbgjPF7rTw
	RfcghOOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1f1P-00DNMd-0L;
	Mon, 07 Apr 2025 13:27:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:27:47 +0800
Date: Mon, 7 Apr 2025 13:27:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 0/3] crypto: arm - drop dependency on SIMD helper
Message-ID: <Z_NiU5dgIT3Wwvxe@gondor.apana.org.au>
References: <20250403071953.2296514-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403071953.2296514-5-ardb+git@google.com>

On Thu, Apr 03, 2025 at 09:19:54AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The non-SIMD fallbacks in the ARM skcipher implementations have become
> dead code now that SIMD is always allowed in the contexts where
> skciphers may be used. So remove them.
> 
> While at it, remove the sync CTR helper function now that its last
> users have been dropped.
> 
> v2:
> - drop unnecessary includes
> - add patch #3
> 
> Ard Biesheuvel (3):
>   crypto: arm/aes-ce - stop using the SIMD helper
>   crypto: arm/aes-neonbs - stop using the SIMD helper
>   crypto: ctr - remove unused crypto_ctr_encrypt_walk()
> 
>  arch/arm/crypto/Kconfig           |   2 -
>  arch/arm/crypto/aes-ce-glue.c     | 104 ++----------------
>  arch/arm/crypto/aes-neonbs-glue.c | 116 ++------------------
>  include/crypto/ctr.h              |  47 --------
>  4 files changed, 20 insertions(+), 249 deletions(-)
> 
> 
> base-commit: 99585c2192cb1ce212876e82ef01d1c98c7f4699
> -- 
> 2.49.0.472.ge94155a9ec-goog

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
