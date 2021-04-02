Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDB1C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 09:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C19E60724
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 09:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhDBJEB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:04:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58930 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhDBJEB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 05:04:01 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lSFif-0002IM-40; Fri, 02 Apr 2021 20:03:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Apr 2021 20:03:56 +1100
Date:   Fri, 2 Apr 2021 20:03:56 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH RESEND] random: initialize ChaCha20 constants with
 correct endianness
Message-ID: <20210402090356.GA24509@gondor.apana.org.au>
References: <20210322051347.266831-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322051347.266831-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 21, 2021 at 10:13:47PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On big endian CPUs, the ChaCha20-based CRNG is using the wrong
> endianness for the ChaCha20 constants.
> 
> This doesn't matter cryptographically, but technically it means it's not
> ChaCha20 anymore.  Fix it to always use the standard constants.
> 
> Cc: linux-crypto@vger.kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/char/random.c   | 4 ++--
>  include/crypto/chacha.h | 9 +++++++--
>  2 files changed, 9 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
