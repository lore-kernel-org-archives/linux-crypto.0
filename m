Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EC4C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 00:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BE9061A3A
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 00:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhJCA3u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Oct 2021 20:29:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55798 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhJCA3u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Oct 2021 20:29:50 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mWpMJ-0006pR-3F; Sun, 03 Oct 2021 08:28:03 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mWpMH-0001QV-I3; Sun, 03 Oct 2021 08:28:01 +0800
Date:   Sun, 3 Oct 2021 08:28:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, llvm@lists.linux.dev
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211003002801.GA5435@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVdNFzs8HUQwHa54@archlinux-ax161>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 01, 2021 at 11:01:59AM -0700, Nathan Chancellor wrote:
>
> I have attached the Kconfig file that I used to reproduce it. It is
> still reproducible for me at your latest commit in cryptodev
> (e42dff467ee688fe6b5a083f1837d06e3b27d8c0) with that exact command that
> I gave you.
> 
> It is possible that it could be crypto_boot_test_finished?

I don't think that's the issue because algapi already depends on
api.  However, the softdep on cryptomgr in api looks suspicious,
as it would always introduce a loop.  Can you try removing that
softdep from api.c and see if the problem resolves it self?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
