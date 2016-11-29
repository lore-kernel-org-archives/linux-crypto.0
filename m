From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND] crypto: CTR DRBG - prevent invalid SG mappings
Date: Tue, 29 Nov 2016 16:05:57 +0800
Message-ID: <20161129080556.GA5467@gondor.apana.org.au>
References: <1833318.YYJALW9cvC@positron.chronox.de>
 <2300597.UdE444b3Re@positron.chronox.de>
 <20161128131027.GA2674@gondor.apana.org.au>
 <1506389.b84a3PTDCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46030 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755198AbcK2IGf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 03:06:35 -0500
Content-Disposition: inline
In-Reply-To: <1506389.b84a3PTDCG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 28, 2016 at 02:39:09PM +0100, Stephan Mueller wrote:
>
> @@ -1737,15 +1750,22 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
>  			      u8 *outbuf, u32 outlen)
>  {
>  	struct scatterlist sg_in;
> +	bool virt_addr_valid = virt_addr_valid(outbuf);
> +	int ret = 0;
>  
>  	sg_init_one(&sg_in, inbuf, inlen);
>  
>  	while (outlen) {
>  		u32 cryptlen = min_t(u32, inlen, outlen);
>  		struct scatterlist sg_out;
> -		int ret;
>  
> -		sg_init_one(&sg_out, outbuf, cryptlen);
> +		/* If output buffer is not valid for SGL, use scratchpad */
> +		if (virt_addr_valid)
> +			sg_init_one(&sg_out, outbuf, cryptlen);
> +		else {
> +			cryptlen = min_t(u32, cryptlen, DRBG_OUTSCRATCHLEN);
> +			sg_init_one(&sg_out, drbg->outscratchpad, cryptlen);
> +		}

I'm sorry but this is just way too ugly.  Please use the scratchpad
unconditionally.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
