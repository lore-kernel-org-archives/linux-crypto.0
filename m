From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: MPI - kunmap after finishing accessing buffer
Date: Wed, 30 Aug 2017 18:33:41 +0200
Message-ID: <4313498.Aq9EThrF88@tauon.chronox.de>
References: <3348160.hjCpAHFZrS@positron.chronox.de> <20170822063315.GA5344@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34518 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750972AbdH3Qdn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2017 12:33:43 -0400
In-Reply-To: <20170822063315.GA5344@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 22. August 2017, 08:33:15 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Aug 10, 2017 at 08:06:18AM +0200, Stephan Müller wrote:
> > Hi Herbert,
> > 
> > I found that issue while playing around with edge conditions in my
> > algif_akcipher implementation. This issue only manifests in a
> > segmentation violation on 32 bit machines and with an SGL where each
> > SG points to one byte. SGLs with larger buffers seem to be not
> > affected by this issue.
> > 
> > Yet this access-after-unmap should be a candidate for stable, IMHO.
> 
> Good catch.  Thanks!
> 
> Fixes: 4816c9406430 ("lib/mpi: Fix SG miter leak")
> Cc: <stable@vger.kernel.org>

Just to confirm: stable is not CCed in this email -- did you send it 
separately to stable? (dto for "[PATCH v4] crypto: only call put_page on 
referenced and used pages")

Thanks a lot
Stephan
