Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1F5C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 08:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 653A661214
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 08:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244529AbhIXIKq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Sep 2021 04:10:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55468 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235272AbhIXIKp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Sep 2021 04:10:45 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mTgGe-00087D-CS; Fri, 24 Sep 2021 16:09:12 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mTgGe-0003So-7c; Fri, 24 Sep 2021 16:09:12 +0800
Date:   Fri, 24 Sep 2021 16:09:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH] crypto: qat - power up 4xxx device
Message-ID: <20210924080912.GC13213@gondor.apana.org.au>
References: <20210916144541.56238-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916144541.56238-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 16, 2021 at 03:45:41PM +0100, Giovanni Cabiddu wrote:
> After reset or boot, QAT 4xxx devices are inactive and require to be
> explicitly activated.
> This is done by writing the DRV_ACTIVE bit in the PM_INTERRUPT register
> and polling the PM_INIT_STATE to make sure that the transaction has
> completed properly.
> 
> If this is not done, the driver will fail the initialization sequence
> reporting the following message:
>     [   22.081193] 4xxx 0000:f7:00.0: enabling device (0140 -> 0142)
>     [   22.720285] QAT: AE0 is inactive!!
>     [   22.720287] QAT: failed to get device out of reset
>     [   22.720288] 4xxx 0000:f7:00.0: qat_hal_clr_reset error
>     [   22.720290] 4xxx 0000:f7:00.0: Failed to init the AEs
>     [   22.720290] 4xxx 0000:f7:00.0: Failed to initialise Acceleration Engine
>     [   22.720789] 4xxx 0000:f7:00.0: Resetting device qat_dev0
>     [   22.825099] 4xxx: probe of 0000:f7:00.0 failed with error -14
> 
> The patch also temporarily disables the power management source of
> interrupt, to avoid possible spurious interrupts as the power management
> feature is not fully supported.
> 
> The device init function has been added to adf_dev_init(), and not in the
> probe of 4xxx to make sure that the device is re-enabled in case of
> reset.
> 
> Note that the error code reported by hw_data->init_device() in
> adf_dev_init() has been shadowed for consistency with the other calls
> in the same function.
> 
> Fixes: 8c8268166e83 ("crypto: qat - add qat_4xxx driver")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> ---
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 31 +++++++++++++++++++
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    | 10 ++++++
>  .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
>  drivers/crypto/qat/qat_common/adf_init.c      |  5 +++
>  4 files changed, 47 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
