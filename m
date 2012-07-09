From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH] crypto: testmgr - make the assoc data and iv contiguous
 for aead tests
Date: Mon, 9 Jul 2012 08:38:54 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE99234333@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1341821863-16074-1-git-send-email-horia.geanta@freescale.com>
 <20120709081935.GA12103@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Phillips Kim-R1AAHA <R1AAHA@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57386 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab2GIIi6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jul 2012 04:38:58 -0400
In-Reply-To: <20120709081935.GA12103@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 9 Jul 2012 11:19:35 +0300, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Jul 09, 2012 at 11:17:43AM +0300, Horia Geanta wrote:
>> In case of AEAD, some crypto engines expect assoc data and iv to be
>> contiguous. This is how native IPsec works; make testmgr's behaviour
>> the same. (Alternative would be to fix this in the crypto engine
>> drivers, but this is pricy since it would involve memory allocation and
>> copy in the hot path.)
>> 
>> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> 
> I think we should fix the buggy driver instead.
> 
> Thanks,

Ok, then we'll see how to work around the HW limitation in the driver,
without affecting performance too much.

Cheers,
Horia
