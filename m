Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B093B3BEF;
	Mon,  2 Mar 2026 12:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454379; cv=none; b=adVHoNy2eJUDQey+ojBDOJPS2yKGGmOOu7CYRl7MbQJPgPekHtwB+GD3Ty9YMOOTnvfcW4CfUGEuKLGK38eK1I/ECWp1ClxDjwBAX4dRtrU5q517NQ1uupBHGL7dOEiNMWxFDk5ItezjycYz52wAVD2sipbysVCSK3NwiHGmGNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454379; c=relaxed/simple;
	bh=RVfsxgTlhH0JmZwUCJXcBzOXQy7zP4FBhDhUvUOB5Q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1Mb23q07GCOY8/8oC+qbxHhmUyZ/mRxzH9S3bK7CKWlvZGFMaihPKOUbLN0rJ/+b0d31oHQcOGGvMI3+lC2aTwWuMc+ph6E3oqxC7zB9o/YQao6HI9wDCD6wSiY97OE98W6C6pfbj3cTJfxndu0J+bLWap+/HgUwndFqXTRcj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eoDZElef; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eoDZElef"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JCf2dHrA2iWaWPU4fEd7CeTt13nQg+INWuJr+P4W4uI=; 
	b=eoDZElefMPXMBIePXRIfKIQ9jcsmjhxJ9LWnQTStlFADXeN6Wx8bdgo+ZM8qZAM+rdVlHH022ZU
	zd3bSY/OzrIJTkJLjTDj6BTY53/dTN2F+lgOriCL11JphXcw8icOQIes1NYRCZeytVDuEzyLwwYyN
	CUHcDKXCdVINHSU8cu3mQ3kN/bT63bW7/IJ0XzJK2GEwWMYyc0Z4mmrcjvpIJ7eLkWhFmEqo5NIJJ
	687AvelxyBjMaXUEOy/x4sDWwJgENYV0EM4gp1eTkY88brI5rBGfqtvpu6IrnUXmT0FUHYsFvnPCV
	Unx3MU/wtXcX876zbvQxZS7opeKIigVVqQPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vx2Ld-00AlE0-10;
	Mon, 02 Mar 2026 20:26:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 02 Mar 2026 21:26:05 +0900
Date: Mon, 2 Mar 2026 21:26:05 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@microsoft.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
Message-ID: <aaWB3RkW4AeJ-c9z@gondor.apana.org.au>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>

On Sun, Mar 01, 2026 at 02:41:28PM -0600, Joachim Vandersmissen wrote:
>
> However, Cryptographic Module Validation Program has also recently made it
> clear that xxhash64 cannot be FIPS approved the way it is currently
> implemented in the kernel. Even though the designers of xxhash publicly
> state that it is a non-cryptographic hash, the kernel offers it as part of
> the shash interface, the same interface as the approved algorithms. The
> interface / API also has "crypto" in the name, which according to CMVP
> implies security. CMVP feels that there could be confusion with the approved
> hash algorithms, so there needs to be some indication that xxhash64 is not
> FIPS approved. I think blocking xxhash64 in FIPS mode would break btrfs,
> where it is used for checksumming.

xxhash64 should be converted to lib/crypto and removed from the
Crypto API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
