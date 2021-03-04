Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1526C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FAD664F1C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhCDGpV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:45:21 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52682 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233886AbhCDGpO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 01:45:14 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHhih-0007gZ-5p; Thu, 04 Mar 2021 17:44:24 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Mar 2021 17:44:23 +1100
Date:   Thu, 4 Mar 2021 17:44:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFT PATCH] crypto: s5p-sss - initialize APB clock after the AXI
 bus clock for SlimSSS
Message-ID: <20210304064422.GJ15863@gondor.apana.org.au>
References: <20210212163526.69422-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212163526.69422-1-krzk@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 12, 2021 at 05:35:26PM +0100, Krzysztof Kozlowski wrote:
> The driver for Slim Security Subsystem (SlimSSS) on Exynos5433 takes two
> clocks - aclk (AXI/AHB clock) and pclk (APB/Advanced Peripheral Bus
> clock).  The "aclk", as main high speed bus clock, is enabled first.  Then
> the "pclk" is enabled.
> 
> However the driver assigned reversed names for lookup of these clocks
> from devicetree, so effectively the "pclk" was enabled first.
> 
> Although it might not matter in reality, the correct order is to enable
> first main/high speed bus clock - "aclk".  Also this was the intention
> of the actual code.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Not tested, please kindly test on Exynos5433 hardware.
> ---
>  drivers/crypto/s5p-sss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
