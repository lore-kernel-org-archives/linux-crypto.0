Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F620C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 03:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AC13207FF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 03:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfI0Dx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 23:53:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39138 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbfI0Dx4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 23:53:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iDhKB-0001tc-SV; Fri, 27 Sep 2019 13:53:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Sep 2019 13:53:19 +1000
Date:   Fri, 27 Sep 2019 13:53:19 +1000
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
Message-ID: <20190927035319.GA23566@gondor.apana.org.au>
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
> Side note: almost nobody does this.
> 
> Almost every single async interface I've ever seen ends up being "only
> designed for async".
> 
> And I think the reason is that everybody first does the simply
> synchronous interfaces, and people start using those, and a lot of
> people are perfectly happy with them. They are simple, and they work
> fine for the huge majority of users.

The crypto API is not the way it is because of async.  In fact, the
crypto API started out as sync only and async was essentially
bolted on top with minimial changes.

The main reason why the crypto API contains indirections is because
of the algorithmic flexibility which WireGuard does not need.

Now whether algorithmic flexibility is a good thing or not is a
different discussion.  But the fact of the matter is that the
majority of heavy crypto users in our kernel do require this
flexibility (e.g., IPsec, dmcrypt, fscrypt).

I don't have a beef with the fact that WireGuard is tied to a
single algorithm.  However, that simply does not work for the
other users that we will have to continue to support.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
