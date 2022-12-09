Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB02C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Dec 2022 11:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLILIl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Dec 2022 06:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLILIk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2022 06:08:40 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C954762
        for <linux-crypto@vger.kernel.org>; Fri,  9 Dec 2022 03:08:39 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p3bEu-005glC-T5; Fri, 09 Dec 2022 19:08:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Dec 2022 19:08:24 +0800
Date:   Fri, 9 Dec 2022 19:08:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     olivia@selenic.com, mpm@selenic.com, mb@bu3sch.de,
        dilinger@queued.net, linux-crypto@vger.kernel.org,
        yangyingliang@huawei.com
Subject: Re: [PATCH v2 0/2] hwrng: Fix PCI device refcount leak
Message-ID: <Y5MXKMCQ3GirluAD@gondor.apana.org.au>
References: <20221202132234.60631-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202132234.60631-1-wangxiongfeng2@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 02, 2022 at 09:22:32PM +0800, Xiongfeng Wang wrote:
> for_each_pci_dev() is implemented by pci_get_device(). The comment of
> pci_get_device() says that it will increase the reference count for the
> returned pci_dev and also decrease the reference count for the input
> pci_dev @from if it is not NULL.
> 
> If we break for_each_pci_dev() loop with pdev not NULL, we need to call
> pci_dev_put() to decrease the reference count. Add the missing
> pci_dev_put() for amd-hwrng and geode-hwrng.
> 
> 
> ChangeLog:
> v1 -> v2:
>   1. fix error in amd_rng_mod_exit()
>   2. also add refcount leak fix for geode-hwrng
> 
> Xiongfeng Wang (2):
>   hwrng: amd - Fix PCI device refcount leak
>   hwrng: geode - Fix PCI device refcount leak
> 
>  drivers/char/hw_random/amd-rng.c   | 18 ++++++++++-----
>  drivers/char/hw_random/geode-rng.c | 36 +++++++++++++++++++++++-------
>  2 files changed, 41 insertions(+), 13 deletions(-)
> 
> -- 
> 2.20.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
