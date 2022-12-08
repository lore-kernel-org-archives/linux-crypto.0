Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB750C3A5A7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Dec 2022 04:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLHETC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 23:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLHETB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 23:19:01 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48F06A779;
        Wed,  7 Dec 2022 20:18:53 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p38Mn-005E22-UN; Thu, 08 Dec 2022 12:18:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Dec 2022 12:18:37 +0800
Date:   Thu, 8 Dec 2022 12:18:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     "Jason A. Donenfeld" <zx2c4@kernel.org>,
        oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: lib/crypto/blake2s-selftest.c:632:1: warning: the frame size of
 1120 bytes is larger than 1024 bytes
Message-ID: <Y5Flnb8jadyDebx3@gondor.apana.org.au>
References: <202211072109.qvrnjNKo-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211072109.qvrnjNKo-lkp@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 07, 2022 at 09:18:05PM +0800, kernel test robot wrote:
> Hi Jason,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   f0c4d9fc9cc9462659728d168387191387e903cc
> commit: 2d16803c562ecc644803d42ba98a8e0aef9c014e crypto: blake2s - remove shash module
> date:   5 months ago
> config: i386-buildonly-randconfig-r006-20221107
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2d16803c562ecc644803d42ba98a8e0aef9c014e
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout 2d16803c562ecc644803d42ba98a8e0aef9c014e

This was fixed months ago with

commit d6c14da474bf260d73953fbf7992c98d9112aec7
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Mon Jun 20 09:52:43 2022 +0200

    crypto: lib/blake2s - reduce stack frame usage in self test

Why is LKP still testing the old commit?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
