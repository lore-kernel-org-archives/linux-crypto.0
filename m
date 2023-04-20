Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2480FC77B73
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 10:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbjDTKYk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 06:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjDTKYJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 06:24:09 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B364C10;
        Thu, 20 Apr 2023 03:23:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ppRRF-000Yfl-FJ; Thu, 20 Apr 2023 18:22:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Apr 2023 18:22:54 +0800
Date:   Thu, 20 Apr 2023 18:22:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>, linux-i2c@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] Use CCP driver to handle PSP I2C arbitration
Message-ID: <ZEESfpbdwmjWWmYx@gondor.apana.org.au>
References: <20230414144008.836-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414144008.836-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 14, 2023 at 09:40:06AM -0500, Mario Limonciello wrote:
> The CCP driver now has symbols that can be used by i2c-designware-amdpsp
> to handle the communication regarding i2c arbitration with the PSP for
> both Cezanne and Mendocino based designs.
> 
> Utilize those symbols.
> 
> v8->v9:
>  * Drop v8 patches 1-4 as they're merged now
>  * Pick up tags for v8 patches 5-6
>  * Repost to linux-crypto as this needs to merge through crypto tree.
> 
> Mario Limonciello (2):
>   i2c: designware: Use PCI PSP driver for communication
>   i2c: designware: Add doorbell support for Mendocino
> 
>  drivers/i2c/busses/Kconfig                  |   5 +-
>  drivers/i2c/busses/i2c-designware-amdpsp.c  | 197 +++++---------------
>  drivers/i2c/busses/i2c-designware-core.h    |   1 -
>  drivers/i2c/busses/i2c-designware-platdrv.c |   1 -
>  include/linux/psp-platform-access.h         |   1 +
>  5 files changed, 53 insertions(+), 152 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
