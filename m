From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/11] crypto: scatterwalk - Add missing sg_init_table to scatterwalk_ffwd
Date: Wed, 27 May 2015 13:24:48 +0200
Message-ID: <12583562.IssoB2EnSZ@tauon>
References: <20150527063539.GA25889@gondor.apana.org.au> <8805468.lNrScoBP33@tauon> <20150527090855.GB27692@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58329 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbE0LYz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 07:24:55 -0400
In-Reply-To: <20150527090855.GB27692@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Mai 2015, 17:08:55 schrieb Herbert Xu:

Hi Herbert,

>On Wed, May 27, 2015 at 11:00:55AM +0200, Stephan Mueller wrote:
>> Shouldn't there be a check for src == NULL here? I see the scatterwalk_ffwd
>> being used in the IV generators where they simply use the AD len and
>> others.
>> For AF_ALG, those values may be set by user space in a deliberately wrong
>> way (e.g. more AD len than provided buffers).
>
>algif_aead should be verifying the user provided input.  AFAICS it
>is doing exactly that.  The crash we had previously were due to
>bugs in my algif_aead patch.

To be precise, the concern I currently have are as follows. But I will test it 
later and report back:

The seqiv.c uses the following call:

                        scatterwalk_ffwd(dstbuf, req->dst,
                                         req->assoclen + ivsize),
                        scatterwalk_ffwd(srcbuf, req->src,
                                         req->assoclen + ivsize),

That together with my other tests for seqniv(rfc4106()) this indicates that 
the input SGL must contain AD || IV || PT.

The algif_aead, however only slurps in AD || PT via the sendmsg call and 
processes that as documented in the recvmsg call. So, the IV part is missing 
in the picture as the IV is set via the setsockopt.

So, the aforementioned call unconditionally advances the SGL by AD + 8 bytes 
where I am not sure that the 8 bytes are always accounted for by algif_aead.


Ciao
Stephan
