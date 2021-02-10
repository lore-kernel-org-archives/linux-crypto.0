Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC38BC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A609F64E02
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhBJHW7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:22:59 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50190 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhBJHWw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:22:52 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jp5-0001F4-LI; Wed, 10 Feb 2021 18:22:04 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:22:03 +1100
Date:   Wed, 10 Feb 2021 18:22:03 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH 0/9] crypto: fix alignmask handling
Message-ID: <20210210072203.GC4493@gondor.apana.org.au>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 01, 2021 at 07:02:28PM +0100, Ard Biesheuvel wrote:
> Some generic implementations of vintage ciphers rely on alignmasks to
> ensure that the input is presented with the right alignment. Given that
> these are all C implementations, which may execute on architectures that
> don't care about alignment in the first place, it is better to use the
> unaligned accessors, which will deal with the misalignment in a way that
> is appropriate for the architecture in question (and in many cases, this
> means simply ignoring the misalignment, as the hardware doesn't care either)
> 
> So fix this across a number of implementations. Patch #1 stands out because
> michael_mic.c was broken in spite of the alignmask. Patch #2 removes tnepres
> instead of updating it, given that there is no point in keeping it.
> 
> The remaining patches all update generic ciphers that are outdated but still
> used, and which are the only implementations available on most architectures
> other than x86.
> 
> 
> 
> Ard Biesheuvel (9):
>   crypto: michael_mic - fix broken misalignment handling
>   crypto: serpent - get rid of obsolete tnepres variant
>   crypto: serpent - use unaligned accessors instead of alignmask
>   crypto: blowfish - use unaligned accessors instead of alignmask
>   crypto: camellia - use unaligned accessors instead of alignmask
>   crypto: cast5 - use unaligned accessors instead of alignmask
>   crypto: cast6 - use unaligned accessors instead of alignmask
>   crypto: fcrypt - drop unneeded alignmask
>   crypto: twofish - use unaligned accessors instead of alignmask
> 
>  crypto/Kconfig            |   3 +-
>  crypto/blowfish_generic.c |  23 ++--
>  crypto/camellia_generic.c |  45 +++----
>  crypto/cast5_generic.c    |  23 ++--
>  crypto/cast6_generic.c    |  39 +++---
>  crypto/fcrypt.c           |   1 -
>  crypto/michael_mic.c      |  31 ++---
>  crypto/serpent_generic.c  | 126 ++++----------------
>  crypto/tcrypt.c           |   6 +-
>  crypto/testmgr.c          |   6 -
>  crypto/testmgr.h          |  79 ------------
>  crypto/twofish_generic.c  |  11 +-
>  12 files changed, 90 insertions(+), 303 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
