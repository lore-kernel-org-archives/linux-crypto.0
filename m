From: Christoph Manszewski <c.manszewski@samsung.com>
Subject: [PATCH v2 2/4] crypto: s5p-sss: Fix Fix argument list alignment
Date: Mon, 17 Sep 2018 17:09:28 +0200
Message-ID: <20180917151007eucas1p175be8c3c1119cff3189aa12722b21ca8~VOIi9Gjo-0057700577eucas1p1F@eucas1p1.samsung.com>
References: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180917151007eucas1p175be8c3c1119cff3189aa12722b21ca8@eucas1p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix misalignment of continued argument list.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 9021ad9df0c4..b7216935236f 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -491,7 +491,7 @@ static void s5p_unset_indata(struct s5p_aes_dev *dev)
 }
 
 static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
-			    struct scatterlist **dst)
+			   struct scatterlist **dst)
 {
 	void *pages;
 	int len;
@@ -1889,7 +1889,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev *dev,
 }
 
 static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
-				struct ablkcipher_request *req)
+				 struct ablkcipher_request *req)
 {
 	struct scatterlist *sg;
 	int err;
-- 
2.7.4
