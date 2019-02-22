Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B63C10F00
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF0302081B
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfBVMAc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:00:32 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54830 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVMAc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:00:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9V7-0000at-OH; Fri, 22 Feb 2019 20:00:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9Uy-0007DT-00; Fri, 22 Feb 2019 20:00:12 +0800
Date:   Fri, 22 Feb 2019 20:00:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     zhangzj@rock-chips.com
Cc:     linux-crypto@vger.kernel.org, heiko@sntech.de, ebiggers@google.com,
        huangtao@rock-chips.com, zhangzj@rock-chips.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: rockchip - fix scatterlist nents error
Message-ID: <20190222120011.bwuxqshhxmapmdqk@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213082439.22138-1-zhangzj@rock-chips.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

zhangzj@rock-chips.com wrote:
> From: Zhang Zhijie <zhangzj@rock-chips.com>
> 
> In some cases, the nents of src scatterlist is different from
> dst scatterlist. So two variables are used to handle the nents
> of src&dst scatterlist.
> 
> Reported-by: Eric Biggers <ebiggers@google.com>
> Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
> Cc: <stable@vger.kernel.org> # v4.5+
> Signed-off-by: Zhang Zhijie <zhangzj@rock-chips.com>
> ---
> drivers/crypto/rockchip/rk3288_crypto.c            | 2 +-
> drivers/crypto/rockchip/rk3288_crypto.h            | 3 ++-
> drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 5 +++--
> drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 2 +-
> 4 files changed, 7 insertions(+), 5 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
