From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Thu, 22 Sep 2016 17:22:44 +0800
Message-ID: <20160922092244.GA5379@gondor.apana.org.au>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
 <20160920092618.GA20808@gondor.apana.org.au>
 <20160920115140.GA12332@sivswdev01.ir.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56633 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755220AbcIVJXs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 05:23:48 -0400
Content-Disposition: inline
In-Reply-To: <20160920115140.GA12332@sivswdev01.ir.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 20, 2016 at 12:51:40PM +0100, Giovanni Cabiddu wrote:
> Hi Herbert,
> 
> On Tue, Sep 20, 2016 at 05:26:18PM +0800, Herbert Xu wrote:
> > Rather than duplicating the scratch buffer handling in every scomp
> > algorithm, let's centralize this and put it into scomp.c.
> Are you suggesting to hide the scratch buffers from the scomp implementations 
> and allocate them inside crypto_register_scomp?

I'm suggesting that we have just one set of buffers for all scomp
algorithms.  After all, a CPU can only process one request at a
time.

> Does that mean we have to go back to a scomp_alg with a flat buffer API
> and linearize inside scomp?

Yes scomp should just be flat.  A sync algorithm capable of producing
partial output should use the acomp interface.

> If we take this direction, how do we support DMA from scomp implementation?
> Scratch buffers are allocated using vmalloc.

Huh? If you're doing DMA then you'd be using the acomp interface,
how can you even get into scomp?

I think you may have misread my earlier message from June.  What
I'd like to see is for the acomp layer to allocate the output
memory, rather than have it provided by the user as is the case
with the current interface.  The user could provide a maximum to
prevent crazy cases consuming unlimited memory.

What will happen with scomp is that it will simply use a linear
vmalloc buffer to store the output before copying it into an SG
list of individual pages allocated on the spot.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
