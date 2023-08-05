Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ACBC001DB
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Aug 2023 04:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjHEEiq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Aug 2023 00:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHEEio (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Aug 2023 00:38:44 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4485B468C;
        Fri,  4 Aug 2023 21:38:41 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qS93U-003umX-Mm; Sat, 05 Aug 2023 12:38:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Aug 2023 12:38:20 +0800
Date:   Sat, 5 Aug 2023 12:38:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rob Herring <robh@kernel.org>
Cc:     Olivia Mackall <olivia@selenic.com>,
        kernel test robot <lkp@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: xgene: Add explicit io.h include
Message-ID: <ZM3SPLTSrHeUuod2@gondor.apana.org.au>
References: <20230804144844.1338640-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804144844.1338640-1-robh@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 04, 2023 at 08:48:44AM -0600, Rob Herring wrote:
> Commit 0788257aeebe ("hwrng: Explicitly include correct DT includes")
> removed an implicit include of io.h. On most architectures, there's
> still an implicit include of it, but not on s390. Enabling COMPILE_TEST
> in commit 1ce1cd8208ad ("hwrng: Enable COMPILE_TEST for more drivers")
> exposed this.
> 
> Fixes: 0788257aeebe ("hwrng: Explicitly include correct DT includes")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308042049.8R2tNRoo-lkp@intel.com/
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/char/hw_random/xgene-rng.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
