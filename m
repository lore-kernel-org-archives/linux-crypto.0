Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE249C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EF3321479
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbfDRO1u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:27:50 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55230 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388850AbfDRO1u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:27:50 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH80y-0004pE-5M; Thu, 18 Apr 2019 22:27:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH80n-0004Ez-GG; Thu, 18 Apr 2019 22:27:37 +0800
Date:   Thu, 18 Apr 2019 22:27:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Nayna <nayna@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] crypto: powerpc - convert to use crypto_simd_usable()
Message-ID: <20190418142737.ks6csnjjcfluacnz@gondor.apana.org.au>
References: <20190413053312.8783-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413053312.8783-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 10:33:12PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Replace all calls to in_interrupt() in the PowerPC crypto code with
> !crypto_simd_usable().  This causes the crypto self-tests to test the
> no-SIMD code paths when CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> 
> The p8_ghash algorithm is currently failing and needs to be fixed, as it
> produces the wrong digest when no-SIMD updates are mixed with SIMD ones.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/powerpc/crypto/crc32c-vpmsum_glue.c    | 4 +++-
>  arch/powerpc/crypto/crct10dif-vpmsum_glue.c | 4 +++-
>  arch/powerpc/include/asm/Kbuild             | 1 +
>  drivers/crypto/vmx/aes.c                    | 7 ++++---
>  drivers/crypto/vmx/aes_cbc.c                | 7 ++++---
>  drivers/crypto/vmx/aes_ctr.c                | 5 +++--
>  drivers/crypto/vmx/aes_xts.c                | 5 +++--
>  drivers/crypto/vmx/ghash.c                  | 9 ++++-----
>  8 files changed, 25 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
