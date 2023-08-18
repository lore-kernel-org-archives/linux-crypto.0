Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9B1C7112B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 09:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359122AbjHRJbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359221AbjHRJa7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 05:30:59 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EEE3AA6;
        Fri, 18 Aug 2023 02:30:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWvnO-005FRU-15; Fri, 18 Aug 2023 17:29:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 17:29:30 +0800
Date:   Fri, 18 Aug 2023 17:29:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
        Victoria Milhoan <vicki.milhoan@freescale.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Douglass <dan.douglass@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: fix PM operations definition
Message-ID: <ZN85+i518CGE6WgH@gondor.apana.org.au>
References: <20230807111653.1794160-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230807111653.1794160-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 07, 2023 at 01:16:43PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added PM operations use the deprecated SIMPLE_DEV_PM_OPS() macro,
> causing a warning in some configurations:
> 
> drivers/crypto/caam/ctrl.c:828:12: error: 'caam_ctrl_resume' defined but not used [-Werror=unused-function]
>   828 | static int caam_ctrl_resume(struct device *dev)
>       |            ^~~~~~~~~~~~~~~~
> drivers/crypto/caam/ctrl.c:818:12: error: 'caam_ctrl_suspend' defined but not used [-Werror=unused-function]
>   818 | static int caam_ctrl_suspend(struct device *dev)
>       |            ^~~~~~~~~~~~~~~~~
> drivers/crypto/caam/jr.c:732:12: error: 'caam_jr_resume' defined but not used [-Werror=unused-function]
>   732 | static int caam_jr_resume(struct device *dev)
>       |            ^~~~~~~~~~~~~~
> drivers/crypto/caam/jr.c:687:12: error: 'caam_jr_suspend' defined but not used [-Werror=unused-function]
>   687 | static int caam_jr_suspend(struct device *dev)
>       |            ^~~~~~~~~~~~~~~
> 
> Use the normal DEFINE_SIMPLE_DEV_PM_OPS() variant now, and use pm_ptr() to
> completely eliminate the structure in configs without CONFIG_PM.
> 
> Fixes: 322d74752c28a ("crypto: caam - add power management support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/caam/ctrl.c | 4 ++--
>  drivers/crypto/caam/jr.c   | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
