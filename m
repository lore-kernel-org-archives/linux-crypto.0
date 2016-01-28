From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Thu, 28 Jan 2016 08:00:25 -0800
Message-ID: <56AA3B19.8080604@intel.com>
References: <20160127221031.12534.13202.stgit@tstruk-mobl1>
 <76537095.pjn76bZGgL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbcA1QET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jan 2016 11:04:19 -0500
In-Reply-To: <76537095.pjn76bZGgL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 01/27/2016 10:26 PM, Stephan Mueller wrote:
>> +	for (i = 0; i < areq->tsgls; i++)
>> > +		put_page(sg_page(sg + i));
> Shouldn't here be the same logic as in put_sgl? I.e.
> 
>         for (i = 0; i < sgl->cur; i++) {
>                 if (!sg_page(sg + i))
>                         continue;
> 
>                 put_page(sg_page(sg + i));
>                 sg_assign_page(sg + i, NULL);
>         }
> 

Thanks for reviewing.
I don't think it is possible that there ever will be any gaps in the tsgl.
In fact if there is such a possibility then it is a serious problem, because
it would mean that we are sending NULL ptrs to the ciphers (see line 640):

	sg_mark_end(sgl->sg + sgl->cur - 1);
	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx->first_rsgl.sgl.sg,
			       used, ctx->iv);

I don't see any implementation checking for null in sgls. Most of them just do:

	for_each_sg(sgl, sg, nents, i)
		sg_virt(sg)...

So it would Oops there. I think this check in put_sgl is redundant.
Thanks,
-- 
TS
