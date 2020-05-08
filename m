Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC321C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A48BE20736
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgEHGGZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:06:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40172 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgEHGGY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:06:24 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jWw2m-0004zL-9N; Fri, 08 May 2020 15:59:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 May 2020 16:06:11 +1000
Date:   Fri, 8 May 2020 16:06:11 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 01/15] crypto - Avoid free() namespace collision
Message-ID: <20200508060611.GF24789@gondor.apana.org.au>
References: <20200430213101.135134-1-arnd@arndb.de>
 <20200430213101.135134-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430213101.135134-2-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 11:30:43PM +0200, Arnd Bergmann wrote:
> gcc-10 complains about using the name of a standard library
> function in the kernel, as we are not building with -ffreestanding:
> 
> crypto/xts.c:325:13: error: conflicting types for built-in function 'free'; expected 'void(void *)' [-Werror=builtin-declaration-mismatch]
>   325 | static void free(struct skcipher_instance *inst)
>       |             ^~~~
> crypto/lrw.c:290:13: error: conflicting types for built-in function 'free'; expected 'void(void *)' [-Werror=builtin-declaration-mismatch]
>   290 | static void free(struct skcipher_instance *inst)
>       |             ^~~~
> crypto/lrw.c:27:1: note: 'free' is declared in header '<stdlib.h>'
> 
> The xts and lrw cipher implementations run into this because they do
> not use the conventional namespaced function names.
> 
> It might be better to rename all local functions in those files to
> help with things like 'ctags' and 'grep', but just renaming these two
> avoids the build issue. I picked the more verbose crypto_xts_free()
> and crypto_lrw_free() names for consistency with several other drivers
> that do use namespaced function names.
> 
> Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
> Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/lrw.c | 6 +++---
>  crypto/xts.c | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
