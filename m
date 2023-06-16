Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B79EB64D8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 12:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbjFPMfN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 08:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344762AbjFPMfM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 08:35:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4E6268A
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2023 05:35:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qA8fS-003p0N-32; Fri, 16 Jun 2023 20:35:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jun 2023 20:35:06 +0800
Date:   Fri, 16 Jun 2023 20:35:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Adam Guerin <adam.guerin@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/4] crypto: qat - extend configuration for 4xxx
Message-ID: <ZIxW+vU/Jdq5HxvJ@gondor.apana.org.au>
References: <20230609163821.6533-1-adam.guerin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609163821.6533-1-adam.guerin@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 05:38:18PM +0100, Adam Guerin wrote:
> This set extends the configuration of the device to accept more
> variations of the configurable services and the device is configured
> correctly based on the configured service. Refactoring the FW config
> logic to avoid duplication. Loading the correct FW based on the type and
> configuration of the device also reporting the correct capabilities
> for the configured service.
> 
> Adam Guerin (2):
>   crypto: qat - move returns to default case
>   crypto: qat - extend configuration for 4xxx
> 
> Giovanni Cabiddu (2):
>   crypto: qat - make fw images name constant
>   crypto: qat - refactor fw config logic for 4xxx
> 
>  Documentation/ABI/testing/sysfs-driver-qat    |  11 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 229 +++++++++++++-----
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  33 +++
>  .../intel/qat/qat_common/adf_accel_devices.h  |   2 +-
>  .../intel/qat/qat_common/adf_accel_engine.c   |   2 +-
>  .../intel/qat/qat_common/adf_cfg_strings.h    |   7 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   2 +-
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   |   7 +
>  .../crypto/intel/qat/qat_common/qat_algs.c    |   1 -
>  .../crypto/intel/qat/qat_common/qat_uclo.c    |   8 +-
>  10 files changed, 231 insertions(+), 71 deletions(-)
> 
> 
> base-commit: 6b5755b35497de5e8ed17772f7b0dd1bbe19cbee
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
