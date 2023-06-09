Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B09FC7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 09:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbjFIJSj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 05:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241420AbjFIJSL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 05:18:11 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6B761A5
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 02:13:21 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q7YA9-000wDl-CB; Fri, 09 Jun 2023 17:12:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Jun 2023 17:12:05 +0800
Date:   Fri, 9 Jun 2023 17:12:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Subject: Re: [PATCH] crypto: qat - set deprecated capabilities as reserved
Message-ID: <ZILs5R/RACdArlRk@gondor.apana.org.au>
References: <20230530155811.6554-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530155811.6554-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 30, 2023 at 04:58:11PM +0100, Giovanni Cabiddu wrote:
> From: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
> 
> The LZS and RAND features are no longer available on QAT.
> Remove the definition of bit 6 (LZS) and bit 7 (RAND) in the enum that
> represents the capabilities and replace them with a comment mentioning
> that those bits are reserved.
> Those bits shall not be used in future.
> 
> Signed-off-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/icp_qat_hw.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
