Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7619DC636D7
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 09:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBIJoI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIJoH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 04:44:07 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CADC47404;
        Thu,  9 Feb 2023 01:44:06 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQ3So-009E6l-Lt; Thu, 09 Feb 2023 17:43:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Feb 2023 17:43:34 +0800
Date:   Thu, 9 Feb 2023 17:43:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     JiaJie Ho <jiajie.ho@starfivetech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] crypto: starfive - Add hash and HMAC support
Message-ID: <Y+TARjfzt2FMG6oJ@gondor.apana.org.au>
References: <20230130154242.112613-1-jiajie.ho@starfivetech.com>
 <20230130154242.112613-5-jiajie.ho@starfivetech.com>
 <Y+S5fBjZQZli9nBg@gondor.apana.org.au>
 <88a62a7a11814d629e2198583a0349b6@EXMBX168.cuchost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88a62a7a11814d629e2198583a0349b6@EXMBX168.cuchost.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 09, 2023 at 09:33:06AM +0000, JiaJie Ho wrote:
>
> The DMA can only support 32-bit addressing.
> So, I am copying everything in case kernel allocated memory region >32-bit for a user app.

Does your hardware support scatter-and-gather? If so you should
at least allocate individual pages rather than one contiguous buffer.

Then you can allocate them on-demand rather than before-hand.

It would also be nice to not do the copy if the input you were
given was in low memory (and contiguous if your hardware doesn't
do SG).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
