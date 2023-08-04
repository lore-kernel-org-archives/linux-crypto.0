Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77513C001DF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 09:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjHDJ0Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjHDJZx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 05:25:53 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0B430EB;
        Fri,  4 Aug 2023 02:25:52 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRr41-003bJ8-Cq; Fri, 04 Aug 2023 17:25:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 17:25:41 +0800
Date:   Fri, 4 Aug 2023 17:25:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Add power management support in CAAM driver
Message-ID: <ZMzEFTwzSt3SZzDS@gondor.apana.org.au>
References: <20230712060728.3562376-1-meenakshi.aggarwal@nxp.com>
 <20230724065230.83017-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724065230.83017-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 24, 2023 at 08:52:28AM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> 
> This patch set add support of Power Management in CAAM driver
> 
> We are saving the state of the CAAM:
>  - JRs MID
>  - Address of input and output rings
> in suspend function and getting same state in resume function
> on platforms where power of CAAM is turned off.
> 
> Changes in v2:
> 	- not protecting PM code under macro CONFIG_PM_SLEEP
> 	as CONFIG_PM_SLEEP is on by default
> 
> Franck LENORMAND (1):
>   crypto: caam - Change structure type representing DECO MID
> 
> Horia Geanta (1):
>   crypto: caam - add power management support
> 
>  drivers/crypto/caam/ctrl.c   | 106 +++++++++++++++++++
>  drivers/crypto/caam/intern.h |  25 ++++-
>  drivers/crypto/caam/jr.c     | 193 +++++++++++++++++++++++++++++++----
>  drivers/crypto/caam/regs.h   |   9 +-
>  4 files changed, 306 insertions(+), 27 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
