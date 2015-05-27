From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/11] crypto: scatterwalk - Add missing sg_init_table to scatterwalk_ffwd
Date: Wed, 27 May 2015 11:00:55 +0200
Message-ID: <8805468.lNrScoBP33@tauon>
References: <20150527063539.GA25889@gondor.apana.org.au> <E1YxUxz-0006lD-TG@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58324 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbbE0JBC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:01:02 -0400
In-Reply-To: <E1YxUxz-0006lD-TG@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Mai 2015, 14:37:27 schrieb Herbert Xu:

Hi Herbert,

>We need to call sg_init_table as otherwise the first entry may
>inadvertently become the last.
>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Although the following remark is to the previous patch to add 
scatterwalk_ffwd, I would like to ask it here:
>---
>
> crypto/scatterwalk.c |    1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
>index 8690324..2ef9cbb 100644
>--- a/crypto/scatterwalk.c
>+++ b/crypto/scatterwalk.c
>@@ -158,6 +158,7 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist
>dst[2],
>		src = sg_next(src);

Shouldn't there be a check for src == NULL here? I see the scatterwalk_ffwd 
being used in the IV generators where they simply use the AD len and others. 
For AF_ALG, those values may be set by user space in a deliberately wrong way 
(e.g. more AD len than provided buffers).


Ciao
Stephan
