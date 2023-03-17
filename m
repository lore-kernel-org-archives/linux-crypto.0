Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12352C6FD1D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 08:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjCQIdp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Mar 2023 04:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjCQIdW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2023 04:33:22 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC183DF;
        Fri, 17 Mar 2023 01:32:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pd5Ts-005ezq-6g; Fri, 17 Mar 2023 16:30:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Mar 2023 16:30:32 +0800
Date:   Fri, 17 Mar 2023 16:30:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto - img-hash: Drop of_match_ptr for ID table
Message-ID: <ZBQlKMTcTm1yjete@gondor.apana.org.au>
References: <20230310223027.315954-1-krzysztof.kozlowski@linaro.org>
 <20230310223027.315954-2-krzysztof.kozlowski@linaro.org>
 <ZBPYpYfd29YwN1Dy@gondor.apana.org.au>
 <b8cd828b-edc5-6748-bf97-af0fc85e14a4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8cd828b-edc5-6748-bf97-af0fc85e14a4@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 17, 2023 at 09:12:05AM +0100, Krzysztof Kozlowski wrote:
>
> The missing dependency on OF is not a problem. The OF code is prepare
> and will work fine if the driver is built with !OF. The point is that
> with !OF after dropping of_match_ptr(), the driver could match via ACPI
> (PRP0001). If we make it depending on OF, the driver won't be able to
> use it, unless kernel is built with OF which is unlikely for ACPI systems.

I know it works now, but what I'm saying is that if struct device_driver
actually had of_match_table as conditional on OF, which ideally it
should, then removing of_match_ptr will break the build.

I know that it's currently unconditionally defined, but that's
just wasting memory on non-OF machines such as x86.

So either this driver is OF-only, in which case you can drop
the of_match_ptr but must add a dependency on OF.  Or it's not
OF-only, in which case you should use of_match_ptr.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
