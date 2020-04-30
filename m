Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68D2C83001
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 05:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D07F22137B
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 05:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgD3Fbm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 01:31:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60368 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgD3Fbm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 01:31:42 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jU1lk-0005LQ-8L; Thu, 30 Apr 2020 15:29:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Apr 2020 15:30:49 +1000
Date:   Thu, 30 Apr 2020 15:30:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH crypto-stable v3 1/2] crypto: arch/lib - limit simd usage
 to 4k chunks
Message-ID: <20200430053049.GA11838@gondor.apana.org.au>
References: <20200422200344.239462-1-Jason@zx2c4.com>
 <20200422231854.675965-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422231854.675965-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 22, 2020 at 05:18:53PM -0600, Jason A. Donenfeld wrote:
> The initial Zinc patchset, after some mailing list discussion, contained
> code to ensure that kernel_fpu_enable would not be kept on for more than
> a 4k chunk, since it disables preemption. The choice of 4k isn't totally
> scientific, but it's not a bad guess either, and it's what's used in
> both the x86 poly1305, blake2s, and nhpoly1305 code already (in the form
> of PAGE_SIZE, which this commit corrects to be explicitly 4k for the
> former two).
> 
> Ard did some back of the envelope calculations and found that
> at 5 cycles/byte (overestimate) on a 1ghz processor (pretty slow), 4k
> means we have a maximum preemption disabling of 20us, which Sebastian
> confirmed was probably a good limit.
> 
> Unfortunately the chunking appears to have been left out of the final
> patchset that added the glue code. So, this commit adds it back in.
> 
> Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
> Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
> Fixes: d7d7b8535662 ("crypto: x86/poly1305 - wire up faster implementations for kernel")
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v2->v3:
>  - [Eric] Split nhpoly1305 changes into separate commit, since it's not
>    related to the library interface.
> 
> Changes v1->v2:
>  - [Ard] Use explicit 4k chunks instead of PAGE_SIZE.
>  - [Eric] Prefer do-while over for (;;).
> 
>  arch/arm/crypto/chacha-glue.c        | 14 +++++++++++---
>  arch/arm/crypto/poly1305-glue.c      | 15 +++++++++++----
>  arch/arm64/crypto/chacha-neon-glue.c | 14 +++++++++++---
>  arch/arm64/crypto/poly1305-glue.c    | 15 +++++++++++----
>  arch/x86/crypto/blake2s-glue.c       | 10 ++++------
>  arch/x86/crypto/chacha_glue.c        | 14 +++++++++++---
>  arch/x86/crypto/poly1305_glue.c      | 13 ++++++-------
>  7 files changed, 65 insertions(+), 30 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
