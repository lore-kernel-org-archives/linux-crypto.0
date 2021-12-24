Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52077C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Dec 2021 03:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351154AbhLXDZY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 22:25:24 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58452 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351151AbhLXDZX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 22:25:23 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n0bCp-0006I4-7z; Fri, 24 Dec 2021 14:25:20 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Dec 2021 14:25:19 +1100
Date:   Fri, 24 Dec 2021 14:25:19 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Aymeric Fromherz <aymeric.fromherz@inria.fr>
Subject: Re: [PATCH] crypto: x86/curve25519 - use in/out register constraints
 more precisely
Message-ID: <YcU9n+B9HHob4s2x@gondor.apana.org.au>
References: <20211214160146.1073616-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214160146.1073616-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 14, 2021 at 05:01:46PM +0100, Jason A. Donenfeld wrote:
> Rather than passing all variables as modified, pass ones that are only
> read into that parameter. This helps with old gcc versions when
> alternatives are additionally used, and lets gcc's codegen be a little
> bit more efficient. This also syncs up with the latest Vale/EverCrypt
> output.
> 
> Reported-by: Mathias Krause <minipli@grsecurity.net>
> Cc: Aymeric Fromherz <aymeric.fromherz@inria.fr>
> Link: https://lore.kernel.org/wireguard/1554725710.1290070.1639240504281.JavaMail.zimbra@inria.fr/
> Link: https://github.com/project-everest/hacl-star/pull/501
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/x86/crypto/curve25519-x86_64.c | 767 ++++++++++++++++++----------
>  1 file changed, 489 insertions(+), 278 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
