From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Wed, 2 Nov 2016 22:25:00 +0100
Message-ID: <CAHmME9rOM-tE=o_4yFd=N1Bw1ur-QKQ-Wp6pnaJ8d62_Eug9og@mail.gmail.com>
References: <20161102175810.18647-1-Jason@zx2c4.com> <20161102200959.GA23297@gondor.apana.org.au>
 <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com> <20161102210802.GA26741@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:42185 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757362AbcKBVZF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 17:25:05 -0400
In-Reply-To: <20161102210802.GA26741@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These architectures select HAVE_EFFICIENT_UNALIGNED_ACCESS:

s390 arm arm64 powerpc x86 x86_64

So, these will use the original old code.

The architectures that will thus use the new code are:

alpha arc avr32 blackfin c6x cris frv h7300 hexagon ia64 m32r m68k
metag microblaze mips mn10300 nios2 openrisc parisc score sh sparc
tile um unicore32 xtensa

Unfortunately, of these, the only machines I have access to are MIPS.
My SPARC access went cold a few years ago.

If you insist on a data-motivated approach approach, then I fear my
test of 1 out of 26 different architectures is woefully insufficient.
Does anybody else on the list have access to more hardware and is
interested in benchmarking?

If not, is there a reasonable way to decide on this by considering the
added complexity of code? Are we able to reason best and worst cases
of instruction latency vs unalignment stalls for most CPU designs?
