Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D051FEB64DA
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 10:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjGDKKu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 06:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjGDKKt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 06:10:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E801EF1;
        Tue,  4 Jul 2023 03:10:45 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qGczZ-000RoK-EA; Tue, 04 Jul 2023 20:10:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Jul 2023 18:10:34 +0800
Date:   Tue, 4 Jul 2023 18:10:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     Ondrej Mosnacek <omosnacek@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        regressions@lists.linux.dev
Subject: Re: Regression bisected to "crypto: af_alg: Convert
 af_alg_sendpage() to use MSG_SPLICE_PAGES"
Message-ID: <ZKPwGognao8MZkdV@gondor.apana.org.au>
References: <ZKPgkgiddAl9qddT@gondor.apana.org.au>
 <CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com>
 <1357760.1688460637@warthog.procyon.org.uk>
 <1361504.1688463705@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361504.1688463705@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 04, 2023 at 10:41:45AM +0100, David Howells wrote:
>
> I didn't change vmsplice() or the way pages are stored in the pipe.
> 
> And, note, there are also a bunch of GUP changes that could have an effect.

This crash was bisected to your commit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
