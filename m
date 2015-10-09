From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 4/5] crypto: marvell: fix wrong hash results
Date: Fri, 9 Oct 2015 21:51:58 +0200
Message-ID: <20151009215158.2e6f0560@bbrezillon>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
	<E1Zkda0-0005In-UI@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38033 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbbJITwB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:52:01 -0400
In-Reply-To: <E1Zkda0-0005In-UI@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 09 Oct 2015 20:43:48 +0100
Russell King <rmk+kernel@arm.linux.org.uk> wrote:

> Attempting to use the sha1 digest for openssh via openssl reveals that
> the result from the hash is wrong: this happens when we export the
> state from one socket and import it into another via calling accept().
> 
> The reason for this is because the operation is reset to "initial block"
> state, whereas we may be past the first fragment of data to be hashed.
> 
> Arrange for the operation code to avoid the initialisation of the state,
> thereby preserving the imported state.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Thanks!

> ---
>  drivers/crypto/marvell/hash.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 458867ce9515..b7c2c05f1a01 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -835,6 +835,11 @@ static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
>  	if (ret)
>  		return ret;
>  
> +	if (in_state->byte_count >= sizeof(in_state->block))
> +		mv_cesa_update_op_cfg(&creq->op_tmpl,
> +				      CESA_SA_DESC_CFG_MID_FRAG,
> +				      CESA_SA_DESC_CFG_FRAG_MSK);
> +
>  	creq->len = in_state->byte_count;
>  	memcpy(creq->state, in_state->hash, digsize);
>  	creq->cache_ptr = 0;
> @@ -929,6 +934,11 @@ static int mv_cesa_sha1_import(struct ahash_request *req, const void *in)
>  	if (ret)
>  		return ret;
>  
> +	if (in_state->count >= SHA1_BLOCK_SIZE)
> +		mv_cesa_update_op_cfg(&creq->op_tmpl,
> +				      CESA_SA_DESC_CFG_MID_FRAG,
> +				      CESA_SA_DESC_CFG_FRAG_MSK);
> +
>  	creq->len = in_state->count;
>  	memcpy(creq->state, in_state->state, digsize);
>  	creq->cache_ptr = 0;
> @@ -1034,6 +1044,11 @@ static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
>  	if (ret)
>  		return ret;
>  
> +	if (in_state->count >= SHA256_BLOCK_SIZE)
> +		mv_cesa_update_op_cfg(&creq->op_tmpl,
> +				      CESA_SA_DESC_CFG_MID_FRAG,
> +				      CESA_SA_DESC_CFG_FRAG_MSK);
> +
>  	creq->len = in_state->count;
>  	memcpy(creq->state, in_state->state, digsize);
>  	creq->cache_ptr = 0;



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
