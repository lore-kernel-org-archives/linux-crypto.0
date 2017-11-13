From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 06/24] staging: ccree: remove unneeded empty lines
Date: Mon, 13 Nov 2017 14:45:34 +0000
Message-ID: <1510584358-29473-7-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

Remove uneeded empty lines that crept in to code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 1 -
 drivers/staging/ccree/ssi_hash.c       | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index cda5a30..684c934 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -691,7 +691,6 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	if (drvdata->coherent &&
 	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
 	    likely(req->src == req->dst)) {
-
 		/* copy back mac from temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence problem.
 		 */
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 8414c25..66b011c 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2064,7 +2064,6 @@ ssi_hash_create_alg(struct ssi_hash_template *template, struct device *dev,
 	if (!t_crypto_alg)
 		return ERR_PTR(-ENOMEM);
 
-
 	t_crypto_alg->ahash_alg = template->template_ahash;
 	halg = &t_crypto_alg->ahash_alg;
 	alg = &halg->halg.base;
-- 
2.7.4
