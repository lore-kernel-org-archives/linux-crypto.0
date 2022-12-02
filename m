Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B51DC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 10:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiLBKUb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiLBKUa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 05:20:30 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A3CCFE3;
        Fri,  2 Dec 2022 02:20:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p139L-003CCn-SP; Fri, 02 Dec 2022 18:20:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Dec 2022 18:20:07 +0800
Date:   Fri, 2 Dec 2022 18:20:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Joe Fradley <joefradley@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kernel-team@android.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/curve25519 - disable gcov
Message-ID: <Y4nRV1u4ZU/WAa0X@gondor.apana.org.au>
References: <20221122225450.789234-1-joefradley@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122225450.789234-1-joefradley@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 22, 2022 at 02:54:49PM -0800, Joe Fradley wrote:
> curve25519-x86_64.c fails to build when CONFIG_GCOV_KERNEL is enabled.
> The error is "inline assembly requires more registers than available"
> thrown from the `fsqr()` function. Therefore, excluding this file from
> GCOV profiling until this issue is resolved. Thereby allowing
> CONFIG_GCOV_PROFILE_ALL to be enabled for x86.
> 
> Signed-off-by: Joe Fradley <joefradley@google.com>
> ---
>  arch/x86/crypto/Makefile | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
