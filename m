From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/3] crypto: af_alg - add AEAD operation type
Date: Sat, 05 Mar 2016 17:20:55 -0800
Message-ID: <20160306012055.6369.73799.stgit@tstruk-mobl1>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbcCFBZ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Mar 2016 20:25:27 -0500
In-Reply-To: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We need to allow the user to set the authentication type.
This adds a new operation that sets IPSec or TLS authentication mode.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/af_alg.c             |    6 ++++++
 include/crypto/if_alg.h     |    1 +
 include/uapi/linux/if_alg.h |    4 ++++
 3 files changed, 11 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index f5e18c2..cc5f2b0 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -464,6 +464,12 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 			con->op = *(u32 *)CMSG_DATA(cmsg);
 			break;
 
+		case ALG_SET_AEAD_TYPE:
+			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
+				return -EINVAL;
+			con->op_type = *(u32 *)CMSG_DATA(cmsg);
+			break;
+
 		case ALG_SET_AEAD_ASSOCLEN:
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index a2bfd78..d76ea0c 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -45,6 +45,7 @@ struct af_alg_completion {
 struct af_alg_control {
 	struct af_alg_iv *iv;
 	int op;
+	int op_type;
 	unsigned int aead_assoclen;
 };
 
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index f2acd2f..cef00de 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -34,9 +34,13 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_AEAD_TYPE		6
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
 #define ALG_OP_ENCRYPT			1
 
+/* AEAD operation type */
+#define ALG_AEAD_IPSEC			0 /* First encrypt then authenticate */
+#define ALG_AEAD_TLS			1 /* First authenticate then encrypt */
 #endif	/* _LINUX_IF_ALG_H */
