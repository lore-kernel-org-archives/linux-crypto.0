Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7884CC3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C33921848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfHVF4p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:56:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58402 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbfHVF4p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 01:56:45 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0g5T-0002yh-0j; Thu, 22 Aug 2019 15:56:43 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0g5S-000124-HP; Thu, 22 Aug 2019 15:56:42 +1000
Date:   Thu, 22 Aug 2019 15:56:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 00/30] crypto: DES/3DES cleanup
Message-ID: <20190822055642.GE3860@gondor.apana.org.au>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 15, 2019 at 12:00:42PM +0300, Ard Biesheuvel wrote:
> In my effort to remove crypto_alloc_cipher() invocations from non-crypto
> code, i ran into a DES call in the CIFS driver. This is addressed in
> patch #30.
> 
> The other patches are cleanups for the quirky DES interface, and lots
> of duplication of the weak key checks etc.
> 
> Changes since v4:
> - Use dedicated inline key verification helpers for skcipher, ablkcipher and
>   aead type transforms, as requested by Herbert
> - Rebase onto cryptodev/master, and fix up the resulting fallout
> - Drop tested-by tags due to code changes
> - Rename local s390 routines as requested by Harald (and added his R-b)
> 
> Changes since v3:
> - rebase onto today's cryptodev/master
> - update safexcel patch to address code that has been added in the mean time
> - replace memzero_explicit() calls with memset() if they don't operate on
>   stack buffers
> - add T-b's from Horia and Corentin
> 
> Changes since v2:
> - fixed another couple of build errors that I missed, apologies to the
>   reviewers for failing to spot these
> - use/retain a simplified 'return verify() ?: setkey()' pattern where possible
>   (as suggested by Horia)
> - ensure that the setkey() routines using the helpers return -EINVAL on weak
>   keys when disallowed by the tfm's weak key policy
> - remove many pointless unlikely() annotations on ice-cold setkey() paths
> 
> Changes since v1/RFC:
> - fix build errors in various drivers that i failed to catch in my
>   initial testing
> - put all caam changes into the correct patch
> - fix weak key handling error flagged by the self tests, as reported
>   by Eric.
> - add ack from Harald to patch #2
> 
> The KASAN error reported by Eric failed to reproduce for me, so I
> didn't include a fix for that. Please check if it still reproduces for
> you.
> 
> Patch #1 adds new helpers to verify DES keys to crypto/internal.des.h
> 
> The next 23 patches move all existing users of DES routines to the
> new interface.
> 
> Patch #25 and #26 are preparatory patches for the new DES library
> introduced in patch #27, which replaces the various DES related
> functions exported to other drivers with a sane library interface.
> 
> Patch #28 switches the x86 asm code to the new librar interface.
> 
> Patch #29 removes code that is no longer used at this point.
> 
> Code can be found here:
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=des-cleanup-v5
> 
> Ard Biesheuvel (30):
>   crypto: des/3des_ede - add new helpers to verify keys
>   crypto: s390/des - switch to new verification routines
>   crypto: sparc/des - switch to new verification routines
>   crypto: atmel/des - switch to new verification routines
>   crypto: bcm/des - switch to new verification routines
>   crypto: caam/des - switch to new verification routines
>   crypto: cpt/des - switch to new verification routines
>   crypto: nitrox/des - switch to new verification routines
>   crypto: ccp/des - switch to new verification routines
>   crypto: ccree/des - switch to new verification routines
>   crypto: hifn/des - switch to new verification routines
>   crypto: hisilicon/des - switch to new verification routines
>   crypto: safexcel/des - switch to new verification routines
>   crypto: ixp4xx/des - switch to new verification routines
>   crypto: cesa/des - switch to new verification routines
>   crypto: n2/des - switch to new verification routines
>   crypto: omap/des - switch to new verification routines
>   crypto: picoxcell/des - switch to new verification routines
>   crypto: qce/des - switch to new verification routines
>   crypto: rk3288/des - switch to new verification routines
>   crypto: stm32/des - switch to new verification routines
>   crypto: sun4i/des - switch to new verification routines
>   crypto: talitos/des - switch to new verification routines
>   crypto: ux500/des - switch to new verification routines
>   crypto: 3des - move verification out of exported routine
>   crypto: des - remove unused function
>   crypto: des - split off DES library from generic DES cipher driver
>   crypto: x86/des - switch to library interface
>   crypto: des - remove now unused __des3_ede_setkey()
>   fs: cifs: move from the crypto cipher API to the new DES library
>     interface
> 
>  arch/s390/crypto/des_s390.c                   |  25 +-
>  arch/sparc/crypto/des_glue.c                  |  37 +-
>  arch/x86/crypto/des3_ede_glue.c               |  38 +-
>  crypto/Kconfig                                |   8 +-
>  crypto/des_generic.c                          | 945 +-----------------
>  drivers/crypto/Kconfig                        |  28 +-
>  drivers/crypto/atmel-tdes.c                   |  28 +-
>  drivers/crypto/bcm/cipher.c                   |  79 +-
>  drivers/crypto/caam/Kconfig                   |   2 +-
>  drivers/crypto/caam/caamalg.c                 |  49 +-
>  drivers/crypto/caam/caamalg_qi.c              |  36 +-
>  drivers/crypto/caam/caamalg_qi2.c             |  36 +-
>  drivers/crypto/caam/compat.h                  |   2 +-
>  drivers/crypto/cavium/cpt/cptvf_algs.c        |  26 +-
>  drivers/crypto/cavium/nitrox/Kconfig          |   2 +-
>  .../crypto/cavium/nitrox/nitrox_skcipher.c    |   4 +-
>  drivers/crypto/ccp/ccp-crypto-des3.c          |   7 +-
>  drivers/crypto/ccree/cc_aead.c                |  24 +-
>  drivers/crypto/ccree/cc_cipher.c              |  15 +-
>  drivers/crypto/hifn_795x.c                    |  32 +-
>  drivers/crypto/hisilicon/sec/sec_algs.c       |  18 +-
>  .../crypto/inside-secure/safexcel_cipher.c    |  26 +-
>  drivers/crypto/ixp4xx_crypto.c                |  27 +-
>  drivers/crypto/marvell/cipher.c               |  25 +-
>  drivers/crypto/n2_core.c                      |  32 +-
>  drivers/crypto/omap-des.c                     |  27 +-
>  drivers/crypto/picoxcell_crypto.c             |  24 +-
>  drivers/crypto/qce/ablkcipher.c               |  55 +-
>  drivers/crypto/rockchip/rk3288_crypto.h       |   2 +-
>  .../rockchip/rk3288_crypto_ablkcipher.c       |  21 +-
>  drivers/crypto/stm32/Kconfig                  |   2 +-
>  drivers/crypto/stm32/stm32-cryp.c             |  30 +-
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c     |  26 +-
>  drivers/crypto/sunxi-ss/sun4i-ss.h            |   2 +-
>  drivers/crypto/talitos.c                      |  37 +-
>  drivers/crypto/ux500/Kconfig                  |   2 +-
>  drivers/crypto/ux500/cryp/cryp_core.c         |  31 +-
>  fs/cifs/Kconfig                               |   2 +-
>  fs/cifs/cifsfs.c                              |   1 -
>  fs/cifs/smbencrypt.c                          |  18 +-
>  include/crypto/des.h                          |  77 +-
>  include/crypto/internal/des.h                 | 152 +++
>  lib/crypto/Makefile                           |   3 +
>  lib/crypto/des.c                              | 902 +++++++++++++++++
>  44 files changed, 1415 insertions(+), 1550 deletions(-)
>  create mode 100644 include/crypto/internal/des.h
>  create mode 100644 lib/crypto/des.c

All applied.  Thanks.

I had to fix the ixp4xx patch to remove the key_len argument.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
