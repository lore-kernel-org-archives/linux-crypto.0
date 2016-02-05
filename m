From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 0/2] crypto: atmel-sha - fix resource management
Date: Fri, 5 Feb 2016 13:45:11 +0100
Message-ID: <cover.1454675769.git.cyrille.pitchen@atmel.com>
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

Hi all,

these two small patches fix resource release and clock management in
atomic context.

Best regards,

Cyrille

Cyrille Pitchen (2):
  crypto: atmel-sha: fix atmel_sha_remove()
  crypto: atmel-sha - remove calls of clk_prepare() from atomic contexts

 drivers/crypto/atmel-sha.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
1.8.2.2
