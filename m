Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FC6C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 03:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296182376F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 03:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgLQDzC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 22:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgLQDzB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 22:55:01 -0500
Date:   Wed, 16 Dec 2020 19:54:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608177260;
        bh=1O3+t+XhP6op9L25LamvDqxeBTZ3JIMb0o2j1ie7P3s=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/WW+BLH4OwB0bUELDV1QMDxxL5Lx1mu/EIf37/GcG12HXa6T93ZNN2L7Y8sfxYgO
         3YemQZ58uJc2g7UroqzYaEyGfeR9L2eSMHLMg4swo2ZQumoJ7J7UrZPqdjwdZaqbYJ
         kUAv62phC/Kwlv3yPJu0Vnd8GWDEW4KYza4ipvWwRG35AMW6VyVyWvrSMF9mMA+/YR
         TTBAxeOo9VEOSGfuwRyFoJTIn4Vrrxk3uWyP337lLms8d+87bMOgubej54kBGk7zvn
         x7BKOzu4xPgqXkZIqi4wm8bL0j/PzuMOfguAFgbn8Uy2qNYqgTRU5mS/ay321oMdMH
         xZw9Cs2hbusuw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 0/5] crypto: add NEON-optimized BLAKE2b
Message-ID: <X9rWatnoHtF/7gBU@sol.localdomain>
References: <20201215234708.105527-1-ebiggers@kernel.org>
 <X9pyfAaw5hQ6ngTI@gmail.com>
 <CAHmME9qj+D8opq6pnoMd4vsOsTYaL9Ntxk0HvskAiPvXFev75A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qj+D8opq6pnoMd4vsOsTYaL9Ntxk0HvskAiPvXFev75A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 16, 2020 at 11:32:44PM +0100, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> On Wed, Dec 16, 2020 at 9:48 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > By the way, if people are interested in having my ARM scalar implementation of
> > BLAKE2s in the kernel too, I can send a patchset for that too.  It just ended up
> > being slower than BLAKE2b and SHA-1, so it wasn't as good for the use case
> > mentioned above.  If it were to be added as "blake2s-256-arm", we'd have:
> 
> I'd certainly be interested in this. Any rough idea how it performs
> for pretty small messages compared to the generic implementation?
> 100-140 byte ranges? Is the speedup about the same as for longer
> messages because this doesn't parallelize across multiple blocks?
> 

It does one block at a time, and there isn't much overhead, so yes the speedup
on short messages should be about the same as on long messages.

I did a couple quick userspace benchmarks and got (still on Cortex-A7):

	100-byte messages:
		BLAKE2s ARM:     28.9 cpb
		BLAKE2s generic: 42.4 cpb

	140-byte messages:
		BLAKE2s ARM:     29.5 cpb
		BLAKE2s generic: 44.0 cpb

The results in the kernel may differ a bit, but probably not by much.

- Eric
