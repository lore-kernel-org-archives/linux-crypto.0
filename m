Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00FFC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 10:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiKKKSt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbiKKKSL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 05:18:11 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C9887B2E
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 02:17:57 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1otR6g-00Cywe-3l; Fri, 11 Nov 2022 18:17:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Nov 2022 18:17:54 +0800
Date:   Fri, 11 Nov 2022 18:17:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shashank Gupta <shashank.gupta@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - remove ADF_STATUS_PF_RUNNING flag from
 probe
Message-ID: <Y24hUk8vrRlEHkle@gondor.apana.org.au>
References: <20221104172107.27599-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104172107.27599-1-shashank.gupta@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 04, 2022 at 01:21:07PM -0400, Shashank Gupta wrote:
> The ADF_STATUS_PF_RUNNING bit is set after the successful initialization
> of the communication between VF to PF in adf_vf2pf_notify_init().
> So, it is not required to be set after the execution of the function
> adf_dev_init().
> 
> Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> ---
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 2 --
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 2 --
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 2 --
>  3 files changed, 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
