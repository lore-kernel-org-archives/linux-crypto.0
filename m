Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C44C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60FD761453
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhENLhx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 07:37:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37334 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231897AbhENLhx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 07:37:53 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lhW7O-00033U-1s; Fri, 14 May 2021 19:36:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lhW7N-0002ZW-KO; Fri, 14 May 2021 19:36:33 +0800
Date:   Fri, 14 May 2021 19:36:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] crypto: ux500 - Fix error return code in
 hash_hw_final()
Message-ID: <20210514113633.faxp737uxm2w5x7f@gondor.apana.org.au>
References: <20210508070049.2674-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508070049.2674-1-thunder.leizhen@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 08, 2021 at 03:00:49PM +0800, Zhen Lei wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 8a63b1994c50 ("crypto: ux500 - Add driver for HASH hardware")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/crypto/ux500/hash/hash_core.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
