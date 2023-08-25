Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61937C3DA66
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 11:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbjHYLFX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbjHYLE5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2023 07:04:57 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1EB1BC9
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2023 04:04:54 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZUcT-007iYx-D3; Fri, 25 Aug 2023 19:04:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Aug 2023 19:04:50 +0800
Date:   Fri, 25 Aug 2023 19:04:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Adam Guerin <adam.guerin@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix crypto capability detection for 4xxx
Message-ID: <ZOiK0iE4J3MCz5el@gondor.apana.org.au>
References: <20230814155230.232672-1-adam.guerin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230814155230.232672-1-adam.guerin@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 14, 2023 at 04:52:30PM +0100, Adam Guerin wrote:
> When extending the capability detection logic for 4xxx devices the
> SMx algorithms were accidentally missed.
> Enable these SMx capabilities by default for QAT GEN4 devices.
> 
> Check for device variants where the SMx algorithms are explicitly
> disabled by the GEN4 hardware. This is indicated in fusectl1
> register.
> Mask out SM3 and SM4 based on a bit specific to those algorithms.
> Mask out SM2 if the PKE slice is not present.
> 
> Fixes: 4b44d28c715d ("crypto: qat - extend crypto capability detection for 4xxx")
> Signed-off-by: Adam Guerin <adam.guerin@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 9 +++++++++
>  drivers/crypto/intel/qat/qat_common/icp_qat_hw.h     | 5 ++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
