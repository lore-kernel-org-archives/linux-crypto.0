Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88897283FEF;
	Fri, 26 Sep 2025 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758874701; cv=none; b=WvRTTQZB51eZEZRq2jHj2cteIs3zGculIPKcVVeSDTQ5z8LB8ynjHjT+SHDuMQRuu8A3QFtP0IBiTKVmyiU45qw/2QlHqBNvOBsUas9+dZm7aCIBIxOc/fINQ0TLhQPkInDNE2wMrTcSaE8f86Un55WcaxhpPQbq9C4JG+fBeUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758874701; c=relaxed/simple;
	bh=Xzm8T0bRW6q4AqDEvNaK0inUym9e7MVN9JxLC4RTnW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRanLGnEgmVkHdP8lRTkKhNJzO2iwXxSQrNCug2MUmZ8nx09+g+1hvWnEGc8aj1ipW/OswQAvaSg0XPungxiWIeARJi6KL/CcVollICvwIiVlUH3gpQnnB1HIz+WVLn04xxhYKo+SfsYCYbaDnjtmdzzXVoCVtNoqiE/FneI11I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NpXX9Lbm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NpXX9Lbm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=1KdawEbxh8nTznkFv3CxiwTcE4T4DRA48BqbQCeDtLw=; b=NpXX9LbmhPLHH8O8SQhR2fEev8
	akRNIlc8c/bA5uU5PlKZSftXpABDi5vd9lf9dzyMjB3cEr+lPqBIuFuGaQyiBsH+fuQnWkZUmOI2G
	ZSeCLEbYaTaioT2BF2uC+acNy+cDz/FbugPQGu1aDNpXdRC1W17yKthwIJLM9gbxVfKkM/FNwap1g
	mrYObvFNnWXZm/ek5W+p2NLu9rNCLavKqWybAGZBBKsfreRR+oLvuijx7Hg8orXB3cFrtCtOjAaaK
	x6/eCiIz/O/V+ZJDz2RGtcXjb1V1YZEcUahi+DmVOAPWxcv3qtRIdo+2C2KnOQL6LqEp49dNWObUD
	MptZA+ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v23eS-008SQJ-0H;
	Fri, 26 Sep 2025 16:18:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Sep 2025 16:18:00 +0800
Date: Fri, 26 Sep 2025 16:18:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	smueller@chronox.de, vegard.nossum@oracle.com
Subject: Re: [PATCH] crypto: pcrypt - Fix recursive instantiation by using
 proper instance naming
Message-ID: <aNZMOL-58r0NEteg@gondor.apana.org.au>
References: <20250925223125.515570-1-saeed.mirzamohammadi@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925223125.515570-1-saeed.mirzamohammadi@oracle.com>

On Thu, Sep 25, 2025 at 03:31:24PM -0700, Saeed Mirzamohammadi wrote:
> The pcrypt template recursively instantiates itself because it copies
> the child algorithm's cra_name directly, causing naming collisions with
> the larval instance. When aead_register_instance() fails with -EEXIST,
> the larval wait mechanism re-runs the lookup and finds the pcrypt instance
> instead of the real child algorithm, leading to pcrypt(pcrypt(...))
> recursion.
> 
> Fix by using crypto_inst_setname() instead of memcpy, ensuring pcrypt
> instances are named "pcrypt(<child>)" rather than reusing the child's name.
> This eliminates the naming collision that triggers the re-lookup mechanism.
> 
> Also apply the same fix to cryptd for consistency, even though it doesn't
> exhibit the same recursion issue.
> 
> To reproduce:
> python -c "import socket; socket.socket(socket.AF_ALG,
> socket.SOCK_SEQPACKET, 0).bind(('aead', 'pcrypt(ccm(aes))'))"
> ...
> OSError: [Errno 36] File name too long
> 
> Before the patch (/proc/crypto):
> name  : ccm(aes)
> driver: pcrypt(pcrypt(...(pcrypt(ccm_base(ctr-aes-aesni,cbcmac(aes-aesni))))...))
> [and 9 other ccm(aes) instances.]
> 
> After the patch (/proc/crypto):
> name  : pcrypt(ccm(aes))
> driver: pcrypt(ccm_base(ctr-aes-aesni,cbcmac(aes-aesni)))
> 
> Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
> Fixes: 4e0958d19bd8 ("crypto: cryptd - Add support for skcipher")
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Closes: https://lore.kernel.org/linux-crypto/4c0e7a68-254e-4f71-a903-952415c609d9@oracle.com
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> ---
>  crypto/cryptd.c | 9 ++++-----
>  crypto/pcrypt.c | 8 ++++----
>  2 files changed, 8 insertions(+), 9 deletions(-)

The algorithm name must stay the same because the whole point of
pcrypt (and cryptd) is to wrap around the underlying algorithm
without turning it into a new algorithm.

The problem here is that the Crypto API only supports two types
of names, algorithm names and driver names.  Your python code
was using a mixture of the two, which creates a name that can
never be fulfilled by the Crypto API.  If you substituted the
name pcrypt(ccm(aes)) with pcrypt(ccm_base(ctr-aes-aesni,cbcmac(aes-aesni)))
then it should work.

Ideally we should support such mixed names so I'm happy to consider
any patches implementing that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
