From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: virtio:rng: Virtio RNG devices need to be re-registered after
 suspend/resume
Date: Tue, 7 Nov 2017 11:36:44 +0800
Message-ID: <20171107033643.GA19846@gondor.apana.org.au>
References: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
 <20171106070928.GF14274@gondor.apana.org.au>
 <CANc+2y7JzcobX7wj236SD4FcimWkqBnprY1Ew7FUprOijn8U-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Quigley <Jim.Quigley@oracle.com>,
        Matt Mackall <mpm@selenic.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53892 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933031AbdKGDhW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 22:37:22 -0500
Content-Disposition: inline
In-Reply-To: <CANc+2y7JzcobX7wj236SD4FcimWkqBnprY1Ew7FUprOijn8U-w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 07, 2017 at 08:44:17AM +0530, PrasannaKumar Muralidharan wrote:
> Hi Herbert,
> 
> On 6 November 2017 at 12:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Fri, Nov 03, 2017 at 09:57:21AM +0000, Jim Quigley wrote:
> >> moved the call to hwrng_register() out of the probe routine into the scan
> >> routine. We need to call hwrng_register() after a suspend/restore cycle
> >> to re-register the device, but the scan function is not invoked for the
> >> restore. Add the call to hwrng_register() to virtio_restore().
> >
> > Patch applied.  Thanks.
> 
> My rb tag is missing in the commit.

That's because you didn't start it on a new line.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
