Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961DAC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7771760F57
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbhHLLhP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 07:37:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52740 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236960AbhHLLhO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 07:37:14 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mE90y-0003M7-54; Thu, 12 Aug 2021 19:36:48 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mE90y-0000B4-25; Thu, 12 Aug 2021 19:36:48 +0800
Date:   Thu, 12 Aug 2021 19:36:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH 0/3] crypto: hisilicon - enable clock gating for
 accelerator device
Message-ID: <20210812113648.GE561@gondor.apana.org.au>
References: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 07, 2021 at 02:29:08PM +0800, Weili Qian wrote:
> Kunpeng930 accelerator devices support dynamic clock gating. This patchset
> enables clock gating for accelerator devices by writing hardware registers.
> 
> Weili Qian (3):
>   crypto: hisilicon - enable zip device clock gating
>   crypto: hisilicon - enable sec device clock gating
>   crypto: hisilicon - enable hpre device clock gating
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 63 +++++++++++++++++++++++++++++++
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 46 +++++++++++++++++++---
>  drivers/crypto/hisilicon/zip/zip_main.c   | 26 +++++++++++++
>  3 files changed, 130 insertions(+), 5 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
