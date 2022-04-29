Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B930C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Apr 2022 05:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243346AbiD2FeT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Apr 2022 01:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345694AbiD2FeS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Apr 2022 01:34:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282F65716B
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 22:31:00 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nkJDI-0088h8-Tp; Fri, 29 Apr 2022 15:30:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Apr 2022 13:30:45 +0800
Date:   Fri, 29 Apr 2022 13:30:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel - Avoid flush_scheduled_work() usage
Message-ID: <Ymt4BfQXbXkY2qo0@gondor.apana.org.au>
References: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 20, 2022 at 10:27:11AM +0900, Tetsuo Handa wrote:
>
> +module_init(atmel_i2c_init);
> +module_exit(atmel_i2c_exit);

What if everything is built-in? Shouldn't this be moved to a place
earlier than module_init?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
