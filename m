Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7785FC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 05:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiCVFvN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 01:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiCVFvM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 01:51:12 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49C3F0;
        Mon, 21 Mar 2022 22:49:43 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nWXOi-0007hA-Gs; Tue, 22 Mar 2022 16:49:37 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Mar 2022 17:49:36 +1200
Date:   Tue, 22 Mar 2022 17:49:35 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 5.18
Message-ID: <YjljbyMKvRObX/og@gondor.apana.org.au>
References: <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au>
 <20210215024721.GA20593@gondor.apana.org.au>
 <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au>
 <20210628110050.GA12162@gondor.apana.org.au>
 <20210830082818.GA30921@gondor.apana.org.au>
 <20211102035201.GA23331@gondor.apana.org.au>
 <Ydzlo+UmL5bbDgUZ@gondor.apana.org.au>
 <Yje766s7fIqYg1Tk@gondor.apana.org.au>
 <CAHk-=wix0F2nwk8v2Hmo-x6Yr0PEji9=oMTewk6YhL+ATM2fVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wix0F2nwk8v2Hmo-x6Yr0PEji9=oMTewk6YhL+ATM2fVg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 21, 2022 at 04:14:50PM -0700, Linus Torvalds wrote:
>
> Can I prod you in the direction of making signed tags a part of your
> workflow? The tag can contain the details of the pull - in which case
> git request-pull will populate the pull request with it - or it can be
> just some dummy message and you write the details separately in the
> pull request email like you do now.

Sure, I can do that starting with the next push request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
