Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAB0C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9D8206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfG2JMJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 05:12:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56482 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfG2JMJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 05:12:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hs1hP-0004R8-Gi; Mon, 29 Jul 2019 19:12:07 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hs1hM-0008KQ-JF; Mon, 29 Jul 2019 19:12:04 +1000
Date:   Mon, 29 Jul 2019 19:12:04 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, geert@linux-m68k.org,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH] crypto: aegis128 - deal with missing simd.h header on
 some architecures
Message-ID: <20190729091204.GA32006@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The generic aegis128 driver has been updated to support using SIMD
> intrinsics to implement the core AES based transform, and this has
> been wired up for ARM and arm64, which both provide a simd.h header.
> 
> As it turns out, most architectures don't provide this header, even
> though a version of it exists in include/asm-generic, and this is
> not taken into account by the aegis128 driver, resulting in build
> failures on those architectures.
> 
> So update the aegis128 code to only import simd.h (and the related
> header in internal/crypto) if the SIMD functionality is enabled for
> this driver.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> crypto/aegis128-core.c | 22 +++++++++++++++++-----
> 1 file changed, 17 insertions(+), 5 deletions(-)

I think we should dig a little deeper into why asm-generic isn't
working for this case.  AFAICS we rely on the same mechanism for
errno.h on m68k and that obviously works.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
