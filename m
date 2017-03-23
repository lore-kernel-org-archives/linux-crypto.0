From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Thu, 23 Mar 2017 09:23:07 +0100
Message-ID: <20170323082307.GB16625@Red>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
 <CANc+2y5gv2ygSM4HF69XCW7Bb8UUHN+qJKq0os-mOvYknH+SeQ@mail.gmail.com>
 <20170320132858.GA27044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33054 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754124AbdCWIXV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 04:23:21 -0400
Received: by mail-wm0-f53.google.com with SMTP id v203so438969wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Mar 2017 01:23:15 -0700 (PDT)
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
> 

Problem with this conversion, a huge regression for user space.
Using hwrng is simple as cat /dev/hwrng.
Using algif_rng via AF_ALG is ... unusable for the moment.
Perhaps creating an user space tool (prng-tool which provide a cat /dev/hwrng replacement) is mandatory before any convertion.

Regards
