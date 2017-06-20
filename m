From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 09/11] Fix ERROR: space prohibited before that ','
Date: Tue, 20 Jun 2017 13:22:41 +0800
Message-ID: <1497936161-4877-1-git-send-email-fbihjmeric@gmail.com>
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

Fixed "ERROR: space prohibited before that ','".

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 6d2c035..d697244 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1916,16 +1916,16 @@ static int config_gcm_context(struct aead_request *req)
 	if (req_ctx->plaintext_authenticate_only == false) {
 		__be64 temp64;
 		temp64 = cpu_to_be64(req->assoclen * 8);
-		memcpy (&req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64));
+		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
-		memcpy (&req_ctx->gcm_len_block.lenC , &temp64, 8);
+		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	}
 	else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
 		temp64 = cpu_to_be64((req->assoclen+GCM_BLOCK_RFC4_IV_SIZE+cryptlen) * 8);
-		memcpy (&req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64));
+		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = 0;
-		memcpy (&req_ctx->gcm_len_block.lenC , &temp64, 8);
+		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	}
 
 	return 0;
-- 
2.7.4
