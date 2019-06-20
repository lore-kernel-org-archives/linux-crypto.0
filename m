Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85814C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F0820449
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbfFTIGx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 04:06:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43614 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfFTIGx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 04:06:53 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hds5s-0002Fd-Fp; Thu, 20 Jun 2019 16:06:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hds5r-0007n3-0i; Thu, 20 Jun 2019 16:06:51 +0800
Date:   Thu, 20 Jun 2019 16:06:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v5 0/7] crypto: rc4 cleanup
Message-ID: <20190620080650.nqajc3aghetfydl6@gondor.apana.org.au>
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
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

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
