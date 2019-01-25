Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEA3C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3CF4218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfAYKsl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:48:41 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44478 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKsl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:48:41 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmz2N-0005jt-RU; Fri, 25 Jan 2019 18:48:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmz2N-00027H-Nc; Fri, 25 Jan 2019 18:48:39 +0800
Date:   Fri, 25 Jan 2019 18:48:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: clarify name of WEAK_KEY request flag
Message-ID: <20190125104839.uakekmhrmqmbjdrw@gondor.apana.org.au>
References: <20190119064800.6713-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190119064800.6713-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 18, 2019 at 10:48:00PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> CRYPTO_TFM_REQ_WEAK_KEY confuses newcomers to the crypto API because it
> sounds like it is requesting a weak key.  Actually, it is requesting
> that weak keys be forbidden (for algorithms that have the notion of
> "weak keys"; currently only DES and XTS do).
> 
> Also it is only one letter away from CRYPTO_TFM_RES_WEAK_KEY, with which
> it can be easily confused.  (This in fact happened in the UX500 driver,
> though just in some debugging messages.)
> 
> Therefore, make the intent clear by renaming it to
> CRYPTO_TFM_REQ_FORBID_WEAK_KEYS.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/s390/crypto/des_s390.c                   |  4 ++--
>  arch/sparc/crypto/des_glue.c                  |  4 ++--
>  crypto/des_generic.c                          |  4 ++--
>  crypto/testmgr.c                              | 14 ++++++-------
>  crypto/testmgr.h                              |  4 ++--
>  drivers/crypto/atmel-tdes.c                   |  2 +-
>  drivers/crypto/bcm/cipher.c                   |  4 ++--
>  drivers/crypto/ccp/ccp-crypto-des3.c          |  2 +-
>  drivers/crypto/ccree/cc_cipher.c              |  3 ++-
>  drivers/crypto/hifn_795x.c                    |  3 ++-
>  .../crypto/inside-secure/safexcel_cipher.c    |  2 +-
>  drivers/crypto/ixp4xx_crypto.c                |  4 ++--
>  drivers/crypto/marvell/cipher.c               |  2 +-
>  drivers/crypto/n2_core.c                      |  2 +-
>  drivers/crypto/omap-des.c                     |  2 +-
>  drivers/crypto/picoxcell_crypto.c             |  3 ++-
>  drivers/crypto/qce/ablkcipher.c               |  4 ++--
>  .../rockchip/rk3288_crypto_ablkcipher.c       |  2 +-
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c     |  2 +-
>  drivers/crypto/talitos.c                      |  2 +-
>  drivers/crypto/ux500/cryp/cryp_core.c         | 20 ++++++++++---------
>  fs/crypto/keyinfo.c                           |  4 ++--
>  fs/ecryptfs/crypto.c                          |  5 +++--
>  include/crypto/xts.h                          |  4 ++--
>  include/linux/crypto.h                        |  2 +-
>  25 files changed, 55 insertions(+), 49 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
