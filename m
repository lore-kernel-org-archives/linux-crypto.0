From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 4/7] crypto: marvell: Moving the tdma chain out of
 mv_cesa_tdma_req
Date: Thu, 16 Jun 2016 14:45:10 +0200
Message-ID: <20160616144510.4d1f0f0f@bbrezillon>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
	<1466018134-10779-5-git-send-email-romain.perier@free-electrons.com>
	<20160615224249.3e1e477b@bbrezillon>
	<57629562.9030908@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:45428 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbcFPMpX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 08:45:23 -0400
In-Reply-To: <57629562.9030908@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 16 Jun 2016 14:02:42 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> > Now that the dma specific fields are part of the base request there's no
> > reason to keep this union.
> >
> > You can just put struct mv_cesa_req base; directly under struct
> > mv_cesa_ablkcipher_req, and move mv_cesa_ablkcipher_std_req fields in
> > mv_cesa_ablkcipher_req.  
> 
> 
> Well, I think that I might keep the changes related to mv_cesa_tdma_req 
> in this commit (+ put struct mv_cesa_req base; direct under struct 
> mv_cesa_ablkcipher_req) and move the changes related to 
> mv_cesa_ablkcipher_std_req into another commit. What do you think ?

Sounds good.

> >  
> >>   	struct mv_cesa_ahash_dma_iter iter;
> >>   	struct mv_cesa_op_ctx *op = NULL;
> >>   	unsigned int frag_len;
> >> @@ -662,11 +661,6 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
> >>   	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
> >>   	int ret;
> >>
> >> -	if (cesa_dev->caps->has_tdma)
> >> -		creq->req.base.type = CESA_DMA_REQ;
> >> -	else
> >> -		creq->req.base.type = CESA_STD_REQ;
> >> -  
> >
> > Hm, where is it decided now? I mean, I don't see this test anywhere
> > else in your patch, which means you're now always using standard mode.  
> 
> It has been replaced by mv_cesa_req_get_type() + initializing 
> chain.first to NULL in std_init. So, that's the same thing, no ?

And that's exactly my point :-). When these fields are NULL the request
is a STD request...

> 
> >  
> >>   	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
> >>   	if (creq->src_nents < 0) {
> >>   		dev_err(cesa_dev->dev, "Invalid number of src SG");
> >> @@ -680,7 +674,7 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
> >>   	if (*cached)
> >>   		return 0;
> >>
> >> -	if (creq->req.base.type == CESA_DMA_REQ)
> >> +	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)  

... and here you're testing if it's a DMA request, which will always be
false, since mv_cesa_ahash_dma_req_init() is the function supposed to
fill the ->first and ->last fields.

> >
> > Should be
> >
> > 	if (cesa_dev->caps->has_tdma)
> >  
> >>   		ret = mv_cesa_ahash_dma_req_init(req);  
> 
> Why ? mv_cesa_req_get_type() tests mv_cesa_req->chain and returns a code 
> depending on its value. This value is initialized according to what is 
> set un "has_tdma"...

As explained above, it's not ;).


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
