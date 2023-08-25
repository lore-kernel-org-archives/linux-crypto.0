Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B7EC71133
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 10:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbjHYKjs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Aug 2023 06:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244613AbjHYKjn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2023 06:39:43 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3ADE67;
        Fri, 25 Aug 2023 03:39:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZUE3-007iHM-5D; Fri, 25 Aug 2023 18:39:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Aug 2023 18:39:36 +0800
Date:   Fri, 25 Aug 2023 18:39:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, andriy.shevchenko@intel.com, alx@kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat - add pm_status debugfs file
Message-ID: <ZOiE6GMY5Qb2S53A@gondor.apana.org.au>
References: <20230818102322.142582-1-lucas.segarra.fernandez@intel.com>
 <20230818102322.142582-3-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818102322.142582-3-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 18, 2023 at 12:23:09PM +0200, Lucas Segarra Fernandez wrote:
>
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
> index 3bde8759c2a2..911aca862798 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
> @@ -1,8 +1,15 @@
>  // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
>  /* Copyright(c) 2022 Intel Corporation */
>  #include <linux/bitfield.h>
> +#include <linux/bits.h>

This is redundant if you include linux/kernel.

> +#include <linux/dma-mapping.h>
> +#include <linux/fs.h>
>  #include <linux/iopoll.h>
>  #include <linux/kstrtox.h>
> +#include <linux/slab.h>
> +#include <linux/stddef.h>

So is this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
