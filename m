Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D6DC001DE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 09:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359130AbjHRJbf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359241AbjHRJbS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 05:31:18 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987B44208
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 02:31:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWvom-005FTK-77; Fri, 18 Aug 2023 17:30:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 17:30:56 +0800
Date:   Fri, 18 Aug 2023 17:30:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     giovanni.cabiddu@intel.com, davem@davemloft.net,
        qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: qat - Remove unused function declarations
Message-ID: <ZN86UAizHKheD7v/@gondor.apana.org.au>
References: <20230809031614.9704-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809031614.9704-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 09, 2023 at 11:16:14AM +0800, Yue Haibing wrote:
> Commit d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> declared but never implemented these functions.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 8 --------
>  1 file changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
