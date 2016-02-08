From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 0/2] crypto: atmel-sha - fix .import()/.export() implementation
Date: Mon, 8 Feb 2016 16:26:47 +0100
Message-ID: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series of patches includes two fixes for the atmel-sha.c driver.

The first one fixes the implementation of the import/export hooks, which
did not pass the recent updates in testmgr.c (partial update exercise).
The new implementation now passes the tcrypt tests: tested with
next-20160208.

The second patch fixes a race condition if acquiring the hardware when it
is already busy.

Cyrille Pitchen (2):
  crypto: atmel-sha - fix .import()/.export() implementation
  crypto: atmel-sha - fix race in atmel_sha_final()

 drivers/crypto/atmel-sha.c | 68 ++++++++--------------------------------------
 1 file changed, 12 insertions(+), 56 deletions(-)

-- 
1.8.2.2
