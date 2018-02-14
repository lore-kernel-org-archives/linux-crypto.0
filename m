From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] Ux500 crypto: Adjustments for ux500_cryp_probe()
Date: Wed, 14 Feb 2018 11:16:39 +0100
Message-ID: <20dcb583-5455-b5b9-94df-db9d1e21931f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 11:12:34 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Delete an error message for a failed memory allocation
  Adjust two condition checks
  Adjust an error message
  Delete two unnecessary variable initialisations

 drivers/crypto/ux500/cryp/cryp_core.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
2.16.1
