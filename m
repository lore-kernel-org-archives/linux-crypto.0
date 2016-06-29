From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH v2] crypto: tcrypt - Fix memory leaks/crashes in
 multibuffer hash speed test
Date: Wed, 29 Jun 2016 10:16:10 +0200
Message-ID: <577383CA.1040204@samsung.com>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au> <57723A08.1010704@samsung.com>
 <20160628095511.GA16644@gondor.apana.org.au>
 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
 <20160628123352.GA17844@gondor.apana.org.au>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61052 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbcF2IQP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 04:16:15 -0400
In-reply-to: <20160628123352.GA17844@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/28/2016 02:33 PM, Herbert Xu wrote:
> On Tue, Jun 28, 2016 at 12:15:43PM +0200, Krzysztof Kozlowski wrote:
>> Oops:
> 
> Thanks, there was a typo where it said k instead of j in the second
> loop.
> 
> ---8<---
> This patch resolves a number of issues with the mb speed test
> function:
> 
> * The tfm is never freed.
> * Memory is allocated even when we're not using mb.
> * When an error occurs we don't wait for completion for other requests.
> * When an error occurs during allocation we may leak memory.
> * The test function ignores plen but still runs for plen != blen.
> * The backlog flag is incorrectly used (may crash).
> 
> This patch tries to resolve all these issues as well as making
> the code consistent with the existing hash speed testing function.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Seems to work fine except:
1. The updates are always 1.
2. For bigger blocks it reports always 1 or 3 cycles per byte:

[root@odroidxu3 ~]# modprobe tcrypt mode=423
[   70.129206]
[   70.129206] testing speed of multibuffer sha256 (sha256-neon)
[   70.135511] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   4597 cycles/operation,   35 cycles/byte
[   70.145826] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   5762 cycles/operation,   11 cycles/byte
[   70.156469] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):  10687 cycles/operation,    5 cycles/byte
[   70.167125] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  31485 cycles/operation,    3 cycles/byte
[   70.177919] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  59281 cycles/operation,    3 cycles/byte
[   70.189780] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 118097 cycles/operation,    3 cycles/byte
[   70.204117] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 232309 cycles/operation,    3 cycles/byte

[root@odroidxu3 ~]# modprobe tcrypt mode=422
[   71.988248]
[   71.988248] testing speed of multibuffer sha1 (sha1-neon)
[   71.994097] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   2506 cycles/operation,   19 cycles/byte
[   72.004547] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   2299 cycles/operation,    4 cycles/byte
[   72.015152] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   3535 cycles/operation,    1 cycles/byte
[   72.025807] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   9403 cycles/operation,    1 cycles/byte
[   72.036401] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  17142 cycles/operation,    1 cycles/byte
[   72.047058] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  33109 cycles/operation,    1 cycles/byte
[   72.057821] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  67750 cycles/operation,    1 cycles/byte
modprobe: ERROR: could not insert 'tcrypt': Resource temporarily unavailable

Is it expected?

Best regards,
Krzysztof
