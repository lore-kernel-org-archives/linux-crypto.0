From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 0/6] New test vectors for camellia, blowfish, serpent, aes,
 des and des3_ede
Date: Sat, 20 Oct 2012 14:52:41 +0300
Message-ID: <20121020115050.17179.44149.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:50411 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2JTLwo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 07:52:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Test vectors for camellia, blowfish and serpent are expanded for future
implementations.

New test vectors for aes, des and des3_ede are added to test existing
implementations.

---

Jussi Kivilinna (6):
      crypto: testmgr - expand camellia test vectors
      crypto: testmgr - expand blowfish test vectors
      crypto: testmgr - expand serpent test vectors
      crypto: testmgr - add new larger AES testvectors
      crypto: testmgr - add new larger DES testvectors
      crypto: testmgr - add new larger DES3_EDE testvectors


 crypto/tcrypt.c  |    2 
 crypto/testmgr.c |   30 
 crypto/testmgr.h | 5616 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 5484 insertions(+), 164 deletions(-)
