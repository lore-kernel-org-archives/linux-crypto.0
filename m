From: Christoph Manszewski <c.manszewski@samsung.com>
Subject: [PATCH 2/4] crypto: s5p-sss: Fix whitespace issues
Date: Thu, 13 Sep 2018 09:58:40 +0200
Message-ID: <20180913075858eucas1p1f528fd0776c32f1c10a3e46f8f2bacd0~T5q9BZO-j1335913359eucas1p1w@eucas1p1.samsung.com>
References: <1536825522-6027-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180913075858eucas1p1f528fd0776c32f1c10a3e46f8f2bacd0@eucas1p1.samsung.com>
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
In-Reply-To: <1536825522-6027-1-git-send-email-c.manszewski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix two whitespace issues that occurred at line breakup.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
---
 drivers/crypto/s5p-sss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0cf3f12d8f74..ce9bd13ea166 100644
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
@@ -1890,7 +1890,7 @@ static int s5p_set_indata_start(struct s5p_aes_dev *dev,
 }
 
 static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
-				struct ablkcipher_request *req)
+				 struct ablkcipher_request *req)
 {
 	struct scatterlist *sg;
 	int err;
-- 
2.7.4
