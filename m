Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C914DC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3A6D206D9
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgAPH15 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 02:27:57 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39812 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbgAPH15 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 02:27:57 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1irzZM-0005Sx-9r; Thu, 16 Jan 2020 15:27:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1irzZL-0000lC-Ig; Thu, 16 Jan 2020 15:27:55 +0800
Date:   Thu, 16 Jan 2020 15:27:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH v8 0/4] crypto: poly1305 improvements
Message-ID: <20200116072755.lxy27mbfwb6jyjjq@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106034049.265162-1-Jason@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Sorry for the repost so soon after version 7. Version 8 fixes a build
> error spotted by kbuild, due to mixing object file name and module name.
> Other than that derp, it's identical to version 7.
> 
> Version 7 incorporates suggestions from the mailing list on version 6.
> We now use a union type to handle the poly1305_core_key, per suggestion.
> And now the changes to the cryptogams code are nicely split out into its
> own commit, with detail on the (limited) scope of the changes. I believe
> this should address the last of issues brought up.
> 
> ####
> 
> These are some improvements to the Poly1305 code that I think should be
> fairly uncontroversial. The first part, the new C implementations, adds
> cleaner code in two forms that can easily be compared and reviewed, and
> also results in performance speedups. The second part, the new x86_64
> implementation, replaces an slow unvetted implementation with an
> extremely fast implementation that has received many eyeballs. Finally,
> we fix up some dead code.
> 
> Jason A. Donenfeld (4):
>  crypto: poly1305 - add new 32 and 64-bit generic versions
>  crypto: x86_64/poly1305 - import unmodified cryptogams implementation
>  crypto: x86_64/poly1305 - wire up faster implementations for kernel
>  crypto: arm/arm64/mips/poly1305 - remove redundant non-reduction from
>    emit
> 
> arch/arm/crypto/poly1305-glue.c               |   18 +-
> arch/arm64/crypto/poly1305-glue.c             |   18 +-
> arch/mips/crypto/poly1305-glue.c              |   18 +-
> arch/x86/crypto/.gitignore                    |    1 +
> arch/x86/crypto/Makefile                      |   11 +-
> arch/x86/crypto/poly1305-avx2-x86_64.S        |  390 --
> arch/x86/crypto/poly1305-sse2-x86_64.S        |  590 ---
> arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 4265 +++++++++++++++++
> arch/x86/crypto/poly1305_glue.c               |  308 +-
> crypto/adiantum.c                             |    4 +-
> crypto/nhpoly1305.c                           |    2 +-
> crypto/poly1305_generic.c                     |   25 +-
> include/crypto/internal/poly1305.h            |   45 +-
> include/crypto/nhpoly1305.h                   |    4 +-
> include/crypto/poly1305.h                     |   26 +-
> lib/crypto/Kconfig                            |    2 +-
> lib/crypto/Makefile                           |    4 +-
> lib/crypto/poly1305-donna32.c                 |  204 +
> lib/crypto/poly1305-donna64.c                 |  185 +
> lib/crypto/poly1305.c                         |  169 +-
> 20 files changed, 4924 insertions(+), 1365 deletions(-)
> create mode 100644 arch/x86/crypto/.gitignore
> delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
> delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
> create mode 100644 arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> create mode 100644 lib/crypto/poly1305-donna32.c
> create mode 100644 lib/crypto/poly1305-donna64.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
