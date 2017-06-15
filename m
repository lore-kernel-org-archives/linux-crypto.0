From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.12
Date: Thu, 15 Jun 2017 18:05:14 +0900
Message-ID: <CA+55aFyEeO1erYKDK1UA00suXwv1r6c1mnrsDPi4bX6ORJuoSA@mail.gmail.com>
References: <20161119102748.GA4277@gondor.apana.org.au> <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au> <20170304074119.GA3041@gondor.apana.org.au>
 <20170523034211.GA12748@gondor.apana.org.au> <20170608092320.GA6478@gondor.apana.org.au>
 <20170615005443.GA30435@gondor.apana.org.au> <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34789 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdFOJFQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 05:05:16 -0400
In-Reply-To: <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 15, 2017 at 6:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ugh, that's a particularly ugly fix for a random gcc bug on a random
> architecture that almost nobody tests.

.. anway, I pulled it, but I don't have to like it.

          Linus
