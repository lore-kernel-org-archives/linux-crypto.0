From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Wed, 11 Aug 2010 07:31:24 -0400 (EDT)
Message-ID: <142347329.201781281526284763.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <2115846701.201281281525518833.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org
To: Linus Walleij <linus.walleij@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58699 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257Ab0HKLbb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 07:31:31 -0400
In-Reply-To: <2115846701.201281281525518833.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
thanks your review and all comments.

----- "Linus Walleij" <linus.walleij@stericsson.com> wrote:
>    For internal keys, a function for compare of HMAC function results
>    could improve security considerably.
I'm afraid I don't understand what this refers to.  Can you give me an example?  (You already can use OP_VERIFY with a HMAC, provide it the key, input data and incoming HMAC value, and receive a pass/fail indication.)

> 3. A general interface for stream ciphers would be nice. The only differences
>    are that they do not operate on blocks, but bits, and that they always require
>    an IV.
I think this is already supported: the IV is specified in "session init" operation, subsequent "session update" operations use a single crypto_ablkcipher that implicitly carries the IV through the chain of "update"s.  Is that not sufficient?


> - The big patch 0002 to crypto/userspace is including the Makefile
>   changes for patch 0004 making it non-bisectable. Also it is very large,
>   is it possible to break it down a little?
It must be :)  I was lazy when posting it for initial review.

> Many files are prefixed "ncr-*"
>   and I don't see why - can this prefix simply be removed?
I suppose so - originally the module included two separate interfaces, "ncr-*" corresponds to the ncr.h inteface.

>   I hope the patch 0004 with software fallbacks is not strictly required
>   by the userspace API so these two can be considered separately?
Those are not fallbacks - AFAIK there is currently no RSA/DSA implementation in the kernel.  It can be separated from the userspace API at the cost of loss of functionality.

>   Else can you describe how the dependecies go.. surely  it must be
>   possible to patch in the software fallbacks in libtom* separately?
Right now ncr-dh.c and ncr-pk.c depend on libtomcrypt, and libtomcrypt depends on some utilities in patch 2/4.  At least the second dependency can be eliminated.

> - The big patch containing the entire libtomcrypt should be destined to
>   drivers/staging or similar at this point (OK it is not a driver, should have
>   been lib/staging if such a thing existed). The sheer size of it makes it very
>   hard to review, and all attempts at breaking it in smaller pieces would
>   be much appreciated.
As noted in the patch, we are considering replacing this with a libgcrypt-based implementation; this was included mainly for functional completeness.

Thanks again for the comments,
    Mirek
