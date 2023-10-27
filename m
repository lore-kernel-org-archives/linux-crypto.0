Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6B6C25B47
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345648AbjJ0Kyt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345649AbjJ0Kys (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:54:48 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0846C9C
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:54:46 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKUD-00Bead-Iy; Fri, 27 Oct 2023 18:54:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:54:47 +0800
Date:   Fri, 27 Oct 2023 18:54:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2 00/11] crypto: qat - add rate limiting feature to
 qat_4xxx
Message-ID: <ZTuW9021lj8iut8j@gondor.apana.org.au>
References: <20231020134931.7530-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020134931.7530-1-damian.muszynski@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 03:49:20PM +0200, Damian Muszynski wrote:
> This set enables hardware rate limiting capabilities on QAT 4xxx
> accelerators. Rate Limiting allows to control the rate of the requests
> that can be submitted to a ring pair (RP). This allows sharing
> a QAT device among multiple users while ensuring guaranteed throughput.
> 
> The driver provides a mechanism that allows users to set policies, through
> a sysfs interface, that are then programmed to the device. The device is
> then enforcing the policies.
> 
> The first six commits are refactoring and additions in preparation for
>   the feature.
> Patch #6 introduces a mechanism for retrieving firmware feature
>   capabilities.
> Patch #8 implements the core of the rate limiting feature by providing
>   mechanisms to set rate limiting policies (aka SLAs).
> The final three commits add the required sysfs interface that allow
>   users to configure SLAs.
> 
> Changes since v1:
> - Removed unnecessary check
> - Simplified a few error paths
> - Reduced a few local variables
> - Fixed repeated error message
> - Moved mutex lock above sla_id existence check.
> - Added Reviewed-by tag from Tero Kristo received from an internal review
>   of the set.
> 
> Ciunas Bennett (3):
>   crypto: qat - add rate limiting sysfs interface
>   crypto: qat - add rp2svc sysfs attribute
>   crypto: qat - add num_rps sysfs attribute
> 
> Damian Muszynski (4):
>   units: Add BYTES_PER_*BIT
>   crypto: qat - add bits.h to icp_qat_hw.h
>   crypto: qat - add retrieval of fw capabilities
>   crypto: qat - add rate limiting feature to qat_4xxx
> 
> Giovanni Cabiddu (4):
>   crypto: qat - refactor fw config related functions
>   crypto: qat - use masks for AE groups
>   crypto: qat - fix ring to service map for QAT GEN4
>   crypto: qat - move admin api
> 
>  Documentation/ABI/testing/sysfs-driver-qat    |   46 +
>  Documentation/ABI/testing/sysfs-driver-qat_rl |  227 ++++
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  190 ++-
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   13 +-
>  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
>  .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |    3 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   11 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |   71 +
>  .../crypto/intel/qat/qat_common/adf_admin.h   |   27 +
>  .../crypto/intel/qat/qat_common/adf_clock.c   |    1 +
>  .../intel/qat/qat_common/adf_cnv_dbgfs.c      |    1 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   10 -
>  .../intel/qat/qat_common/adf_fw_counters.c    |    1 +
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |    7 +
>  .../crypto/intel/qat/qat_common/adf_gen4_pm.c |    1 +
>  .../qat/qat_common/adf_gen4_pm_debugfs.c      |    1 +
>  .../intel/qat/qat_common/adf_gen4_timer.c     |    1 +
>  .../intel/qat/qat_common/adf_heartbeat.c      |    1 +
>  .../qat/qat_common/adf_heartbeat_dbgfs.c      |    1 +
>  .../crypto/intel/qat/qat_common/adf_init.c    |   13 +
>  drivers/crypto/intel/qat/qat_common/adf_rl.c  | 1169 +++++++++++++++++
>  drivers/crypto/intel/qat/qat_common/adf_rl.h  |  176 +++
>  .../intel/qat/qat_common/adf_rl_admin.c       |   97 ++
>  .../intel/qat/qat_common/adf_rl_admin.h       |   18 +
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   |   80 ++
>  .../intel/qat/qat_common/adf_sysfs_rl.c       |  451 +++++++
>  .../intel/qat/qat_common/adf_sysfs_rl.h       |   11 +
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |   41 +
>  .../crypto/intel/qat/qat_common/icp_qat_hw.h  |    2 +
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |    1 +
>  include/linux/units.h                         |    4 +
>  32 files changed, 2605 insertions(+), 73 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_rl
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_admin.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl_admin.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.h
> 
> 
> base-commit: 1bb03421eab67940b6509fe0869ff43df5fbe3e6
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
