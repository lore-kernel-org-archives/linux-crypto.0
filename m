Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70790C0015E
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjG1KHT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjG1KHS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:07:18 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3954E1FF5;
        Fri, 28 Jul 2023 03:07:17 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qPKM4-0011VE-8y; Fri, 28 Jul 2023 18:05:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jul 2023 18:05:52 +0800
Date:   Fri, 28 Jul 2023 18:05:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Haren Myneni <haren@us.ibm.com>,
        Nick Terrell <terrelln@fb.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Richard Weinberger <richard@nod.at>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        qat-linux@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/21] crypto: consolidate and clean up compression
 APIs
Message-ID: <ZMOTAB595JyptIN4@gondor.apana.org.au>
References: <20230718125847.3869700-1-ardb@kernel.org>
 <ZMOQiPadP2jggZ2i@gondor.apana.org.au>
 <CAMj1kXFRAhoyRD8mGe4xKZ-xGord2vwPXHCM7O8DPOpYWcgnJw@mail.gmail.com>
 <ZMORcmIA/urS8OI4@gondor.apana.org.au>
 <CAMj1kXFnr64b7SA1zYvSOrXazdH_O5G=i4re=taQa9hAeRbh-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFnr64b7SA1zYvSOrXazdH_O5G=i4re=taQa9hAeRbh-w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 28, 2023 at 12:03:23PM +0200, Ard Biesheuvel wrote:
>
> Fair enough. But my point remains: this requires a lot of boilerplate
> on the part of the driver, and it would be better if we could do this
> in the acomp generic layer.

Absolutely.  If the hardware can't support allocate-as-you-go then
this should very much go into the generic layer.

> Does the IPcomp case always know the decompressed size upfront?

No it doesn't know.  Of course, we could optimise it because we know
that in 99% cases, the packet is going to be less than 4K.  But we
need a safety-net for those weird jumbo packets.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
