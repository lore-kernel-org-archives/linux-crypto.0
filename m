Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9083C4167B
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Dec 2022 11:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiLILG7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Dec 2022 06:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLILG6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2022 06:06:58 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1FC4D5FA
        for <linux-crypto@vger.kernel.org>; Fri,  9 Dec 2022 03:06:56 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p3bDQ-005gj2-4Q; Fri, 09 Dec 2022 19:06:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Dec 2022 19:06:52 +0800
Date:   Fri, 9 Dec 2022 19:06:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v3 00/12] crypto: qat - enable compression deflate
 algorithm
Message-ID: <Y5MWzD4CpyprQy+p@gondor.apana.org.au>
References: <20221128122123.130459-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128122123.130459-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 28, 2022 at 12:21:11PM +0000, Giovanni Cabiddu wrote:
> This set enables the offload of the compression deflate algorithm to QAT
> accelerators through the acomp API.
> 
> The first part of the set (patches 1 to 8) reworks and refactors logic
> that is specific to the crypto service in order to be used by the
> compression service.
> In particular, the first 6 patches rework the buffer list logic, which
> is used to map, unmap and convert scatterlists into the format that the
> QAT firmware can understand. These relocate the bufferlist logic to a
> separate file, change the interfaces so that the logic is service
> agnostic (not tied to compression or crypto) and extend the interface to
> allow an additional pre-allocated buffer for each destination scatter list
> which will be used to avoid premature overflows reported by the compression
> hardware.
> Patch 7 relocates the function qat_algs_alloc_flags() from a crypto
> specific header to qat_bl.h.
> Patch 8 moves and renames the configuration function for GEN2,
> qat_crypto_dev_config(), to a new file, adf_gen2_config.h, which
> contains the configuration logic for both crypto and compression
> instances for QAT GEN2 devices.
> 
> The last 2 patches in the set introduce all the infrastructure required
> to enable the compression service in the QAT driver and expose it through
> the acomp APIs.
> In particular, patch 9 introduces the logic related to the creation
> and handling of compression instances and their configuration. In addition,
> it adds the back-end for qat_deflate to plug into acomp, including the logic
> to build descriptors for the newly added GEN2 compression firmware APIs.
> This was all kept in a single patch to avoid introducing unused logic in
> the QAT driver in previous patches.
> 
> Patch 10, extends the compression logic to support to QAT GEN4 devices.
> 
> Patch 11 extends the acomp api by defining the max size for the destination
> buffer when a request is submitted with NULL destination buffer.
> This value is then used in the followin patch.
> 
> Patch 12 implements the resubmission logic for decompression requests
> that is triggered if the destination buffer, allocated by the driver,
> is not sufficiently big to store the output from the operation.
> 
> Changes from v1:
>  - Implemented resubmission logic for decompression triggered when
>    the output buffer allocated by the driver is not sufficiently large to
>    store the result from the operation
>  - Renamed buffer list functions that are moved to the qat_bl module
> 
> Changes from v2:
>  - Reworked decompression re-submission logic. For decompression operations
>    submitted specifying NULL as destination buffer, resubmit once with a
>    destination buffer of size 128KB instead of retying multiple times
>    doubling every time the size of the destination buffer.
>  - Added define in acomp api to specify the destination maximum size.
> 
> Giovanni Cabiddu (12):
>   crypto: qat - relocate bufferlist logic
>   crypto: qat - rename bufferlist functions
>   crypto: qat - change bufferlist logic interface
>   crypto: qat - generalize crypto request buffers
>   crypto: qat - extend buffer list interface
>   crypto: qat - relocate backlog related structures
>   crypto: qat - relocate qat_algs_alloc_flags()
>   crypto: qat - rename and relocate GEN2 config function
>   crypto: qat - expose deflate through acomp api for QAT GEN2
>   crypto: qat - enable deflate for QAT GEN4
>   crypto: acomp - define max size for destination
>   crypto: qat - add resubmit logic for decompression
> 
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   4 +-
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   2 +-
>  drivers/crypto/qat/qat_4xxx/adf_drv.c         | 145 ++++++-
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |   4 +
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c        |   2 +-
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   4 +
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |   4 +
>  drivers/crypto/qat/qat_c62x/adf_drv.c         |   2 +-
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   4 +
>  drivers/crypto/qat/qat_common/Makefile        |   8 +-
>  .../crypto/qat/qat_common/adf_accel_devices.h |  14 +
>  .../crypto/qat/qat_common/adf_cfg_strings.h   |   1 +
>  .../crypto/qat/qat_common/adf_common_drv.h    |   9 +-
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   6 +
>  .../crypto/qat/qat_common/adf_gen2_config.c   | 206 +++++++++
>  .../crypto/qat/qat_common/adf_gen2_config.h   |  10 +
>  drivers/crypto/qat/qat_common/adf_gen2_dc.c   |  70 +++
>  drivers/crypto/qat/qat_common/adf_gen2_dc.h   |  10 +
>  drivers/crypto/qat/qat_common/adf_gen4_dc.c   |  83 ++++
>  drivers/crypto/qat/qat_common/adf_gen4_dc.h   |  10 +
>  drivers/crypto/qat/qat_common/adf_init.c      |  11 +
>  drivers/crypto/qat/qat_common/adf_sriov.c     |   4 +
>  drivers/crypto/qat/qat_common/icp_qat_fw.h    |  24 ++
>  .../crypto/qat/qat_common/icp_qat_fw_comp.h   | 404 ++++++++++++++++++
>  drivers/crypto/qat/qat_common/icp_qat_hw.h    |  66 +++
>  .../qat/qat_common/icp_qat_hw_20_comp.h       | 164 +++++++
>  .../qat/qat_common/icp_qat_hw_20_comp_defs.h  | 300 +++++++++++++
>  drivers/crypto/qat/qat_common/qat_algs.c      | 208 +--------
>  drivers/crypto/qat/qat_common/qat_algs_send.h |  16 +-
>  drivers/crypto/qat/qat_common/qat_bl.c        | 383 +++++++++++++++++
>  drivers/crypto/qat/qat_common/qat_bl.h        |  67 +++
>  drivers/crypto/qat/qat_common/qat_comp_algs.c | 344 +++++++++++++++
>  drivers/crypto/qat/qat_common/qat_comp_req.h  | 123 ++++++
>  .../crypto/qat/qat_common/qat_compression.c   | 297 +++++++++++++
>  .../crypto/qat/qat_common/qat_compression.h   |  37 ++
>  drivers/crypto/qat/qat_common/qat_crypto.c    | 120 +-----
>  drivers/crypto/qat/qat_common/qat_crypto.h    |  55 +--
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   4 +
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |   2 +-
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   4 +
>  include/crypto/acompress.h                    |   1 +
>  41 files changed, 2848 insertions(+), 384 deletions(-)
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_config.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_config.h
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_dc.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_dc.h
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_dc.c
>  create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_dc.h
>  create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_comp.h
>  create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h
>  create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp_defs.h
>  create mode 100644 drivers/crypto/qat/qat_common/qat_bl.c
>  create mode 100644 drivers/crypto/qat/qat_common/qat_bl.h
>  create mode 100644 drivers/crypto/qat/qat_common/qat_comp_algs.c
>  create mode 100644 drivers/crypto/qat/qat_common/qat_comp_req.h
>  create mode 100644 drivers/crypto/qat/qat_common/qat_compression.c
>  create mode 100644 drivers/crypto/qat/qat_common/qat_compression.h
> 
> -- 
> 2.38.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
