Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC3FC4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60DFA611C9
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhHUHuq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Aug 2021 03:50:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53810 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232469AbhHUHuq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Aug 2021 03:50:46 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mHLlW-0006FJ-98; Sat, 21 Aug 2021 15:50:06 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mHLlW-0000uJ-1Q; Sat, 21 Aug 2021 15:50:06 +0800
Date:   Sat, 21 Aug 2021 15:50:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v4 0/2] crypto: hisilicon - some misc bugfix for SEC
 engine
Message-ID: <20210821075006.GD3392@gondor.apana.org.au>
References: <1628840462-25437-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628840462-25437-1-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 13, 2021 at 03:41:00PM +0800, Kai Ye wrote:
> some misc bugfix for SEC engine.
> 
> changes v1->v2:
> 	delete the "ifdefs", use the IS_ENABLED.
> changes v2->v3:
> 	fix merge conflict
> changes v3->v4:
> 	fix build error.
> 
> Kai Ye (2):
>   crypto: hisilicon/sec - fix the abnormal exiting process
>   crypto: hisilicon/sec - modify the hardware endian configuration
> 
>  drivers/crypto/hisilicon/sec2/sec.h      |  5 -----
>  drivers/crypto/hisilicon/sec2/sec_main.c | 34 +++++++++++---------------------
>  2 files changed, 11 insertions(+), 28 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
