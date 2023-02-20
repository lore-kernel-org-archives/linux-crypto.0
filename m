Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E69CC6379F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Feb 2023 09:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjBTJCM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Feb 2023 04:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjBTJCA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2023 04:02:00 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9009B1499B
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2023 01:01:52 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pU238-00DIgA-6n; Mon, 20 Feb 2023 17:01:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Feb 2023 17:01:30 +0800
Date:   Mon, 20 Feb 2023 17:01:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH 4/5] hwrng: meson: use struct hw_random priv data
Message-ID: <Y/M26lBXwIUCIGVc@gondor.apana.org.au>
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
 <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
 <Y/L6E+7SmLha7Bp8@gondor.apana.org.au>
 <426a526b-cd55-0bd0-1ab9-623832ef7417@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426a526b-cd55-0bd0-1ab9-623832ef7417@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 20, 2023 at 08:18:18AM +0100, Heiner Kallweit wrote:
>
> OK, then let's omit patches 4 and 5.
> Patches 1-3 have a Reviewed-by, can you apply them as-is or do
> you need a resubmit of the series with patch 1-3 only?

Sure, no problems.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
