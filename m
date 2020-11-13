Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF1DC4742C
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 05:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E82B220B80
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 05:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgKMFKq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 00:10:46 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33708 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgKMFKq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 00:10:46 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kdRMB-0000sT-KT; Fri, 13 Nov 2020 16:10:44 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2020 16:10:43 +1100
Date:   Fri, 13 Nov 2020 16:10:43 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jack Xu <jack.xu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 00/32] crypto: qat - rework firmware loader in
 preparation for qat_4xxx
Message-ID: <20201113051043.GE8350@gondor.apana.org.au>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 06, 2020 at 07:27:38PM +0800, Jack Xu wrote:
> Rework firmware loader in QAT driver in preparation for the support of the qat_4xxx driver.
> 
> Patch #1 add support for the mof format in the firmware loader
> Patches from #2 to #7 introduce some general fixes
> Patches from #8 to #30 rework and refactor the firmware loader to support the new features added by the next generation of QAT devices (QAT GEN4)
> Patch #31 introduces the firmware loader changes to support QAT GEN4 devices
> 
> Giovanni Cabiddu (1):
>   crypto: qat - support for mof format in fw loader
> 
> Jack Xu (31):
>   crypto: qat - loader: fix status check in qat_hal_put_rel_rd_xfer()
>   crypto: qat - loader: fix CSR access
>   crypto: qat - loader: fix error message
>   crypto: qat - loader: remove unnecessary parenthesis
>   crypto: qat - loader: introduce additional parenthesis
>   crypto: qat - loader: rename qat_uclo_del_uof_obj()
>   crypto: qat - loader: add support for relative FW ucode loading
>   crypto: qat - loader: change type for ctx_mask
>   crypto: qat - loader: change micro word data mask
>   crypto: qat - loader: refactor AE start
>   crypto: qat - loader: remove global CSRs helpers
>   crypto: qat - loader: move defines to header files
>   crypto: qat - loader: refactor qat_uclo_set_ae_mode()
>   crypto: qat - loader: refactor long expressions
>   crypto: qat - loader: introduce chip info structure
>   crypto: qat - loader: replace check based on DID
>   crypto: qat - loader: add next neighbor to chip_info
>   crypto: qat - loader: add support for lm2 and lm3
>   crypto: qat - loader: add local memory size to chip info
>   crypto: qat - loader: add reset CSR and mask to chip info
>   crypto: qat - loader: add clock enable CSR to chip info
>   crypto: qat - loader: add wake up event to chip info
>   crypto: qat - loader: add misc control CSR to chip info
>   crypto: qat - loader: add check for null pointer
>   crypto: qat - loader: use ae_mask
>   crypto: qat - loader: add CSS3K support
>   crypto: qat - loader: add FCU CSRs to chip info
>   crypto: qat - loader: allow to target specific AEs
>   crypto: qat - loader: add support for shared ustore
>   crypto: qat - loader: add support for broadcasting mode
>   crypto: qat - loader: add gen4 firmware loader
> 
>  .../crypto/qat/qat_common/adf_accel_devices.h |   2 +
>  .../crypto/qat/qat_common/adf_accel_engine.c  |  13 +-
>  .../crypto/qat/qat_common/adf_common_drv.h    |  19 +-
>  .../qat/qat_common/icp_qat_fw_loader_handle.h |  26 +-
>  drivers/crypto/qat/qat_common/icp_qat_hal.h   |  63 +-
>  drivers/crypto/qat/qat_common/icp_qat_uclo.h  | 132 +++-
>  drivers/crypto/qat/qat_common/qat_hal.c       | 400 +++++++---
>  drivers/crypto/qat/qat_common/qat_uclo.c      | 737 ++++++++++++++----
>  8 files changed, 1097 insertions(+), 295 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
