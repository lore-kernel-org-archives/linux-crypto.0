Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1E0C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 12:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BEB720665
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 12:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfHOMIU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 08:08:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57268 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbfHOMIU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 08:08:20 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hyEYD-0003RU-Kq; Thu, 15 Aug 2019 22:08:17 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hyEYD-0007kB-CR; Thu, 15 Aug 2019 22:08:17 +1000
Date:   Thu, 15 Aug 2019 22:08:17 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v2 0/3] crypto: aegis128 followup
Message-ID: <20190815120817.GJ29355@gondor.apana.org.au>
References: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 12, 2019 at 01:59:09AM +0300, Ard Biesheuvel wrote:
> This series resubmits the aegis128 SIMD patches that were reverted due to
> the fact that the compiler's optimization behavior wrt variables with static
> linkage does not turn out to guarantee that function calls that are
> conditional on the value of such a variable are optimized away if the value
> is a compile time constant and the condition evaluates to false at compile
> time as well.
> 
> Changes since v1:
> - minor tweaks to #2 to drop a memset() invocation from the decrypt path,
>   and some temp vars in various places
> - update the NEON code in #3 so it builds with Clang as well as GCC (and
>   drop the RFC annotation)
> 
> Patch #1 reintroduces the changes to the generic code to permit SIMD
> routines to be attached to the aegis128 driver. This time, the conditional
> check is pulled into a helper function which collapses to 'return false'
> if the CONFIG_CRYPTO_AEGIS128_SIMD Kconfig symbol is not set. (This has
> been confirmed by one of the reporters of the original issue as sufficient
> to address the problem).
> 
> Patch #2 is mostly unchanged wrt the version that got reverted, only some
> inline annotations were added back.
> 
> Patch #3 is new and implements the SIMD routines for arm64 without using
> the optional AES instructions, but using plain SIMD arithmetic instead.
> This is much slower than AES instructions, but still substantially more
> efficient than table based scalar AES on systems where memory accesses are
> expensive, such as the Raspberry Pi 3 (which does not implement the AES
> instructions)
> 
> Ard Biesheuvel (3):
>   crypto: aegis128 - add support for SIMD acceleration
>   crypto: aegis128 - provide a SIMD implementation based on NEON
>     intrinsics
>   crypto: arm64/aegis128 - implement plain NEON version
> 
>  crypto/Kconfig                         |   5 +
>  crypto/Makefile                        |  20 ++
>  crypto/{aegis128.c => aegis128-core.c} |  52 ++++-
>  crypto/aegis128-neon-inner.c           | 212 ++++++++++++++++++++
>  crypto/aegis128-neon.c                 |  49 +++++
>  5 files changed, 334 insertions(+), 4 deletions(-)
>  rename crypto/{aegis128.c => aegis128-core.c} (89%)
>  create mode 100644 crypto/aegis128-neon-inner.c
>  create mode 100644 crypto/aegis128-neon.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
