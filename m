Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462DF3A1D0C;
	Mon, 10 Aug 2026 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349718; cv=none; b=udiKE2F5oQbzFfmXgx+TdqW9TD/i+RX/m8asjKmvYm43VHJmqE+LmNJZ6LJh4VgdwxIrIL60dOgQV+GZFiWUYcWZ6QIDOAhuPPmYOhD4Gv2wydZNaVK9HTX0mIhEWbY115R2l6LTuXPqr0RUCtiAsY59+uHam/tfdh5pbeVBUrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349718; c=relaxed/simple;
	bh=Jo9JoEttSI05kzEFTrr+sl23lNNQD3jZAwbd9f+c1cM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X43W9ThDmTFMAXrFyhFdnZqhx3HUs/3NTigeOJRSCsIUQdFvaUnQyzk3iMg6NFMsj0VWc6LjPKtgF1Oy8vFOLKsWtvzdHOV67xSnmpfpggjPk22aHS3KBzq3KHlJ35jQa71T1yED/RMTCmuDT9KLlhW14gxITQTSGrw92TThUaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=s+mQ1Uz9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="s+mQ1Uz9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VNIoZfVWESI2bPCASpoykEbx0LEfjHjuUlUPX6VaO0Y=; 
	b=s+mQ1Uz9fI+KU2d0ln701ckk9OV4hRrKRvnBN6+voduFoOwiQZZ9XadU1PRoInWcgzL6105ecGD
	zZHuOPs+An98EdNXhtIjPboS7TDNTiGtpEyYhDlCiP9qIOpN4BNT3fH/YhjJU+Dx0EFt1KCb0RruK
	R/DXDcHOmtnZ9WrTmOLnfFJlbF1jDMAV5PFlPo2WEN7PevLL/EUKSVd/Zd54VklZySM9+foJuOn6N
	QY3OmrPVphZ84QPG+eQfEBkefiKgDmVTpJpEoNWronTCzMZiT1VItK8RZx2CHRTB1/fMUA3kHX7ni
	ElZ66R5Yq0y4xwVe5W11Ixmc16p3imAlci0Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLA2-00000003WQ8-1uBX;
	Mon, 10 Aug 2026 16:15:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:15:06 +1000
Date: Mon, 10 Aug 2026 18:15:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc - fix missing DMA memory barriers in
 descriptor handling
Message-ID: <anmIiof2gsFT_LV0@gondor.apana.org.au>
References: <20260731212040.22764-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731212040.22764-1-rosenp@gmail.com>

On Fri, Jul 31, 2026 at 02:20:40PM -0700, Rosen Penev wrote:
>
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index 0271b5e4d923..851bf075d769 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -876,11 +876,13 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
>  		}
>  	}
>  
> +	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
> +	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
> +
> +	dma_wmb();

Please always add an accompanying comment explaining exactly which
two writes are being ordered.

>  	pd->pd_ctl.w = PD_CTL_HOST_READY |
>  		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>  			PD_CTL_HASH_FINAL : 0);
> -	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
> -	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
>  
>  	wmb();
>  	/* write any value to push engine to read a pd */
> @@ -1031,6 +1033,7 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
>  		     ((READ_ONCE(pd->pd_ctl.w) &
>  		       (PD_CTL_PE_DONE | PD_CTL_HOST_READY)) ==
>  		       PD_CTL_PE_DONE)) {
> +			dma_rmb();

Ditto.  Please add a comment explaining which two reads are being ordered.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
