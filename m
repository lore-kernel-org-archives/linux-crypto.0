From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 05/24] staging: ccree: shorten parameter name
Date: Tue, 12 Dec 2017 14:52:51 +0000
Message-ID: <1513090395-7938-6-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

Shorten parameter name for better code readability

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 75a578e..62d45e9 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2687,7 +2687,7 @@ static struct ssi_alg_template aead_algs[] = {
 };
 
 static struct ssi_crypto_alg *cc_create_aead_alg(
-			struct ssi_alg_template *template,
+			struct ssi_alg_template *tmpl,
 			struct device *dev)
 {
 	struct ssi_crypto_alg *t_alg;
@@ -2697,26 +2697,26 @@ static struct ssi_crypto_alg *cc_create_aead_alg(
 	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
 
-	alg = &template->template_aead;
+	alg = &tmpl->template_aead;
 
 	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 template->name);
+		 tmpl->name);
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 template->driver_name);
+		 tmpl->driver_name);
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = SSI_CRA_PRIO;
 
 	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			 template->type;
+			 tmpl->type;
 	alg->init = cc_aead_init;
 	alg->exit = cc_aead_exit;
 
 	t_alg->aead_alg = *alg;
 
-	t_alg->cipher_mode = template->cipher_mode;
-	t_alg->flow_mode = template->flow_mode;
-	t_alg->auth_mode = template->auth_mode;
+	t_alg->cipher_mode = tmpl->cipher_mode;
+	t_alg->flow_mode = tmpl->flow_mode;
+	t_alg->auth_mode = tmpl->auth_mode;
 
 	return t_alg;
 }
-- 
2.7.4
