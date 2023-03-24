Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DDFC76196
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 10:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjCXK3u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 06:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjCXK3j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 06:29:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8931922009;
        Fri, 24 Mar 2023 03:29:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfeft-008Fcf-6v; Fri, 24 Mar 2023 18:29:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Mar 2023 18:29:33 +0800
Date:   Fri, 24 Mar 2023 18:29:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        franck.lenormand@nxp.com, vijayb@linux.microsoft.com,
        code@tyhicks.com
Subject: Re: [PATCH v2] drivers: crypto: caam: jr: add .shutdown hook
Message-ID: <ZB17jSx32jCRVH39@gondor.apana.org.au>
References: <20230221054047.2140558-1-meenakshi.aggarwal@nxp.com>
 <20230316060734.818549-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316060734.818549-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 16, 2023 at 11:37:34AM +0530, meenakshi.aggarwal@nxp.com wrote:
> From: Gaurav Jain <gaurav.jain@nxp.com>
> 
> add .shutdown hook in caam_jr driver to support kexec boot
> 
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> Tested-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@nxp.com>
> ---
> 
>  changes in v2:
> 	- corrected alignment
> 
>  drivers/crypto/caam/jr.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
