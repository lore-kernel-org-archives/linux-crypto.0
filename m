From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Mon, 20 Mar 2017 20:24:01 +0200
Message-ID: <20170320182401.x2yhl5pcpqihcvj3@kozik-lap>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
 <CANc+2y5gv2ygSM4HF69XCW7Bb8UUHN+qJKq0os-mOvYknH+SeQ@mail.gmail.com>
 <20170320132858.GA27044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34504 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbdCTSYb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2017 14:24:31 -0400
Received: by mail-wr0-f195.google.com with SMTP id u48so19400302wrc.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Mar 2017 11:24:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170320132858.GA27044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 20, 2017 at 09:28:58PM +0800, Herbert Xu wrote:
> On Mon, Mar 20, 2017 at 12:19:32PM +0530, PrasannaKumar Muralidharan wrote:
> >
> > AF_ALG interface for rng does have seeding support. I think hw_random
> > does not provide seeding support intentionally as I understand that
> > True RNG need not require seeding (please correct me if I am wrong).
> 
> Yes.  We should be converting PRNGs in hwrng over to algif_rng.

The actual hardware block can be seeded from true RNG (taking data
from thermal noise) so the solutions (if I understand correctly) for
exynos-rng might be:
1. Seed from internal TRNG making it a proper hwrandom device,
2. Convert to AF_ALG and seed with data from user-space through that
   interface.

Thanks for explanation, I'll queue it to my tasks list.

Best regards,
Krzysztof
