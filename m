From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Thu, 10 Aug 2017 08:39:12 +0200
Message-ID: <26359147.tCiuJ5s8mz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58450 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752181AbdHJGkr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 02:40:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch set adds the AF_ALG user space API to externalize the
asymmetric cipher API recently added to the kernel crypto API.

The patch set is tested with the user space library of libkcapi [1].
Use [1] test/test.sh for a full test run. The test covers the
following scenarios:

	* sendmsg of one IOVEC

	* sendmsg of 16 IOVECs with non-linear buffer

	* vmsplice of one IOVEC

	* vmsplice of 15 IOVECs with non-linear buffer

	* invoking multiple separate cipher operations with one
	  open cipher handle

	* encryption with private key (using vector from testmgr.h)

	* encryption with public key (using vector from testmgr.h)

	* decryption with private key (using vector from testmgr.h)

Note, to enable the test, edit line [2] from "4 99" to "4 13".

[1] http://www.chronox.de/libkcapi.html
[2] https://github.com/smuellerDD/libkcapi/blob/master/test/test.sh#L1452

Changes v8:
 * port to kernel 4.13
 * port to consolidated AF_ALG code

Stephan Mueller (4):
  crypto: AF_ALG -- add sign/verify API
  crypto: AF_ALG -- add setpubkey setsockopt call
  crypto: AF_ALG -- add asymmetric cipher
  crypto: algif_akcipher - enable compilation

 crypto/Kconfig              |   9 +
 crypto/Makefile             |   1 +
 crypto/af_alg.c             |  28 ++-
 crypto/algif_aead.c         |  36 ++--
 crypto/algif_akcipher.c     | 466 ++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_skcipher.c     |  26 ++-
 include/crypto/if_alg.h     |   7 +-
 include/uapi/linux/if_alg.h |   3 +
 8 files changed, 543 insertions(+), 33 deletions(-)
 create mode 100644 crypto/algif_akcipher.c

-- 
2.13.4
