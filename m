Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481EEC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 15:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243748AbiBJPm4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:42:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243705AbiBJPmw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 10:42:52 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5386AFA
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 07:42:53 -0800 (PST)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 21AFgkja020323
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 10:42:47 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6BC5E15C0040; Thu, 10 Feb 2022 10:42:46 -0500 (EST)
Date:   Thu, 10 Feb 2022 10:42:46 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/4] random: get_source_long() function
Message-ID: <YgUydpc+ftvl7Y6+@mit.edu>
References: <CACXcFm=whnpd3v5gJAoTJ-pL27NOOkMKvD3W_RQXy1kj2B6p=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=whnpd3v5gJAoTJ-pL27NOOkMKvD3W_RQXy1kj2B6p=g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:41:53PM +0800, Sandy Harris wrote:
> +/**************************************************************************
> + * Load a 64-bit word with data from whatever source we have
> + *
> + *       arch_get_random_long()
> + *       hardware RNG
> + *       emulated HWRNG in a VM
> + *
> + * When there are two sources, alternate.
> + * If you have no better source, or if one fails,
> + * fall back to get_xtea_long()

This isn't quite right.  First of all arch_get_random is as much a
hardware RNG as a arch_get_random_seed.  So trying to distinguish the
two here is confusing and blurs what is going on.

Secondly, arch_get_random_seed, on those platforms that have it, is
strictly better than arch_get_random.  It takes more CPU cycles, and
has different security properties[1], but there's no good reason to
add complexity to alternate between the two.   

[1] "RDSEED is intended for seeding a software PRNG of arbitrary
    width. RDRAND is intended for applications that merely require
    high-quality random numbers." --- Intel documentation

Finally, arch_get_random_seed and arch_get_random work in VM's, so
talking about "emulating HWRNG in a VM" doesn't make any sense.  And
as I've mentioned in my comment on the previous patch, using a CRNG to
help seed a CRNG doesn't make any sense, and isn't worth the extra
complexity.

Also, note that as the code is currently situated there isn't any
extra "work" if CONFIG_ARCH_RANDOM is disabled.  That's because
config_get_random_seed and friends are inline functions, and if it is
disabled, it will return false unconditionally, and the compiler will
optimize away the call.  Also, note that on CPU architectures which
have CPU instructions ala RDREAD and RDSEED, it's rarely disabled
since it's on by default and to disable it you need to be in
CONFIG_EXPERT mode.

Cheers,

					- Ted
