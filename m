Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E31C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 11:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0869261153
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 11:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhDPLdC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Apr 2021 07:33:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53120 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238757AbhDPLdC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Apr 2021 07:33:02 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lXMi9-0003WY-2n; Fri, 16 Apr 2021 21:32:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Apr 2021 21:32:32 +1000
Date:   Fri, 16 Apr 2021 21:32:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH] crypto: qat - enable detection of accelerators hang
Message-ID: <20210416113232.GL16633@gondor.apana.org.au>
References: <20210409135619.3879-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409135619.3879-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 09, 2021 at 02:56:19PM +0100, Giovanni Cabiddu wrote:
> From: Wojciech Ziemba <wojciech.ziemba@intel.com>
> 
> Enable the detection of hangs by setting watchdog timers (WDTs) on
> generations that supports that feature.
> 
> The default timeout value comes from HW specs. WTDs are reset each time
> an accelerator wins arbitration and is able to send/read a command to/from
> an accelerator.
> 
> The value has added significant margin to make sure there are no spurious
> timeouts. The scope of watchdog is per QAT device.
> 
> If a timeout is detected, the firmware resets the accelerator and
> returns a response descriptor with an appropriate error code.
> 
> Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  1 +
>  .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  1 +
>  .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  1 +
>  .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
>  .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 25 ++++++++++++
>  .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 13 ++++++
>  .../crypto/qat/qat_common/adf_gen4_hw_data.c  | 40 +++++++++++++++++++
>  .../crypto/qat/qat_common/adf_gen4_hw_data.h  | 14 ++++++-
>  drivers/crypto/qat/qat_common/adf_init.c      |  4 ++
>  9 files changed, 99 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
