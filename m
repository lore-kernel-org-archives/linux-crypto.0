Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D34DC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 08:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245069AbiDOInJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351439AbiDOImr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 04:42:47 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E962245BF
        for <linux-crypto@vger.kernel.org>; Fri, 15 Apr 2022 01:40:20 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nfHV2-003EYX-Oy; Fri, 15 Apr 2022 18:40:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Apr 2022 16:40:17 +0800
Date:   Fri, 15 Apr 2022 16:40:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Marco Chiappero <marco.chiappero@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com
Subject: Re: [PATCH v2 00/16] crypto: qat - misc fixes
Message-ID: <YlkvcQaOVJI2X1eM@gondor.apana.org.au>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 07, 2022 at 05:54:39PM +0100, Marco Chiappero wrote:
> This set contains a collection of fixes for DH895XCC (the first two
> patches), PFVF (most of the set) and a few more.
> 
> Patches one and two correct the lack of necessary flags to indicate the
> presence of specific HW capabilities, which could result in VFs unable
> to work correctly.
> 
> The third patch fixes some ring interrupts silently enabled even when
> VFs are active, while the fourth one is just a style fix.
> 
> Patches from five to eleven are minor PFVF fixes, while patch twelve
> addresses a bigger problem which caused lost PFVF messages due to
> unhandled interrupts during bursts of PFVF messages from multiple VFs.
> This was usually noticeable when restarting many VMs/VFs at the same
> time. The remainder of the set is a refactoring resulting from the
> previous fix, but split into multiple commits to ease the review.
> 
> Changes from v1:
> 
> - Addition of patches #3, #4, #6, #7, #8, #9, #10 and #11.
> 
> Giovanni Cabiddu (3):
>   crypto: qat - set CIPHER capability for DH895XCC
>   crypto: qat - set COMPRESSION capability for DH895XCC
>   crypto: qat - remove unused PFVF stubs
> 
> Marco Chiappero (12):
>   crypto: qat - fix ETR sources enabled by default on GEN2 devices
>   crypto: qat - remove unneeded braces
>   crypto: qat - remove unnecessary tests to detect PFVF support
>   crypto: qat - add missing restarting event notification in VFs
>   crypto: qat - test PFVF registers for spurious interrupts on GEN4
>   crypto: qat - fix wording and formatting in code comment
>   crypto: qat - fix off-by-one error in PFVF debug print
>   crypto: qat - rework the VF2PF interrupt handling logic
>   crypto: qat - leverage the GEN2 VF mask definiton
>   crypto: qat - replace disable_vf2pf_interrupts()
>   crypto: qat - use u32 variables in all GEN4 pfvf_ops
>   crypto: qat - remove line wrapping for pfvf_ops functions
> 
> Wojciech Ziemba (1):
>   crypto: qat - add check for invalid PFVF protocol version 0
> 
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  15 +--
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |   4 -
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  15 +--
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |   4 -
>  .../crypto/qat/qat_common/adf_accel_devices.h |   4 +-
>  .../crypto/qat/qat_common/adf_common_drv.h    |  18 +--
>  .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  13 ++
>  .../crypto/qat/qat_common/adf_gen2_hw_data.h  |   6 +
>  drivers/crypto/qat/qat_common/adf_gen2_pfvf.c |  78 ++++++-----
>  drivers/crypto/qat/qat_common/adf_gen4_pfvf.c |  61 ++++++---
>  drivers/crypto/qat/qat_common/adf_isr.c       |  21 ++-
>  drivers/crypto/qat/qat_common/adf_pfvf_msg.h  |   4 +-
>  .../crypto/qat/qat_common/adf_pfvf_pf_proto.c |   6 +-
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  13 +-
>  drivers/crypto/qat/qat_common/adf_vf_isr.c    |   1 +
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 126 ++++++++++--------
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   4 -
>  17 files changed, 206 insertions(+), 187 deletions(-)
> 
> 
> base-commit: 25d8a743a4810228f9b391f6face4777b28bae7b
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
