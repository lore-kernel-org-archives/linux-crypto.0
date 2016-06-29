From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: tcrypt - Fix memory leaks/crashes in
 multibuffer hash speed test
Date: Wed, 29 Jun 2016 16:19:05 +0800
Message-ID: <20160629081905.GA25215@gondor.apana.org.au>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au>
 <57723A08.1010704@samsung.com>
 <20160628095511.GA16644@gondor.apana.org.au>
 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
 <20160628123352.GA17844@gondor.apana.org.au>
 <577383CA.1040204@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Megha Dey <megha.dey@linux.intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44892 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbcF2ITN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 04:19:13 -0400
Content-Disposition: inline
In-Reply-To: <577383CA.1040204@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2016 at 10:16:10AM +0200, Krzysztof Kozlowski wrote:
> 
> Seems to work fine except:
> 1. The updates are always 1.

Yes the test function only does digest so it's always one update.

> 2. For bigger blocks it reports always 1 or 3 cycles per byte:

Yes the average cycles per-byte should reach an asymptotic value.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
