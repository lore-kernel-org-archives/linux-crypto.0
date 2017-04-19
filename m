From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] n2rng: Fine-tuning for n2rng_probe()
Date: Wed, 19 Apr 2017 11:08:21 +0200
Message-ID: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Shannon Nelson <shannon.nelson@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Apr 2017 11:00:11 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use devm_kcalloc()
  Combine substrings for two messages

 drivers/char/hw_random/n2-drv.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

-- 
2.12.2
