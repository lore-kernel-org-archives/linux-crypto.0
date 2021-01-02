Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7EDC43381
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC69220799
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhABWHK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:07:10 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37298 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbhABWHJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:07:09 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp2T-0000b0-Mz; Sun, 03 Jan 2021 09:06:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:06:21 +1100
Date:   Sun, 3 Jan 2021 09:06:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2 0/2] crypto: remove bare cipher from public API
Message-ID: <20210102220621.GH12767@gondor.apana.org.au>
References: <20201211122715.15090-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211122715.15090-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 11, 2020 at 01:27:13PM +0100, Ard Biesheuvel wrote:
> Patch #2 puts the cipher API (which should not be used outside of the
> crypto API implementation) into an internal header file and module
> namespace
> 
> Patch #1 is a prerequisite for this, to avoid having to make the chelsio
> driver import the crypto internal namespace.
> 
> Changes since v1:
> - add missing Kconfig dependency on CRYPT_LIB_AES (#1)
> - add missing module namespace import into skcipher.c (#2) - this addresses
>   the kbuild failure report
> - add module import to QAT driver, which now contains a valid use of the
>   bare cipher API
> 
> Cc: Eric Biggers <ebiggers@google.com>
> 
> Ard Biesheuvel (2):
>   chcr_ktls: use AES library for single use cipher
>   crypto: remove cipher routines from public crypto API
> 
>  Documentation/crypto/api-skcipher.rst         |   4 +-
>  arch/arm/crypto/aes-neonbs-glue.c             |   3 +
>  arch/s390/crypto/aes_s390.c                   |   2 +
>  crypto/adiantum.c                             |   2 +
>  crypto/ansi_cprng.c                           |   2 +
>  crypto/cbc.c                                  |   1 +
>  crypto/ccm.c                                  |   2 +
>  crypto/cfb.c                                  |   2 +
>  crypto/cipher.c                               |   7 +-
>  crypto/cmac.c                                 |   2 +
>  crypto/ctr.c                                  |   2 +
>  crypto/drbg.c                                 |   2 +
>  crypto/ecb.c                                  |   1 +
>  crypto/essiv.c                                |   2 +
>  crypto/keywrap.c                              |   2 +
>  crypto/ofb.c                                  |   2 +
>  crypto/pcbc.c                                 |   2 +
>  crypto/skcipher.c                             |   2 +
>  crypto/testmgr.c                              |   3 +
>  crypto/vmac.c                                 |   2 +
>  crypto/xcbc.c                                 |   2 +
>  crypto/xts.c                                  |   2 +
>  drivers/crypto/geode-aes.c                    |   2 +
>  drivers/crypto/inside-secure/safexcel.c       |   1 +
>  drivers/crypto/inside-secure/safexcel_hash.c  |   1 +
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   1 +
>  drivers/crypto/qat/qat_common/qat_algs.c      |   1 +
>  drivers/crypto/vmx/aes.c                      |   1 +
>  drivers/crypto/vmx/vmx.c                      |   1 +
>  .../ethernet/chelsio/inline_crypto/Kconfig    |   1 +
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  19 +-
>  include/crypto/algapi.h                       |  39 ----
>  include/crypto/internal/cipher.h              | 218 ++++++++++++++++++
>  include/crypto/internal/skcipher.h            |   1 +
>  include/linux/crypto.h                        | 163 -------------
>  35 files changed, 281 insertions(+), 219 deletions(-)
>  create mode 100644 include/crypto/internal/cipher.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
