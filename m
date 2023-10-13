Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9F3CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 10:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjJMKg7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 06:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjJMKg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 06:36:57 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72FDD7
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 03:36:54 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qrFXF-006jZL-H4; Fri, 13 Oct 2023 18:36:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Oct 2023 18:36:54 +0800
Date:   Fri, 13 Oct 2023 18:36:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v6 0/2] Add debugfs pm_status for qat driver
Message-ID: <ZSkdxnt+HEXOnK8D@gondor.apana.org.au>
References: <20231004100920.33705-1-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004100920.33705-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 04, 2023 at 12:09:18PM +0200, Lucas Segarra Fernandez wrote:
> Add debugfs pm_status.
> 
> Expose power management info by providing the "pm_status" file under
> debugfs.
> 
> ---
> v5 -> v6:
> - include kernel.h in adf_gen4_pm_debugfs.c
> - fit to ~80 chars
> - alphabetical order for intel_qat-$(CONFIG_DEBUG_FS) makefile target
> ---
> v4 -> v5:
> - use linux/kernel.h in C files
> ---
> v3 -> v4:
> - init variable `len` at adf_gen4_print_pm_status()
> ---
> v2 -> v3:
> - Move debugfs Power Management GEN4 specific logic to adf_gen4_pm_debugfs.c,
> this fixes error building with CONFIG_DEBUG_FS=n
> - increase doc's Date and KernelVersion
> ---
> v1 -> v2:
> - Add constant ICP_QAT_NUMBER_OF_PM_EVENTS, rather than ARRAY_SIZE_OF_FIELD()
> ---
> 
> Lucas Segarra Fernandez (2):
>   crypto: qat - refactor included headers
>   crypto: qat - add pm_status debugfs file
> 
>  Documentation/ABI/testing/debugfs-driver-qat  |   9 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |  13 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |  27 ++
>  .../intel/qat/qat_common/adf_common_drv.h     |   1 +
>  .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   3 +
>  .../crypto/intel/qat/qat_common/adf_gen4_pm.c |  26 +-
>  .../crypto/intel/qat/qat_common/adf_gen4_pm.h |  50 +++-
>  .../qat/qat_common/adf_gen4_pm_debugfs.c      | 265 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_pm_dbgfs.c       |  48 ++++
>  .../intel/qat/qat_common/adf_pm_dbgfs.h       |  12 +
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |  35 +++
>  12 files changed, 485 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.h
> 
> 
> base-commit: 7ae976c427d2d9a82164b32d19a54c07ac9bc6e2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
