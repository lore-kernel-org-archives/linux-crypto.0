From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] crypto: powerpc - Fix initialisation of crc32c context
Date: Mon, 06 Mar 2017 15:43:31 +1100
Message-ID: <87tw77ow0c.fsf@concordia.ellerman.id.au>
References: <20170303065655.7317-1-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: anton@samba.org, Daniel Axtens <dja@axtens.net>
To: Daniel Axtens <dja@axtens.net>, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:39371 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752792AbdCFEng (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2017 23:43:36 -0500
In-Reply-To: <20170303065655.7317-1-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Daniel Axtens <dja@axtens.net> writes:

> Turning on crypto self-tests on a POWER8 shows:
>
>     alg: hash: Test 1 failed for crc32c-vpmsum
>     00000000: ff ff ff ff
>
> Comparing the code with the Intel CRC32c implementation on which
> ours is based shows that we are doing an init with 0, not ~0
> as CRC32c requires.
>
> This probably wasn't caught because btrfs does its own weird
> open-coded initialisation.
>
> Initialise our internal context to ~0 on init.
>
> This makes the self-tests pass, and btrfs continues to work.
>
> Fixes: 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
> Cc: Anton Blanchard <anton@samba.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
>  arch/powerpc/crypto/crc32c-vpmsum_glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This driver was originally merged via the crypto tree, so I'll assume
Herbert will pick up the fix. If he hasn't in a few days I'll take it.

cheers
