Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA71EFFA7;
	Fri, 21 Mar 2025 11:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555161; cv=none; b=bnjfgoiIcdoS9HJhowS4w7hVjR7ek4m/GgeARDsqw5JDteEY1AB/jsP8vRzDMieCa8Q1/21vKSZjd54A49tBEJszPPWIhsogxb6OdUe1raNjvSP0ndTXasWnabwR5rBpnm0O6lh8dQZtzHReLWgDNaP3qlwWCywwqezlqY++Ci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555161; c=relaxed/simple;
	bh=xRLqHhWbNuG5IhyGQKgEDIc+2UgujdPr4j682Mmsg5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+hh4+mdAYmwC73TFaKoGIAMSQ3xQoIYhivW+EUKjy2l4gzQAqKm8L5nK4RSbjHVN3dReS3ul7z5JTUthfVnJmjxiGOrO+wtYQlWpLWfYC//oTCxYa/6U316DRYBWal54a0U7H50dYt4cLyu9ukaJs+0d2z9SNRtJi1jf50H3eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b8M6lK95; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b8M6lK95"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1F9WGvTQK6WV1C3GwKW0y31cLCZnLWHSsvw77eUqVxw=; b=b8M6lK95rucNzuK9Z99Q2eIbmG
	iDSxCz+Jx6zCqd8GZknOy8T0F1ZVoO7jnquSgIFeEkS3pWZK89aJKZuo4kdVyFu9xdnk88t+Ye3SQ
	3ep5CRdPxQgdZNaU2FWw4NLrECpqZuQq5ZP5DX0ebnUytcl3MW6u44ruRIPSLKnKwIO7f8HYjY18v
	K9SOSIXg4JR/2bH/SLjjeKytSk+ROz3H/+EvEl7Jgji+gd2ttIJWNW4zWoC180L9nHf6CIwfAaJXJ
	RbxXPyGS6LvXZNkjikX1Z4IkLH0kUD41XUZBkARlydvn5gf/CKX2AKOL/WD5fQCuXT4BQJkdhnFAN
	Au7/8SvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaC8-0090DL-0n;
	Fri, 21 Mar 2025 19:05:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:05:44 +0800
Date: Fri, 21 Mar 2025 19:05:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>, Chen Ridong <chenridong@huawei.com>,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tegra: fix size_t format string
Message-ID: <Z91ICAzFbHIzLjhA@gondor.apana.org.au>
References: <20250314160006.346042-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314160006.346042-1-arnd@kernel.org>

On Fri, Mar 14, 2025 at 04:59:59PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Printing size_t as %lu causes a warning when it is defined as 'unsigned int':
> 
> drivers/crypto/tegra/tegra-se-hash.c:344:22: error: format specifies type 'unsigned long' but the argument has type 'ssize_t' (aka 'int') [-Werror,-Wformat]
>   343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
>       |                                                         ~~~
>       |                                                         %zd
> 
> Use %zu as the proper format string.
> 
> Fixes: ff4b7df0b511 ("crypto: tegra - Fix HASH intermediate result handling")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/tegra/tegra-se-hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

A similar patch has already been applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
