Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953FBC4743D
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7292B613BA
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhFKHT1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:19:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50548 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhFKHTW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 03:19:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lrbPr-000585-9u; Fri, 11 Jun 2021 15:17:19 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lrbPn-0001e3-IA; Fri, 11 Jun 2021 15:17:15 +0800
Date:   Fri, 11 Jun 2021 15:17:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     davem@davemloft.net, pali@kernel.org, pavel@ucw.cz,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next 0/2] Fix error handling in omap sham ops
Message-ID: <20210611071715.GB23016@gondor.apana.org.au>
References: <20210601145118.126169-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601145118.126169-1-zhangqilong3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 01, 2021 at 10:51:16PM +0800, Zhang Qilong wrote:
> First patch clear pm_runtime_get_sync calls. The other
> fix PM disable depth imbalance.
> 
> Zhang Qilong (2):
>   crypto: omap-des - using pm_runtime_resume_and_get instead of
>     pm_runtime_get_sync
>   crypto: omap-sham - Fix PM reference leak in omap sham ops
> 
>  drivers/crypto/omap-des.c  | 9 +++------
>  drivers/crypto/omap-sham.c | 4 ++--
>  2 files changed, 5 insertions(+), 8 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
