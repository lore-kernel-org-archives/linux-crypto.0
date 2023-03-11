Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92F4C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 09:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjCKJmE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 04:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCKJmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 04:42:03 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547601981
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 01:42:02 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pavjg-002y9Z-IU; Sat, 11 Mar 2023 17:41:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Mar 2023 17:41:56 +0800
Date:   Sat, 11 Mar 2023 17:41:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB
 mode
Message-ID: <ZAxM5NLU6a2SUDuh@gondor.apana.org.au>
References: <ZAw2eHDQELdiVXcZ@gondor.apana.org.au>
 <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au>
 <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
 <ZAxAK2rlOsQjlgB9@gondor.apana.org.au>
 <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
 <ZAxDOhfuSTsgncMU@gondor.apana.org.au>
 <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
 <ZAxIKu3t4NJEGz6I@gondor.apana.org.au>
 <CAMj1kXF6_JFMFTqzmXWxM=zJ7HmDqnivAKjUT=pN-34werkd5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF6_JFMFTqzmXWxM=zJ7HmDqnivAKjUT=pN-34werkd5g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 11, 2023 at 10:25:48AM +0100, Ard Biesheuvel wrote:
>
> So what use case is the driver for this sync skcipher change? And how

The main reason I wanted to do this is because I'd like to get
rid of crypto_cipher.  I'm planning on replacing the underlying
simple ciphers with their ECB equivalent.

> will this work with existing templates? Do they all have to implement
> two flavors now?

Let's say we're calling this vkcipher.  Because the existing
skcipher templates should continue to work with an underlying
vkcipher algorithm, I won't be adding any vkcipher template
unless there is a specific use-case, such as CFB here.

But I will do the common ones like CBC/CTR.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
