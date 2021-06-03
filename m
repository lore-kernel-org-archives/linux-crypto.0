Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3400AC47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A985610CB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFCMai (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:30:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60844 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhFCMai (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 08:30:38 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lomSq-0001uy-Rg; Thu, 03 Jun 2021 20:28:44 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lomSm-0001bm-QL; Thu, 03 Jun 2021 20:28:40 +0800
Date:   Thu, 3 Jun 2021 20:28:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     wangzhou1@hisilicon.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v3] crypto: hisilicon - switch to memdup_user_nul()
Message-ID: <20210603122840.GA6161@gondor.apana.org.au>
References: <1621849628-108717-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621849628-108717-1-git-send-email-zou_wei@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 24, 2021 at 05:47:08PM +0800, Zou Wei wrote:
> Use memdup_user_nul() helper instead of open-coding to
> simplify the code.
> 
> v1-->v2:
>    fixed patch title error
> v2-->v3:
>    return the actual error
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
