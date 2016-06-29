From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH v2] crypto: tcrypt - Fix memory leaks/crashes in
 multibuffer hash speed test
Date: Wed, 29 Jun 2016 10:28:07 +0200
Message-ID: <57738697.1050401@samsung.com>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au> <57723A08.1010704@samsung.com>
 <20160628095511.GA16644@gondor.apana.org.au>
 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
 <20160628123352.GA17844@gondor.apana.org.au> <577383CA.1040204@samsung.com>
 <20160629081905.GA25215@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Megha Dey <megha.dey@linux.intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20160629081905.GA25215@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/29/2016 10:19 AM, Herbert Xu wrote:
> On Wed, Jun 29, 2016 at 10:16:10AM +0200, Krzysztof Kozlowski wrote:
>>
>> Seems to work fine except:
>> 1. The updates are always 1.
> 
> Yes the test function only does digest so it's always one update.
> 
>> 2. For bigger blocks it reports always 1 or 3 cycles per byte:
> 
> Yes the average cycles per-byte should reach an asymptotic value.

Then:
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
