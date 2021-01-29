Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC6FC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 05:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5201E64DFD
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 05:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhA2FLs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:11:48 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55906 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231919AbhA2FLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 00:11:38 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l5M3W-0002Al-O8; Fri, 29 Jan 2021 16:10:51 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jan 2021 16:10:50 +1100
Date:   Fri, 29 Jan 2021 16:10:50 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 0/5] crypto: remove some obsolete algorithms
Message-ID: <20210129051050.GE12070@gondor.apana.org.au>
References: <20210121130733.1649-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121130733.1649-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 21, 2021 at 02:07:28PM +0100, Ard Biesheuvel wrote:
> Remove a set of algorithms that are never used in the kernel, and are
> highly unlikely to be depended upon by user space either.
> 
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (5):
>   crypto: remove RIPE-MD 128 hash algorithm
>   crypto: remove RIPE-MD 256 hash algorithm
>   crypto: remove RIPE-MD 320 hash algorithm
>   crypto: remove Tiger 128/160/192 hash algorithms
>   crypto: remove Salsa20 stream cipher algorithm
> 
>  .../device-mapper/dm-integrity.rst            |    4 +-
>  crypto/Kconfig                                |   62 -
>  crypto/Makefile                               |    4 -
>  crypto/ripemd.h                               |   14 -
>  crypto/rmd128.c                               |  323 ----
>  crypto/rmd256.c                               |  342 ----
>  crypto/rmd320.c                               |  391 -----
>  crypto/salsa20_generic.c                      |  212 ---
>  crypto/tcrypt.c                               |   87 +-
>  crypto/testmgr.c                              |   48 -
>  crypto/testmgr.h                              | 1553 -----------------
>  crypto/tgr192.c                               |  682 --------
>  12 files changed, 3 insertions(+), 3719 deletions(-)
>  delete mode 100644 crypto/rmd128.c
>  delete mode 100644 crypto/rmd256.c
>  delete mode 100644 crypto/rmd320.c
>  delete mode 100644 crypto/salsa20_generic.c
>  delete mode 100644 crypto/tgr192.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
