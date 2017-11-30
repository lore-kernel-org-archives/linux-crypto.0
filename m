From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/6] crypto: tcrypt: fix and add multi buf speed tests
Date: Thu, 30 Nov 2017 10:09:26 +0000
Message-ID: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The performance of some crypto tfm providers is affected by
the amount of parallelism possible with the processing.

We already had some support for speed test of multiple concurrent
requests, dubbed multi buffer, in ahash speed tests.

This patch set extends said support and add similar support for skcipher
and AEAD, as well as fixes some odd bugs discovered along the way.

It is noted that it is possible to consolidate some of the none multi buffer
speed test code better, but given that tcrypt as a whole is a developer testing
harness rather than production code, the value of this activity seems
questionable. Do let me know if you disagree.

The patch set is built on top of Robert Baronescu's patch titled
"crypto: tcrypt - fix S/G table for test_aead_speed()" which was posted on
the list, as without it the AEAD tests fails.

Gilad Ben-Yossef (6):
  crypto: tcrypt: use multi buf for ahash mb test
  crypto: tcrypt: fix AEAD decryption speed test
  crypto: tcrypt: allow setting num of bufs
  crypto: tcrypt: add multi buf ahash jiffies test
  crypto: tcrypt: add multibuf skcipher speed test
  crypto: tcrypt: add multibuf aead speed test

 crypto/tcrypt.c | 1074 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 973 insertions(+), 101 deletions(-)

-- 
2.7.4
