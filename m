Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0F7EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 08:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbjGNI4L (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbjGNI4K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 04:56:10 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D42683
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 01:56:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qKEap-001Rgd-2t; Fri, 14 Jul 2023 18:56:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jul 2023 18:55:56 +1000
Date:   Fri, 14 Jul 2023 18:55:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2] crypto: qat - add fw_counters debugfs file
Message-ID: <ZLENnFXfOsFokq2F@gondor.apana.org.au>
References: <20230630153235.47867-1-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630153235.47867-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 30, 2023 at 05:32:07PM +0200, Lucas Segarra Fernandez wrote:
> Expose FW counters statistics by providing the "fw_counters" file
> under debugfs. Currently the statistics include the number of
> requests sent to the FW and the number of responses received
> from the FW for each Acceleration Engine, for all the QAT product
> line.
> 
> This patch is based on earlier work done by Marco Chiappero.
> 
> Co-developed-by: Adam Guerin <adam.guerin@intel.com>
> Signed-off-by: Adam Guerin <adam.guerin@intel.com>
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v1 -> v2:
> - Updated version and date in documentation
> ---
>  Documentation/ABI/testing/debugfs-driver-qat  |  10 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   1 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |  18 ++
>  .../intel/qat/qat_common/adf_common_drv.h     |   1 +
>  .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   7 +
>  .../intel/qat/qat_common/adf_fw_counters.c    | 264 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_fw_counters.h    |  11 +
>  8 files changed, 313 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-driver-qat
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_counters.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
