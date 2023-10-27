Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB812C25B67
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345549AbjJ0Ky3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345691AbjJ0Ky1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:54:27 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D743B9C
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:54:24 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKTr-00BeYm-Tj; Fri, 27 Oct 2023 18:54:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:54:26 +0800
Date:   Fri, 27 Oct 2023 18:54:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shashank Gupta <shashank.gupta@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/9] add ras error detection and reporting for GEN4
 devices
Message-ID: <ZTuW4nKoYQ6pKK76@gondor.apana.org.au>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 11:32:44AM +0100, Shashank Gupta wrote:
> This set introduces the required infrastructure to detect, report, and count errors in the QAT drivers and enables the reporting of errors in QAT GEN4 devices.
> In particular, it enables the reporting of correctable, nonfatal, and fatal errors.
> In addition, exposes the number of occurrences of each type of error through sysfs.
> 
> The first patch adds the common infrastructures for error reporting for all generations of QAT.
> Patches from 2 to 5 and 7 enable the reporting of errors flagged through the register ERRSOUx for GEN4 devices.
> ERRSOUx error reporting for GEN4 devices.
> Patch 6 adds a helper to retrieve the base address of the aram bar.
> Patch 8 introduces the ras counter interface for counting QAT-specific errors, and exposes such counters through sysfs.
> Patch 9 adds logic to count correctable, nonfatal, and fatal errors for GEN4 devices.
> 
> Shashank Gupta (9):
>   crypto: qat - add infrastructure for error reporting
>   crypto: qat - add reporting of correctable errors for QAT GEN4
>   crypto: qat - add reporting of errors from ERRSOU1 for QAT GEN4
>   crypto: qat - add handling of errors from ERRSOU2 for QAT GEN4
>   crypto: qat - add handling of compression related errors for QAT GEN4
>   crypto: qat - add adf_get_aram_base() helper function
>   crypto: qat - add handling of errors from ERRSOU3 for QAT GEN4
>   crypto: qat - add error counters
>   crypto: qat - count QAT GEN4 errors
> 
>  .../ABI/testing/sysfs-driver-qat_ras          |   42 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   13 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   17 +
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |    1 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |    2 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   34 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   10 +
>  .../intel/qat/qat_common/adf_gen4_ras.c       | 1566 +++++++++++++++++
>  .../intel/qat/qat_common/adf_gen4_ras.h       |  825 +++++++++
>  .../crypto/intel/qat/qat_common/adf_init.c    |    9 +
>  drivers/crypto/intel/qat/qat_common/adf_isr.c |   18 +
>  .../qat/qat_common/adf_sysfs_ras_counters.c   |  112 ++
>  .../qat/qat_common/adf_sysfs_ras_counters.h   |   28 +
>  13 files changed, 2677 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_ras
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.h
> 
> -- 
> 2.41.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
