Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620ADCDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjJTF5l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjJTF5k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:57:40 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED22D11B;
        Thu, 19 Oct 2023 22:57:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiVY-0097hj-Eb; Fri, 20 Oct 2023 13:57:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:57:22 +0800
Date:   Fri, 20 Oct 2023 13:57:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     wangzhou1@hisilicon.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/qm - fix EQ/AEQ interrupt issue
Message-ID: <ZTIWwr8FzmuKam8q@gondor.apana.org.au>
References: <20231013034957.28311-1-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013034957.28311-1-liulongfang@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 13, 2023 at 11:49:57AM +0800, Longfang Liu wrote:
> During hisilicon accelerator live migration operation. In order to
> prevent the problem of EQ/AEQ interrupt loss. Migration driver will
> trigger an EQ/AEQ doorbell at the end of the migration.
> 
> This operation may cause double interruption of EQ/AEQ events.
> To ensure that the EQ/AEQ interrupt processing function is normal.
> The interrupt handling functionality of EQ/AEQ needs to be updated.
> Used to handle repeated interrupts event.
> 
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 105 +++++++++++++---------------------
>  include/linux/hisi_acc_qm.h   |   1 +
>  2 files changed, 41 insertions(+), 65 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
