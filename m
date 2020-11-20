Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79B7C56201
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 06:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CA6222226
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 06:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgKTG6J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 01:58:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34222 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgKTG6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 01:58:09 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kg0Mp-0007lK-B2; Fri, 20 Nov 2020 17:58:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2020 17:57:59 +1100
Date:   Fri, 20 Nov 2020 17:57:59 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/zip - add a work_queue for zip irq
Message-ID: <20201120065759.GE20581@gondor.apana.org.au>
References: <1605259955-17796-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605259955-17796-1-git-send-email-shenyang39@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 13, 2020 at 05:32:35PM +0800, Yang Shen wrote:
> The patch 'irqchip/gic-v3-its: Balance initial LPI affinity across CPUs'
> set the IRQ to an uncentain CPU. If an IRQ is bound to the CPU used by the
> thread which is sending request, the throughput will be just half.
> 
> So allocate a 'work_queue' and set as 'WQ_UNBOUND' to do the back half work
> on some different CPUS.
> 
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
