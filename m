From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: [PATCH v2] crypto: tcrypt - Fix memory leaks/crashes in
 multibuffer hash speed test
Date: Wed, 29 Jun 2016 10:45:56 -0700
Message-ID: <1467222356.4247.4.camel@megha-Z97X-UD7-TH>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
	 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
	 <20160628084138.GD15985@gondor.apana.org.au> <57723A08.1010704@samsung.com>
	 <20160628095511.GA16644@gondor.apana.org.au>
	 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
	 <20160628123352.GA17844@gondor.apana.org.au> <577383CA.1040204@samsung.com>
	 <20160629081905.GA25215@gondor.apana.org.au> <57738697.1050401@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:20267 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbcF2RkH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 13:40:07 -0400
In-Reply-To: <57738697.1050401@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I tested the latest cryptodev tree on my haswell machine and this is
what I see:
[   40.402834] modprobe tcrypt mode=422
[   40.403105] testing speed of multibuffer sha1 (sha1_mb)
[   40.403108] test  0 (   16 byte blocks,   16 bytes per update,   1
updates):  32271 cycles/operation,  252 cycles/byte
[   40.403118] At least one hashing failed ret=-115
[   43.218712] modprobe tcrypt mode=423
[   43.218712] testing speed of multibuffer sha256 (sha256_mb)
[   43.218715] test  0 (   16 byte blocks,   16 bytes per update,   1
updates): 106965 cycles/operation,  835 cycles/byte
[   43.218747] At least one hashing failed ret=-115
[   45.346657] modprobe tcrypt mode=424
[   45.346657] testing speed of multibuffer sha512 (sha512_mb)
[   45.346660] test  0 (   16 byte blocks,   16 bytes per update,   1
updates):  43179 cycles/operation,  337 cycles/byte
[   45.346673] At least one hashing failed ret=-115

Don't think this is expected, is it?

This is the patch which might have an issue?
72259deb3a9f2c07d18d71d7c9356754e7d88369

Thanks,
Megha

On Wed, 2016-06-29 at 10:28 +0200, Krzysztof Kozlowski wrote:
> On 06/29/2016 10:19 AM, Herbert Xu wrote:
> > On Wed, Jun 29, 2016 at 10:16:10AM +0200, Krzysztof Kozlowski wrote:
> >>
> >> Seems to work fine except:
> >> 1. The updates are always 1.
> > 
> > Yes the test function only does digest so it's always one update.
> > 
> >> 2. For bigger blocks it reports always 1 or 3 cycles per byte:
> > 
> > Yes the average cycles per-byte should reach an asymptotic value.
> 
> Then:
> Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Best regards,
> Krzysztof
> 
