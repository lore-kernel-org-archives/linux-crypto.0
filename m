Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFF9C3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ADE321848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfHVF6C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:58:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58452 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731523AbfHVF6C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 01:58:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0g6K-00030i-Oa; Thu, 22 Aug 2019 15:57:36 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0g6G-00013W-Es; Thu, 22 Aug 2019 15:57:32 +1000
Date:   Thu, 22 Aug 2019 15:57:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] crypto: sha256 - Merge 2 separate C
 implementations into 1, put into separate library
Message-ID: <20190822055732.GI3860@gondor.apana.org.au>
References: <20190817142435.8532-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817142435.8532-1-hdegoede@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 17, 2019 at 04:24:28PM +0200, Hans de Goede wrote:
> Hi All,
> 
> Here is v2 of my patch series refactoring the current 2 separate SHA256
> C implementations into 1 and put it into a separate library.
> 
> There are 3 reasons for this:
> 
> 1) Remove the code duplication of having 2 separate implementations
> 
> 2) Offer a separate library SHA256 implementation which can be used
> without having to call crypto_alloc_shash first. This is especially
> useful for use during early boot when crypto_alloc_shash does not
> work yet.
> 
> 3) Having the purgatory code using the same code as the crypto subsys means
> that the purgratory code will be tested by the crypto subsys selftests.
> 
> This has been tested on x86, including checking that kecec still works.
> 
> This has NOT been tested on s390, if someone with access to s390 can
> test that things still build with this series applied and that
> kexec still works, that would be great.
> 
> Changes in v2:
> - Use put_unaligned_be32 to store the hash to allow callers to use an
>   unaligned buffer for storing the hash
> - Add a comment to include/crypto/sha256.h explaining that these functions
>   now may be used outside of the purgatory too (and that using the crypto
>   API instead is preferred)
> - Add sha224 support to the lib/crypto/sha256 library code
> - Make crypto/sha256_generic.c not only use sha256_transform from
>   lib/crypto/sha256.c but also switch it to using sha256_init, sha256_update
>   and sha256_final from there so that the crypto subsys selftests fully test
>   the lib/crypto/sha256.c implementation

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
