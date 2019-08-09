Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0E6C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49052208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405472AbfHIGKb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:10:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37270 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405442AbfHIGKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:10:31 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvy6b-0007AC-Ul; Fri, 09 Aug 2019 16:10:26 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvy6a-0002id-L5; Fri, 09 Aug 2019 16:10:24 +1000
Date:   Fri, 9 Aug 2019 16:10:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] crypto: ux500/crypt: Mark expected switch fall-throughs
Message-ID: <20190809061024.GC10392@gondor.apana.org.au>
References: <20190729223819.GA21985@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190729223819.GA21985@embeddedor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 05:38:19PM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warning (Building: arm):
> 
> drivers/crypto/ux500/cryp/cryp.c: In function ‘cryp_save_device_context’:
> drivers/crypto/ux500/cryp/cryp.c:316:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ctx->key_4_r = readl_relaxed(&src_reg->key_4_r);
> drivers/crypto/ux500/cryp/cryp.c:318:2: note: here
>   case CRYP_KEY_SIZE_192:
>   ^~~~
> drivers/crypto/ux500/cryp/cryp.c:320:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ctx->key_3_r = readl_relaxed(&src_reg->key_3_r);
> drivers/crypto/ux500/cryp/cryp.c:322:2: note: here
>   case CRYP_KEY_SIZE_128:
>   ^~~~
> drivers/crypto/ux500/cryp/cryp.c:324:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ctx->key_2_r = readl_relaxed(&src_reg->key_2_r);
> drivers/crypto/ux500/cryp/cryp.c:326:2: note: here
>   default:
>   ^~~~~~~
> In file included from ./include/linux/io.h:13:0,
>                  from drivers/crypto/ux500/cryp/cryp_p.h:14,
>                  from drivers/crypto/ux500/cryp/cryp.c:15:
> drivers/crypto/ux500/cryp/cryp.c: In function ‘cryp_restore_device_context’:
> ./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  #define __raw_writel __raw_writel
>                       ^
> ./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
>  #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
>                              ^~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:363:3: note: in expansion of macro ‘writel_relaxed’
>    writel_relaxed(ctx->key_4_r, &reg->key_4_r);
>    ^~~~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:365:2: note: here
>   case CRYP_KEY_SIZE_192:
>   ^~~~
> In file included from ./include/linux/io.h:13:0,
>                  from drivers/crypto/ux500/cryp/cryp_p.h:14,
>                  from drivers/crypto/ux500/cryp/cryp.c:15:
> ./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  #define __raw_writel __raw_writel
>                       ^
> ./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
>  #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
>                              ^~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:367:3: note: in expansion of macro ‘writel_relaxed’
>    writel_relaxed(ctx->key_3_r, &reg->key_3_r);
>    ^~~~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:369:2: note: here
>   case CRYP_KEY_SIZE_128:
>   ^~~~
> In file included from ./include/linux/io.h:13:0,
>                  from drivers/crypto/ux500/cryp/cryp_p.h:14,
>                  from drivers/crypto/ux500/cryp/cryp.c:15:
> ./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  #define __raw_writel __raw_writel
>                       ^
> ./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
>  #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
>                              ^~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:371:3: note: in expansion of macro ‘writel_relaxed’
>    writel_relaxed(ctx->key_2_r, &reg->key_2_r);
>    ^~~~~~~~~~~~~~
> drivers/crypto/ux500/cryp/cryp.c:373:2: note: here
>   default:
>   ^~~~~~~
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/crypto/ux500/cryp/cryp.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
