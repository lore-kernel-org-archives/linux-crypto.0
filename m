Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E07BCE79AC
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 04:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjITE6p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 00:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjITE6o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 00:58:44 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB05495
        for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 21:58:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qipIH-00GCrA-Mk; Wed, 20 Sep 2023 12:58:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Sep 2023 12:58:36 +0800
Date:   Wed, 20 Sep 2023 12:58:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v2] crypto: qat - add cnv_errors debugfs file
Message-ID: <ZQp7/Jn8Ks66v31e@gondor.apana.org.au>
References: <20230911104111.87940-1-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911104111.87940-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 11, 2023 at 12:41:11PM +0200, Lucas Segarra Fernandez wrote:
>
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
> new file mode 100644
> index 000000000000..693ef3d47369
> --- /dev/null
> +++ b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
> @@ -0,0 +1,296 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Intel Corporation */
> +
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +#include <linux/debugfs.h>
> +#include <linux/kernel.h>

linux/bits.h is unnecessary if you already included kernel.h.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
