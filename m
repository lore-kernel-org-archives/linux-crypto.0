From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 3/6] staging: ccree: move '{' to next line for function.
Date: Tue, 20 Jun 2017 22:52:01 +0800
Message-ID: <1497970324-9725-4-git-send-email-fbihjmeric@gmail.com>
References: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Move '{' to next line for function.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 6bcab5a..3d9957f 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1542,7 +1542,8 @@ static inline int ssi_aead_ccm(
 	return 0;
 }
 
-static int config_ccm_adata(struct aead_request *req) {
+static int config_ccm_adata(struct aead_request *req)
+{
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
@@ -1886,7 +1887,8 @@ static inline void ssi_aead_dump_gcm(
 }
 #endif
 
-static int config_gcm_context(struct aead_request *req) {
+static int config_gcm_context(struct aead_request *req)
+{
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-- 
2.7.4
