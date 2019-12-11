Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AD9C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07F8214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfLKJjN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:39:13 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54434 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfLKJjN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:39:13 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieySK-00008Q-PN; Wed, 11 Dec 2019 17:38:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieySC-0005TH-9x; Wed, 11 Dec 2019 17:38:44 +0800
Date:   Wed, 11 Dec 2019 17:38:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7] crypto: x86: Regularize glue function prototypes
Message-ID: <20191211093844.vwguh6yjgab5hza5@gondor.apana.org.au>
References: <201911262205.FD985935F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201911262205.FD985935F@keescook>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 26, 2019 at 10:08:02PM -0800, Kees Cook wrote:
> The crypto glue performed function prototype casting via macros to make
> indirect calls to assembly routines. Instead of performing casts at the
> call sites (which trips Control Flow Integrity prototype checking), switch
> each prototype to a common standard set of arguments which allows the
> removal of the existing macros. In order to keep pointer math unchanged,
> internal casting between u128 pointers and u8 pointers is added.
> 
> Co-developed-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v7:
> - added João's SoB (ebiggers)
> - corrected aesni .S prototype comments (ebiggers)
> - collapsed glue series into a single patch (ebiggers)
> v6: https://lore.kernel.org/lkml/20191122010334.12081-1-keescook@chromium.org
> v5: https://lore.kernel.org/lkml/20191113182516.13545-1-keescook@chromium.org
> v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
> v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org
> ---
>  arch/x86/crypto/aesni-intel_asm.S          |  8 +--
>  arch/x86/crypto/aesni-intel_glue.c         | 45 ++++++-------
>  arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++-----------
>  arch/x86/crypto/camellia_aesni_avx_glue.c  | 72 +++++++++------------
>  arch/x86/crypto/camellia_glue.c            | 45 +++++++------
>  arch/x86/crypto/cast6_avx_glue.c           | 68 +++++++++-----------
>  arch/x86/crypto/glue_helper.c              | 23 ++++---
>  arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
>  arch/x86/crypto/serpent_avx_glue.c         | 63 +++++++++---------
>  arch/x86/crypto/serpent_sse2_glue.c        | 30 +++++----
>  arch/x86/crypto/twofish_avx_glue.c         | 75 ++++++++++------------
>  arch/x86/crypto/twofish_glue_3way.c        | 37 ++++++-----
>  arch/x86/include/asm/crypto/camellia.h     | 63 +++++++++---------
>  arch/x86/include/asm/crypto/glue_helper.h  | 18 ++----
>  arch/x86/include/asm/crypto/serpent-avx.h  | 20 +++---
>  arch/x86/include/asm/crypto/serpent-sse2.h | 28 ++++----
>  arch/x86/include/asm/crypto/twofish.h      | 19 +++---
>  crypto/cast6_generic.c                     | 18 +++---
>  crypto/serpent_generic.c                   |  6 +-
>  include/crypto/cast6.h                     |  4 +-
>  include/crypto/serpent.h                   |  4 +-
>  include/crypto/xts.h                       |  2 -
>  22 files changed, 374 insertions(+), 413 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
