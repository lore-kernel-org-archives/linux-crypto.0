From: Dave Watson <davejwatson@fb.com>
Subject: Re: [PATCH] crypto: aesni-intel - RFC4106 can zero copy when
 !PageHighMem
Date: Tue, 13 Dec 2016 11:07:32 -0800
Message-ID: <20161213190732.GB68289@davejwatson-mba.local>
References: <1481639526-71743-1-git-send-email-ilyal@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-crypto@vger.kernel.org>, <tadeusz.struk@intel.com>,
        <herbert@gondor.apana.org.au>, <tls-fpga-sw-dev@mellanox.com>
To: Ilya Lesokhin <ilyal@mellanox.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37159 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753120AbcLMTH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 14:07:58 -0500
Content-Disposition: inline
In-Reply-To: <1481639526-71743-1-git-send-email-ilyal@mellanox.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/13/16 04:32 PM, Ilya Lesokhin wrote:
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -903,9 +903,11 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
>  	*((__be32 *)(iv+12)) = counter;
>  
>  	if (sg_is_last(req->src) &&
> -	    req->src->offset + req->src->length <= PAGE_SIZE &&
> +	    (!PageHighMem(sg_page(req->src)) ||
> +	    req->src->offset + req->src->length <= PAGE_SIZE) &&
>  	    sg_is_last(req->dst) &&
> -	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
> +	    (!PageHighMem(sg_page(req->dst)) ||
> +	    req->dst->offset + req->dst->length <= PAGE_SIZE)) {
>  		one_entry_in_sg = 1;
>  		scatterwalk_start(&src_sg_walk, req->src);
>  		assoc = scatterwalk_map(&src_sg_walk);

I was also experimenting with a similar patch that loosened up the
restrictions here, checking for highmem.  Note that you can go even
further and check the AAD, data, and TAG all separately, the current
aesni crypto routines take them as separate buffers.  (This might fix
the RFC5288 patch AAD size issue?)

Long term it would be nice to improve the asm routines instead to
support scatter / gather IO and any AAD len, as the newer intel
routines do:

https://github.com/01org/isa-l_crypto/tree/master/aes
