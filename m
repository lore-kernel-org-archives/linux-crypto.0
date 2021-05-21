Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD2DC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F226600CC
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhEUH5M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 03:57:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55850 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhEUH5L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 03:57:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lk00a-0004WP-00; Fri, 21 May 2021 15:55:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lk00W-0005qv-MY; Fri, 21 May 2021 15:55:44 +0800
Date:   Fri, 21 May 2021 15:55:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v3 1/7] crypto: handle zero sized AEAD inputs correctly
Message-ID: <20210521075544.kywxswbfyoauvhmg@gondor.apana.org.au>
References: <20210512184439.8778-1-ardb@kernel.org>
 <20210512184439.8778-2-ardb@kernel.org>
 <YJw01Z3oxwY5Sfpa@gmail.com>
 <CAMj1kXHofDrzEs4qc8VNCLpyL-Hc4PSg-JXKTckJvfD6qoK78Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHofDrzEs4qc8VNCLpyL-Hc4PSg-JXKTckJvfD6qoK78Q@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 11:24:09PM +0200, Ard Biesheuvel wrote:
>
> The difference is that zero sized inputs never make sense for
> skciphers, but for AEADs, they could occur, even if they are uncommon
> (the AEAD could have associated data only, and no plain/ciphertext)

I don't see what a zero-sized input has to do with this though.
When the walk->nbytes is zero, that means that you must never
call the done function, because the walk state could be in error
in which case everything would have been freed already and calling
the done function may potentially cause a double-free.

I don't understand why in the case of AEAD you cannot structure
your code such that the done function is not called when nbytes
is zero.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
