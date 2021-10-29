Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F10C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5AA60724
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhJ2NOm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:14:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56400 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231610AbhJ2NOj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:14:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mgRfy-0002qL-B6; Fri, 29 Oct 2021 21:12:06 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mgRfw-0003E0-2d; Fri, 29 Oct 2021 21:12:04 +0800
Date:   Fri, 29 Oct 2021 21:12:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: pcrypt - Delay write to padata->info
Message-ID: <20211029131204.GE12278@gondor.apana.org.au>
References: <20211021183028.837112-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021183028.837112-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 21, 2021 at 02:30:28PM -0400, Daniel Jordan wrote:
> These three events can race when pcrypt is used multiple times in a
> template ("pcrypt(pcrypt(...))"):
> 
>   1.  [taskA] The caller makes the crypto request via crypto_aead_encrypt()
>   2.  [kworkerB] padata serializes the inner pcrypt request
>   3.  [kworkerC] padata serializes the outer pcrypt request
> 
> 3 might finish before the call to crypto_aead_encrypt() returns in 1,
> resulting in two possible issues.
> 
> First, a use-after-free of the crypto request's memory when, for
> example, taskA writes to the outer pcrypt request's padata->info in
> pcrypt_aead_enc() after kworkerC completes the request.
> 
> Second, the outer pcrypt request overwrites the inner pcrypt request's
> return code with -EINPROGRESS, making a successful request appear to
> fail.  For instance, kworkerB writes the outer pcrypt request's
> padata->info in pcrypt_aead_done() and then taskA overwrites it
> in pcrypt_aead_enc().
> 
> Avoid both situations by delaying the write of padata->info until after
> the inner crypto request's return code is checked.  This prevents the
> use-after-free by not touching the crypto request's memory after the
> next-inner crypto request is made, and stops padata->info from being
> overwritten.
> 
> Fixes: 5068c7a883d16 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
> Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> So, pcrypt(pcrypt(...)) doesn't make all that much sense, but apparently
> there's not an easy way to prevent it [1], so I'm going with the minimal
> fix.
> 
> [1] https://lkml.kernel.org/20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de/
> 
>  crypto/pcrypt.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
