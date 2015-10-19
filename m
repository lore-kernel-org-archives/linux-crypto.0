From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH 17/18] crypto: marvell: fix first-fragment handling in mv_cesa_ahash_dma_last_req()
Date: Tue, 20 Oct 2015 00:53:39 +0200
Message-ID: <87wpuicvws.fsf@natisbad.org>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
	<E1ZnqlQ-0005Xl-Ie@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:59593 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbJSWxz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 18:53:55 -0400
In-Reply-To: <E1ZnqlQ-0005Xl-Ie@rmk-PC.arm.linux.org.uk> (Russell King's
	message of "Sun, 18 Oct 2015 17:24:52 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russell,

Russell King <rmk+kernel@arm.linux.org.uk> writes:

> When adding the software padding, this must be done using the first/mid
> fragment mode, and any subsequent operation needs to be a mid-fragment.
> Fix this.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/crypto/marvell/hash.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index da541e59cc1d..34271e9eb3a5 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -575,20 +575,12 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
>  		if (IS_ERR(op))
>  			return op;
>  
> -		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
> -				      CESA_SA_DESC_CFG_FRAG_MSK);
> -
>  		if (len == trailerlen)
>  			return op;
>  
>  		padoff += len;
>  	}
>  
> -	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
> -		mv_cesa_update_op_cfg(&creq->op_tmpl,
> -				      CESA_SA_DESC_CFG_MID_FRAG,
> -				      CESA_SA_DESC_CFG_FRAG_MSK);
> -
>  	ret = mv_cesa_dma_add_data_transfer(chain,
>  					    CESA_SA_DATA_SRAM_OFFSET,
>  					    ahashdreq->padding_dma +

I'll consider it's just late here and I need some sleep but I fail to
align the commit message w/ the content of the patch, i.e. it's
unclear to me.

Cheers,

a+
