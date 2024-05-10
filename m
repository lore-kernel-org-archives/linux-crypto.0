Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A3679945;
	Fri, 10 May 2024 09:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715332700; cv=none; b=oMPg6/b0q/WrPdP/SaTq9dCiIfiJGQ/ZQIBAAN5O2foJ0VTUG9483qXp83iGzbfoS8w4SfQ7P5lYYIl5Sk//mAc4GGAWiA26g5bZGCC3J26aGbMe0nPB3G+WsVwhXKte4SjL5qH+DPwLiE8EUzfLZMvOc3YccqzVbvhQP13F1U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715332700; c=relaxed/simple;
	bh=E6Ay7Fs1hTsSl0DvT8d82qvURwi2t3B7eqBbVBHr9pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X39yqD1FzIk4bcDfRcs40PhvbN19HVVPaLxdNwDrjinOSfS6Zh2RvyE9BIMWsqQ00jJvjSm1YFFjdOs0o2Cl5eTix+yaen/ovaNmR8DfSFA8kridVh7l1/833sDHg5C/t7OsYGIImXGYec+u4PSkLtbI+J2Cn00Ma7Cu0bUCPj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5MOF-00DK86-1G;
	Fri, 10 May 2024 17:18:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 17:18:08 +0800
Date: Fri, 10 May 2024 17:18:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/4] crypto: starfive - Minor fixes for AES and RSA
Message-ID: <Zj3mUIispwCN_Az_@gondor.apana.org.au>
References: <20240429060640.2451685-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429060640.2451685-1-jiajie.ho@starfivetech.com>

On Mon, Apr 29, 2024 at 02:06:36PM +0800, Jia Jie Ho wrote:
> This patch series fix a bug caused by freeing a stack buffer in RSA
> module and skip some unneeded steps in StarFive crypto driver.
> 
> Jia Jie Ho (4):
>   crypto: starfive - Skip dma setup for zeroed message
>   crypto: starfive: Skip unneeded fallback allocation
>   crypto: starfive: Do not free stack buffer
>   crypto: starfive: Use fallback for unaligned dma access
> 
>  drivers/crypto/starfive/jh7110-aes.c | 16 +++++++++++-----
>  drivers/crypto/starfive/jh7110-rsa.c | 11 ++++-------
>  2 files changed, 15 insertions(+), 12 deletions(-)
> 
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
