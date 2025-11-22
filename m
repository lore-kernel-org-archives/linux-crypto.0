Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4B81DF271;
	Sat, 22 Nov 2025 02:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763779547; cv=none; b=oKI0s3R5AcyVOn2htoHG5DWz8j5vfp+7Ers98HymnJkMv70cG8tP8Bw4VmwFazFLOb0On5ybUKXMAl6phX8l8hBhdLRkKRYa77HCaZ19S2StA3//qz6bfvcjLXE+4DeVRdwa2FjrchPBO2tmdGHUmGimIu0b/zQt6fJIPLY38rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763779547; c=relaxed/simple;
	bh=LuGxQpXcBhsf4NVIKp9TL1wkUYYN3z2hQlu8iJlZhLg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=rzO3KyrSI1hBfGL5pOaDwKtlI+G/Ca10XM8v7jRkflIEKvS48Gvdd3pHXlqYddQSDM+x0KFU9+e7gGAyCU3ia/SKmEF3/q5S7n5ZmYPzEoWu6uMK2Gktoam1KXAR6aqpwaBT1ZIa7Xhxq7F7JC4m/1wthcIGe1fDpl2TMHUfgBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RdwRd7Cs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RdwRd7Cs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=+viVTxmcZ+kLMEaiIjkiqfJKt1+mr8d8jqecmDG2r9k=; b=RdwRd7CsZUHfJeo87UJfCXLJvb
	rgmkSocyuop0IDHDhHSrvWtrR8u3L2ZyyWFWDLbDjAiRNCYplfDy5YbM6PENsAtUY6hv5GQ8nJZV9
	z72amMRkr7zTxZkznTOrg/WgyELpL7Skm1VYXwveGh/uivtnvQRI0VlJ/RjdzICtvOsXDh0iyQf6V
	pNAEQhhhu/Js1Nsf3FgU/9t5Y0GvVwh4+Y11S9ZC6ku33g6mZEdsnPeGTPDK09C39ohzzN1KKVTYo
	I6gec4bGSeKSsVhcKnGh/aUrOAIFsCGO898M8+XJ39j10xpHzoK5wxVBSBjoqnUyLwv4naWlycTnN
	/gxN9rOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMdd2-0056GK-3B;
	Sat, 22 Nov 2025 10:45:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 10:45:36 +0800
Date: Sat, 22 Nov 2025 10:45:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: torvalds@linux-foundation.org, ebiggers@kernel.org, ardb@kernel.org,
	kees@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <aSEj0GvbFjwlDbVM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120011022.1558674-2-Jason@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> +/*
> + * This designates the minimum number of elements a passed array parameter must
> + * have. For example:
> + *
> + *     void some_function(u8 param[at_least 7]);
> + * 
> + * If a caller passes an array with fewer than 7 elements, the compiler will
> + * emit a warning.
> + */
> +#define at_least static

Please make this conditional on __CHECKER__ as sparse still chokes
on the following which compiles fine with gcc and clang:

int foo(int n, int a[static n])
{
	return a[0]++;
}

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
