From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/11] crypto: scatterwalk - Add missing sg_init_table to
 scatterwalk_ffwd
Date: Wed, 27 May 2015 20:01:28 +0800
Message-ID: <20150527120128.GA29323@gondor.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
 <8805468.lNrScoBP33@tauon>
 <20150527090855.GB27692@gondor.apana.org.au>
 <12583562.IssoB2EnSZ@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37299 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbE0MBd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 08:01:33 -0400
Content-Disposition: inline
In-Reply-To: <12583562.IssoB2EnSZ@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 27, 2015 at 01:24:48PM +0200, Stephan Mueller wrote:
> 
> To be precise, the concern I currently have are as follows. But I will test it 
> later and report back:
> 
> The seqiv.c uses the following call:
> 
>                         scatterwalk_ffwd(dstbuf, req->dst,
>                                          req->assoclen + ivsize),
>                         scatterwalk_ffwd(srcbuf, req->src,
>                                          req->assoclen + ivsize),
> 
> That together with my other tests for seqniv(rfc4106()) this indicates that 
> the input SGL must contain AD || IV || PT.

seqniv verifies that the IV is present.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
