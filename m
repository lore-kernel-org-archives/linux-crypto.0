From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 0/4] crypto: s5p-sss - Fix and minor improvements
Date: Fri, 17 Mar 2017 16:49:18 +0200
Message-ID: <20170317144922.27379-1-krzk@kernel.org>
Cc: Nathan Royce <nroycea+kernel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I still did not fix the NULL pointer dereference reported by
Nathan Royce [1], but I got some other improvements.

Testing done on Odroid U3 (Exynos4412) with tcrypt and cryptsetup.

Best regards,
Krzysztof


[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1351149.html

Krzysztof Kozlowski (4):
  crypto: s5p-sss - Close possible race for completed requests
  crypto: s5p-sss - Remove unused variant field from state container
  crypto: s5p-sss - Document the struct s5p_aes_dev
  crypto: s5p-sss - Use mutex instead of spinlock

 drivers/crypto/s5p-sss.c | 70 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 25 deletions(-)

-- 
2.9.3
