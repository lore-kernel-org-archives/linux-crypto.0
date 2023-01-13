Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC11C54EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Jan 2023 04:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbjAMEQq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Jan 2023 23:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjAMEPi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2023 23:15:38 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12CF65355;
        Thu, 12 Jan 2023 20:13:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pGBR0-00H5Ig-Q3; Fri, 13 Jan 2023 12:12:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jan 2023 12:12:54 +0800
Date:   Fri, 13 Jan 2023 12:12:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Danny Tsen <dtsen@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, ltcgcw@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/6] crypto: Accelerated AES/GCM stitched
 implementation
Message-ID: <Y8DaRph5Sv709m/m@gondor.apana.org.au>
References: <20221205003458.4182-1-dtsen@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205003458.4182-1-dtsen@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 04, 2022 at 07:34:52PM -0500, Danny Tsen wrote:
> This patch series enable an accelerated AES/GCM stitched implementation for
> Power10+ CPU(ppc64le).  This module supports AEAD algorithm.  The stitched
> implementation provides 3.5X+ better performance than the baseline.
> 
> This patch has been tested with the kernel crypto module tcrypt.ko and has
> passed the selftest.  The patch is also tested with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled
> 
> Danny Tsen (6):
>   Patch1: Update Kconfig and Makefile.
>   Patch2: Glue code for AES/GCM stitched implementation.
>   Patch3: An accelerated AES/GCM stitched implementation.
>   Patch4: Supporting functions for AES.
>   Patch5: Supporting functions for ghash.
>   Patch6: A perl script to process PowerPC assembler source.
> 
>  arch/powerpc/crypto/Kconfig            |   11 +
>  arch/powerpc/crypto/Makefile           |   10 +
>  arch/powerpc/crypto/aesp8-ppc.pl       | 3846 ++++++++++++++++++++++++
>  arch/powerpc/crypto/ghashp8-ppc.pl     |  370 +++
>  arch/powerpc/crypto/p10-aes-gcm-glue.c |  345 +++
>  arch/powerpc/crypto/p10_aes_gcm.S      | 1519 ++++++++++
>  arch/powerpc/crypto/ppc-xlate.pl       |  229 ++
>  7 files changed, 6330 insertions(+)
>  create mode 100644 arch/powerpc/crypto/aesp8-ppc.pl
>  create mode 100644 arch/powerpc/crypto/ghashp8-ppc.pl
>  create mode 100644 arch/powerpc/crypto/p10-aes-gcm-glue.c
>  create mode 100644 arch/powerpc/crypto/p10_aes_gcm.S
>  create mode 100644 arch/powerpc/crypto/ppc-xlate.pl
> 
> -- 
> 2.31.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
