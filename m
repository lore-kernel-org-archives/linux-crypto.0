From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 2.6.31
Date: Sun, 21 Jun 2009 22:09:24 +0800
Message-ID: <20090621140924.GA3305@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35369 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbZFUOJ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 10:09:28 -0400
Content-Disposition: inline
In-Reply-To: <20090613020512.GA21024@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a number of regressions for hardware AES:

* Spurious page faults with AES on Via Nano.
* Fix broken decryption with Intel AES.
* Fix atomic sleep with Intel AES.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Chuck Ebbert (2):
      crypto: padlock-aes - work around Nano CPU errata in ECB mode
      crypto: padlock-aes - work around Nano CPU errata in CBC mode

Huang Ying (3):
      crypto: aes-ni - Fix cbc mode IV saving
      crypto: aes-ni - Do not sleep when using the FPU
      crypto: aes-ni - Remove CRYPTO_TFM_REQ_MAY_SLEEP from fpu template

 arch/x86/crypto/aesni-intel_asm.S  |    5 +-
 arch/x86/crypto/aesni-intel_glue.c |    4 +
 arch/x86/crypto/fpu.c              |    4 +-
 drivers/crypto/padlock-aes.c       |  138 +++++++++++++++++++++++++----------
 4 files changed, 107 insertions(+), 44 deletions(-)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
