Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EE9ECAAD4
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 11:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244825AbiHZLIh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343636AbiHZLI0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 07:08:26 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB2EDF14;
        Fri, 26 Aug 2022 04:08:25 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRXCE-00FQDn-Ni; Fri, 26 Aug 2022 21:08:19 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 19:08:18 +0800
Date:   Fri, 26 Aug 2022 19:08:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Robert Elliott <elliott@hpe.com>
Cc:     davem@davemloft.net, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] crypto: Kconfig - simplify menus and help text
Message-ID: <Ywipov6gviNszSBp@gondor.apana.org.au>
References: <20220817232057.73643-1-elliott@hpe.com>
 <20220820184151.1149247-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820184151.1149247-1-elliott@hpe.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 20, 2022 at 01:41:34PM -0500, Robert Elliott wrote:
> Improve the "make menuconfig" experience under the
> Cryptographic API page.
> 
> Tested by running commands like these for arm, arm64, mips, powerpc,
> sparc, s390, and x86:
>     make ARCH=arm O=build-arm allmodconfig  # also defconfig
>     make ARCH=arm O=build-arm menuconfig
> 
> Patch series history:
> v2: divide into arch-specific Kconfig files, stop series
>     after the submenu patch
> v3: added back the entry name/help text changes after the
>     submenu patch; submenus suggested by Eric; rebased onto v6.0-rc1
> 
> Robert Elliott (17):
>   crypto: Kconfig - move mips entries to a submenu
>   crypto: Kconfig - move powerpc entries to a submenu
>   crypto: Kconfig - move s390 entries to a submenu
>   crypto: Kconfig - move sparc entries to a submenu
>   crypto: Kconfig - move x86 entries to a submenu
>   crypto: Kconfig - remove AES_ARM64 ref by SA2UL
>   crypto: Kconfig - submenus for arm and arm64
>   crypto: Kconfig - sort the arm64 entries
>   crypto: Kconfig - sort the arm entries
>   crypto: Kconfig - add submenus
>   crypto: Kconfig - simplify public-key entries
>   crypto: Kconfig - simplify CRC entries
>   crypto: Kconfig - simplify aead entries
>   crypto: Kconfig - simplify hash entries
>   crypto: Kconfig - simplify userspace entries
>   crypto: Kconfig - simplify cipher entries
>   crypto: Kconfig - simplify compression/RNG entries
> 
>  arch/arm/Kconfig                         |    4 -
>  arch/arm/configs/exynos_defconfig        |    1 -
>  arch/arm/configs/milbeaut_m10v_defconfig |    1 -
>  arch/arm/configs/multi_v7_defconfig      |    1 -
>  arch/arm/configs/omap2plus_defconfig     |    1 -
>  arch/arm/configs/pxa_defconfig           |    1 -
>  arch/arm/crypto/Kconfig                  |  238 ++-
>  arch/arm64/Kconfig                       |    3 -
>  arch/arm64/configs/defconfig             |    1 -
>  arch/arm64/crypto/Kconfig                |  281 ++-
>  arch/mips/crypto/Kconfig                 |   74 +
>  arch/powerpc/crypto/Kconfig              |   97 +
>  arch/s390/crypto/Kconfig                 |  135 ++
>  arch/sparc/crypto/Kconfig                |   90 +
>  arch/x86/crypto/Kconfig                  |  466 +++++
>  crypto/Kconfig                           | 2242 ++++++++--------------
>  drivers/crypto/Kconfig                   |    2 -
>  drivers/net/Kconfig                      |    2 -
>  18 files changed, 2001 insertions(+), 1639 deletions(-)
>  create mode 100644 arch/mips/crypto/Kconfig
>  create mode 100644 arch/powerpc/crypto/Kconfig
>  create mode 100644 arch/s390/crypto/Kconfig
>  create mode 100644 arch/sparc/crypto/Kconfig
>  create mode 100644 arch/x86/crypto/Kconfig
> 
> 
> base-commit: 0eaf37ee04dabc136acc68567c39d6dc35def06c
> prerequisite-patch-id: 45479e93dd6a6ed73701a2155cd151d2c296bc50
> prerequisite-patch-id: cd82799c9463ceb05a6528e9eac583020618754e
> -- 
> 2.37.1

All applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
