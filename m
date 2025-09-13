Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EBC1F4701;
	Sat, 13 Sep 2025 04:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737660; cv=none; b=SQyVqQQUT5SSPGdjfKIEzjZ+pXk+L4BbtRRf1UCt2GDYbsmvsZgdpqXEpZuPOY4mqP9L5K2icawZYPHDnFeD1GuoupkSyuAwj1uOCCYci+KqzJ0N0WbpXtKWbvZatv4Ti8WVLJTYB4fTyoZpoLOdnRHXJ5I8uKqVJX6GurgHSXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737660; c=relaxed/simple;
	bh=UELnH33wB1e47n7521mUtkAHbBE64gz1SiS+UKk6AJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sI5KrG0sQ+QNH8p+cAI4wZW9Bly38QfAiseoFoGoiGFLNSHr0XbpoSKcc+tyv8rjyGONMMUPEYccuaXM5bjtIeaug+yy3/Ip+LhuQaYSzU70z4vcuQSV8dQEaMXhWq6iJvfeHMdzYQBCY4bbFjUqjZM6v5C1xnyqFeBcindkx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nbggkaAE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nbggkaAE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iSVkUnsuLm8K/odNf3C0EF9KilrIxZZwbyFVZ8ag+TQ=; b=nbggkaAEeK/crB5jJOp+6hKwr1
	CTq8FlvJ2oUMaJ09AM7IqYIxDDNkZSDhffwVxTZ4Pb1oQrdTi1sObuu8Gl7BaQtWA2sU2LlfuiVZU
	1cyikuomn9KUOtlBIPbt4vMmMVcLwZctZ2PUXDL3bzsYhVwvnlToAENOoWxa1+jmpsrs2WzVeGukh
	ExZV6nULo+Kt0LhbWPriTdRCSsbsX55aCe1RcbQn4pIRBJKrQqavKBtm12fxridCBAbBSjNykobKQ
	YgGFBjj/z7B1zCWio4OAIYVrQjkilKy/JT0Jm6avtgE+Qzsj6KX5conCj+dgy+K7MrS5jX7LF6drJ
	0hX31bJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHbk-0053sY-2P;
	Sat, 13 Sep 2025 12:27:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:27:25 +0800
Date: Sat, 13 Sep 2025 12:27:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	"open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:TEGRA ARCHITECTURE SUPPORT" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] crypto: Use int type to store negative error codes
Message-ID: <aMTyraqo3GukxpnO@gondor.apana.org.au>
References: <20250903132539.416439-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903132539.416439-1-rongqianfeng@vivo.com>

On Wed, Sep 03, 2025 at 09:25:34PM +0800, Qianfeng Rong wrote:
> The 'ret' variable usually is used to store returns from some functions,
> which return either zero on success or negative error codes on failure.
> 
> Storing the negative error codes in unsigned type, doesn't cause an issue
> at runtime but can be confusing.  Additionally, assigning negative error
> codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
> flag is enabled.
> 
> Change 'ret' from u32/unsigned int to int type.  No effect on runtime.
> 
> Qianfeng Rong (3):
>   crypto: ccp - Use int type to store negative error codes
>   crypto: hisilicon/sec - Use int type to store negative error codes
>   crypto: tegra - Use int type to store negative error codes
> 
>  drivers/crypto/ccp/sev-dev.c           | 3 ++-
>  drivers/crypto/hisilicon/sec/sec_drv.c | 3 ++-
>  drivers/crypto/tegra/tegra-se-hash.c   | 3 ++-
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
