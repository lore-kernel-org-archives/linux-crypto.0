Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9BDC678DC
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 08:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358616AbjHRIeN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 04:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358672AbjHRIeB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 04:34:01 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A575D3AB8;
        Fri, 18 Aug 2023 01:33:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWuvM-005ETi-R3; Fri, 18 Aug 2023 16:33:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 16:33:41 +0800
Date:   Fri, 18 Aug 2023 16:33:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>, Bastian Krause <bst@pengutronix.de>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH] Revert "crypto: caam - optimize RNG sample size"
Message-ID: <ZN8s5UL1SuJOQtKh@gondor.apana.org.au>
References: <20230814053239.608702-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230814053239.608702-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 14, 2023 at 07:32:39AM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> 
> This reverts commit 1abc89661ad3cd18d8c6af5c2584bcc63df43bf2.
> 
> Reverting the commit because of RNG instantiation failure
> observed on imx8mm board.
> 
> Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> ---
>  drivers/crypto/caam/ctrl.c | 52 +++++++++++++++-----------------------
>  drivers/crypto/caam/regs.h | 14 ++--------
>  2 files changed, 22 insertions(+), 44 deletions(-)

This isn't the patch that was being discussed.  The offending
patch was ef492d08030 ("crypto: caam - adjust RNG timing to support
more devices").

I'll revert that one instead of this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
