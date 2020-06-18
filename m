Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72B5C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA714217A0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgFRH4R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 03:56:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60412 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgFRH4P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 03:56:15 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jlpP7-00022M-WA; Thu, 18 Jun 2020 17:56:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 18 Jun 2020 17:56:09 +1000
Date:   Thu, 18 Jun 2020 17:56:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - convert to SPDX License Identifiers
Message-ID: <20200618075609.GA10091@gondor.apana.org.au>
References: <20200527152128.352735-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527152128.352735-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 27, 2020 at 04:21:28PM +0100, Giovanni Cabiddu wrote:
> Replace License Headers with SPDX License Identifiers.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 48 +-----------------
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  | 48 +-----------------
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c        | 48 +-----------------
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     | 48 +-----------------
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h     | 48 +-----------------
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      | 48 +-----------------
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 48 +-----------------
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    | 48 +-----------------
>  drivers/crypto/qat/qat_c62x/adf_drv.c         | 48 +-----------------
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       | 48 +-----------------
>  .../qat/qat_c62xvf/adf_c62xvf_hw_data.h       | 48 +-----------------
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       | 48 +-----------------
>  .../crypto/qat/qat_common/adf_accel_devices.h | 48 +-----------------
>  .../crypto/qat/qat_common/adf_accel_engine.c  | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_admin.c     | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_aer.c       | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_cfg.c       | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_cfg.h       | 48 +-----------------
>  .../crypto/qat/qat_common/adf_cfg_common.h    | 48 +-----------------
>  .../crypto/qat/qat_common/adf_cfg_strings.h   | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_cfg_user.h  | 48 +-----------------
>  .../crypto/qat/qat_common/adf_common_drv.h    | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c   | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_dev_mgr.c   | 48 +-----------------
>  .../crypto/qat/qat_common/adf_hw_arbiter.c    | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_init.c      | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_isr.c       | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 49 +------------------
>  drivers/crypto/qat/qat_common/adf_pf2vf_msg.h | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_sriov.c     | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_transport.c | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_transport.h | 48 +-----------------
>  .../qat_common/adf_transport_access_macros.h  | 48 +-----------------
>  .../qat/qat_common/adf_transport_debug.c      | 48 +-----------------
>  .../qat/qat_common/adf_transport_internal.h   | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 48 +-----------------
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    | 48 +-----------------
>  drivers/crypto/qat/qat_common/icp_qat_fw.h    | 48 +-----------------
>  .../qat/qat_common/icp_qat_fw_init_admin.h    | 48 +-----------------
>  drivers/crypto/qat/qat_common/icp_qat_fw_la.h | 48 +-----------------
>  .../qat/qat_common/icp_qat_fw_loader_handle.h | 48 +-----------------
>  .../crypto/qat/qat_common/icp_qat_fw_pke.h    | 48 +-----------------
>  drivers/crypto/qat/qat_common/icp_qat_hal.h   | 48 +-----------------
>  drivers/crypto/qat/qat_common/icp_qat_hw.h    | 48 +-----------------
>  drivers/crypto/qat/qat_common/icp_qat_uclo.h  | 48 +-----------------
>  drivers/crypto/qat/qat_common/qat_algs.c      | 48 +-----------------
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 49 +------------------
>  drivers/crypto/qat/qat_common/qat_crypto.c    | 48 +-----------------
>  drivers/crypto/qat/qat_common/qat_crypto.h    | 48 +-----------------
>  drivers/crypto/qat/qat_common/qat_hal.c       | 48 +-----------------
>  drivers/crypto/qat/qat_common/qat_uclo.c      | 48 +-----------------
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 48 +-----------------
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   | 48 +-----------------
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c     | 48 +-----------------
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   | 48 +-----------------
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.h   | 48 +-----------------
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   | 48 +-----------------
>  57 files changed, 114 insertions(+), 2624 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
