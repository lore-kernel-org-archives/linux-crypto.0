From: Christoph Manszewski <c.manszewski@samsung.com>
Subject: [PATCH 0/4] crypto: s5p-sss: Fix and add aes-ctr support
Date: Thu, 13 Sep 2018 09:58:38 +0200
Message-ID: <20180913075854eucas1p1ab212d14a48f86dd94f8580dca4bc63c~T5q5vKjDE1335913359eucas1p1q@eucas1p1.samsung.com>
References: <CGME20180913075854eucas1p1ab212d14a48f86dd94f8580dca4bc63c@eucas1p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

This patch series adds aes-ctr support in s5p-sss.c driver. Additionally it
it provides a fix, and a minor code cleanup.

Patch 1 contains a simple fix, of a possible race condition.
Patches 2-3 are code cleanup patches.
Patch 4 adds support for aes-ctr block cipher mode of operation.

Regards,
Chris

Christoph Manszewski (4):
  crypto: s5p-sss: Fix race in error handling
  crypto: s5p-sss: Fix whitespace issues
  crypto: s5p-sss: Minor code cleanup
  crypto: s5p-sss: Add aes-ctr support

 drivers/crypto/s5p-sss.c | 114 +++++++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 48 deletions(-)

-- 
2.7.4
