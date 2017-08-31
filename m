From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: MPI - kunmap after finishing accessing buffer
Date: Thu, 31 Aug 2017 22:37:28 +0800
Message-ID: <20170831143728.GD31769@gondor.apana.org.au>
References: <3348160.hjCpAHFZrS@positron.chronox.de>
 <20170822063315.GA5344@gondor.apana.org.au>
 <4313498.Aq9EThrF88@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37590 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdHaOhn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 10:37:43 -0400
Content-Disposition: inline
In-Reply-To: <4313498.Aq9EThrF88@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 30, 2017 at 06:33:41PM +0200, Stephan Mueller wrote:
> Am Dienstag, 22. August 2017, 08:33:15 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Thu, Aug 10, 2017 at 08:06:18AM +0200, Stephan Müller wrote:
> > > Hi Herbert,
> > > 
> > > I found that issue while playing around with edge conditions in my
> > > algif_akcipher implementation. This issue only manifests in a
> > > segmentation violation on 32 bit machines and with an SGL where each
> > > SG points to one byte. SGLs with larger buffers seem to be not
> > > affected by this issue.
> > > 
> > > Yet this access-after-unmap should be a candidate for stable, IMHO.
> > 
> > Good catch.  Thanks!
> > 
> > Fixes: 4816c9406430 ("lib/mpi: Fix SG miter leak")
> > Cc: <stable@vger.kernel.org>
> 
> Just to confirm: stable is not CCed in this email -- did you send it 
> separately to stable? (dto for "[PATCH v4] crypto: only call put_page on 
> referenced and used pages")

The cc is meant to go into the commit and when the commit hits
mainline it'll automatically get picked up by stable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
