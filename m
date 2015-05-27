From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/11] crypto: scatterwalk - Add missing sg_init_table to
 scatterwalk_ffwd
Date: Wed, 27 May 2015 17:08:55 +0800
Message-ID: <20150527090855.GB27692@gondor.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
 <E1YxUxz-0006lD-TG@gondolin.me.apana.org.au>
 <8805468.lNrScoBP33@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44873 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbbE0JI6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:08:58 -0400
Content-Disposition: inline
In-Reply-To: <8805468.lNrScoBP33@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 27, 2015 at 11:00:55AM +0200, Stephan Mueller wrote:
>
> Shouldn't there be a check for src == NULL here? I see the scatterwalk_ffwd 
> being used in the IV generators where they simply use the AD len and others. 
> For AF_ALG, those values may be set by user space in a deliberately wrong way 
> (e.g. more AD len than provided buffers).

algif_aead should be verifying the user provided input.  AFAICS it
is doing exactly that.  The crash we had previously were due to
bugs in my algif_aead patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
