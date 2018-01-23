From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH] crypto: chelsio - Delete stray tabs in
 create_authenc_wr()
Date: Tue, 23 Jan 2018 09:28:05 +0530
Message-ID: <6eeb22ce-6423-81df-f86c-dae26e864b7a@chelsio.com>
References: <20180122102140.GA23912@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:20177 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeAWEB1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 23:01:27 -0500
In-Reply-To: <20180122102140.GA23912@mwanda>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 22-01-2018 15:51, Dan Carpenter wrote:
> We removed some if statements but left these statements indented too
> far.
HI Dan,

Change already applied to cryptodev tree.

https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30560.html

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index a9c894bf9c01..34a02d690548 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -2112,11 +2112,11 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
>  	error = chcr_aead_common_init(req, op_type);
>  	if (error)
>  		return ERR_PTR(error);
> -		dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
> -		dnents += sg_nents_xlen(req->dst, req->cryptlen +
> -			(op_type ? -authsize : authsize), CHCR_DST_SG_SIZE,
> -			req->assoclen);
> -		dnents += MIN_AUTH_SG; // For IV
> +	dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
> +	dnents += sg_nents_xlen(req->dst, req->cryptlen +
> +		(op_type ? -authsize : authsize), CHCR_DST_SG_SIZE,
> +		req->assoclen);
> +	dnents += MIN_AUTH_SG; // For IV
>  
>  	dst_size = get_space_for_phys_dsgl(dnents);
>  	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
