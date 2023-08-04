Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604DAC00528
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 09:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjHDJgT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjHDJgS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 05:36:18 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51C830EB;
        Fri,  4 Aug 2023 02:36:16 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRrDs-003baZ-Uj; Fri, 04 Aug 2023 17:35:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 17:35:52 +0800
Date:   Fri, 4 Aug 2023 17:35:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rob Herring <robh@kernel.org>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH] hwrng: Enable COMPILE_TEST for more drivers
Message-ID: <ZMzGeELPudVhTvRF@gondor.apana.org.au>
References: <20230728195015.1198427-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728195015.1198427-1-robh@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 28, 2023 at 01:50:15PM -0600, Rob Herring wrote:
> There's quite a few hwrng drivers which are easily enabled for
> COMPILE_TEST, so let's enable them.
> 
> The dependency on HW_RANDOM is redundant, so drop that while we're here.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Passed allyesconfig builds on arm, arm64, x86, riscv, powerpc, sparc
> ---
>  drivers/char/hw_random/Kconfig       | 35 ++++++++++++++--------------
>  drivers/char/hw_random/amd-rng.c     |  1 +
>  drivers/char/hw_random/ingenic-rng.c |  2 +-
>  3 files changed, 20 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
