Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E56C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 09:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbjBWJe1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 04:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjBWJeY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 04:34:24 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1C84D616;
        Thu, 23 Feb 2023 01:33:58 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pV7yh-00Eort-Ib; Thu, 23 Feb 2023 17:33:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Feb 2023 17:33:27 +0800
Date:   Thu, 23 Feb 2023 17:33:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     davem@davemloft.net, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [PATCH] stm32: stm32-hash: Add kmalloc_array allocation check
Message-ID: <Y/cy5wUtk10OahpO@gondor.apana.org.au>
References: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au>
 <20230224231430.2948-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224231430.2948-1-kunyu@nfschina.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 25, 2023 at 07:14:29AM +0800, Li kunyu wrote:
> 
> hello senior:
>   'rctx->hw_context' is a member of the rctx pointer array object and will pass 'memcpy(out, rctx, sizeof(*rctx)) at the end of the function;  ', copied to the out pointer memory, it cannot be released, I think this patch does an allocation check on the 'rctx->hw_context' pointer should help a bit.

Ugh that's completely broken.  You can't export pointers.

I guess this driver needs to be disabled.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
