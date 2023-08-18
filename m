Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458F0C678DC
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 08:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358463AbjHRINf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 04:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358483AbjHRIN2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 04:13:28 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70332D73
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 01:13:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWubR-005E3K-Ce; Fri, 18 Aug 2023 16:13:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 16:13:06 +0800
Date:   Fri, 18 Aug 2023 16:13:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, shenyang39@huawei.com,
        liulongfang@huawei.com
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
Message-ID: <ZN8oEpUBq87m+r++@gondor.apana.org.au>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811140749.5202-2-qianweili@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 11, 2023 at 10:07:43PM +0800, Weili Qian wrote:
> The malibox needs to be triggered by a 128bit atomic operation. The
> reason is that one QM hardware entity in one accelerator servers QM
> mailbox MMIO interfaces in related PF and VFs. A mutex cannot lock
> mailbox processes in different functions. When multiple functions access
> the mailbox simultaneously, if the generic IO interface readq/writeq
> is used to access the mailbox, the data read from mailbox or written to
> mailbox is unpredictable. Therefore, the generic IO interface is changed
> to a 128bit atomic operation.
> 
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 160 ++++++++++++++++++++++------------
>  include/linux/hisi_acc_qm.h   |   1 -
>  2 files changed, 105 insertions(+), 56 deletions(-)
>  mode change 100644 => 100755 drivers/crypto/hisilicon/qm.c

...

> -	qm_mb_write(qm, mailbox);
> +#if IS_ENABLED(CONFIG_ARM64)
> +	asm volatile("ldp %0, %1, %3\n"
> +		     "stp %0, %1, %2\n"
> +		     "dmb oshst\n"
> +		     : "=&r" (tmp0),
> +		       "=&r" (tmp1),
> +		       "+Q" (*((char *)dst))
> +		     : "Q" (*((char __iomem *)fun_base))
> +		     : "memory");
> +#endif

You should add a generic 128-bite write primitive for arm64 instead
of doing it in raw assembly in the driver.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
