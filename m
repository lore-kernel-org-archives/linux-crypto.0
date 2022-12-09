Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171ECC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Dec 2022 11:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLILHT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Dec 2022 06:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLILHS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2022 06:07:18 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88E14D5FA
        for <linux-crypto@vger.kernel.org>; Fri,  9 Dec 2022 03:07:17 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p3bDl-005gjX-7g; Fri, 09 Dec 2022 19:07:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Dec 2022 19:07:13 +0800
Date:   Fri, 9 Dec 2022 19:07:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        keescook@chromium.org, ebiggers@kernel.org
Subject: Re: [PATCH 0/4] crypto: arm64 - use frame_push/pop macros
Message-ID: <Y5MW4TRGizt9IogW@gondor.apana.org.au>
References: <20221129164852.2051561-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129164852.2051561-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 29, 2022 at 05:48:48PM +0100, Ard Biesheuvel wrote:
> We have a pair of macros on arm64 that can be used in asm code to set up
> and tear down the stack frame when implementing a non-leaf function.
> 
> We will be adding support for shadow call stack and pointer
> authentication to those macros, so that the code in question is less
> likely to be abused for someone's ROP/JOP enjoyment. So let's fix the
> existing crypto code to use those macros where they should be used.
> 
> Ard Biesheuvel (4):
>   crypto: arm64/aes-neonbs - use frame_push/pop consistently
>   crypto: arm64/aes-modes - use frame_push/pop macros consistently
>   crypto: arm64/crct10dif - use frame_push/pop macros consistently
>   crypto: arm64/ghash-ce - use frame_push/pop macros consistently
> 
>  arch/arm64/crypto/aes-modes.S         | 34 +++++++-------------
>  arch/arm64/crypto/aes-neonbs-core.S   | 16 ++++-----
>  arch/arm64/crypto/crct10dif-ce-core.S |  5 ++-
>  arch/arm64/crypto/ghash-ce-core.S     |  8 ++---
>  4 files changed, 24 insertions(+), 39 deletions(-)
> 
> -- 
> 2.35.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
