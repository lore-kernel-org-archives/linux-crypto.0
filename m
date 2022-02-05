Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E558C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 03:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379279AbiBEDvC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 22:51:02 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33928 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbiBEDvA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 22:51:00 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGC64-0001eW-Hc; Sat, 05 Feb 2022 14:50:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 14:50:48 +1100
Date:   Sat, 5 Feb 2022 14:50:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 0/7] Common entropy source and DRNG management
Message-ID: <Yf30GEJi/61RNq8A@gondor.apana.org.au>
References: <2486550.t9SDvczpPo@positron.chronox.de>
 <YfHP3xs6f68wR/Z/@sol.localdomain>
 <9785493.cvP5XnM2Xn@tauon.chronox.de>
 <YfQ7FDJqb2zhVcfp@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfQ7FDJqb2zhVcfp@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 28, 2022 at 10:51:00AM -0800, Eric Biggers wrote:
>
> > The extraction of the entropy source and DRNG management into its own 
> > component separates out the security sensitive implementation currently found 
> > in multiple locations following the strategy found in the crypto API where 
> > each moving part is separated and encapsulated.
> > 
> > The current implementation of the ESDM allows an easy addition of new entropy 
> > sources which are properly encapsulated in self-contained code allowing self-
> > contained entropy analyses to be performed for each. These entropy sources 
> > would provide their seed data completely separate from other entropy sources 
> > to the DRNG preventing any mutual entanglement and thus challenges in the 
> > entropy assessment. I have additional entropy sources already available that I 
> > would like to contribute at a later stage. These entropy sources can be 
> > enabled, disabled or its entropy rate set as needed by vendors depending on 
> > their entropy source analysis. Proper default values would be used for the 
> > common case where a vendor does not want to perform its own analysis or a 
> > distro which want to provide a common kernel binary for many users.
> 
> What is the actual point of this?  The NIST DRBGs are already seeded from
> random.c, which is sufficient by itself but doesn't play well with
> certifications, and from Jitterentropy which the certification side is happy
> with.  And the NIST DRBGs are only present for certification purposes anyway;
> all real users use random.c instead.  So what problem still needs to be solved?

Indeed.  Stephan, could you please explain exactly what additional
seeding sources are needed over the current jitter+/dev/random sources
(and why).  Or even better, add those seeding sources that we must have
in your patch series so that they can be evaluated together.

As it stands this patch series seems to be adding a lot of code without
any uses.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
