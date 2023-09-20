Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05518CE79AC
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 04:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjITE5R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 00:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjITE5R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 00:57:17 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ECA95
        for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 21:57:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qipGs-00GCqD-4W; Wed, 20 Sep 2023 12:57:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Sep 2023 12:57:09 +0800
Date:   Wed, 20 Sep 2023 12:57:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v4 1/2] crypto: qat - refactor included headers
Message-ID: <ZQp7pbYZ6t6Fy7cV@gondor.apana.org.au>
References: <20230911101939.86140-1-lucas.segarra.fernandez@intel.com>
 <20230911101939.86140-2-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911101939.86140-2-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 11, 2023 at 12:19:38PM +0200, Lucas Segarra Fernandez wrote:
> Include missing headers for GENMASK(), kstrtobool() and types.
> 
> Add forward declaration for struct adf_accel_dev. Remove unneeded
> include.
> 
> This change doesn't introduce any function change.
> 
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c | 3 +++
>  drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h | 4 +++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
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

Please use linux/kernel.h in C files.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
