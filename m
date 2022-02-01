Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BD7C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 16:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbiBAQD2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 11:03:28 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53020 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S240788AbiBAQD2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 11:03:28 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 211G3FRg023102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 1 Feb 2022 11:03:15 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 351DA15C0040; Tue,  1 Feb 2022 11:03:15 -0500 (EST)
Date:   Tue, 1 Feb 2022 11:03:15 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        m@ib.tc, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] random.c Remove locking in extract_buf()
Message-ID: <YflZw7B1F41KpJ0K@mit.edu>
References: <CACXcFmnPumpkfLLzzjqkBmxwtpMa0izNj3LOtf2ycTugAKAUwQ@mail.gmail.com>
 <CAHmME9pUW1o_QPfs45Q0JWucA5Qu1jhgMV7x2PycxosYV2wV7A@mail.gmail.com>
 <CACXcFmk049OXc16ynjHBa+OSEOMYB=nYE1MDM_oM=Maf8bfcEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmk049OXc16ynjHBa+OSEOMYB=nYE1MDM_oM=Maf8bfcEA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 01, 2022 at 05:40:11PM +0800, Sandy Harris wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> > Either way, I don't think this is safe to do. We want the feed forward
> > there to totally separate generations of seeds.
> 
> Yes, but the right way to do that is to lock the chacha context
> in the reseed function and call extract_buf() while that lock
> is held. I'll send a patch for that soon.

Extract_buf() is supposed to be able to reliably generate high quality
randomness; that's why we use it for the chacha reseed.  If
extract_buf() can return return the same value for two parallel calls
to extract_buf(), that's a Bad Thing.  For example, suppose there were
two chacha contexts reseeding using extract_buf(), and they were
racing against each other on two different CPU's.  Having two of them
reseed with the same value would be a cryptographic weakness.

NACK to both patches.

       	    	     	   	    - Ted
				    
