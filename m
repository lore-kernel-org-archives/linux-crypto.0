From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Wed, 2 Nov 2016 22:06:39 +0100
Message-ID: <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
References: <20161102175810.18647-1-Jason@zx2c4.com> <20161102200959.GA23297@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:52454 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754833AbcKBVGr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 17:06:47 -0400
In-Reply-To: <20161102200959.GA23297@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 2, 2016 at 9:09 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Can you give some numbers please? What about other architectures
> that your patch impacts?

Per [1], the patch gives a 181% speed up on MIPS32r2.

[1] https://lists.zx2c4.com/pipermail/wireguard/2016-September/000398.html
