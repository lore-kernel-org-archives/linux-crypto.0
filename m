Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A5EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14E6218DE
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfIIHxB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 03:53:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32880 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbfIIHxB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 03:53:01 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7ETp-0007bp-5n; Mon, 09 Sep 2019 17:52:58 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Sep 2019 17:52:56 +1000
Date:   Mon, 9 Sep 2019 17:52:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v2 00/17] crypto: arm/aes - XTS ciphertext stealing and
 other updates
Message-ID: <20190909075256.GB21364@gondor.apana.org.au>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 03, 2019 at 09:43:22AM -0700, Ard Biesheuvel wrote:
> This is a collection of improvements for the ARM and arm64 implementations
> of the AES based skciphers.
> 
> NOTES:
> - the last two patches add XTS ciphertext stealing test vectors and should
>   NOT be merged until all AES-XTS implementations have been confirmed to work
> - tested for correctness [on both QEMU and actual hardware (via kernelci)] but
>   not for performance regressions
> 
> The most important part of this series is the implementation of ciphertext
> stealing support for the XTS skciphers. The CE and NEON bit slicing based
> code for both ARM and arm64 is updated to handle inputs of any length >= the
> XTS block size of 16 bytes.
> 
> It also updates the arm64 CTS/CBC implementation not to use a request ctx
> structure, and ports the resulting implementation to ARM as well.
> 
> The remaining patches are cleanups and minor improvements in the 'ongoing
> maintenance' category. None of these are -stable candidates AFAICT.
> 
> Changes since v1:
> - simply skcipher_walk_abort() - pass -ECANCELED instead of walk->nbytes into
>   skcipher_walk_done() so that the latter does not require any changes (#8)
> - rebased onto cryptodev/master
> 
> 
> Ard Biesheuvel (16):
>   crypto: arm/aes - fix round key prototypes
>   crypto: arm/aes-ce - yield the SIMD unit between scatterwalk steps
>   crypto: arm/aes-ce - switch to 4x interleave
>   crypto: arm/aes-ce - replace tweak mask literal with composition
>   crypto: arm/aes-neonbs - replace tweak mask literal with composition
>   crypto: arm64/aes-neonbs - replace tweak mask literal with composition
>   crypto: arm64/aes-neon - limit exposed routines if faster driver is
>     enabled
>   crypto: skcipher - add the ability to abort a skcipher walk
>   crypto: arm64/aes-cts-cbc-ce - performance tweak
>   crypto: arm64/aes-cts-cbc - move request context data to the stack
>   crypto: arm64/aes - implement support for XTS ciphertext stealing
>   crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS
>   crypto: arm/aes-ce - implement ciphertext stealing for XTS
>   crypto: arm/aes-neonbs - implement ciphertext stealing for XTS
>   crypto: arm/aes-ce - implement ciphertext stealing for CBC
>   crypto: testmgr - add test vectors for XTS ciphertext stealing
> 
> Pascal van Leeuwen (1):
>   crypto: testmgr - Add additional AES-XTS vectors for covering CTS
> 
>  arch/arm/crypto/aes-ce-core.S       | 462 ++++++++++++++------
>  arch/arm/crypto/aes-ce-glue.c       | 377 +++++++++++++---
>  arch/arm/crypto/aes-neonbs-core.S   |  24 +-
>  arch/arm/crypto/aes-neonbs-glue.c   |  91 +++-
>  arch/arm64/crypto/aes-ce.S          |   3 +
>  arch/arm64/crypto/aes-glue.c        | 299 ++++++++-----
>  arch/arm64/crypto/aes-modes.S       | 107 ++++-
>  arch/arm64/crypto/aes-neon.S        |   5 +
>  arch/arm64/crypto/aes-neonbs-core.S |   9 +-
>  arch/arm64/crypto/aes-neonbs-glue.c | 111 ++++-
>  crypto/testmgr.h                    | 368 ++++++++++++++++
>  include/crypto/internal/skcipher.h  |   5 +
>  12 files changed, 1495 insertions(+), 366 deletions(-)

Patches 1-15 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
