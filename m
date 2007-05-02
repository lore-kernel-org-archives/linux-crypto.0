From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.22
Date: Wed, 2 May 2007 15:02:34 +1000
Message-ID: <20070502050234.GA29838@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "David S. Miller" <davem@davemloft.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4199 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030572AbXEBFCl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 May 2007 01:02:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

Here is the crypto update for 2.6.22:

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

Summary:

* Added API for asynchronous block ciphers.
* Small clean-up's.


Herbert Xu (9):
      [CRYPTO] api: Proc functions should be marked as unused
      [CRYPTO] api: Add async block cipher interface
      [CRYPTO] tcrypt: Use async blkcipher interface
      [CRYPTO] templates: Pass type/mask when creating instances
      [CRYPTO] api: Add async blkcipher type
      [CRYPTO] cryptomgr: Fix parsing of nested templates
      [CRYPTO] api: Do not remove users unless new algorithm matches
      [CRYPTO] cryptd: Add software async crypto daemon
      [CRYPTO] api: Add ablkcipher_request_set_tfm

Simon Arlott (1):
      [CRYPTO] padlock: Remove pointless padlock module

 crypto/Kconfig          |   13 +
 crypto/Makefile         |    2 
 crypto/ablkcipher.c     |   83 ++++++++++
 crypto/algapi.c         |  169 +++++++++++++++++----
 crypto/blkcipher.c      |   72 ++++++++-
 crypto/cbc.c            |   11 +
 crypto/cryptd.c         |  375 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/cryptomgr.c      |   66 +++++---
 crypto/ecb.c            |   11 +
 crypto/hash.c           |    2 
 crypto/hmac.c           |   11 +
 crypto/lrw.c            |   11 +
 crypto/pcbc.c           |   11 +
 crypto/tcrypt.c         |  121 ++++++++++-----
 crypto/xcbc.c           |   12 +
 drivers/crypto/Kconfig  |   16 --
 drivers/crypto/Makefile |    1 
 include/crypto/algapi.h |   84 ++++++++++
 include/linux/crypto.h  |  236 +++++++++++++++++++++++++++++-
 19 files changed, 1166 insertions(+), 141 deletions(-)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
