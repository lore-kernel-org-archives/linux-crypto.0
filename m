Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0EEC636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBPFWA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBPFV2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:21:28 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515DF46D40
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:19:42 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSWfZ-00Bqu6-SG; Thu, 16 Feb 2023 13:18:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 13:18:57 +0800
Date:   Thu, 16 Feb 2023 13:18:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 9/10] crypto: api - Move MODULE_ALIAS_CRYPTO to algapi.h
Message-ID: <Y+28wd7Vz5atplvA@gondor.apana.org.au>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2W-00BVm0-2d@formenos.hmeau.com>
 <Y+28cG3kezAyPZSN@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+28cG3kezAyPZSN@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 09:17:36PM -0800, Eric Biggers wrote:
>
> For this to work, drivers/crypto/qat/qat_common/adf_ctl_drv.c needs to include
> <crypto/algapi.h>.

https://patchwork.kernel.org/project/linux-crypto/patch/Y+yZHiWPKyyR6fLw@gondor.apana.org.au/

> There could be others too.

I grepped and couldn't find any others.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
