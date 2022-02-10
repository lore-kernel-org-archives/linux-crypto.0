Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51135C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 15:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiBJPc5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:32:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240898AbiBJPc4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 10:32:56 -0500
X-Greylist: delayed 163 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 07:32:57 PST
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E021D6
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 07:32:56 -0800 (PST)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 21AFU4EH013043
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 10:30:05 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8F9D815C0040; Thu, 10 Feb 2022 10:30:04 -0500 (EST)
Date:   Thu, 10 Feb 2022 10:30:04 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] random: Add a pseudorandom generator based on the
 xtea cipher
Message-ID: <YgUvfN1Kch1jD5Ik@mit.edu>
References: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:38:28PM +0800, Sandy Harris wrote:
> Add a pseudorandom generator based on the xtea cipher
> 
> This will be used only within the kernel, mainly within the driver
> to rekey chacha or dump extra random data into the input pool.
> 
> It needs a 64-bit output to match arch_get_random_long(), and
> the obvious way to get that is a 64-bit block cipher.

I'm not convinced the proposed use case is worth the complexity it
adds.  Our current use for arch_get_random_[seed_] is to add extra
hardware-generated random which is cheap (compared to using external
sources such as virtio_rng or a USB attached hardware number
generator).  If it doesn't exist, we fall back to using the CPU cycle
counter (if present) because it's cheap.  But if none of this exists,
the source of entropy used to reseed the CRNG or the timing data into
input pool is supposed to be sufficient.  So RDSEED, RDLONG, or the
TSC (using the x86 facilities for example) are a nice-to-have not a necessity.

The TEA code path is not going to be used much on 99% of the systems
out there, and even it is used, on those systems which don't have
RDSEED, RDLONG, etc., there's not going to be anything to initialize
the pseudo-random number generator, so I fear it will be considered
security theatre.  Fundamentally, it's another CRNG that is supposed
to be only used for the kernel, and is it really worth it?

      	   	    		    - Ted
