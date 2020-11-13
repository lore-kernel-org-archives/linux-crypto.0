Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07809C4742C
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 05:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADBBF2137B
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 05:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgKMFLE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 00:11:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33722 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgKMFLE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 00:11:04 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kdRMT-0000su-N0; Fri, 13 Nov 2020 16:11:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2020 16:11:01 +1100
Date:   Fri, 13 Nov 2020 16:11:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] crypto: arm64/chacha - simplify tail block handling
Message-ID: <20201113051101.GF8350@gondor.apana.org.au>
References: <20201106163938.3050-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106163938.3050-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 06, 2020 at 05:39:38PM +0100, Ard Biesheuvel wrote:
> Based on lessons learnt from optimizing the 32-bit version of this driver,
> we can simplify the arm64 version considerably, by reordering the final
> two stores when the last block is not a multiple of 64 bytes. This removes
> the need to use permutation instructions to calculate the elements that are
> clobbered by the final overlapping store, given that the store of the
> penultimate block now follows it, and that one carries the correct values
> for those elements already.
> 
> While at it, simplify the overlapping loads as well, by calculating the
> address of the final overlapping load upfront, and switching to this
> address for every load that would otherwise extend past the end of the
> source buffer.
> 
> There is no impact on performance, but the resulting code is substantially
> smaller and easier to follow.
> 
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/chacha-neon-core.S | 193 +++++++-------------
>  1 file changed, 69 insertions(+), 124 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
