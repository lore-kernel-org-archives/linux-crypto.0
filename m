From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - reinitialize keys_fit_inline for decrypt and
 givencrypt
Date: Fri, 9 May 2014 20:34:40 -0500
Message-ID: <20140509203440.6148a33a29c0e7003b7f152b@freescale.com>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
	<20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
	<72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
	<20140505133725.33abd0d08a1662a147c498f5@freescale.com>
	<70e10fa687e249f08a102f148edd3231@BL2PR03MB162.namprd03.prod.outlook.com>
	<20140506151114.e44a1af14c9d5b63ecbac603@freescale.com>
	<20140508135255.GA13355@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Garg Vakul-B16394 <vakul@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia Ioan-B05471 <Horia.Geanta@freescale.com>,
	Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>,
	Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [207.46.163.139] ([207.46.163.139]:52771 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750744AbaEJBmJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 May 2014 21:42:09 -0400
In-Reply-To: <20140508135255.GA13355@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Vakul Garg <vakul@freescale.com>

Re-initialize keys_fit_inline to avoid using its stale encrypt() shared
descriptor value prior to building descriptors for the decrypt() and
givencrypt() cases.

Signed-off-by: Vakul Garg <vakul@freescale.com>
[reworded commit text, enhanced code readability]
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 5f89125..4bf7634 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -303,6 +303,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
+	keys_fit_inline = false;
 	if (DESC_AEAD_NULL_DEC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
@@ -472,6 +473,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
+	keys_fit_inline = false;
 	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=
 	    CAAM_DESC_BYTES_MAX)
@@ -527,6 +529,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
+	keys_fit_inline = false;
 	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=
 	    CAAM_DESC_BYTES_MAX)
-- 
1.9.2
