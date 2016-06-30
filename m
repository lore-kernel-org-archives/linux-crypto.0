From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: tcrypt - Do not bail on EINPROGRESS in multibuffer hash test
Date: Thu, 30 Jun 2016 11:00:13 +0800
Message-ID: <20160630030013.GA535@gondor.apana.org.au>
References: <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au>
 <57723A08.1010704@samsung.com>
 <20160628095511.GA16644@gondor.apana.org.au>
 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
 <20160628123352.GA17844@gondor.apana.org.au>
 <577383CA.1040204@samsung.com>
 <20160629081905.GA25215@gondor.apana.org.au>
 <57738697.1050401@samsung.com>
 <1467222356.4247.4.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38935 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbcF3DAU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 23:00:20 -0400
Content-Disposition: inline
In-Reply-To: <1467222356.4247.4.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2016 at 10:45:56AM -0700, Megha Dey wrote:
> I tested the latest cryptodev tree on my haswell machine and this is
> what I see:
> [   40.402834] modprobe tcrypt mode=422
> [   40.403105] testing speed of multibuffer sha1 (sha1_mb)
> [   40.403108] test  0 (   16 byte blocks,   16 bytes per update,   1
> updates):  32271 cycles/operation,  252 cycles/byte
> [   40.403118] At least one hashing failed ret=-115
> [   43.218712] modprobe tcrypt mode=423
> [   43.218712] testing speed of multibuffer sha256 (sha256_mb)
> [   43.218715] test  0 (   16 byte blocks,   16 bytes per update,   1
> updates): 106965 cycles/operation,  835 cycles/byte
> [   43.218747] At least one hashing failed ret=-115
> [   45.346657] modprobe tcrypt mode=424
> [   45.346657] testing speed of multibuffer sha512 (sha512_mb)
> [   45.346660] test  0 (   16 byte blocks,   16 bytes per update,   1
> updates):  43179 cycles/operation,  337 cycles/byte
> [   45.346673] At least one hashing failed ret=-115
> 
> Don't think this is expected, is it?

No that's not right.  Does this patch fix it?

Thanks!

---8<---
The multibuffer hash speed test is incorrectly bailing because
of an EINPROGRESS return value.  This patch fixes it by setting
ret to zero if it is equal to -EINPROGRESS.

Reported-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8a91dc3..202cfa1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -655,8 +486,10 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 
 		for (k = 0; k < 8; k++) {
 			ret = crypto_ahash_digest(data[k].req);
-			if (ret == -EINPROGRESS)
+			if (ret == -EINPROGRESS) {
+				ret = 0;
 				continue;
+			}
 
 			if (ret)
 				break;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
