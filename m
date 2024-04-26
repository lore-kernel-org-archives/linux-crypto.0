Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC61113DB90;
	Fri, 26 Apr 2024 09:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123969; cv=none; b=e31F8v32WSyk4iROFDBCDK+hvJ2c+d0agORYoQ95IEMp8m12gaTifTKgBDC0k98rAFqgRq2Xd/0vsciK83etjIBZNUXe8kxwd4T62Y14loesVKJlL051lu6Zx0AdifFaXxChpWlzET1Yt8v4M43WRAb8X7hoyW7/lzLgEFWqads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123969; c=relaxed/simple;
	bh=R6A1kwxDS7Gj46FdqR10ssFG+tuR5RWyKtng5Ej0Ors=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pq+Wz8Y0EQLF7sQ1mTs3h9Arave3z4U+ElHWB/jWntOF1yemJOVtL/xIQFyIHvXj2oZfJ6Bmyw+WTycVo2HzuK++uleqgmFeE4bh7gMsIaCQZdVMD89S9T81ppBEgu3EJv5+S8qzu0uoNPimI62a+o04XB4vN0iMWlpdklUrG1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0Hwe-006eQ0-O7; Fri, 26 Apr 2024 17:32:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:32:58 +0800
Date: Fri, 26 Apr 2024 17:32:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: tegra - Fix some error codes
Message-ID: <Zit0yiDp1ECQODNA@gondor.apana.org.au>
References: <ec425896-49eb-4099-9898-ac9509f6ab8f@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec425896-49eb-4099-9898-ac9509f6ab8f@moroto.mountain>

On Wed, Apr 17, 2024 at 09:12:32PM +0300, Dan Carpenter wrote:
> Return negative -ENOMEM, instead of positive ENOMEM.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
