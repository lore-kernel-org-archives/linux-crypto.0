From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v3 3/3] crypto: rsa_helper - export symbols for asn1 structures
Date: Wed, 6 Apr 2016 16:37:06 +0300
Message-ID: <1459949826-11840-4-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <tadeusz.struk@intel.com>,
	<smueller@chronox.de>, <cristian.stoica@nxp.com>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0098.outbound.protection.outlook.com ([207.46.100.98]:10912
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbcDFNhy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 09:37:54 -0400
In-Reply-To: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Export rsapubkey_decoder and rsaprivkey_decoder structures,
since they can (will) be used by caam and qat drivers.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/rsa_helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index df1f480..d81a0ec 100644
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
