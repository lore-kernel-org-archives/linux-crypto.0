Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54F8C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 12:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFCD260FC2
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 12:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbhJHMZu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Oct 2021 08:25:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55914 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhJHMZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Oct 2021 08:25:49 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mYouc-0003bC-UL; Fri, 08 Oct 2021 20:23:42 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mYouW-00085i-Da; Fri, 08 Oct 2021 20:23:36 +0800
Date:   Fri, 8 Oct 2021 20:23:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        YueHaibing <yuehaibing@huawei.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] crypto: ccree - avoid out-of-range warnings from clang
Message-ID: <20211008122336.GB31060@gondor.apana.org.au>
References: <20210927121811.940899-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927121811.940899-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 27, 2021 at 02:18:03PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out inconsistencies in the FIELD_PREP() invocation in
> this driver that result from the 'mask' being a 32-bit value:
> 
> drivers/crypto/ccree/cc_driver.c:117:18: error: result of comparison of constant 18446744073709551615 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>         cache_params |= FIELD_PREP(mask, val);
>                         ^~~~~~~~~~~~~~~~~~~~~
> include/linux/bitfield.h:94:3: note: expanded from macro 'FIELD_PREP'
>                 __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/bitfield.h:52:28: note: expanded from macro '__BF_FIELD_CHECK'
>                 BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,         \
>                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This does not happen in other places that just pass a constant here.
> 
> Work around the warnings by widening the type of the temporary variable.
> 
> Fixes: 05c2a705917b ("crypto: ccree - rework cache parameters handling")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/ccree/cc_driver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
