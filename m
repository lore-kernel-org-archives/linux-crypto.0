Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6EAC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C85E2067B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfJJMzi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:55:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37644 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfJJMzh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:55:37 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIXyg-0001tB-T6; Thu, 10 Oct 2019 23:55:36 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:55:34 +1100
Date:   Thu, 10 Oct 2019 23:55:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, arnd@arndb.de,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject: Re: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8
 architecture explicitly
Message-ID: <20191010125534.GF31566@gondor.apana.org.au>
References: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 09:54:48AM +0200, Ard Biesheuvel wrote:
> Now that the Clang compiler has taken it upon itself to police the
> compiler command line, and reject combinations for arguments it views
> as incompatible, the AEGIS128 no longer builds correctly, and errors
> out like this:
> 
>   clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
>   architecture does not support it [-Winvalid-command-line-argument]
> 
> So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
> FPU profile we specify. Since neither were actually supported by GCC
> versions before 4.8, let's tighten the Kconfig dependencies as well so
> we won't run into errors when building with an ancient compiler.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig  | 1 +
>  crypto/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
