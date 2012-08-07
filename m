From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH 5/5] crypto: talitos - add IPsec ESN support
Date: Tue, 7 Aug 2012 13:34:07 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE99293799@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
	<1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
 <20120806204751.1f6277ba8f7b1de92fd128ac@freescale.com>
 <FD18E5D573A8AB48A365D4D78185DE9929291E@039-SN1MPN1-001.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:55091
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab2HGNeN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Aug 2012 09:34:13 -0400
In-Reply-To: <FD18E5D573A8AB48A365D4D78185DE9929291E@039-SN1MPN1-001.039d.mgd.msft.net>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 7 Aug 2012 09:54:14 +0300, Geanta Neag Horia Ioan-B05471 <B05471@freescale.com> wrote:
> On Tue, 7 Aug 2012 04:47:51 +0300, Phillips Kim-R1AAHA <R1AAHA@freescale.com> wrote:

>> Also: if the algorithm name is really all that changes, can it be
>> done more space-efficiently with some string manipulation in the
>> algorithm registration loop?:  If registering an "authenc"
>> algorithm, also register an "authencesn" version.
> 
> Agree. Will come up with smth more elegant in v2.
> 

Looking closer at algorithm registration, talitos_alg_alloc uses shallow copies
of the templates in driver_algs[], so maybe sticking with the initial approach
is safer ?
