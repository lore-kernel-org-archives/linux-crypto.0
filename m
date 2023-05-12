Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0E0C77B7C
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 10:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbjELK6O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 06:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbjELK6B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 06:58:01 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F9106CF;
        Fri, 12 May 2023 03:58:00 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pxQTC-008C8M-MP; Fri, 12 May 2023 18:57:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 May 2023 18:57:55 +0800
Date:   Fri, 12 May 2023 18:57:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        leonard.crestez@nxp.com, aisheng.dong@nxp.com
Subject: Re: [PATCH v3] crypto: caam - refactor RNG initialization
Message-ID: <ZF4bs1Zct18G+FiM@gondor.apana.org.au>
References: <20230405103306.1763491-1-meenakshi.aggarwal@nxp.com>
 <20230417182839.782924-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417182839.782924-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 17, 2023 at 08:28:39PM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Horia GeantA <horia.geanta@nxp.com>
> 
> RNG (re-)initialization will be needed on pm resume path,
> thus refactor the corresponding code out of the probe callback.
> 
> Signed-off-by: Horia GeantA <horia.geanta@nxp.com>
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> ---
> changes in v2:
> 	Rebased on "page 0" patches
> 
> changes in v3:
> 	Incorporated review comments
> 
>  drivers/crypto/caam/ctrl.c   | 205 +++++++++++++++++++----------------
>  drivers/crypto/caam/intern.h |   1 +
>  2 files changed, 115 insertions(+), 91 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
