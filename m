Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2618BEB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 08:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbjGNI4b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbjGNI4a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 04:56:30 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE2E198A
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 01:56:29 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qKEbC-001Rgk-1X; Fri, 14 Jul 2023 18:56:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jul 2023 18:56:19 +1000
Date:   Fri, 14 Jul 2023 18:56:19 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v4 0/5] crypto: qat - add heartbeat feature
Message-ID: <ZLENs265lSwAzTKU@gondor.apana.org.au>
References: <20230630170356.177654-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630170356.177654-1-damian.muszynski@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 30, 2023 at 07:03:53PM +0200, Damian Muszynski wrote:
> This set introduces support for the QAT heartbeat feature. It allows
> detection whenever device firmware or acceleration unit will hang.
> We're adding this feature to allow our clients having a tool with
> they could verify if all of the Quick Assist hardware resources are
> healthy and operational.
> 
> QAT device firmware periodically writes counters to a specified physical
> memory location. A pair of counters per thread is incremented at
> the start and end of the main processing loop within the firmware.
> Checking for Heartbeat consists of checking the validity of the pair
> of counter values for each thread. Stagnant counters indicate
> a firmware hang.
> 
> The first patch adds timestamp synchronization to the firmware.
> The second patch removes historical and never used HB definitions.
> Patch no. 3 is implementing the hardware clock frequency measuring
> interface.
> The fourth introduces the main heartbeat implementation with the debugfs
> interface.
> The last patch implements an algorithm that allows the code to detect
> which version of heartbeat API is used at the currently loaded firmware.
> 
> Changes since v3:
> - improved comment in measure_clock() as suggested by Andy Shevchenko
> - changed release date and version for 6.6 in interface documentation
> 
> Changes since v2:
> - fixed build error on a few of architectures - reduced unnecessary
>   64bit division.
> 
> Changes since v1:
> - fixed build errors on a few of architectures - replaced macro
>   DIV_ROUND_CLOSEST with DIV_ROUND_CLOSEST_ULL
> - included prerequisite patch "add internal timer for qat 4xxx" which initially
>   was sent separately as this patchset was still in development.
>   - timer patch reworked to use delayed work as suggested by Herbert Xu
> 
> Damian Muszynski (5):
>   crypto: qat - add internal timer for qat 4xxx
>   crypto: qat - drop obsolete heartbeat interface
>   crypto: qat - add measure clock frequency
>   crypto: qat - add heartbeat feature
>   crypto: qat - add heartbeat counters check
> 
>  Documentation/ABI/testing/debugfs-driver-qat  |  51 +++
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  14 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   4 +
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   3 +
>  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  28 ++
>  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   7 +
>  .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |  28 ++
>  .../intel/qat/qat_c62x/adf_c62x_hw_data.h     |   7 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   4 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |  13 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |  43 +++
>  .../intel/qat/qat_common/adf_cfg_strings.h    |   2 +
>  .../crypto/intel/qat/qat_common/adf_clock.c   | 131 +++++++
>  .../crypto/intel/qat/qat_common/adf_clock.h   |  14 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   5 +
>  .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   9 +-
>  .../intel/qat/qat_common/adf_gen2_config.c    |   7 +
>  .../intel/qat/qat_common/adf_gen2_hw_data.h   |   3 +
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |   3 +
>  .../intel/qat/qat_common/adf_gen4_timer.c     |  70 ++++
>  .../intel/qat/qat_common/adf_gen4_timer.h     |  21 ++
>  .../intel/qat/qat_common/adf_heartbeat.c      | 336 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_heartbeat.h      |  79 ++++
>  .../qat/qat_common/adf_heartbeat_dbgfs.c      | 194 ++++++++++
>  .../qat/qat_common/adf_heartbeat_dbgfs.h      |  12 +
>  .../crypto/intel/qat/qat_common/adf_init.c    |  28 ++
>  drivers/crypto/intel/qat/qat_common/adf_isr.c |   6 +
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |  23 +-
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  13 +
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   5 +
>  30 files changed, 1147 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.h
> 
> 
> base-commit: 67b9bc0df80cfa241fe7a9c2b857c3e3efde982a
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
