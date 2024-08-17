Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D8713213C;
	Sat, 17 Aug 2024 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878556; cv=none; b=ovsGkdnmCa2lQoWT1cYUhSMTtmdX5Rxkj+sisNMx6WOJWe75GXnt9Kvw7X/CziiL9nt/D7tVbdZClXj98YPw59zacBEihdRIGEQgRmD6+muIowexxjVBDCuJh6WpKLyTJq2iu2ijDHC0FwSCDT28rUKEIiJjulqydYggRcoAZGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878556; c=relaxed/simple;
	bh=KiN5at4d3qP18ofT9fzMyx2b3EB1WB3f1W1aAbx/9lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLNhlELxq1MYwm8Pj2DVlM+iTK79zJIWN6mwQtrf0uFihFxq6di4Sad0bV0TPphKWPEKlMcUnT14sU6OeT9CiPlResEQTULkBg8pv+uMkvJUcCefUI2RrSF/rkIY3xr/KLLESs0xf+cySnJSnl5SU3n6Qs8MAdihtK6DmTgNCjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDQA-005ILI-0l;
	Sat, 17 Aug 2024 15:09:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:09:03 +0800
Date: Sat, 17 Aug 2024 15:09:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, jserv@ccns.ncku.edu.tw,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: marvell - Remove custom swap function in
 favor of built-in sort swap
Message-ID: <ZsBMj2x25A3e7alC@gondor.apana.org.au>
References: <20240811062817.210527-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811062817.210527-1-visitorckw@gmail.com>

On Sun, Aug 11, 2024 at 02:28:15PM +0800, Kuan-Wei Chiu wrote:
> The custom swap function used in octeontx/octeontx2 driver do not
> perform any special operations and can be replaced with the built-in
> swap function of sort. This change not only reduces code size but also
> improves efficiency, especially in scenarios where CONFIG_RETPOLINE is
> enabled, as it makes indirect function calls more expensive.
> 
> By using the built-in swap, we avoid these costly indirect function
> calls, leading to better performance.
> 
> Kuan-Wei Chiu (2):
>   crypto: octeontx - Remove custom swap function in favor of built-in
>     sort swap
>   crypto: octeontx2 - Remove custom swap functions in favor of built-in
>     sort swap
> 
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   | 12 ++----------
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 10 +---------
>  2 files changed, 3 insertions(+), 19 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
