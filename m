Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E3EEB3;
	Fri, 21 Mar 2025 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555138; cv=none; b=P+NO1P3vMHMsEAEiI2g1ZNcALZVIbkVrJ+o1NN3sX068WJCPZVdngm9hKjo8zeAM0ZVlQw/vszhYCmu/UpsY43DSdPR07FSFVr2YjyfvagHyomOwLJojwSszheS6X28JBGA3c2d+vgTqQ9UIm3ud0dJP+g1DHYbTwjHLl1yx3fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555138; c=relaxed/simple;
	bh=B4IzFYj788tU7aJFc3RiDB0Q4xbYY17WUUF0Lub25L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=palRdk9KP/wWd/w7gBRV2Fx2GMZMnBFNSZbxW8HogQUzjvjOjAewrVVvdqOSBr4PDA1onUVz0oooDWCkSY62XOeiyDrq/DG0et8pKSFh5BdMFdA4hBHIspaKFW6E8ClvTfZ2lYw0ETlcuDG55ZsLgT2bSttmYfCmn0V8xMpCa18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=a+LqpFZq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="a+LqpFZq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SVnbEUv45EGKp5GEwds5oMcm/dliN8kRkMXwmns82v8=; b=a+LqpFZqXExI6tCRc0I+T69kVy
	1W/SAMZ5YnZWHEgr4FatGlbEoyVoNb2oWORAlQ0+iaze+G3jNwhK7Volde9pNgwrS0WiT+TMR5fiF
	hqpQVYZoljjNaITg4Rm9Ym3kj8rQzDldcdKFl3dxeVO/4vjPzCEyuvEW2qV/I3XZc6zNlFKCTXb9B
	QIQ/Y8mYZ9fIPWEZHGllFTXfdPWJ+Ts7ReyX0dQUviovqFpkeUt+L/m0vDd0O3rRkoXrvhxASfoEC
	OMDYFfCRawkPd+SLDn+96c97e+BkHp5xSdlpXFyRI+w3z03J6eSZ4UmlkLmk0oV4nw84Ee2c2wG14
	Zc2GxeiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaBs-0090DE-06;
	Fri, 21 Mar 2025 19:05:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:05:28 +0800
Date: Fri, 21 Mar 2025 19:05:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Akhil R <akhilrajeev@nvidia.com>, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] crypto: tegra - Fix format specifier in
 tegra_sha_prep_cmd()
Message-ID: <Z91H-DiWq15lozQj@gondor.apana.org.au>
References: <20250313-crypto-tegra-fix-format-specifier-for-size_t-v1-1-0b957726c9e5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313-crypto-tegra-fix-format-specifier-for-size_t-v1-1-0b957726c9e5@kernel.org>

On Thu, Mar 13, 2025 at 04:29:31PM +0100, Nathan Chancellor wrote:
> When building for 32-bit targets, for which ssize_t is 'int' instead of
> 'long', there is a warning due to an incorrect format specifier:
> 
>   In file included from include/linux/printk.h:610,
>                    from include/linux/kernel.h:31,
>                    from include/linux/clk.h:13,
>                    from drivers/crypto/tegra/tegra-se-hash.c:7:
>   drivers/crypto/tegra/tegra-se-hash.c: In function 'tegra_sha_prep_cmd':
>   drivers/crypto/tegra/tegra-se-hash.c:343:26: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'ssize_t' {aka 'int'} [-Werror=format=]
>     343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   ...
>   drivers/crypto/tegra/tegra-se-hash.c:343:59: note: format string is defined here
>     343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
>         |                                                         ~~^
>         |                                                           |
>         |                                                           long unsigned int
>         |                                                         %u
>   cc1: all warnings being treated as errors
> 
> Use '%zd', the proper specifier for ssize_t, to resolve the warning.
> 
> Fixes: ff4b7df0b511 ("crypto: tegra - Fix HASH intermediate result handling")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/crypto/tegra/tegra-se-hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
