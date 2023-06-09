Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DBEC7EE25
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 09:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbjFIJSl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 05:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239338AbjFIJSM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 05:18:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B66F4C25
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 02:13:22 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q7YAF-000wDp-LU; Fri, 09 Jun 2023 17:12:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Jun 2023 17:12:11 +0800
Date:   Fri, 9 Jun 2023 17:12:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Subject: Re: [PATCH] crypto: qat - update slice mask for 4xxx devices
Message-ID: <ZILs67FLKzQ5OeRI@gondor.apana.org.au>
References: <20230530160147.9977-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160147.9977-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 30, 2023 at 05:01:47PM +0100, Giovanni Cabiddu wrote:
> From: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
> 
> Update slice mask enum for 4xxx device with BIT(7) to mask SMX fuse.
> This change is done to align the slice mask with the hardware fuse
> register.
> 
> Signed-off-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
