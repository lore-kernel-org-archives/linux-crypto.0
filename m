Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A99C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8021E21917
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBHHsj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:48:39 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34242 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHsj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:48:39 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0tg-0000o1-1N; Fri, 08 Feb 2019 15:48:28 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0te-0002Te-0F; Fri, 08 Feb 2019 15:48:26 +0800
Date:   Fri, 8 Feb 2019 15:48:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drag <ofir.drang@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX PATCH] crypto: ccree: fix resume race condition on init
Message-ID: <20190208074825.d24swebf2cz3edrk@gondor.apana.org.au>
References: <20190207133612.31836-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207133612.31836-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 07, 2019 at 03:36:11PM +0200, Gilad Ben-Yossef wrote:
> We were enabling autosuspend, which is using data set by the
> hash module, prior to the hash module being inited, casuing
> a crash on resume as part of the startup sequence if the race
> was lost.
> 
> This was never a real problem because the PM infra was using low
> res timers so we were always winning the race, until commit 8234f6734c5d
> ("PM-runtime: Switch autosuspend over to using hrtimers") changed that :-)
> 
> Fix this by seperating the PM setup and enablement and doing the
> latter only at the end of the init sequence.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: stable@kernel.org # v4.20
> ---
> Herbert, could you please take this for 5.0-rc6 ? thanks.
> 
>  drivers/crypto/ccree/cc_driver.c |  7 ++++---
>  drivers/crypto/ccree/cc_pm.c     | 13 ++++++-------
>  drivers/crypto/ccree/cc_pm.h     |  3 +++
>  3 files changed, 13 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
