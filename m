Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFFDC6FD1F
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 09:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjCKJmJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 04:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCKJmF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 04:42:05 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612C31981
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 01:42:04 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pavQB-002xuf-05; Sat, 11 Mar 2023 17:21:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Mar 2023 17:21:46 +0800
Date:   Sat, 11 Mar 2023 17:21:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB
 mode
Message-ID: <ZAxIKu3t4NJEGz6I@gondor.apana.org.au>
References: <ZAsDT00Jgs2p6luL@gondor.apana.org.au>
 <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
 <ZAw2eHDQELdiVXcZ@gondor.apana.org.au>
 <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au>
 <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
 <ZAxAK2rlOsQjlgB9@gondor.apana.org.au>
 <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
 <ZAxDOhfuSTsgncMU@gondor.apana.org.au>
 <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 11, 2023 at 10:02:01AM +0100, Ard Biesheuvel wrote:
>
> So we are basically going back to ablkcipher/blkcipher then? How about aead?

No I just dug up the old blkcipher code and it's based on SGs
just like skcipher.

I went back to the beginning of git and we've only ever had
an SG-based encryption interface.  This would be the very first
time that we've had this in the Crypto API.

Do we have any potential users for such an AEAD interface?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
