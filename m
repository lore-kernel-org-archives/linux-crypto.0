Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BFF39EF14;
	Fri,  3 Jul 2026 09:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070064; cv=none; b=b8iaKf5BrEoziiHSrR9ZlfLXCIG1zzTqf4+6XCoJU+kvkqkK+cWsSvhEQvudb55oLM7xywy8DNZVwiLJHbIIbAAmDySAaLGt0PryFtLzXXN5lDIxQoQlDaQ5dlDG7fr6ftg1vIxin/66ET7uCl5CjGMCexS+nj7BsGQpOktY2Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070064; c=relaxed/simple;
	bh=snJnQRCS8zndlVCIy6gOADlDKzUX7TpWbgDclpBA7Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxJKS6IB32MVwN179Xx+ZPzH7fPc+USrQYVsoIRNB8DYl6iNnSlAXmD2vPo/W2tp2E+DdzY+oxFZPVQ1YyD9ZkLoHR7vupC43VzUGCNO4YQoVlF3+xMnNS5WIj1xqZk4Kq0kK2GDPF3UNLhEel5zqb7IKEwz4lkgbyGFSekYT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mC4mOf3b; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mC4mOf3b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=30V3ZanzmhKn8hhEzaFNiZTTwqLHoZJTyhnXu7/fmZo=; 
	b=mC4mOf3boBc1L+0HJ8WwbxM/wNZh9DhvqLd+jKxCRhODgK23Iiatt0afvUlVjopQ8EBA7emzCFg
	elmwpsy0f0k//IeW+PE8dUgGP31IYTTzqTM5hbjS2Fas8a79qK1OVJoE93RkvgFOwxUrcuaXLoMEx
	I4HzlycLHFouqtZ91jKsdk76CDuDaAfyZJtLY+sRRqLyphSEfPA+4qWfUEVc8ruR98GQOXn2LVUOa
	VtnhWTJWVWSyCUSjRJ7e54f7mJA0KgRYmJSOh9udvIdCMzGY1UMnb6rGJaA1KsxrPKdocyVC4XbRe
	lCEdsBL1pqXGAqvvlD4TRuqiIYyyY36mMZKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wfZyT-0000000AK0c-2u2k;
	Fri, 03 Jul 2026 17:14:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2026 17:14:17 +0800
Date: Fri, 3 Jul 2026 17:14:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: depopulate job rings on populate failure
Message-ID: <akd9affKSWuznl0U@gondor.apana.org.au>
References: <20260616005239.6655-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616005239.6655-1-pengpeng@iscas.ac.cn>

On Tue, Jun 16, 2026 at 08:52:39AM +0800, Pengpeng Hou wrote:
> devm_of_platform_populate() only registers its automatic cleanup action
> after child population succeeds.  If CAAM job-ring population fails after
> creating some job-ring devices, the probe error path reports the error
> but leaves the partial children registered.
> 
> Explicitly depopulate the job-ring children on the populate failure path.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/crypto/caam/ctrl.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 320be5d77737..716c57b9f89b 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -1150,8 +1150,10 @@ static int caam_probe(struct platform_device *pdev)
>  		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
>  
>  	ret = devm_of_platform_populate(dev);
> -	if (ret)
> +	if (ret) {
>  		dev_err(dev, "JR platform devices creation error\n");
> +		of_platform_depopulate(dev);
> +	}

This seems counter-intuitive.  Why is this necessary and if it is,
why isn't this just a bug in devm_of_platform_populate?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
