From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: aead: driver side documentation
Date: Fri, 15 Apr 2011 16:46:07 +0800
Message-ID: <20110415084607.GA1622@gondor.apana.org.au>
References: <20110405192129.d2778dec.kim.phillips@freescale.com> <20110408005533.GA14581@gondor.apana.org.au> <20110408154401.4cbb989b.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: phil@nwl.cc, linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33290 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1DOIqQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2011 04:46:16 -0400
Content-Disposition: inline
In-Reply-To: <20110408154401.4cbb989b.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 08, 2011 at 03:44:01PM -0500, Kim Phillips wrote:
> the following conditions in a driver setkey fail:
> 
>         if (!RTA_OK(rta, keylen))
>                 goto badkey;
> 
>         if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
>                 goto badkey;
> 
> because testmgr keys are plain strings, not rtattr structs.

There is no reason why an authenc test vector can't use an rtattr.
The key value is a char *, so you can point it to a struct quite
easily.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
