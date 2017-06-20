From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 07/11] Fix ERROR: open brace '{' following function
 declarations go on the next line
Date: Tue, 20 Jun 2017 13:22:14 +0800
Message-ID: <1497936134-4777-1-git-send-email-fbihjmeric@gmail.com>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Fixed "ERROR: open brace '{' following function declarations go on the next line".

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 32edebe..7bc1193 100644
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
