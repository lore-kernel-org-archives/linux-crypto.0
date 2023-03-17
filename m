Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186F5C6FD1D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 03:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjCQDXv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCQDXt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 23:23:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F3332E67
        for <linux-crypto@vger.kernel.org>; Thu, 16 Mar 2023 20:23:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pd0gt-005anV-TI; Fri, 17 Mar 2023 11:23:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Mar 2023 11:23:39 +0800
Date:   Fri, 17 Mar 2023 11:23:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shashank Gupta <shashank.gupta@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix apply custom thread-service mapping
 for dc service
Message-ID: <ZBPdOz17xxW07JQw@gondor.apana.org.au>
References: <20230306160923.11962-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306160923.11962-1-shashank.gupta@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 06, 2023 at 11:09:23AM -0500, Shashank Gupta wrote:
> The thread to arbiter mapping for 4xxx devices does not allow to
> achieve optimal performance for the compression service as it makes
> all the engines to compete for the same resources.
> 
> Update the logic so that a custom optimal mapping is used for the
> compression service.
> 
> Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c        | 19 ++++++++++++++++---
>  drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c      |  2 +-
>  drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c        |  2 +-
>  drivers/crypto/qat/qat_common/adf_accel_devices.h     |  2 +-
>  drivers/crypto/qat/qat_common/adf_hw_arbiter.c        |  2 +-
>  .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c    |  2 +-
>  6 files changed, 21 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
