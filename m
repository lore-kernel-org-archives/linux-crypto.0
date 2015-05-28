From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 10/10] crypto: aesni - Convert rfc4106 to new AEAD
 interface
Date: Thu, 28 May 2015 14:23:33 -0700
Message-ID: <1432848213.15761.13.camel@schen9-desk2.jf.intel.com>
References: <20150528140311.GA8423@gondor.apana.org.au>
	 <E1YxyQL-0002Ha-OL@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbbE1VXf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 17:23:35 -0400
In-Reply-To: <E1YxyQL-0002Ha-OL@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-05-28 at 22:04 +0800, Herbert Xu wrote:

> @@ -1011,55 +966,55 @@ static int __driver_rfc4106_encrypt(struct aead_request *req)
>  		*(iv+4+i) = req->iv[i];
>  	*((__be32 *)(iv+12)) = counter;
>  
> -	if ((sg_is_last(req->src)) && (sg_is_last(req->assoc))) {
> +	if (sg_is_last(req->src) &&
> +	    req->src->offset + req->src->length <= PAGE_SIZE &&
> +	    sg_is_last(req->dst) &&
> +	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
>  		one_entry_in_sg = 1;
>  		scatterwalk_start(&src_sg_walk, req->src);
> -		scatterwalk_start(&assoc_sg_walk, req->assoc);
> -		src = scatterwalk_map(&src_sg_walk);
> -		assoc = scatterwalk_map(&assoc_sg_walk);
> +		assoc = scatterwalk_map(&src_sg_walk);
> +		src = assoc + req->assoclen;
>  		dst = src;
>  		if (unlikely(req->src != req->dst)) {
>  			scatterwalk_start(&dst_sg_walk, req->dst);
> -			dst = scatterwalk_map(&dst_sg_walk);
> +			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;

Herbert,

Quick question.  When src and dst are different, the above code 
leave space for the assoc data in dst.  However, I don't think we copy
over the assoc data from src to dst.
I assume we don't have to do that, right?  If so, we have not
initialized assoc in dst.  This won't be a problem, will it?

Tim
