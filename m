Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB3BC05027
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 09:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjBJJpq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjBJJpp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 04:45:45 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDFD5C498
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 01:45:44 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQPyN-009c0J-Ax; Fri, 10 Feb 2023 17:45:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Feb 2023 17:45:39 +0800
Date:   Fri, 10 Feb 2023 17:45:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-crypto@vger.kernel.org, peter@n8pjl.ca, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: Re: [PATCH v2 0/3] crypto: x86/blowfish - Cleanup and convert to
 ECB/CBC macros
Message-ID: <Y+YSQxsegOhpBcx/@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131012624.6230-1-peter@n8pjl.ca>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Peter Lafreniere <peter@n8pjl.ca> wrote:
> We can acheive a reduction in code size by cleaning up unused logic in
> assembly functions, and by replacing handwritten ECB/CBC routines with
> helper macros from 'ecb_cbc_helpers.h'.
> 
> Additionally, these changes can allow future x86_64 optimized
> implementations to take advantage of blowfish-x86_64's fast 1-way and
> 4-way functions with less code churn.
> 
> When testing the patch, I saw a few percent lower cycle counts per
> iteration on Intel Skylake for both encryption and decryption. This
> is merely a single observation and this series has not been rigorously
> benchmarked, as performance changes are not expected. 
> 
> v1 -> v2:
> - Fixed typo that caused an assembler failure
> - Added note about performance to cover letter
> 
> Peter Lafreniere (3):
>  crypto: x86/blowfish - Remove unused encode parameter
>  crypto: x86/blowfish - Convert to use ECB/CBC helpers
>  crypto: x86/blowfish - Eliminate use of SYM_TYPED_FUNC_START in asm
> 
> arch/x86/crypto/blowfish-x86_64-asm_64.S |  71 ++++----
> arch/x86/crypto/blowfish_glue.c          | 200 +++--------------------
> 2 files changed, 55 insertions(+), 216 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
