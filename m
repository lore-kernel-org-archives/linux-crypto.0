Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2977C43460
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 07:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AEC8610CF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 07:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhDIHwO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 03:52:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52002 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhDIHwN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 03:52:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lUlvj-0006Dk-8v; Fri, 09 Apr 2021 17:51:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Apr 2021 17:51:51 +1000
Date:   Fri, 9 Apr 2021 17:51:51 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     wangzhou1@hisilicon.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: hisilicon/sec - Fix a module parameter error
Message-ID: <20210409075150.GC31447@gondor.apana.org.au>
References: <1617091352-52938-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617091352-52938-1-git-send-email-liulongfang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 30, 2021 at 04:02:32PM +0800, Longfang Liu wrote:
> ctx_q_num is a module parameter set by the user to specify the
> number of qp queues required to create a ctx.
> 
> When the number of qp queues allocated by PF or VF is less than
> the ctx_q_num, an error will be reported when ctx is initialized
> in kernel mode, which leads to the problem that the registered
> algorithms cannot be used.
> 
> Therefore, when PF or VF is initialized, if the number of qp queues
> is not enough to create a ctx, the kernel mode cannot be used,
> and there is no need to register the kernel mode algorithms.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
> 
> Changes in V2:
>  - Add algorithms unregistration processing
> 
>  drivers/crypto/hisilicon/sec2/sec_main.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
