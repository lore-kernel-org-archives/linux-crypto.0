From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/10] crypto mv_cesa : Invoke the user callback from a
	softirq context
Date: Fri, 19 Mar 2010 14:04:49 +0800
Message-ID: <20100319060449.GA22474@gondor.apana.org.au>
References: <4B9F98DF.9010705@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Uri Simchoni <uri@jdland.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34374 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119Ab0CSGEw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:52 -0400
Content-Disposition: inline
In-Reply-To: <4B9F98DF.9010705@jdland.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 16, 2010 at 04:42:39PM +0200, Uri Simchoni wrote:
> Invoke the user callback from a softirq context
>
> Signed-off-by: Uri Simchoni <uri@jdland.co.il>
> ---
> diff -upr linux-2.6.32.8_orig/drivers/crypto/mv_cesa.c  
> linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c
> --- linux-2.6.32.8_orig/drivers/crypto/mv_cesa.c    2010-02-09  
> 14:57:19.000000000 +0200
> +++ linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c    2010-03-16  
> 08:59:12.074583163 +0200
> @@ -275,7 +275,9 @@ static void dequeue_complete_req(void)
>          sg_miter_stop(&cpg->p.dst_sg_it);
>          mv_crypto_algo_completion();
>          cpg->eng_st = ENGINE_IDLE;
> +        local_bh_disable();
>          req->base.complete(&req->base, 0);
> +        local_bh_enable();
>      }
>  }

Your patches are all space damaged and cannot be applied until
that is fixed.

Please always check your patches by trying to apply the copy
you receive via the list.  If that doesn't work, then you need
to figure out why.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
