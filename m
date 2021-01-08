Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0223FC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 04:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD96B22AAF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 04:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbhAHEnA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:43:00 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40328 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbhAHEm7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 23:42:59 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kxjbK-0006jX-2S; Fri, 08 Jan 2021 15:42:15 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Jan 2021 15:42:13 +1100
Date:   Fri, 8 Jan 2021 15:42:13 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: Re: [PATCH v2 0/2] crypto: x86/aes-ni-xts - recover and improve
 performance
Message-ID: <20210108044213.GC12339@gondor.apana.org.au>
References: <20201231164155.21792-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231164155.21792-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 05:41:53PM +0100, Ard Biesheuvel wrote:
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
> Changes since v1:
> - use 'test LEN, LEN' instead of 'cmp $0, LEN' to get shorter opcodes, as
>   suggested by Uros
> - rebase to get rid of false dependencies on other changes that are in flight.
> 
> NOTE: patch #2 depends on [0], which provides the permutation table used for
>       ciphertext stealing
> 
> [0] https://lore.kernel.org/linux-crypto/20201207233402.17472-1-ardb@kernel.org/
> 
> Cc: Megha Dey <megha.dey@intel.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Uros Bizjak <ubizjak@gmail.com>
> 
> Ard Biesheuvel (2):
>   crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>   crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper
> 
>  arch/x86/crypto/aesni-intel_asm.S  | 353 ++++++++++++++++----
>  arch/x86/crypto/aesni-intel_glue.c | 229 +++++++------
>  crypto/Kconfig                     |   1 -
>  3 files changed, 411 insertions(+), 172 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
