Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91736CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 10:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjJMKhH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 06:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjJMKhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 06:37:06 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748ACA
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 03:37:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qrFXO-006jZS-Ty; Fri, 13 Oct 2023 18:37:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Oct 2023 18:37:03 +0800
Date:   Fri, 13 Oct 2023 18:37:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v4] crypto: qat - add cnv_errors debugfs file
Message-ID: <ZSkdzy9EHeeFRxBm@gondor.apana.org.au>
References: <20231004103642.37876-1-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004103642.37876-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 04, 2023 at 12:36:42PM +0200, Lucas Segarra Fernandez wrote:
> The Compress and Verify (CnV) feature check and ensures data integrity
> in the compression operation. The implementation of CnV keeps a record
> of the CnV errors that have occurred since the driver was loaded.
> 
> Expose CnV error stats by providing the "cnv_errors" file under
> debugfs. This includes the number of errors detected up to now and
> the type of the last error. The error count is provided on a per
> Acceleration Engine basis and it is reset every time the driver is loaded.
> 
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> v3 -> v4:
> - rebase on top of latest version (v6) of crypto: qat - add pm_status debugfs file
> - alphabetical order for intel_qat-$(CONFIG_DEBUG_FS) makefile target
> ---
> v2 -> v3:
> - remove unneeded header inclussion
> ---
> v1 -> v2:
> - Rebase on top of latest version (v4) of crypto: qat - add pm_status debugfs file
> ---
>  Documentation/ABI/testing/debugfs-driver-qat  |  13 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   1 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |  21 ++
>  .../intel/qat/qat_common/adf_cnv_dbgfs.c      | 299 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_cnv_dbgfs.h      |  11 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   1 +
>  .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   3 +
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |   5 +
>  9 files changed, 355 insertions(+)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
