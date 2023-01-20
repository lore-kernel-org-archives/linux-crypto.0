Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6831C05027
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 10:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjATKfj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 05:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjATKfg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 05:35:36 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF478A7F
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2023 02:35:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIok8-002Be8-Ie; Fri, 20 Jan 2023 18:35:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jan 2023 18:35:32 +0800
Date:   Fri, 20 Jan 2023 18:35:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net, x86@kernel.org,
        jbeulich@suse.com
Subject: Re: [PATCH 0/3] crypto: x86/aria - fix build failure with old
 binutils
Message-ID: <Y8pudCQPrubAYlQr@gondor.apana.org.au>
References: <20230115121536.465367-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230115121536.465367-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jan 15, 2023 at 12:15:33PM +0000, Taehee Yoo wrote:
> There is build failure issue when old binutils is used.
> 
> The minimum version of binutils to build kernel is 2.23 but it doesn't
> support GFNI.
> But aria-avx, aria-avx2, and aria-avx512 use GFNI.
> So, the build will be failed when old binutils is used.
> 
> In order to fix this issue, it checks build environment is using
> binutils, which don't support GFNI or not.
> In addition, it also checks AVX512 for aria-avx512.
> 
> aria-avx and aria-avx2 use GFNI optionally.
> So, if binutils doesn't support GFNI, it hides GFNI code.
> But aria-avx512 mandatorily requires GFNI and AVX512.
> So, if binutils doesn't support GFNI or AVX512, it disallows select to
> build.
> 
> In order to check whether the using binutils is supporting GFNI, it adds
> AS_GFNI.
> 
> Taehee Yoo (3):
>   crypto: x86/aria-avx - fix build failure with old binutils
>   crypto: x86/aria-avx2 - fix build failure with old binutils
>   crypto: x86/aria-avx15 - fix build failure with old binutils
> 
>  arch/x86/Kconfig.assembler               |  5 +++++
>  arch/x86/crypto/Kconfig                  |  2 +-
>  arch/x86/crypto/aria-aesni-avx-asm_64.S  | 10 ++++++++++
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S | 10 +++++++++-
>  arch/x86/crypto/aria_aesni_avx2_glue.c   |  4 +++-
>  arch/x86/crypto/aria_aesni_avx_glue.c    |  4 +++-
>  6 files changed, 31 insertions(+), 4 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
