From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: crypto: tcrypt - Do not bail on EINPROGRESS in multibuffer hash
 test
Date: Thu, 30 Jun 2016 10:36:10 -0700
Message-ID: <1467308170.3969.1.camel@megha-Z97X-UD7-TH>
References: <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
	 <20160628084138.GD15985@gondor.apana.org.au> <57723A08.1010704@samsung.com>
	 <20160628095511.GA16644@gondor.apana.org.au>
	 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
	 <20160628123352.GA17844@gondor.apana.org.au> <577383CA.1040204@samsung.com>
	 <20160629081905.GA25215@gondor.apana.org.au> <57738697.1050401@samsung.com>
	 <1467222356.4247.4.camel@megha-Z97X-UD7-TH>
	 <20160630030013.GA535@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35425 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbcF3Rg6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jun 2016 13:36:58 -0400
In-Reply-To: <20160630030013.GA535@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-06-30 at 11:00 +0800, Herbert Xu wrote:
> On Wed, Jun 29, 2016 at 10:45:56AM -0700, Megha Dey wrote:
> > I tested the latest cryptodev tree on my haswell machine and this is
> > what I see:
> > [   40.402834] modprobe tcrypt mode=422
> > [   40.403105] testing speed of multibuffer sha1 (sha1_mb)
> > [   40.403108] test  0 (   16 byte blocks,   16 bytes per update,   1
> > updates):  32271 cycles/operation,  252 cycles/byte
> > [   40.403118] At least one hashing failed ret=-115
> > [   43.218712] modprobe tcrypt mode=423
> > [   43.218712] testing speed of multibuffer sha256 (sha256_mb)
> > [   43.218715] test  0 (   16 byte blocks,   16 bytes per update,   1
> > updates): 106965 cycles/operation,  835 cycles/byte
> > [   43.218747] At least one hashing failed ret=-115
> > [   45.346657] modprobe tcrypt mode=424
> > [   45.346657] testing speed of multibuffer sha512 (sha512_mb)
> > [   45.346660] test  0 (   16 byte blocks,   16 bytes per update,   1
> > updates):  43179 cycles/operation,  337 cycles/byte
> > [   45.346673] At least one hashing failed ret=-115
> > 
> > Don't think this is expected, is it?
> 
> No that's not right.  Does this patch fix it?
> 
yes, it fixes it. This is my output:

testing speed of multibuffer sha1 (sha1_mb)
[   31.342538] test  0 (   16 byte blocks,   16 bytes per update,   1
updates):
31614 cycles/operation,  246 cycles/byte
[   31.342549] test  2 (   64 byte blocks,   64 bytes per update,   1
updates):
10893 cycles/operation,   21 cycles/byte
[   31.342553] test  5 (  256 byte blocks,  256 bytes per update,   1
updates):
11043 cycles/operation,    5 cycles/byte
[   31.342557] test  8 ( 1024 byte blocks, 1024 bytes per update,   1
updates):
17355 cycles/operation,    2 cycles/byte
[   31.342562] test 12 ( 2048 byte blocks, 2048 bytes per update,   1
updates):
26328 cycles/operation,    1 cycles/byte
[   31.342570] test 16 ( 4096 byte blocks, 4096 bytes per update,   1
updates):
43833 cycles/operation,    1 cycles/byte
[   31.342584] test 21 ( 8192 byte blocks, 8192 bytes per update,   1
updates):
81141 cycles/operation,    1 cycles/byte
[   44.700088]
[   44.700088] testing speed of multibuffer sha256 (sha256_mb)
[   44.700091] test  0 (   16 byte blocks,   16 bytes per update,   1
updates):
116874 cycles/operation,  913 cycles/byte
[   44.700126] test  2 (   64 byte blocks,   64 bytes per update,   1
updates):
60894 cycles/operation,  118 cycles/byte
[   44.700144] test  5 (  256 byte blocks,  256 bytes per update,   1
updates):
15366 cycles/operation,    7 cycles/byte
[   44.700149] test  8 ( 1024 byte blocks, 1024 bytes per update,   1
updates):
29130 cycles/operation,    3 cycles/byte
[   44.700158] test 12 ( 2048 byte blocks, 2048 bytes per update,   1
updates):
48561 cycles/operation,    2 cycles/byte
[   44.700173] test 16 ( 4096 byte blocks, 4096 bytes per update,   1
updates):
119697 cycles/operation,    3 cycles/byte
[   44.700207] test 21 ( 8192 byte blocks, 8192 bytes per update,   1
updates):
164163 cycles/operation,    2 cycles/byte
[   66.309608]
[   66.309608] testing speed of multibuffer sha512 (sha512_mb)
[   66.309623] test  0 (   16 byte blocks,   16 bytes per update,   1
updates):
301050 cycles/operation, 2351 cycles/byte
[   66.309717] test  2 (   64 byte blocks,   64 bytes per update,   1
updates):
115416 cycles/operation,  225 cycles/byte
[   66.309757] test  5 (  256 byte blocks,  256 bytes per update,   1
updates):
175068 cycles/operation,   85 cycles/byte
[   66.309814] test  8 ( 1024 byte blocks, 1024 bytes per update,   1
updates):
354834 cycles/operation,   43 cycles/byte
[   66.309920] test 12 ( 2048 byte blocks, 2048 bytes per update,   1
updates):
599814 cycles/operation,   36 cycles/byte
[   66.310096] test 16 ( 4096 byte blocks, 4096 bytes per update,   1
updates):
585666 cycles/operation,   17 cycles/byte
[   66.310263] test 21 ( 8192 byte blocks, 8192 bytes per update,   1
updates):
1057770 cycles/operation,   16 cycles/byte

> Thanks!
> 
> ---8<---
> The multibuffer hash speed test is incorrectly bailing because
> of an EINPROGRESS return value.  This patch fixes it by setting
> ret to zero if it is equal to -EINPROGRESS.
> 
> Reported-by: Megha Dey <megha.dey@linux.intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 8a91dc3..202cfa1 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -655,8 +486,10 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
>  
>  		for (k = 0; k < 8; k++) {
>  			ret = crypto_ahash_digest(data[k].req);
> -			if (ret == -EINPROGRESS)
> +			if (ret == -EINPROGRESS) {
> +				ret = 0;
>  				continue;
> +			}
>  
>  			if (ret)
>  				break;
