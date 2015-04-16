From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 4.1
Date: Wed, 15 Apr 2015 19:37:19 -0700
Message-ID: <CA+55aFz8pr-J7K-EY5gjCV7ajJZC2tkFwjNG1xLXvQk0qAm2HA@mail.gmail.com>
References: <20130223023331.GA11002@gondor.apana.org.au>
	<20130907035544.GA22658@gondor.apana.org.au>
	<20131107080131.GA32307@gondor.apana.org.au>
	<20140123115319.GA20602@gondor.apana.org.au>
	<20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
	<20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150415033951.GA1406@gondor.apana.org.au>
	<CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35063 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbDPChU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2015 22:37:20 -0400
In-Reply-To: <CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2015 at 6:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Apr 14, 2015 at 8:39 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> Here is the crypto update for 4.1:
>
> Just a heads-up: this breaks iwlwifi for me after suspend.

Ok, bisect completed:

    [torvalds@vaio linux]$ git bisect bad
    9c521a200bc3c12bd724e48a75c57d5358f672be is the first bad commit
    commit 9c521a200bc3c12bd724e48a75c57d5358f672be
    Author: Stephan Mueller <smueller@chronox.de>
    Date:   Thu Apr 9 12:09:55 2015 +0200

        crypto: api - remove instance when test failed
    ...

and while I have no idea *why* it breaks iwlwifi after a
suspend/resume cycle, it is 100% repeatable. The bisect zoomed right
to that commit, and reverting it on top of the current tree also makes
everything work again.

So it gets reverted. I'll be happy to test things out, but with the
merge window *and* travel, I may or may not be quick about it.

           Linus
