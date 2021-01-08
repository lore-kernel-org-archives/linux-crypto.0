Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B30FC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 04:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0800822A99
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 04:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbhAHEmk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:42:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40320 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbhAHEmk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 23:42:40 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kxjau-0006jN-5w; Fri, 08 Jan 2021 15:41:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Jan 2021 15:41:48 +1100
Date:   Fri, 8 Jan 2021 15:41:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: Fix divide error in do_xor_speed()
Message-ID: <20210108044147.GB12339@gondor.apana.org.au>
References: <160933061716.928967.463919628731790218.stgit@localhost.localdomain>
 <CAMj1kXHTzafF5ZZR5Ornusjt6cd0K-Lczb0Z0FK54jBTv9cKsA@mail.gmail.com>
 <30381b78-8721-5b4e-e075-300c5af3f9fa@virtuozzo.com>
 <CAD=FV=Uq5TWpObFLhHBp7T4esuT_qaaMuYGaEz7xy1_MD5w_Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Uq5TWpObFLhHBp7T4esuT_qaaMuYGaEz7xy1_MD5w_Gw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 05, 2021 at 01:24:18PM -0800, Doug Anderson wrote:
>
> ...so while I think your fix will avoid the crash and could land as a
> stopgap, it's a sign that we need to run more repetitions on your
> particular setup to get accurate timings.  Your patch will probably
> cause it to just randomly pick one of the implementations.

We can always do a follow-up patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
