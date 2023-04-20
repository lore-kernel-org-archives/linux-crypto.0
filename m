Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4ADAC77B73
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 10:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbjDTKYa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 06:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbjDTKYE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 06:24:04 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2013558A;
        Thu, 20 Apr 2023 03:23:07 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ppRQx-000Ydo-4C; Thu, 20 Apr 2023 18:22:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Apr 2023 18:22:36 +0800
Date:   Thu, 20 Apr 2023 18:22:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Danny Tsen <dtsen@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH v2 0/2] Remove POWER10_CPU dependency and move
 PPC_MODULE_FEATURE_P10.
Message-ID: <ZEESbNOBirwSksig@gondor.apana.org.au>
References: <20230413194625.10631-1-dtsen@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413194625.10631-1-dtsen@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 13, 2023 at 03:46:23PM -0400, Danny Tsen wrote:
> Remove Power10 dependency in Kconfig and detect Power10 feature at runtime.
> Move PPC_MODULE_FEATURE_P10 definition to be in
> arch/powerpc/include/asm/cpufeature.h.
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> 
> Danny Tsen (2):
>   Kconfig: Remove POWER10_CPU dependency.
>   aes-gcm-p10-glue.c, cpufeature.h: Move Power10 feature, PPC_MODULE_FEATURE_P10.
> 
>  arch/powerpc/crypto/Kconfig            | 2 +-
>  arch/powerpc/crypto/aes-gcm-p10-glue.c | 1 -
>  arch/powerpc/include/asm/cpufeature.h  | 1 +
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> 2.31.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
