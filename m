From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/10] staging: ccree: NULLify backup_info when unused
Date: Sun,  3 Dec 2017 13:58:19 +0000
Message-ID: <1512309503-29766-9-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
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

backup_info field is only allocated for decrypt code path.
The field was not nullified when not used causing a kfree
in an error handling path to attempt to free random
addresses as uncovered in stress testing.

Fixes: 737aed947f9b ("staging: ccree: save ciphertext for CTS IV")
Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 9019615..7b484f1 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -907,6 +907,7 @@ static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 	unsigned int ivsize = crypto_ablkcipher_ivsize(ablk_tfm);
 
 	req_ctx->is_giv = false;
+	req_ctx->backup_info = NULL;
 
 	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
 				     req->nbytes, req->info, ivsize,
-- 
2.7.4
