Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7618C88CB2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 10:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242774AbjHYKgf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Aug 2023 06:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244453AbjHYKgX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2023 06:36:23 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACB810FE;
        Fri, 25 Aug 2023 03:36:19 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZUAl-007iDL-A8; Fri, 25 Aug 2023 18:36:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Aug 2023 18:36:12 +0800
Date:   Fri, 25 Aug 2023 18:36:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, andriy.shevchenko@intel.com, alx@kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: qat - refactor included headers
Message-ID: <ZOiEHCsjBCL04Z3x@gondor.apana.org.au>
References: <20230818102322.142582-1-lucas.segarra.fernandez@intel.com>
 <20230818102322.142582-2-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818102322.142582-2-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 18, 2023 at 12:23:08PM +0200, Lucas Segarra Fernandez wrote:
>
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
> index 34c6cd8e27c0..3bde8759c2a2 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
> @@ -2,6 +2,9 @@
>  /* Copyright(c) 2022 Intel Corporation */
>  #include <linux/bitfield.h>
>  #include <linux/iopoll.h>
> +#include <linux/kstrtox.h>
> +#include <linux/types.h>

Please include linux/kernel.h instead of these two.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
