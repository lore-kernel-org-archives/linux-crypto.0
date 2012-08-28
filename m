From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH v2 5/5] crypto: talitos - add IPsec ESN support
Date: Tue, 28 Aug 2012 15:47:19 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE992E16AB@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1344440805-20324-1-git-send-email-horia.geanta@freescale.com>
 <20120808202215.da5ef82b25f655956cabae80@freescale.com>
 <20120820083212.GE22951@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:26564
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149Ab2H1Pr3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 11:47:29 -0400
In-Reply-To: <20120820083212.GE22951@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 20 Aug 2012 11:32:12 +0300, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Aug 08, 2012 at 08:22:15PM -0500, Kim Phillips wrote:
>> On Wed, 8 Aug 2012 18:46:45 +0300
>> Horia Geanta <horia.geanta@freescale.com> wrote:
>> 
>>> Support for ESNs (extended sequence numbers).
>>> Tested with strongswan on a P2020RDB back-to-back setup.
>>> Extracted from /etc/ipsec.conf:
>>> esp=aes-sha1-esn-modp4096!
>>> 
>>> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
>>> ---
>> 
>> series:
>> 
>> Reviewed-by: Kim Phillips <kim.phillips@freescale.com>
> 
> Patch applied.  Thanks!

What about patches [1-4]/5 ?
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg07507.html

Patch 5/5 won't work without these.
4/5 adds "support for handling non-contiguous assoc data and iv", which is
exactly how native IPsec submits SPI + ESN to talitos.

Horia
