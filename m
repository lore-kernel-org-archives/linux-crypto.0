From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Thu, 03 Nov 2016 13:08:52 -0400 (EDT)
Message-ID: <20161103.130852.1456848512897088071.davem@davemloft.net>
References: <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
        <20161103004934.GA30775@gondor.apana.org.au>
        <CAHmME9oL-pOWWXXFhJz1vSm5ftnSfmYrquGbH0acapgEL=c4Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin@strongswan.org
To: Jason@zx2c4.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:38678 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758278AbcKCRIy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Nov 2016 13:08:54 -0400
In-Reply-To: <CAHmME9oL-pOWWXXFhJz1vSm5ftnSfmYrquGbH0acapgEL=c4Ew@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 3 Nov 2016 08:24:57 +0100

> Hi Herbert,
> 
> On Thu, Nov 3, 2016 at 1:49 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> FWIW I'd rather live with a 6% slowdown than having two different
>> code paths in the generic code.  Anyone who cares about 6% would
>> be much better off writing an assembly version of the code.
> 
> Please think twice before deciding that the generic C "is allowed to
> be slow".

In any event no piece of code should be doing 32-bit word reads from
addresses like "x + 3" without, at a very minimum, going through the
kernel unaligned access handlers.

Yet that is what the generic C poly1305 code is doing, all over the
place.

We know explicitly that these offsets will not be 32-bit aligned, so
it is required that we use the helpers, or alternatively do things to
avoid these unaligned accesses such as using temporary storage when
the HAVE_EFFICIENT_UNALIGNED_ACCESS kconfig value is not set.
