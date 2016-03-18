From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 04/10] crypto: rsa_helper - export symbols for asn1 structures
Date: Fri, 18 Mar 2016 20:32:01 +0200
Message-ID: <1458325927-14737-4-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:19488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752183AbcCRScX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:32:23 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Export rsapubkey_decoder and rsaprivkey_decoder structures,
since they can (will) be used by caam and qat drivers.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/rsa_helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 1708db8..14aef69 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -21,6 +21,9 @@
 #include "rsapubkey-asn1.h"
 #include "rsaprivkey-asn1.h"
 
+EXPORT_SYMBOL_GPL(rsapubkey_decoder);
+EXPORT_SYMBOL_GPL(rsaprivkey_decoder);
+
 int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
 {
-- 
1.8.3.1
