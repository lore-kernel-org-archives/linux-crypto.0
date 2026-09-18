Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D1749739A;
	Fri, 18 Sep 2026 08:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721401; cv=none; b=r/WYbmGDJwHzohiPNPh7VcsY1P6DSEy8+kSt+1AwRQS6cXcatvPJ8GzWbFsQHNRc2Q+u2bfWDbgtz6EARgJinUJCIfpa0lSKOv3fjRxqJnBbZ1RjDdTv0kp/gEkItGAalGS26/Ia8rJlsFBlhOel44aBfK6D5YCmDXBdeKPhCgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721401; c=relaxed/simple;
	bh=OK3fZ1EKDVrW2H8mnAsaC2ga1lNTc1Y+TwoGIQTwKOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOAyZNFXbx/xZLc3X0Zhyc/EO2MJbfxyep/WsBh6+h/RFt3Rdk8qgT2Un98fJv+k4vQuSwp6KOND3lKAxzaTai51ZwCFOr3WEJZvtfh8ve1SSRakOtplL9VPkCowgQD5rsAN1IhFkUOXOnoaVo408mSLia9bsNdcDniKsYIldwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FgwDp0cW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FgwDp0cW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=twAcShB0ssfs1STehyRnA9ISuo+8g0bLFk7z/G9GBis=; 
	b=FgwDp0cW89Dfxl/09R0OvotqVI9eKoM/AU05+pnySYHq0DdRSwx7BgJb9oYvM1sjcrLZXAsU3Yi
	zhOHnnPayETJ0gvSpAN2JfdefllUS+Eo32Z64ytExCUCP/caB6vcZcTAnuwq4/EKBWVDeGg3+jWFo
	9NH17PhDOE8ZIMtwcIfvgq2agyOAsWqSGniKCGguBXW6jIemx11Rp/IepNi4MRnrTTzWl9vI81A/m
	5fSt2SpwogiyT4MDOq7K189Zs+oUt2fkctpjTb50ahl/swRiD9G1UGQaWppsAahom7JQwfWMp8sQd
	bw3beXSi6reswYs1aCDxBGh2xg3qpX0XUXSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UHs-0000000FKcI-2vnV;
	Fri, 18 Sep 2026 16:49:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 18:49:40 +1000
Date: Fri, 18 Sep 2026 18:49:40 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dmitriy Okunev <dokunevdmitriy@gmail.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, lvc-project@linuxtesting.org,
	Declan Murphy <declan.murphy@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay-ocs: prevent underflow in sg_data_total
 - remainder
Message-ID: <aqz7JHL40gvHh7jP@gondor.apana.org.au>
References: <20260908143447.2155188-1-dokunevdmitriy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908143447.2155188-1-dokunevdmitriy@gmail.com>

On Tue, Sep 08, 2026 at 05:34:47PM +0300, Dmitriy Okunev wrote:
> In the kmb_ocs_dma_prepare() function, the `remainder` is calculated
> as `total % blk_sz`, where `total = sg_data_total + buf_cnt`. In
> update requests, if `buf_cnt` is large and `total` is less than
> `rctx->blk_sz`, the `remainder` may exceed `sg_data_total`, which
> will lead to an overflow of `sg_data_total - remainder`. This results
> in an incorrect large value being passed to the `sg_nents_for_len()`
> function, which can lead to memory corruption.
> 
> Add a check to return -EINVAL if `sg_data_total < remainder`,
> so that the subtraction is always safe.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
> Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> index 9a67bb4ecc82..92f2d9ff6f83 100644
> --- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> +++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> @@ -246,8 +246,11 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
>  	 * HCU must be aligned to the block size; compute the remainder data to
>  	 * be processed in the next request.
>  	 */
> -	if (!(rctx->flags & REQ_FINAL))
> +	if (!(rctx->flags & REQ_FINAL)) {
>  		remainder = total % rctx->blk_sz;
> +		if (rctx->sg_data_total < remainder)
> +			return -EINVAL;
> +	}

This driver buffers data less than block size, so how can it get
here with sg_data_total less than block size?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
