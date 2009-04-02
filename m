From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.30
Date: Thu, 2 Apr 2009 14:14:13 +0800
Message-ID: <20090402061413.GA28925@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59667 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbZDBGOV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2009 02:14:21 -0400
Content-Disposition: inline
In-Reply-To: <20090324044932.GA18245@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes three bugs/regressions:

* IO address handling fix in timeriomem.
* Crash due to incorrect SG handling in ixp4xx.
* Crypto API (shash) bug that can lead to a CRC32C crash.
 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alexander Clouter (1):
      hwrng: timeriomem - Use phys address rather than virt

Christian Hohnstaedt (1):
      crypto: ixp4xx - Fix handling of chained sg buffers

Yehuda Sadeh (1):
      crypto: shash - Fix unaligned calculation with short length

 crypto/shash.c                          |    3 +
 drivers/char/hw_random/timeriomem-rng.c |   39 ++++++-
 drivers/crypto/ixp4xx_crypto.c          |  182 +++++++++++--------------------
 include/linux/timeriomem-rng.h          |    2 +-
 4 files changed, 102 insertions(+), 124 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
