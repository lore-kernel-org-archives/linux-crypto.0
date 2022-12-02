Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4ABC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 09:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiLBJm2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 04:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbiLBJmL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 04:42:11 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24698B2740
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 01:42:10 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p12YR-003BNL-Jt; Fri, 02 Dec 2022 17:42:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Dec 2022 17:41:59 +0800
Date:   Fri, 2 Dec 2022 17:41:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     olivia@selenic.com, mpm@selenic.com, mb@bu3sch.de,
        linux-crypto@vger.kernel.org, yangyingliang@huawei.com
Subject: Re: [PATCH] hwrng: amd - Fix PCI device refcount leak
Message-ID: <Y4nIZ+qkew6APlCM@gondor.apana.org.au>
References: <20221123093949.115579-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123093949.115579-1-wangxiongfeng2@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 23, 2022 at 05:39:49PM +0800, Xiongfeng Wang wrote:
> for_each_pci_dev() is implemented by pci_get_device(). The comment of
> pci_get_device() says that it will increase the reference count for the
> returned pci_dev and also decrease the reference count for the input
> pci_dev @from if it is not NULL.
> 
> If we break for_each_pci_dev() loop with pdev not NULL, we need to call
> pci_dev_put() to decrease the reference count. Add the missing
> pci_dev_put() for the normal and error path.
> 
> Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>  drivers/char/hw_random/amd-rng.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

The driver geode-rng seems to have the same problem, could you please
fix that as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
