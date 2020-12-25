Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F781C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Dec 2020 19:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55B222252
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Dec 2020 19:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgLYTPS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Dec 2020 14:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgLYTPR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Dec 2020 14:15:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C56E22203;
        Fri, 25 Dec 2020 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608923677;
        bh=QDqTtLgpDD7RDx1IC6Hh4p9gjvbSZQEsiOQofhn+YaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOMEgVuFI5hxwo+ioQIQrtmIMUkjxLj6Jgk/M9PEYgO1MAEUF95Mc2qUe+/RAkFPw
         wy6zcIA3bZ1oiqsq2mWVBaAsNBd2Z+h2CLiJhWJBI70uTkg+fJy4Cd5lYI2bDh1wxB
         4WhkwCQKYODn5tqCn/U9LPkMDPtJuqEz8LBS2pVflb0Rv9UneTKdQmmaR9KmsJwXpZ
         HdrtFlxqrOUWTv/Fv9Y25GNupIUV92T499GrOddCYiSp0/gar5dmZgjszz1fZNT7wF
         ywOquqBx38kkvTFmtDdM1GwU/P3ZrAEmWMzPChGv3SqmedUQ9YHvQEq1+rb8KGmHSj
         +Tvwydin+f26Q==
Date:   Fri, 25 Dec 2020 11:14:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: x86/aes-ni-xts - recover and improve
 performance
Message-ID: <X+Y6G0pHja1C61s9@sol.localdomain>
References: <20201222160629.22268-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222160629.22268-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 22, 2020 at 05:06:27PM +0100, Ard Biesheuvel wrote:
> The AES-NI implementation of XTS was impacted significantly by the retpoline
> changes, which is due to the fact that both its asm helper and the chaining
> mode glue library use indirect calls for processing small quantitities of
> data
> 
> So let's fix this, by:
> - creating a minimal, backportable fix that recovers most of the performance,
>   by reducing the number of indirect calls substantially;
> - for future releases, rewrite the XTS implementation completely, and replace
>   the glue helper with a core asm routine that is more flexible, making the C
>   code wrapper much more straight-forward.
> 
> This results in a substantial performance improvement: around ~2x for 1k and
> 4k blocks, and more than 3x for ~1k blocks that require ciphertext stealing
> (benchmarked using tcrypt using 1420 byte blocks - full results below)
> 
> It also allows us to enable the same driver for i386.
> 
> Cc: Megha Dey <megha.dey@intel.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (2):
>   crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>   crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper
> 
>  arch/x86/crypto/aesni-intel_asm.S  | 353 ++++++++++++++++----
>  arch/x86/crypto/aesni-intel_glue.c | 230 +++++++------
>  2 files changed, 412 insertions(+), 171 deletions(-)
> 
> -- 
> 2.17.1
> 
> Benchmarked using tcrypt on a Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.

Thanks for doing this!  I didn't realize that there was such a big performance
regression here.  Getting rid of these indirect calls looks like the right
approach; this all seems to have been written for a world where indirect calls
are much faster...

I did some quick benchmarks on Zen ("AMD Ryzen Threadripper 1950X 16-Core
Processor") with CONFIG_RETPOLINE=y and confirmed the speedup on 4096-byte
blocks is around 2x there too.  (It's over 2x for AES-128-XTS and AES-192-XTS,
and a bit under 2x for AES-256-XTS.  And most of the speedup comes from the
first patch.)  Also, the extra self-tests are passing.

So feel free to add:

	Tested-by: Eric Biggers <ebiggers@google.com> # x86_64

Note that this patch series didn't apply cleanly, as it seems to depend on some
other patches you've sent out recently.  So I actually tested your
"for-kernelci" branch instead of applying these directly.

- Eric
