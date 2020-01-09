Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB55FC32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A279D20678
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgAIFP7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:15:59 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40506 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgAIFP6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:15:58 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQAc-0003Oh-5n; Thu, 09 Jan 2020 13:15:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQAW-0003ZE-K6; Thu, 09 Jan 2020 13:15:40 +0800
Date:   Thu, 9 Jan 2020 13:15:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Zaibo Xu <xuzaibo@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Longfang Liu <liulongfang@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/sec2 - Use atomics instead of __sync
Message-ID: <20200109051540.pnwmajhrl6wts2g6@gondor.apana.org.au>
References: <20200107200926.3659010-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107200926.3659010-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 07, 2020 at 09:08:58PM +0100, Arnd Bergmann wrote:
> The use of __sync functions for atomic memory access is not
> supported in the kernel, and can result in a link error depending
> on configuration:
> 
> ERROR: "__tsan_atomic32_compare_exchange_strong" [drivers/crypto/hisilicon/sec2/hisi_sec2.ko] undefined!
> ERROR: "__tsan_atomic64_fetch_add" [drivers/crypto/hisilicon/sec2/hisi_sec2.ko] undefined!
> 
> Use the kernel's own atomic interfaces instead. This way the
> debugfs interface actually reads the counter atomically.
> 
> Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/hisilicon/sec2/sec.h        |  6 +++---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
>  drivers/crypto/hisilicon/sec2/sec_main.c   | 14 ++++++++++++--
>  3 files changed, 21 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
