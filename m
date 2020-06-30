Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3CDC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 04:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B33EF20722
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 04:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgF3EK5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 00:10:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32880 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgF3EK4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 00:10:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jq7bJ-00083u-S7; Tue, 30 Jun 2020 14:10:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Jun 2020 14:10:29 +1000
Date:   Tue, 30 Jun 2020 14:10:29 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ux500: hash: Add namespacing to hash_init()
Message-ID: <20200630041029.GA20892@gondor.apana.org.au>
References: <20200629123003.1014387-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629123003.1014387-1-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 29, 2020 at 01:30:03PM +0100, Lee Jones wrote:
> A recent change to the Regulator consumer API (which this driver
> utilises) add prototypes for the some suspend functions.  These
> functions require including header file include/linux/suspend.h.
> 
> The following tree of includes affecting this driver will be
> present:
> 
>    In file included from include/linux/elevator.h:6,
>                     from include/linux/blkdev.h:288,
>                     from include/linux/blk-cgroup.h:23,
>                     from include/linux/writeback.h:14,
>                     from include/linux/memcontrol.h:22,
>                     from include/linux/swap.h:9,
>                     from include/linux/suspend.h:5,
>                     from include/linux/regulator/consumer.h:35,
>                     from drivers/crypto/ux500/hash/hash_core.c:28:
> 
> include/linux/elevator.h pulls in include/linux/hashtable.h which
> contains its own version of hash_init().  This confuses the build
> system and results in the following error (amongst others):
> 
>  drivers/crypto/ux500/hash/hash_core.c:1362:19: error: passing argument 1 of '__hash_init' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1362 |  return hash_init(req);
> 
> Fix this by namespacing the local hash_init() such that the
> source of confusion is removed.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> 
> Ideally this should go into v5.8's -rcs else it runs the risk of
> breaking when Linus pulls everything in for v5.9-rc1.

I have no objections to this patch.  However, I'd rather put
it on a topic branch which you could pull rather than pushing
it into 5.8 straight away.

I also dislike pulling in the kitchen sink when all you need in
consumer.h is the definition of suspend_state_t.  A better solution
would be to move the definition of suspend_state_t into linux/types.h
and including that instead of suspend.h in consumer.h.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
