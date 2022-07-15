Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836B5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jul 2022 08:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiGOItV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jul 2022 04:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiGOItV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jul 2022 04:49:21 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E2525F5;
        Fri, 15 Jul 2022 01:49:20 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCH09-000nut-Kc; Fri, 15 Jul 2022 18:48:47 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:48:45 +0800
Date:   Fri, 15 Jul 2022 16:48:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/blowfish: remove redundant assignment to
 variable nytes
Message-ID: <YtEp7Ubl+fnCBePR@gondor.apana.org.au>
References: <20220707080546.151730-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707080546.151730-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 07, 2022 at 09:05:46AM +0100, Colin Ian King wrote:
> Variable nbytes is being assigned a value that is never read, it is
> being re-assigned in the next statement in the while-loop. The
> assignment is redundant and can be removed.
> 
> Cleans up clang scan-build warnings, e.g.:
> arch/x86/crypto/blowfish_glue.c:147:10: warning: Although the value
> stored to 'nbytes' is used in the enclosing expression, the value
> is never actually read from 'nbytes'
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  arch/x86/crypto/blowfish_glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
