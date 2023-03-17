Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27933C6FD1D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 03:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCQDZF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCQDZD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 23:25:03 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE893253F;
        Thu, 16 Mar 2023 20:25:01 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pd0i1-005aoT-NS; Fri, 17 Mar 2023 11:24:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Mar 2023 11:24:49 +0800
Date:   Fri, 17 Mar 2023 11:24:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yang Shen <shenyang39@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Nick Terrell <terrelln@fb.com>, Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com
Subject: Re: [PATCH 0/6] crypto: remove unnecessary PCI error handling
Message-ID: <ZBPdgcHp4rWm6Ss6@gondor.apana.org.au>
References: <20230307161947.857491-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307161947.857491-1-helgaas@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 07, 2023 at 10:19:41AM -0600, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> which appeared in v6.0, the PCI core has enabled PCIe error reporting for
> all devices during enumeration.
> 
> Remove driver code to do this (qat_4xxx) and remove unnecessary includes of
> <linux/aer.h> from several other drivers.
> 
> Bjorn Helgaas (6):
>   crypto: qat - drop redundant adf_enable_aer()
>   crypto: cavium/nitrox - remove unnecessary aer.h include
>   crypto: hisilicon/hpre - remove unnecessary aer.h include
>   crypto: hisilicon/qm - remove unnecessary aer.h include
>   crypto: hisilicon/sec - remove unnecessary aer.h include
>   crypto: hisilicon/zip - remove unnecessary aer.h include
> 
>  drivers/crypto/cavium/nitrox/nitrox_main.c    |  1 -
>  drivers/crypto/hisilicon/hpre/hpre_main.c     |  1 -
>  drivers/crypto/hisilicon/qm.c                 |  1 -
>  drivers/crypto/hisilicon/sec2/sec_main.c      |  1 -
>  drivers/crypto/hisilicon/zip/zip_main.c       |  1 -
>  drivers/crypto/qat/qat_4xxx/adf_drv.c         | 11 ++----
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  9 ++---
>  drivers/crypto/qat/qat_c62x/adf_drv.c         |  9 ++---
>  drivers/crypto/qat/qat_common/adf_aer.c       | 35 -------------------
>  .../crypto/qat/qat_common/adf_common_drv.h    |  2 --
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  9 ++---
>  11 files changed, 9 insertions(+), 71 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
