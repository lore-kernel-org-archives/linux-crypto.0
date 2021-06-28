Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1691C48BC2
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A0A61465
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhF1Den (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jun 2021 23:34:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51016 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhF1Den (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jun 2021 23:34:43 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lxi0P-0001tf-RZ; Mon, 28 Jun 2021 11:32:17 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lxi0P-0002og-FI; Mon, 28 Jun 2021 11:32:17 +0800
Date:   Mon, 28 Jun 2021 11:32:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec - fix the process of disabling sva
 prefetching
Message-ID: <20210628033217.GD10694@gondor.apana.org.au>
References: <1624675833-20107-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624675833-20107-1-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 26, 2021 at 10:50:33AM +0800, Kai Ye wrote:
> The open interface of the sva prefetching function is distinguish the chip
> version. But the close interface of the sva prefetching function doesn't
> distinguish the chip version. As a result, the sva prefetching close
> operation is also performed on Kunpeng920, those registers are important
> on Kunpeng920, which eventually leads to abnormal hardware problems. So
> need to fix it immediately.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_main.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
