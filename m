Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB01C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E50B208D5
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgFRH5Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 03:57:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60460 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgFRH5Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 03:57:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jlpQ9-00026L-T9; Thu, 18 Jun 2020 17:57:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 18 Jun 2020 17:57:13 +1000
Date:   Thu, 18 Jun 2020 17:57:13 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Replace user types and remove packed
Message-ID: <20200618075713.GF10091@gondor.apana.org.au>
References: <20200603173346.96967-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603173346.96967-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 03, 2020 at 06:33:43PM +0100, Giovanni Cabiddu wrote:
> Remove user types across qat code base and replace packed attribute in
> etr ring struct which causes a split lock.
> 
> These changes are on top of "crypto: qat - fix parameter check in aead
> encryption" (https://patchwork.kernel.org/patch/11574001/)
> 
> Giovanni Cabiddu (1):
>   crypto: qat - remove packed attribute in etr structs
> 
> Wojciech Ziemba (2):
>   crypto: qat - replace user types with kernel u types
>   crypto: qat - replace user types with kernel ABI __u types
> 
>  .../crypto/qat/qat_common/adf_accel_devices.h |  54 +++---
>  .../crypto/qat/qat_common/adf_accel_engine.c  |   4 +-
>  drivers/crypto/qat/qat_common/adf_aer.c       |   2 +-
>  .../crypto/qat/qat_common/adf_cfg_common.h    |  24 +--
>  drivers/crypto/qat/qat_common/adf_cfg_user.h  |  10 +-
>  .../crypto/qat/qat_common/adf_common_drv.h    |  12 +-
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   4 +-
>  drivers/crypto/qat/qat_common/adf_dev_mgr.c   |   8 +-
>  drivers/crypto/qat/qat_common/adf_transport.c |  62 +++----
>  drivers/crypto/qat/qat_common/adf_transport.h |   4 +-
>  .../qat_common/adf_transport_access_macros.h  |   6 +-
>  .../qat/qat_common/adf_transport_internal.h   |  27 ++-
>  drivers/crypto/qat/qat_common/icp_qat_fw.h    |  58 +++----
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |  46 ++---
>  drivers/crypto/qat/qat_common/icp_qat_fw_la.h | 158 +++++++++---------
>  .../crypto/qat/qat_common/icp_qat_fw_pke.h    |  52 +++---
>  drivers/crypto/qat/qat_common/icp_qat_hw.h    |  16 +-
>  drivers/crypto/qat/qat_common/icp_qat_uclo.h  |   6 +-
>  drivers/crypto/qat/qat_common/qat_algs.c      |  54 +++---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c |  12 +-
>  drivers/crypto/qat/qat_common/qat_hal.c       |  40 ++---
>  drivers/crypto/qat/qat_common/qat_uclo.c      |  20 +--
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  26 +--
>  23 files changed, 352 insertions(+), 353 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
