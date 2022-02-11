Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EFCC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345809AbiBKJfm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:35:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiBKJfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:35:42 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4847F5B;
        Fri, 11 Feb 2022 01:35:40 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nISL0-0004RH-BA; Fri, 11 Feb 2022 20:35:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:35:34 +1100
Date:   Fri, 11 Feb 2022 20:35:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wojciech Ziemba <wojciech.ziemba@intel.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com
Subject: Re: [PATCH 0/3] Introduce support for QAT Dynamic Power Management
Message-ID: <YgYt5tFt+0CD/0V3@gondor.apana.org.au>
References: <20220203135434.584967-1-wojciech.ziemba@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203135434.584967-1-wojciech.ziemba@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 03, 2022 at 01:54:31PM +0000, Wojciech Ziemba wrote:
> This patch set consist of following updates:
> 1. Add misc workqueue for general purpose usage.
> 2. Move error source related CSRs from 4xxx to the wider GEN4 header
> file.
> 3. Add support for HW QAT Power Management (PM) feature.
> 	This feature is enabled at init time (1) by sending an admin
> message to
> 	the firmware, targeting the admin AE, that sets the idle time
> before
> 	the device changes state and (2) by unmasking the PM source of
> 	interrupt in ERRMSK2.
> 
> 	The interrupt handler is extended to handle a PM interrupt which
> 	is triggered by HW when a PM transition occurs. In this case,
> the
> 	driver responds acknowledging the transaction using the HOST_MSG
> 	mailbox.
> 
> 
> Wojciech Ziemba (3):
>   crypto: qat - add misc workqueue
>   crypto: qat - move and rename GEN4 error register definitions
>   crypto: qat - enable power management for QAT GEN4
> 
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  21 +--
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |  24 ---
>  drivers/crypto/qat/qat_common/Makefile        |   1 +
>  .../crypto/qat/qat_common/adf_accel_devices.h |   2 +
>  drivers/crypto/qat/qat_common/adf_admin.c     |  37 +++++
>  .../crypto/qat/qat_common/adf_common_drv.h    |   4 +
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   6 +
>  .../crypto/qat/qat_common/adf_gen4_hw_data.h  |  14 ++
>  drivers/crypto/qat/qat_common/adf_gen4_pm.c   | 137 ++++++++++++++++++
>  drivers/crypto/qat/qat_common/adf_gen4_pm.h   |  44 ++++++
>  drivers/crypto/qat/qat_common/adf_init.c      |   6 +
>  drivers/crypto/qat/qat_common/adf_isr.c       |  42 ++++++
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |   1 +
>  13 files changed, 306 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pm.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pm.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
