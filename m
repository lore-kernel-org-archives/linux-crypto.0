Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400ACC3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1106521848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfHVF5H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:57:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58408 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbfHVF5H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 01:57:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0g5o-0002zA-Hw; Thu, 22 Aug 2019 15:57:04 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0g5m-00012g-W8; Thu, 22 Aug 2019 15:57:03 +1000
Date:   Thu, 22 Aug 2019 15:57:02 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        smueller@chronox.de
Subject: Re: [PATCH v2] crypto: x86/xts - implement support for ciphertext
 stealing
Message-ID: <20190822055702.GF3860@gondor.apana.org.au>
References: <20190816122150.22170-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816122150.22170-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 16, 2019 at 03:21:50PM +0300, Ard Biesheuvel wrote:
> Align the x86 code with the generic XTS template, which now supports
> ciphertext stealing as described by the IEEE XTS-AES spec P1619.
> 
> Tested-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> v2: - move 'decrypt' flag from glue ctx struct to function prototype
>     - remove redundant goto
>     - make 'final_tweak' a pointer
>     - fix typo in subject
> 
>  arch/x86/crypto/aesni-intel_glue.c         |  6 +-
>  arch/x86/crypto/camellia_aesni_avx2_glue.c |  4 +-
>  arch/x86/crypto/camellia_aesni_avx_glue.c  |  4 +-
>  arch/x86/crypto/cast6_avx_glue.c           |  4 +-
>  arch/x86/crypto/glue_helper.c              | 67 +++++++++++++++++++-
>  arch/x86/crypto/serpent_avx2_glue.c        |  4 +-
>  arch/x86/crypto/serpent_avx_glue.c         |  4 +-
>  arch/x86/crypto/twofish_avx_glue.c         |  4 +-
>  arch/x86/include/asm/crypto/glue_helper.h  |  2 +-
>  9 files changed, 81 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
