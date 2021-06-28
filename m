Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27709C49EAB
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABED61465
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhF1Ddy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jun 2021 23:33:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51012 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhF1Ddy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jun 2021 23:33:54 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lxhzV-0001rm-8F; Mon, 28 Jun 2021 11:31:21 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lxhzO-0002n8-RB; Mon, 28 Jun 2021 11:31:14 +0800
Date:   Mon, 28 Jun 2021 11:31:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Colin King <colin.king@canonical.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Qinglang Miao <miaoqinglang@huawei.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: ratelimit invalid ioctl message and print
 the invalid cmd
Message-ID: <20210628033114.GA10694@gondor.apana.org.au>
References: <20210622151608.23741-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622151608.23741-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 22, 2021 at 04:16:08PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently incorrect QAT ioctls can spam the kernel log with error messages
> of the form "QAT: Invalid ioctl" if a userspace program uses the wrong
> ioctl command. Quench the messages by ratelimiting them and also print
> the invalid command being used as that is useful to know.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
