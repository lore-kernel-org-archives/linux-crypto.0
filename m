Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C32C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jan 2022 15:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376666AbiATPew (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jan 2022 10:34:52 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33237 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1376742AbiATPes (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jan 2022 10:34:48 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 20KFYX7q023612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 10:34:34 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6A80615C41B6; Thu, 20 Jan 2022 10:34:33 -0500 (EST)
Date:   Thu, 20 Jan 2022 10:34:33 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: random(4) question
Message-ID: <YemBCdWrGeKHWeFN@mit.edu>
References: <CACXcFm=67TU=wy-WdkpiGnSm2M-E5__z=ACTzCmOkiGijrWNOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=67TU=wy-WdkpiGnSm2M-E5__z=ACTzCmOkiGijrWNOg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 20, 2022 at 06:39:31PM +0800, Sandy Harris wrote:
> 
> Like the previous version based on SHA1, this produces an output half
> the hash size which is likely a fine idea since we do not want to
> expose the full hash output to an enemy. Unlike the older code,
> though, this does expose some hash output.

Well, as the comment says, we do this because we want to prevent
backtracking attacks --- where the attacker knows the state of the
pool plus the current outputs, and is trying to go back in time to
figure out previous outputs.  Whether we XOR the halves together or
just reveal half the bits, either will achieve this goal.

Note that we're actually no longer directly exposing this output to
the enemy, since extract_buf is now only being use to extract entropy
from the input pool into the CRNG.  And if the attacker can intercept
the values being used to reseed the CRNG, we've got bigger problems.  :-)

Given how extrat_buf is being used today, assuming that we are
confident in the cryptosecurity of the CHACHA20 algorithm, it's
probably a bit of overkill as it is.  However, it's not like this is
on the hot path from a performance perspective, and a bit of
over-engineering is not a bad thing.

Cheers,

					- Ted
