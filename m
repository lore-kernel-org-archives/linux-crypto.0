Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D18DC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBB1B24683
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgAVKQO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:16:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39228 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgAVKQO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:16:14 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iuD3S-0000eQ-UF; Wed, 22 Jan 2020 18:16:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iuD3Q-00045N-Ct; Wed, 22 Jan 2020 18:16:08 +0800
Date:   Wed, 22 Jan 2020 18:16:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: arm/chacha - fix build failured when kernel mode
 NEON is disabled
Message-ID: <20200122101608.v7phje7p52rxjorw@gondor.apana.org.au>
References: <20200117164318.21941-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117164318.21941-1-ardb@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 17, 2020 at 05:43:18PM +0100, Ard Biesheuvel wrote:
> When the ARM accelerated ChaCha driver is built as part of a configuration
> that has kernel mode NEON disabled, we expect the compiler to propagate
> the build time constant expression IS_ENABLED(CONFIG_KERNEL_MODE_NEON) in
> a way that eliminates all the cross-object references to the actual NEON
> routines, which allows the chacha-neon-core.o object to be omitted from
> the build entirely.
> 
> Unfortunately, this fails to work as expected in some cases, and we may
> end up with a build error such as
> 
>   chacha-glue.c:(.text+0xc0): undefined reference to `chacha_4block_xor_neon'
> 
> caused by the fact that chacha_doneon() has not been eliminated from the
> object code, even though it will never be called in practice.
> 
> Let's fix this by adding some IS_ENABLED(CONFIG_KERNEL_MODE_NEON) tests
> that are not strictly needed from a logical point of view, but should
> help the compiler infer that the NEON code paths are unreachable in
> those cases.
> 
> Fixes: b36d8c09e710c71f ("crypto: arm/chacha - remove dependency on generic ...")
> Reported-by: Russell King <linux@armlinux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/chacha-glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
