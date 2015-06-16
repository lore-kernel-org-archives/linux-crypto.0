From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/2] crypto: testmgr: test IV value after a cipher operation
Date: Tue, 16 Jun 2015 11:46:45 +0200
Message-ID: <1434448007-9537-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: linux-kernel@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:56061 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756505AbbFPJqx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 05:46:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Crypto drivers are supposed to update the IV passed to a cipher request
but it appears that some of them are not updating it.
The first patch of this series adds a new test for cipher algo (test the IV
value after a cipher operation) and the second one adds the expected IV value
to all the CBC test vectors.

Other cipher modes (LRW, CTR, ...) should be updated too.

Best Regards,

Boris

Boris Brezillon (2):
  crypto: testmgr: test IV value after a cipher operation
  crypto: testmgr: add iv_out information for all CBC testvec

 crypto/testmgr.c | 12 ++++++++-
 crypto/testmgr.h | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 1 deletion(-)

-- 
1.9.1
