Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356F2C7EE22
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 04:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjEOEZI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 00:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEOEZG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 00:25:06 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFC810CC;
        Sun, 14 May 2023 21:25:04 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pyPkf-0090a9-6j; Mon, 15 May 2023 12:24:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 May 2023 12:24:01 +0800
Date:   Mon, 15 May 2023 12:24:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v7 4/4] crypto: starfive - Add hash and HMAC support
Message-ID: <ZGGz4YFDMKQThG2x@gondor.apana.org.au>
References: <20230504073400.1170979-1-jiajie.ho@starfivetech.com>
 <20230504073400.1170979-5-jiajie.ho@starfivetech.com>
 <ZF4bKe0YkpcQakLs@gondor.apana.org.au>
 <2ae2d187-5db7-9207-7846-1a80e87047b2@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ae2d187-5db7-9207-7846-1a80e87047b2@starfivetech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 15, 2023 at 11:27:35AM +0800, Jia Jie Ho wrote:
>
> I've added COMPILE_TEST in the Kconfig, then ran make W=1, sparse and smatch.
> However it did not produce the error message.

I guess you weren't testing on a 64-bit platform.  BIT(2) is
an unsigned long, so ~BIT(2) is 64-bit long on 64-bit platforms.

You're trying to feed it into writel which takes a 32-bit value,
hence the warning.

If you have to use the BIT macro, then you need to cast the result
to u32:

#define STARFIVE_IE_MASK_HASH_DONE ((u32)BIT(2))

But it's probably a lot clearer if you do it as:

#define STARFIVE_IE_MASK_HASH_DONE 0x4

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
