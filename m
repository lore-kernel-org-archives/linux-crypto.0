From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 03/10] crypto: aead: Add aead_request_cast() api
Date: Thu, 2 Jul 2015 10:48:33 +0530
Message-ID: <1435814320-30347-4-git-send-email-lokeshvutla@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbbGBFVv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 01:21:51 -0400
In-Reply-To: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add aead_request_cast() api to get pointer to aead_request
from cryto_async_request.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 include/linux/crypto.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 10df5d2..20fac3d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1460,6 +1460,12 @@ static inline void aead_request_set_tfm(struct aead_request *req,
 	req->base.tfm = crypto_aead_tfm(crypto_aead_crt(tfm)->base);
 }
 
+static inline struct aead_request *aead_request_cast(
+					struct crypto_async_request *req)
+{
+	return container_of(req, struct aead_request, base);
+}
+
 /**
  * aead_request_alloc() - allocate request data structure
  * @tfm: cipher handle to be registered with the request
-- 
1.7.9.5
