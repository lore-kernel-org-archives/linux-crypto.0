From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 1/5] crypto: caam: print errno code when hash registration
 fails
Date: Sat, 17 Oct 2015 19:51:23 +0100
Message-ID: <E1ZnWZf-0001mt-EN@rmk-PC.arm.linux.org.uk>
References: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43428 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJQSvb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 14:51:31 -0400
In-Reply-To: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Print the errno code when hash registration fails, so we know why the
failure occurred.  This aids debugging.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 94433b9fc200..2faf71ccbd43 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1952,8 +1952,9 @@ static int __init caam_algapi_hash_init(void)
 
 		err = crypto_register_ahash(&t_alg->ahash_alg);
 		if (err) {
-			pr_warn("%s alg registration failed\n",
-				t_alg->ahash_alg.halg.base.cra_driver_name);
+			pr_warn("%s alg registration failed: %d\n",
+				t_alg->ahash_alg.halg.base.cra_driver_name,
+				err);
 			kfree(t_alg);
 		} else
 			list_add_tail(&t_alg->entry, &hash_list);
@@ -1968,8 +1969,9 @@ static int __init caam_algapi_hash_init(void)
 
 		err = crypto_register_ahash(&t_alg->ahash_alg);
 		if (err) {
-			pr_warn("%s alg registration failed\n",
-				t_alg->ahash_alg.halg.base.cra_driver_name);
+			pr_warn("%s alg registration failed: %d\n",
+				t_alg->ahash_alg.halg.base.cra_driver_name,
+				err);
 			kfree(t_alg);
 		} else
 			list_add_tail(&t_alg->entry, &hash_list);
-- 
2.1.0
