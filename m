Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49462C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 16:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A1EF21850
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 16:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfGRQSk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 12:18:40 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:36818 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729774AbfGRQSk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 12:18:40 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 568338023D98;
        Thu, 18 Jul 2019 16:18:38 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: deer25_684dc6a622a40
X-Filterd-Recvd-Size: 4295
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu, 18 Jul 2019 16:18:36 +0000 (UTC)
Message-ID: <db0a363fa35f1582f20e529d79927995a5512c0d.camel@perches.com>
Subject: Re: [PATCH] crypto: aegis: fix badly optimized clang output
From:   Joe Perches <joe@perches.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ondrej Mosnacek <omosnacek@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Thu, 18 Jul 2019 09:18:35 -0700
In-Reply-To: <20190718135017.2493006-1-arnd@arndb.de>
References: <20190718135017.2493006-1-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2019-07-18 at 15:50 +0200, Arnd Bergmann wrote:
> Clang sometimes makes very different inlining decisions from gcc.
> In case of the aegis crypto algorithms, it decides to turn the innermost
> primitives (and, xor, ...) into separate functions but inline most of
> the rest.

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

Why weren't these functions in .h files
not always marked with inline?

Are there other static non-inlined function
definitions in .h files that should also get
this inline/__always_inline marking?

I presume there are but can't think of a
reasonable way to find them off the top of
my head.

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/aegis.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/aegis.h b/crypto/aegis.h
> index 41a3090cda8e..efed7251c49d 100644
> --- a/crypto/aegis.h
> +++ b/crypto/aegis.h
> @@ -34,21 +34,21 @@ static const union aegis_block crypto_aegis_const[2] = {
>  	} },
>  };
>  
> -static void crypto_aegis_block_xor(union aegis_block *dst,
> +static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,
>  				   const union aegis_block *src)
>  {
>  	dst->words64[0] ^= src->words64[0];
>  	dst->words64[1] ^= src->words64[1];
>  }
>  
> -static void crypto_aegis_block_and(union aegis_block *dst,
> +static __always_inline void crypto_aegis_block_and(union aegis_block *dst,
>  				   const union aegis_block *src)
>  {
>  	dst->words64[0] &= src->words64[0];
>  	dst->words64[1] &= src->words64[1];
>  }
>  
> -static void crypto_aegis_aesenc(union aegis_block *dst,
> +static __always_inline void crypto_aegis_aesenc(union aegis_block *dst,
>  				const union aegis_block *src,
>  				const union aegis_block *key)
>  {

