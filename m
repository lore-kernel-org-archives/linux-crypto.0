Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B56C61DA4
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Mar 2023 05:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCOFGN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Mar 2023 01:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCOFGN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2023 01:06:13 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C20921947;
        Tue, 14 Mar 2023 22:06:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pcJKt-004VpK-Dp; Wed, 15 Mar 2023 13:06:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Mar 2023 13:06:03 +0800
Date:   Wed, 15 Mar 2023 13:06:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Harsha, Harsha" <harsha.harsha@amd.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "saratcha@xilinx.com" <saratcha@xilinx.com>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Shah, Dhaval (CPG-PSAV)" <dhaval.r.shah@amd.com>
Subject: Re: [PATCH 3/4] crypto: xilinx: Add ZynqMP RSA driver
Message-ID: <ZBFSO8WMLC7/5S8q@gondor.apana.org.au>
References: <20230218053809.1780-1-harsha.harsha@amd.com>
 <20230218053809.1780-4-harsha.harsha@amd.com>
 <ZAsHHOOpEzXVY23I@gondor.apana.org.au>
 <MN2PR12MB460728BD61F5B2D7C06FFEF2F3BF9@MN2PR12MB4607.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB460728BD61F5B2D7C06FFEF2F3BF9@MN2PR12MB4607.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 15, 2023 at 05:02:39AM +0000, Harsha, Harsha wrote:
>
> To perform the operation, the request goes to the RSA HW engine. Once the operation is done, the response is sent back
> via firmware and ATF to the linux driver. Meanwhile the API in the linux driver waits until the operation is complete.
> This is why the driver is synchronous and therefore the CRYPTO_ALG_ASYNC flag is not set.

But you use crypto_engine, right? That is always async regardless
of what your driver does.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
