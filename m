Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B64C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 19:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB7B215EA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560367016;
	bh=aenpxhMy7/1vHBZSX3BbEdK/1JKlXHiSJLShsF1HDp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZGfnt6A6Oef/DUhhKi/HpQZFbOfyZ/bLz7lA9bD2duyXqpOcXI8/0eViZ5q6svfl1
	 P5b177c0Rn/34hNTXEVlSNAQtv1jkNdGZvImKyW5yQPkLPrUHrZb3wfvGpII7dj022
	 tIcZuC3ShZyHkDOhONqPG/TOR0aNPBx98f8QsdCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfFLTQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 15:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbfFLTQz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 15:16:55 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C86520B7C;
        Wed, 12 Jun 2019 19:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560367014;
        bh=aenpxhMy7/1vHBZSX3BbEdK/1JKlXHiSJLShsF1HDp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIOw7u3B0zwQH9t4BtsrA5Bt9DjzvSlLz8y8GWE4R0560EG5Q60uYLG6uQ3XE9+xX
         i/rEF/WWi1Wc/J5kkfJWUofzZHjX57rR35upPbmaHItCPPYDoHpok9/rrOl2Y9eNod
         ztX2S1bQgbgvqbAbrAx4a0784P9XS6Bs+P5c/fKw=
Date:   Wed, 12 Jun 2019 12:16:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v5 0/7] crypto: rc4 cleanup
Message-ID: <20190612191652.GE18795@gmail.com>
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 06:19:52PM +0200, Ard Biesheuvel wrote:
> This is a follow-up to, and supersedes [0], which moved some WEP code from
> the cipher to the skcipher interface, in order to reduce the use of the bare
> cipher interface in non-crypto subsystem code.
> 
> Since using the skcipher interface to invoke the generic C implementation of
> an algorithm that is known at compile time is rather pointless, this series
> moves those users to a new arc4 library interface instead, which is based on
> the existing code.
> 
> Along the way, the arc4 cipher implementation is removed entirely, and only
> the ecb(arc4) code is preserved, which is used in a number of places in the
> kernel, and is known to be used by at least 'iwd' from user space via the
> algif_skcipher API.
> 
> Changes since v4:
> - add a missing MODULE_LICENSE() for the new libarc4 module
> - add a missing 'select CRYPTO_LIB_ARC4' to the lib80211-tkip patch
> - some cosmetic changes for the skcipher driver after removing the cipher code
> - a testmgr fix to ensure that the test framework understands that this skcipher
>   driver is the reference for testing ecb(arc4)
> 
> Changes since v3:
> - fix some remaining occurrences where a tfm non-NULL test should be replaced
>   with a fips_enabled test
> - use kzfree() or memzero_explicit() to clear the arc4 ctx where appropriate
> - clean up the function naming of the crypto arc4 driver when removing the
>   cipher part
> - remove .h declaration of a function that is being removed
> - revert a prior CIFS change that moved a variable from the stack to the heap,
>   which is no longer necessary
> - remove arc4 softdep from the cifs code
> 
> Changes since v2:
> - drop the crypto_ prefix from the arc4 library functions and types
> - rename the source file to arc4.c but keep the lib prefix for the actual
>   module to prevent a clash with the crypto API driver
> - preserve the existing behavior wrt the fips_enabled flag, which prevents
>   any use of ARC4 (note that the fips_enabled flag evaluates to 'false' at
>   compile time for kernels that lack the feature, so with these patches, we
>   get rid of most of the runtime logic regarding FIPS for builds that don't
>   have it enabled)
> 
> [0] https://lore.kernel.org/linux-crypto/20190607144944.13485-1-ard.biesheuvel@linaro.org/
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> 
> Ard Biesheuvel (7):
>   crypto: arc4 - refactor arc4 core code into separate library
>   net/mac80211: move WEP handling to ARC4 library interface
>   net/lib80211: move WEP handling to ARC4 library code
>   net/lib80211: move TKIP handling to ARC4 library code
>   crypto: arc4 - remove cipher implementation
>   ppp: mppe: switch to RC4 library interface
>   fs: cifs: switch to RC4 library interface
> 
>  MAINTAINERS                        |   1 +
>  crypto/Kconfig                     |   4 +
>  crypto/arc4.c                      | 124 +++-----------------
>  crypto/testmgr.c                   |   1 +
>  drivers/net/ppp/Kconfig            |   3 +-
>  drivers/net/ppp/ppp_mppe.c         |  97 +++------------
>  fs/cifs/Kconfig                    |   2 +-
>  fs/cifs/cifsencrypt.c              |  62 +++-------
>  fs/cifs/cifsfs.c                   |   1 -
>  include/crypto/arc4.h              |  10 ++
>  lib/Makefile                       |   2 +-
>  lib/crypto/Makefile                |   4 +
>  lib/crypto/arc4.c                  |  74 ++++++++++++
>  net/mac80211/Kconfig               |   2 +-
>  net/mac80211/cfg.c                 |   4 +-
>  net/mac80211/ieee80211_i.h         |   4 +-
>  net/mac80211/key.h                 |   1 +
>  net/mac80211/main.c                |   6 +-
>  net/mac80211/mlme.c                |   3 +-
>  net/mac80211/tkip.c                |   8 +-
>  net/mac80211/tkip.h                |   4 +-
>  net/mac80211/wep.c                 |  49 ++------
>  net/mac80211/wep.h                 |   5 +-
>  net/mac80211/wpa.c                 |   4 +-
>  net/wireless/Kconfig               |   2 +
>  net/wireless/lib80211_crypt_tkip.c |  48 +++-----
>  net/wireless/lib80211_crypt_wep.c  |  51 ++------
>  27 files changed, 205 insertions(+), 371 deletions(-)
>  create mode 100644 lib/crypto/Makefile
>  create mode 100644 lib/crypto/arc4.c

For the series:

	Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
