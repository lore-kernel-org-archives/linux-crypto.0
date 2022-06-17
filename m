Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF2DC43334
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jun 2022 09:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380986AbiFQJVd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 05:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380990AbiFQJVT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 05:21:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EAB5D19D;
        Fri, 17 Jun 2022 02:21:18 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o28AE-008Bxw-Gb; Fri, 17 Jun 2022 19:21:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jun 2022 17:21:14 +0800
Date:   Fri, 17 Jun 2022 17:21:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        wangzhou1@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH 0/3] crypto: hisilicon/qm - modify event interrupt
 processing
Message-ID: <YqxHikeZu6n9gEs+@gondor.apana.org.au>
References: <20220609123119.27252-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609123119.27252-1-qianweili@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 09, 2022 at 08:31:16PM +0800, Weili Qian wrote:
> This patchset contains following updates:
> 1. Modify accelerator devices event irq processing.
> 2. Some cleanups.
> 
> Weili Qian (3):
>   crypto: hisilicon/qm - add functions for releasing resources
>   crypto: hisilicon/qm - move alloc qm->wq to qm.c
>   crypto: hisilicon/qm - modify event irq processing
> 
>  drivers/crypto/hisilicon/qm.c            | 203 +++++++++++++++--------
>  drivers/crypto/hisilicon/sec2/sec_main.c |  24 +--
>  drivers/crypto/hisilicon/zip/zip_main.c  |  17 +-
>  include/linux/hisi_acc_qm.h              |   8 +-
>  4 files changed, 141 insertions(+), 111 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
