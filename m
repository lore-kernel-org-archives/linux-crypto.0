Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A96EC6FD1C
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 10:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCJKxo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCJKxn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 05:53:43 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40BDB77E;
        Fri, 10 Mar 2023 02:53:41 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paaNT-002XOa-Vx; Fri, 10 Mar 2023 18:53:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 18:53:35 +0800
Date:   Fri, 10 Mar 2023 18:53:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        franck.lenormand@nxp.com, vijayb@linux.microsoft.com,
        code@tyhicks.com
Subject: Re: [PATCH] drivers: crypto: caam: jr: add .shutdown hook
Message-ID: <ZAsML/qAyPExMudN@gondor.apana.org.au>
References: <20230220105033.1449263-1-meenakshi.aggarwal@nxp.com>
 <20230221054047.2140558-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221054047.2140558-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 21, 2023 at 11:10:47AM +0530, meenakshi.aggarwal@nxp.com wrote:
>
> @@ -653,6 +658,7 @@ static struct platform_driver caam_jr_driver = {
>  	},
>  	.probe       = caam_jr_probe,
>  	.remove      = caam_jr_remove,
> +	.shutdown = caam_jr_platform_shutdown,

Please make your new addition line up with the rest of the code.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
