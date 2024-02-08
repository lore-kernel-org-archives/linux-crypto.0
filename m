Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E9325613;
	Thu,  8 Feb 2024 03:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707363780; cv=none; b=DnPop0guKHoGfwVkjgs6/rAuKjBELH+6q+tIqWXUXgz7XJsDe1NyYnbDMOQvhWvZWkrKWBZ5VNADlp9c/PSU/gfFqv6/MzbEN0Z7yxUwdL2L/qZNmI9U0euop7s2xSW4/JpWtBlSsJL1gFC9KAQHZ7l5GJwBLVZWWH4hzsDTYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707363780; c=relaxed/simple;
	bh=rGOPrAcS1Z86EhBz2ty3dct08n2j7GPKeuvvpkVTn6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdxeulbsilLG5hoCkKDQ4KOUtQvZ76cLji77FD6gveMPF5tex5LZCvbSVYaNwvp+858zch7qIrh0Ip+dkCjKiT4ezqnU00Sy5T2aD/vw9UVX190hrvT5YntntcxmwuSoZ796KIFACHOc7BMwhYPyzCgWD+G5Tm2fRqFesxtKl+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rXvJ7-00BGtl-49; Thu, 08 Feb 2024 11:42:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Feb 2024 11:42:50 +0800
Date: Thu, 8 Feb 2024 11:42:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: A question about modifying the buffer under authenticated
 encryption
Message-ID: <ZcRNur8+h9BYzRog@gondor.apana.org.au>
References: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com>
 <20240207004723.GA35324@sol.localdomain>
 <1a4713fc-62c7-4a8f-e28a-14fc5d04977@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a4713fc-62c7-4a8f-e28a-14fc5d04977@redhat.com>

On Wed, Feb 07, 2024 at 01:51:51PM +0100, Mikulas Patocka wrote:
>
> I assume that authenticated encryption or decryption using the same buffer 
> as a source and as a destination should be ok. Right?

Yes, in-place encryption and decryption is OK.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
