Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4154AC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00AE464E2A
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhBJHZl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:25:41 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50348 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232501AbhBJHZB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:25:01 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jrG-0001Iq-DD; Wed, 10 Feb 2021 18:24:19 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:24:18 +1100
Date:   Wed, 10 Feb 2021 18:24:18 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/6] crypto: hisilicon/qm - misc fixes
Message-ID: <20210210072418.GN4493@gondor.apana.org.au>
References: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 05, 2021 at 06:12:52PM +0800, Weili Qian wrote:
> This patchset fixes some bugs:
> 1. Removing the waiting reset's completion logic of driver.
> 2. In order to prevent request missing,
>    call user's callback before device resetting.
> 3. Fix the value of 'QM_SQC_VFT_BASE_MASK_V2'.
> 4. Update irqflag.
> 5. Do not reset when CE error occurs.
> 6. Fix printing format issue. 
> 
> Sihang Chen (1):
>   crypto: hisilicon/qm - update irqflag
> 
> Weili Qian (5):
>   crypto: hisilicon/qm - removing driver after reset
>   crypto: hisilicon/qm - fix request missing error
>   crypto: hisilicon/qm - fix the value of 'QM_SQC_VFT_BASE_MASK_V2'
>   crypto: hisilicon/qm - do not reset hardware when CE happens
>   crypto: hisilicon/qm - fix printing format issue
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |   3 +-
>  drivers/crypto/hisilicon/qm.c             | 124 +++++++++++++++++++++---------
>  drivers/crypto/hisilicon/qm.h             |   5 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  |   3 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |   7 +-
>  5 files changed, 101 insertions(+), 41 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
