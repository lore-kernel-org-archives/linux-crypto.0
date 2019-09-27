Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13437C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBB1A20835
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbfI0EB4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 00:01:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39168 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfI0EB4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 00:01:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iDhRw-0001yA-0u; Fri, 27 Sep 2019 14:01:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Sep 2019 14:01:41 +1000
Date:   Fri, 27 Sep 2019 14:01:41 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
Message-ID: <20190927040140.GA24370@gondor.apana.org.au>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org>
 <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 26, 2019 at 07:54:03PM -0700, Linus Torvalds wrote:
>
> There's no "read_potentially_async()" interface that just does the
> synchronous read for any cached portion of the data, and then delays
> just the IO parts and returns a "here, I gave you X bytes right now,
> use this cookie to wait for the rest".

Incidentally this is exactly how the crypto async interface works.
For example, the same call works whether you're sync or async:

	aead_request_set_callback(req, ...);
	aead_request_set_crypt(req, ...);
	err = crypto_aead_encrypt(req);
	if (err == -EINPROGRESS)
		/*
		 * Request is processed asynchronously.
		 * This cannot occur if the algorithm is sync,
		 * e.g., when you specifically allocated sync
		 * algorithms.
		 */
	else
		/* Request was processed synchronously */

We even allow the request to be on the stack in the sync case, e.g.,
with SYNC_SKCIPHER_REQUEST_ON_STACK.

> Maybe nobody would use it. But it really should be possibly to have
> interfaces where a good synchronous implementation is _possible_
> without the extra overhead, while also allowing async implementations.

So there is really no async overhead in the crypto API AFAICS if
you're always doing sync.  What you see as overheads are probably
the result of having to support multiple underlying algorithms
(not just accelerations which can indeed be handled without
indirection at least for CPU-based ones).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
