Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954DFC56201
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 06:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47CE022203
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 06:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgJ3Gtu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 02:49:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60510 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgJ3Gtu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 02:49:50 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kYOEO-0004sZ-1p; Fri, 30 Oct 2020 17:49:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2020 17:49:48 +1100
Date:   Fri, 30 Oct 2020 17:49:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 00/31] crypto: qat - rework in preparation for qat_4xxx
 driver
Message-ID: <20201030064947.GF25453@gondor.apana.org.au>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 12, 2020 at 09:38:16PM +0100, Giovanni Cabiddu wrote:
> This set is an initial rework of the QAT driver in preparation for the
> inclusion of the qat_4xxx driver (QAT GEN4).
> 
> Summary of changes:
>   * IV update logic moved to software to remove allocation of the IV
>     buffer in the data-path and allow for devices that are not capable
>     of updating it when performing AES-CBC or AES-CTR.
>   * Added logic to detect the presence of engines and accelerators via
>     soft-straps and fuse registers.
>   * Added infrastructure to support devices with an arbitrary number of
>     rings per bank.
>   * Introduced adf_gen2_hw_data.[c|h] that contain logic that is common
>     between QAT GEN2 devices (c62x, c3xxx and dh895xcc).
>   * Abstracted logic that configures iov threads.
>   * Abstracted access to transport CSRs.
>   * Abstracted, refactored and updated admin interface logic.
>   * Abstracted and refactored arbiter logic.
>   * Changed sequence on how arbitration is enabled on rings.
>   * Added support for device capability detection.
>   * Replaced hardcoded masks.
>   * Changed logic in adf_sriov.c to allow for drivers that do not
>     implement some of the functions of that module.
>   * Refactored logic related to device configuration and instance
>     creation.
>   * Changed logic to allow for instances in different banks.
>   * Extended accelerator mask.
> 
> Ahsan Atta (1):
>   crypto: qat - num_rings_per_bank is device dependent
> 
> Giovanni Cabiddu (28):
>   crypto: qat - mask device capabilities with soft straps
>   crypto: qat - fix configuration of iov threads
>   crypto: qat - split transport CSR access logic
>   crypto: qat - relocate GEN2 CSR access code
>   crypto: qat - abstract admin interface
>   crypto: qat - add packed to init admin structures
>   crypto: qat - rename ME in AE
>   crypto: qat - change admin sequence
>   crypto: qat - use admin mask to send fw constants
>   crypto: qat - update constants table
>   crypto: qat - remove writes into WQCFG
>   crypto: qat - remove unused macros in arbiter module
>   crypto: qat - abstract arbiter access
>   crypto: qat - register crypto instances based on capability
>   crypto: qat - enable ring after pair is programmed
>   crypto: qat - abstract build ring base
>   crypto: qat - replace constant masks with GENMASK
>   crypto: qat - use BIT_ULL() - 1 pattern for masks
>   crypto: qat - abstract writes to arbiter enable
>   crypto: qat - remove hardcoded bank irq clear flag mask
>   crypto: qat - call functions in adf_sriov if available
>   crypto: qat - remove unnecessary void* casts
>   crypto: qat - change return value in adf_cfg_add_key_value_param()
>   crypto: qat - change return value in adf_cfg_key_val_get()
>   crypto: qat - refactor qat_crypto_create_instances()
>   crypto: qat - refactor qat_crypto_dev_config()
>   crypto: qat - allow for instances in different banks
>   crypto: qat - extend ae_mask
> 
> Marco Chiappero (2):
>   crypto: qat - update IV in software
>   crypto: qat - add support for capability detection
> 
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  49 ++++-
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |   5 +
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  11 +-
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   7 +-
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |   4 +-
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  49 ++++-
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |   5 +
>  drivers/crypto/qat/qat_c62x/adf_drv.c         |  11 +-
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   7 +-
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       |   4 +-
>  drivers/crypto/qat/qat_common/Makefile        |   1 +
>  .../crypto/qat/qat_common/adf_accel_devices.h |  58 +++++-
>  drivers/crypto/qat/qat_common/adf_admin.c     |  77 ++++----
>  drivers/crypto/qat/qat_common/adf_cfg.c       |   4 +-
>  .../crypto/qat/qat_common/adf_cfg_strings.h   |   3 +-
>  .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 181 ++++++++++++++++++
>  .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 123 ++++++++++++
>  .../crypto/qat/qat_common/adf_hw_arbiter.c    |  94 ++++-----
>  drivers/crypto/qat/qat_common/adf_isr.c       |   4 +-
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  74 ++-----
>  drivers/crypto/qat/qat_common/adf_transport.c | 130 +++++++++----
>  .../qat_common/adf_transport_access_macros.h  |  67 -------
>  .../qat/qat_common/adf_transport_debug.c      |  32 ++--
>  .../qat/qat_common/adf_transport_internal.h   |   2 +-
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    |   5 +-
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |   6 +-
>  drivers/crypto/qat/qat_common/icp_qat_hw.h    |  23 +++
>  drivers/crypto/qat/qat_common/qat_algs.c      | 136 +++++++------
>  drivers/crypto/qat/qat_common/qat_crypto.c    | 162 ++++++++++------
>  drivers/crypto/qat/qat_common/qat_crypto.h    |  26 ++-
>  drivers/crypto/qat/qat_common/qat_hal.c       |  27 +--
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  60 +++++-
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   5 +
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |   9 +-
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   7 +-
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |   4 +-
>  36 files changed, 1024 insertions(+), 448 deletions(-)
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
