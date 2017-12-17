From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/6] crypto: tcrypt: fix and add multi buf speed tests
Date: Sun, 17 Dec 2017 08:28:59 +0000
Message-ID: <1513499346-9047-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:40894 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdLQIaC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Dec 2017 03:30:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The performance of some crypto tfm providers is affected by
the amount of parallelism possible with the processing.

We already had some support for speed test of multiple concurrent
requests, dubbed multi buffer, in ahash speed tests.
                                                                                
This patch set extends said support and add similar support for skcipher
and AEAD, as well as fixes some odd bugs discovered along the way.
                                                                                
It is noted that it is possible to consolidate some of the none multi
buffer speed test code better, but given that tcrypt as a whole is a
developer testing harness rather than production code, the value of
this activity seems questionable. Do let me know if you disagree.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Changes from v1:
- re-spin on top of latest cryptodev

Gilad Ben-Yossef (6):
  crypto: tcrypt: use multi buf for ahash mb test
  crypto: tcrypt: fix AEAD decryption speed test
  crypto: tcrypt: allow setting num of bufs
  crypto: tcrypt: add multi buf ahash jiffies test
  crypto: tcrypt: add multibuf skcipher speed test
  crypto: tcrypt: add multibuf aead speed test

 crypto/tcrypt.c | 1079 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 975 insertions(+), 104 deletions(-)

-- 
2.7.4
