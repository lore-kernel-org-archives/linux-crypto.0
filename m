Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9972C32774
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 11:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348473AbiHSLFi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 07:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348539AbiHSLEy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 07:04:54 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F8FBA57;
        Fri, 19 Aug 2022 04:04:51 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzo0-00Cpol-EW; Fri, 19 Aug 2022 21:04:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 19:04:48 +0800
Date:   Fri, 19 Aug 2022 19:04:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - remove unneeded hardware cache
 write back
Message-ID: <Yv9uUDw/bX+HCcp2@gondor.apana.org.au>
References: <20220813103545.27370-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813103545.27370-1-shenyang39@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 13, 2022 at 06:35:45PM +0800, Yang Shen wrote:
> From: Weili Qian <qianweili@huawei.com>
> 
> Data in the hardware cache needs to be written back to the memory
> before the queue memory is released. Currently, the queue memory is
> applied for when the driver is loaded and released when the driver is
> removed. Therefore, the hardware cache does not need to be written back
> when process puts queue.
> 
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
