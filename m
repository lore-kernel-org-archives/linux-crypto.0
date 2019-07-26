Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB3EC76191
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A394D22ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfGZMft (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:35:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46530 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfGZMft (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:35:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzRg-00040d-2g; Fri, 26 Jul 2019 22:35:36 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzRe-0002E3-BI; Fri, 26 Jul 2019 22:35:34 +1000
Date:   Fri, 26 Jul 2019 22:35:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     davem@davemloft.net, arnd@arndb.de, omosnacek@gmail.com,
        ard.biesheuvel@linaro.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: aegis: fix badly optimized clang output
Message-ID: <20190726123534.GA8490@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718135017.2493006-1-arnd@arndb.de>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:
> Clang sometimes makes very different inlining decisions from gcc.
> In case of the aegis crypto algorithms, it decides to turn the innermost
> primitives (and, xor, ...) into separate functions but inline most of
> the rest.
> 
> This results in a huge amount of variables spilled on the stack, leading
> to rather slow execution as well as kernel stack usage beyond the 32-bit
> warning limit when CONFIG_KASAN is enabled:
> 
> crypto/aegis256.c:123:13: warning: stack frame size of 648 bytes in function 'crypto_aegis256_encrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis256.c:366:13: warning: stack frame size of 1264 bytes in function 'crypto_aegis256_crypt' [-Wframe-larger-than=]
> crypto/aegis256.c:187:13: warning: stack frame size of 656 bytes in function 'crypto_aegis256_decrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128l.c:135:13: warning: stack frame size of 832 bytes in function 'crypto_aegis128l_encrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128l.c:415:13: warning: stack frame size of 1480 bytes in function 'crypto_aegis128l_crypt' [-Wframe-larger-than=]
> crypto/aegis128l.c:218:13: warning: stack frame size of 848 bytes in function 'crypto_aegis128l_decrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128.c:116:13: warning: stack frame size of 584 bytes in function 'crypto_aegis128_encrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128.c:351:13: warning: stack frame size of 1064 bytes in function 'crypto_aegis128_crypt' [-Wframe-larger-than=]
> crypto/aegis128.c:177:13: warning: stack frame size of 592 bytes in function 'crypto_aegis128_decrypt_chunk' [-Wframe-larger-than=]
> 
> Forcing the primitives to all get inlined avoids the issue and the
> resulting code is similar to what gcc produces.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> crypto/aegis.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
