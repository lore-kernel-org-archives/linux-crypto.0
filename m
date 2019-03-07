Return-Path: <SRS0=O2m6=RK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05212C43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 08:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDEA720675
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 08:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfCGI0D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Mar 2019 03:26:03 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:55276 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfCGI0C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Mar 2019 03:26:02 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h1oLh-00048Y-Vp; Thu, 07 Mar 2019 16:25:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h1oLe-0006AM-Er; Thu, 07 Mar 2019 16:25:50 +0800
Date:   Thu, 7 Mar 2019 16:25:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: s5p-sss - fix AES support for Exynos5433
Message-ID: <20190307082550.4ijrmlrupyvwdyl5@gondor.apana.org.au>
References: <CGME20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83@eucas1p2.samsung.com>
 <20190301140254.19341-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301140254.19341-1-k.konieczny@partner.samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 01, 2019 at 03:02:54PM +0100, Kamil Konieczny wrote:
> Commit 0918f18c7179 ("crypto: s5p - add AES support for Exynos5433")
> introduced bug in dereferencing clk_names[1] on platforms different from
> Exynos5433. On Exynos board XU3 call trace is:
> 
> "Unable to handle kernel paging request at virtual address 00004000"
> (strcmp) from [<c0774014>] (of_property_match_string+0x58/0xd0)
> ...
> (devm_clk_get) from [<c075c248>] (s5p_aes_probe+0xd4/0x4a0)
> (s5p_aes_probe) from [<c059dbc4>] (platform_drv_probe+0x6c/0xa4)
> 
> Fix this by setting array clk_names size to 2.
> 
> Fixes: 0918f18c7179 ("crypto: s5p - add AES support for Exynos5433")
> Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
