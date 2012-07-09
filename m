From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: testmgr - make the assoc data and iv contiguous
 for aead tests
Date: Mon, 9 Jul 2012 11:26:32 -0500
Message-ID: <20120709112632.66137bd25ff3bbad799d8ae5@freescale.com>
References: <1341821863-16074-1-git-send-email-horia.geanta@freescale.com>
	<20120709081935.GA12103@gondor.apana.org.au>
	<FD18E5D573A8AB48A365D4D78185DE99234333@039-SN1MPN1-001.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:10543
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab2GIQ2h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jul 2012 12:28:37 -0400
In-Reply-To: <FD18E5D573A8AB48A365D4D78185DE99234333@039-SN1MPN1-001.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 9 Jul 2012 03:38:54 -0500
Geanta Neag Horia Ioan-B05471 <B05471@freescale.com> wrote:

> On Mon, 9 Jul 2012 11:19:35 +0300, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Mon, Jul 09, 2012 at 11:17:43AM +0300, Horia Geanta wrote:
> >> In case of AEAD, some crypto engines expect assoc data and iv to be
> >> contiguous. This is how native IPsec works; make testmgr's behaviour
> >> the same. (Alternative would be to fix this in the crypto engine
> >> drivers, but this is pricy since it would involve memory allocation and
> >> copy in the hot path.)
> >> 
> >> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> > 
> > I think we should fix the buggy driver instead.

technically it's buggy h/w.  Even though SEC 2/3 descriptors have
separate fields for assoc and iv data, the h/w produces incorrect
results if they are disjoint.

> Ok, then we'll see how to work around the HW limitation in the driver,
> without affecting performance too much.

If it comes down to more than a simple unlikely(assoc_addr +
assoclen == iv_addr) check, then we may want to introduce a
TALITOS_STRICT config, which may be further made dependent on 
!CRYPTO_MANAGER_DISABLE_TESTS.

Kim
