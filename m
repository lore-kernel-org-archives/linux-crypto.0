Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53342E748E9
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Oct 2023 08:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjJAIf0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Oct 2023 04:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbjJAIfZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2023 04:35:25 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E56EA7;
        Sun,  1 Oct 2023 01:35:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qmrum-002PYY-KX; Sun, 01 Oct 2023 16:35:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Oct 2023 16:35:04 +0800
Date:   Sun, 1 Oct 2023 16:35:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Adam Guerin <adam.guerin@intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: Annotate struct adf_fw_counters with
 __counted_by
Message-ID: <ZRkvOMsJ9EMAKG8t@gondor.apana.org.au>
References: <20230922175432.work.709-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922175432.work.709-kees@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 22, 2023 at 10:54:33AM -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct adf_fw_counters.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Tom Rix <trix@redhat.com>
> Cc: Adam Guerin <adam.guerin@intel.com>
> Cc: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: qat-linux@intel.com
> Cc: linux-crypto@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_fw_counters.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
