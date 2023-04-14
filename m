Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A8AC77B6E
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Apr 2023 11:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDNLGy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Apr 2023 07:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDNLGx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2023 07:06:53 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404339EF0;
        Fri, 14 Apr 2023 04:06:37 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pnHG7-00Fqkr-Je; Fri, 14 Apr 2023 19:06:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Apr 2023 19:06:27 +0800
Date:   Fri, 14 Apr 2023 19:06:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] No access to CAAM page 0 registers
Message-ID: <ZDkzs/LvWpyN2D4p@gondor.apana.org.au>
References: <20230322061716.3195841-3-meenakshi.aggarwal@nxp.com>
 <20230405090752.1708455-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405090752.1708455-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 05, 2023 at 11:07:50AM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> 
> This series includes patches to reduce access to page 0 registers of
> CAAM from non-secure world.
> 
> In non-secure world, access to page 0 registers of CAAM is
> forbidden, so we are using alias registers available in Job Ring's
> register address space.
> 
> Allow CAAM's page 0 access to OPTEE, as OPTEE runs in secure world.
> 
> changes in v3:
> 	- Fixed compile time warnings reported by kernel test robot
> 	- incorporated review comments
> 
> changes in v2:
> 	- Fixed compile time warnings coming with compilation flag W=1
> 
> Horia GeantA (2):
>   crypto: caam - reduce page 0 regs access to minimum
>   crypto: caam - OP-TEE firmware support
> 
>  drivers/crypto/caam/caamalg.c  |  21 +++----
>  drivers/crypto/caam/caamhash.c |  10 ++--
>  drivers/crypto/caam/caampkc.c  |   6 +-
>  drivers/crypto/caam/caamrng.c  |   6 +-
>  drivers/crypto/caam/ctrl.c     | 106 +++++++++++++++++++++++----------
>  drivers/crypto/caam/debugfs.c  |  12 ++--
>  drivers/crypto/caam/debugfs.h  |   7 ++-
>  drivers/crypto/caam/intern.h   |   1 +
>  8 files changed, 110 insertions(+), 59 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
