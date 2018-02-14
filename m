From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] crypto/sahara: Adjustments for sahara_probe()
Date: Wed, 14 Feb 2018 14:32:28 +0100
Message-ID: <6a487cd1-c05c-3d5d-ec6b-a6a2ae376f05@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 14:30:28 +0100

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation
  Improve a size determination

 drivers/crypto/sahara.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.16.1
