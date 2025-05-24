Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4184315A;
	Sat, 24 May 2025 00:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748046339; cv=none; b=fHDnHDT8uuu3zIzt047iKvHJBXfSy9jo6g4wJxjQVM+dMzWCfWB/96okHVPJkmKMc5ZQpfIl73MZ+kC37XkxThdRWvGnkM2LKPEihrvlbVjijgxmx1Gm96JUtAjw6pozl44jp17B0oDUo6Od7Dn7AKMMhuyG66JwOyFI9YWir5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748046339; c=relaxed/simple;
	bh=qp5bWAI/ApTcI5VWNtOuXcgZRbbelkVMrMhCpyLDIyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFz29axXNAPrO+4St8k70B3BjGYyvJwCKJ3owEqXHwJ0g6aOk1sULoibl8+ILPymNfZ/OA7PswIdn1W0XkFZRZVslN5qil+A4zpqLOvDlGbJ1ZYvfzeM5dSat2gVGLBsb6c7aHF6R/1yBUxdbxiMfbM56ZjPBueKP1uQS8eTBTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O1svsWh9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O1svsWh9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mPhumSAIpNGqxgXHi49XsBBAwTCl//Mu1cy+jljbUnI=; b=O1svsWh9jUs2osvstWTVqF1NFW
	hAPsSO/m7squVj3sBleHgoU06DFp5jRHXs5Sk8d4+t9BFHYR0efp2UMkOr/+rE13fUwL1Axffc+Mp
	AH2qtXbf3AsVcX+Zs7Lr9agoKiJeSSd7ps96c+brZTi9hRuD8UPg13FqMIShtKcVu8NyIGPaEqbrz
	lfp9EdAbbqlWJ8mhy1Yv+S2W3dnl2kWnibGyEjgH7E7JaYIQ7Ne3gL4aHdn2ACz4Jt9Xwgbr3hoSI
	E+2jGxqqNjtYfFHYtZMuM07x0WQj/CAjBnqKxV0aTkWtuZIUAFeNrNLgR0ol/nAMTzIqzz2K8UP98
	McGCeyYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIchN-008SgX-0B;
	Sat, 24 May 2025 08:25:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 May 2025 08:25:13 +0800
Date: Sat, 24 May 2025 08:25:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: qianweili@huawei.com, wangzhou1@hisilicon.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] crypto: hisilicon: use kfree_sensitive() for pool cleanup
Message-ID: <aDER6cD9S5HcbV2W@gondor.apana.org.au>
References: <20250523133057.4025075-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523133057.4025075-1-zilin@seu.edu.cn>

On Fri, May 23, 2025 at 01:30:57PM +0000, Zilin Guan wrote:
> The error path of hisi_acc_create_sgl_pool() already calls
> kfree_sensitive() to wipe sensitive data before freeing the pool.
> However, hisi_acc_free_sgl_pool() currently uses plain kfree(), which
> may leave secrets behind in memory and undo the protection applied
> during creation.
> 
> This patch replaces kfree() with kfree_sensitive() in
> hisi_acc_free_sgl_pool(), ensuring that all SGL pool deallocations
> securely clear their contents.
> 
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>  drivers/crypto/hisilicon/sgl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index c974f95cd126..6a88a2056708 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -151,7 +151,7 @@ void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
>  		dma_free_coherent(dev, block[i].size, block[i].sgl,
>  				  block[i].sgl_dma);
>  
> -	kfree(pool);
> +	kfree_sensitive(pool);
>  }
>  EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);

What's in the pool? If it's just pointers then that is not sensitive
information.

You should only use kfree_sensitive if plaintext or private keys are
present.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
