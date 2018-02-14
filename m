From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] crypto/omap: Adjustments for three function
 implementations
Date: Wed, 14 Feb 2018 16:23:53 +0100
Message-ID: <28780631-d093-a581-8690-3868f8fa327e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Joel Fernandes <joelf@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 16:18:19 +0100

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete error messages for a failed memory allocation
  Improve size determinations

 drivers/crypto/omap-aes.c  | 8 +++-----
 drivers/crypto/omap-des.c  | 8 +++-----
 drivers/crypto/omap-sham.c | 4 +---
 3 files changed, 7 insertions(+), 13 deletions(-)

-- 
2.16.1
