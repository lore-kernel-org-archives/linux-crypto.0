Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF72EC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Dec 2021 03:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351153AbhLXDZv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 22:25:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58456 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234131AbhLXDZu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 22:25:50 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n0bDE-0006KZ-QF; Fri, 24 Dec 2021 14:25:45 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Dec 2021 14:25:44 +1100
Date:   Fri, 24 Dec 2021 14:25:44 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Marco Chiappero <marco.chiappero@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com
Subject: Re: [PATCH 00/24] crypto: qat - PFVF updates and improved GEN4
 support
Message-ID: <YcU9uBxlskOKcnVe@gondor.apana.org.au>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 16, 2021 at 09:13:10AM +0000, Marco Chiappero wrote:
> This set mainly revolves around PFVF and support for compression on GEN4
> devices.
> 
> Along with misc quality improvements to the PFVF code, it includes the
> following major changes:
> * Improved detection of HW capabilities for both GEN2 and GEN4 devices
> * PFVF protocol updates, up to version 4, which include Block Messages
>   and Fast ACK
> * PFVF support for the GEN4 host driver
> * Support for enabling and reporting the compression service on GEN4
>   devices
> * Support for Ring Pair reset by VFs on GEN4 devices
> * The refactoring of PFVF code to allow for the introduction of GEN4
>   support
> 
> Giovanni Cabiddu (5):
>   crypto: qat - get compression extended capabilities
>   crypto: qat - set CIPHER capability for QAT GEN2
>   crypto: qat - set COMPRESSION capability for QAT GEN2
>   crypto: qat - extend crypto capability detection for 4xxx
>   crypto: qat - allow detection of dc capabilities for 4xxx
> 
> Marco Chiappero (18):
>   crypto: qat - support the reset of ring pairs on PF
>   crypto: qat - add the adf_get_pmisc_base() helper function
>   crypto: qat - make PFVF message construction direction agnostic
>   crypto: qat - make PFVF send and receive direction agnostic
>   crypto: qat - set PFVF_MSGORIGIN just before sending
>   crypto: qat - abstract PFVF messages with struct pfvf_message
>   crypto: qat - leverage bitfield.h utils for PFVF messages
>   crypto: qat - leverage read_poll_timeout in PFVF send
>   crypto: qat - improve the ACK timings in PFVF send
>   crypto: qat - store the PFVF protocol version of the endpoints
>   crypto: qat - store the ring-to-service mapping
>   crypto: qat - introduce support for PFVF block messages
>   crypto: qat - exchange device capabilities over PFVF
>   crypto: qat - support fast ACKs in the PFVF protocol
>   crypto: qat - exchange ring-to-service mappings over PFVF
>   crypto: qat - config VFs based on ring-to-svc mapping
>   crypto: qat - add PFVF support to the GEN4 host driver
>   crypto: qat - add PFVF support to enable the reset of ring pairs
> 
> Tomasz Kowalik (1):
>   crypto: qat - add support for compression for 4xxx
> 
>  drivers/crypto/qat/Kconfig                    |   1 +
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 145 ++++++--
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   2 +
>  drivers/crypto/qat/qat_4xxx/adf_drv.c         |  33 ++
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |   1 +
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   1 +
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |   4 -
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |   1 +
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   1 +
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       |   4 -
>  drivers/crypto/qat/qat_common/Makefile        |   4 +-
>  .../crypto/qat/qat_common/adf_accel_devices.h |  28 +-
>  .../crypto/qat/qat_common/adf_accel_engine.c  |   8 +-
>  drivers/crypto/qat/qat_common/adf_admin.c     |  47 ++-
>  drivers/crypto/qat/qat_common/adf_cfg.c       |   1 +
>  .../crypto/qat/qat_common/adf_cfg_common.h    |  13 +
>  .../crypto/qat/qat_common/adf_cfg_strings.h   |   3 +
>  .../crypto/qat/qat_common/adf_common_drv.h    |  12 +
>  .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  57 ++--
>  .../crypto/qat/qat_common/adf_gen2_hw_data.h  |   9 +
>  drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 316 +++++++++++++-----
>  .../crypto/qat/qat_common/adf_gen4_hw_data.c  |  62 +++-
>  .../crypto/qat/qat_common/adf_gen4_hw_data.h  |  17 +
>  drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 148 ++++++++
>  drivers/crypto/qat/qat_common/adf_gen4_pfvf.h |  17 +
>  drivers/crypto/qat/qat_common/adf_init.c      |   9 +-
>  drivers/crypto/qat/qat_common/adf_isr.c       |  28 +-
>  drivers/crypto/qat/qat_common/adf_pfvf_msg.h  | 202 +++++++++--
>  .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   |  35 +-
>  .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |   8 +
>  .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 262 +++++++++++++--
>  .../crypto/qat/qat_common/adf_pfvf_pf_proto.h |   2 +-
>  .../crypto/qat/qat_common/adf_pfvf_utils.c    |  65 ++++
>  .../crypto/qat/qat_common/adf_pfvf_utils.h    |  31 ++
>  .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   |  98 +++++-
>  .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |   2 +
>  .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 284 ++++++++++++++--
>  .../crypto/qat/qat_common/adf_pfvf_vf_proto.h |   7 +-
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  39 ++-
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    |  14 +-
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |   4 +-
>  drivers/crypto/qat/qat_common/icp_qat_hw.h    |  13 +-
>  drivers/crypto/qat/qat_common/qat_crypto.c    |  25 ++
>  drivers/crypto/qat/qat_common/qat_hal.c       |  41 +--
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   3 +
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   1 +
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |   4 -
>  47 files changed, 1776 insertions(+), 336 deletions(-)
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pfvf.h
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_utils.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_utils.h
> 
> -- 
> 2.31.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
