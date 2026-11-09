Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209777;
	b=qrZ1gJYajQOibjWiMKiYz2JHzOE1bAaqcRqE6vw2i7iwl3kVGAC/Q4LZeY67YfU6VddQ
	 tbs8lujgsHXzNDoSiY9LCLDXvdtzbd7FnwHDlCiGslZZ2DVqjmNxQM6pY/O0BDPwLkV6l
	 pp/rRegGwc4LtDWlSqZ0SuAVQvkrmpa9igl54kKYuKufd9Mck7qu8HCAmomh0/vPcqDkn
	 IIeOk5eeibhRdQZ6hpnXPL6bZqxo6q0PGvZgbHUCX25xupi3uwC7Hghjeyvrm4xPyuGvl
	 TMkXj2qGqh/6MUHEfwC9aR1uMrRtlptQ8aGrPygtuKG+YilMOFSc6U0K+J9Q60lLjxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209777;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=32XgZBXjOCn+IKt4h3wSP8Hi+HSC5pHyRltEaxkxL94=;
	b=haRGc8VyKq3Ya9zKyI/X6TuEyrURwfhWu7hETJBoKYKD3IH3oaI6aQs3UBjF+JQqziOM
	 UHVtqq0eoRL/Mrq73heK3/ea0x6O4t43PbJJnQaE6qsFfSnmN4iUGbVAhgGkJqYzed5Dj
	 bQ0kdTRwAZQRGoosvqnc+h5LoUfPYxHQ23Nc8M1BnplymhCM7XbGfDKf9Rk550SF4IEzB
	 gxr/0YRSQPcbWzyPe0n4uLIjVkMhES9VxCYgUhaU44PA/aBXHFdoWaBgiLuZaR17CnD2S
	 KKc+wKuoHw7v+zTvFR1Ngr2i1krabnrGChzq7ssM5qOKKvDhcS8uwjcSM4zBmjMpQ3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=J+I3hdh3;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD90F606EE99;
	Mon,  9 Nov 2026 07:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD90F606EE99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=J+I3hdh3
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=32XgZBXjOCn+IKt4h3wSP8Hi+HSC5pHyRltEaxkxL94=;
	b=J+I3hdh3PBQIFANVWRJ0VyotTbHx3HfwUOT1p0g8n84FpvnUjfh2S/p5ltBkWQCTXJq2mIle/
	M8sviiE9sc/onh+tkk7FyZWZ+sIDSE2riOjDqNHLtQ8qGg/llrlvNuXRnhmsx0lBoeLCm16mBEf
	+JrBLhkIoXOR7hkPdjbTpYw=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jNM5W5M2wz1T4LL;
	Mon,  9 Nov 2026 15:35:43 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 692C740561;
	Mon,  9 Nov 2026 15:36:10 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:36:09 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 2/4] crypto: engine - add acomp support
Date: Mon, 9 Nov 2026 15:35:54 +0800
Message-ID: <20261109073556.2517351-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109073556.2517351-1-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

Add support for asynchronous compression (acomp) algorithms to the
crypto engine framework: transfer/finalize helpers plus an
acomp_engine_alg registration interface, mirroring the existing
akcipher and kpp support.

As engine.h needs to embed struct acomp_alg by value, move it from
include/crypto/internal/acompress.h to include/crypto/acompress.h.
The internal header still provides it through the existing include.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 crypto/crypto_engine.c              | 42 +++++++++++++++++++++++++++++
 include/crypto/acompress.h          | 33 +++++++++++++++++++++++
 include/crypto/engine.h             | 13 +++++++++
 include/crypto/internal/acompress.h | 33 -----------------------
 4 files changed, 88 insertions(+), 33 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 5b669038acb4..2a0740d9dd63 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -7,6 +7,7 @@
  * Author: Baolin Wang <baolin.wang@linaro.org>
  */
 
+#include <crypto/internal/acompress.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/engine.h>
@@ -220,6 +221,19 @@ static int crypto_transfer_request_to_engine(struct crypto_engine *engine,
 	return crypto_transfer_request(engine, req, true);
 }
 
+/**
+ * crypto_transfer_acomp_request_to_engine - transfer one acomp_request
+ * to list into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_acomp_request_to_engine(struct crypto_engine *engine,
+					    struct acomp_req *req)
+{
+	return crypto_transfer_request_to_engine(engine, &req->base);
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_acomp_request_to_engine);
+
 /**
  * crypto_transfer_aead_request_to_engine - transfer one aead_request
  * to list into the engine queue
@@ -285,6 +299,20 @@ int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
 }
 EXPORT_SYMBOL_GPL(crypto_transfer_skcipher_request_to_engine);
 
+/**
+ * crypto_finalize_acomp_request - finalize one acomp_request if
+ * the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_acomp_request(struct crypto_engine *engine,
+				   struct acomp_req *req, int err)
+{
+	return crypto_finalize_request(engine, &req->base, err);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_acomp_request);
+
 /**
  * crypto_finalize_aead_request - finalize one aead_request if
  * the request is done
@@ -504,6 +532,20 @@ void crypto_engine_exit(struct crypto_engine *engine)
 }
 EXPORT_SYMBOL_GPL(crypto_engine_exit);
 
+int crypto_engine_register_acomp(struct acomp_engine_alg *alg)
+{
+	if (!alg->op.do_one_request)
+		return -EINVAL;
+	return crypto_register_acomp(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_register_acomp);
+
+void crypto_engine_unregister_acomp(struct acomp_engine_alg *alg)
+{
+	crypto_unregister_acomp(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_engine_unregister_acomp);
+
 int crypto_engine_register_aead(struct aead_engine_alg *alg)
 {
 	if (!alg->op.do_one_request)
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 5d5358dfab73..0809fa35490a 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -122,6 +122,39 @@ struct crypto_acomp {
 }
 struct comp_alg_common COMP_ALG_COMMON;
 
+/**
+ * struct acomp_alg - asynchronous compression algorithm
+ *
+ * @compress:	Function performs a compress operation
+ * @decompress:	Function performs a de-compress operation
+ * @init:	Initialize the cryptographic transformation object.
+ *		This function is used to initialize the cryptographic
+ *		transformation object. This function is called only once at
+ *		the instantiation time, right after the transformation context
+ *		was allocated. In case the cryptographic hardware has some
+ *		special requirements which need to be handled by software, this
+ *		function shall check for the precise requirement of the
+ *		transformation and put any software fallbacks in place.
+ * @exit:	Deinitialize the cryptographic transformation object. This is a
+ *		counterpart to @init, used to remove various changes set in
+ *		@init.
+ *
+ * @base:	Common crypto API algorithm data structure
+ * @calg:	Common algorithm data structure shared with scomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common
+ */
+struct acomp_alg {
+	int (*compress)(struct acomp_req *req);
+	int (*decompress)(struct acomp_req *req);
+	int (*init)(struct crypto_acomp *tfm);
+	void (*exit)(struct crypto_acomp *tfm);
+
+	union {
+		struct COMP_ALG_COMMON;
+		struct comp_alg_common calg;
+	};
+};
+
 /**
  * DOC: Asynchronous Compression API
  *
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 2e60344437da..2b4e3d0e43ed 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -7,6 +7,7 @@
 #ifndef _CRYPTO_ENGINE_H
 #define _CRYPTO_ENGINE_H
 
+#include <crypto/acompress.h>
 #include <crypto/aead.h>
 #include <crypto/akcipher.h>
 #include <crypto/hash.h>
@@ -26,6 +27,11 @@ struct crypto_engine_op {
 			      void *areq);
 };
 
+struct acomp_engine_alg {
+	struct acomp_alg base;
+	struct crypto_engine_op op;
+};
+
 struct aead_engine_alg {
 	struct aead_alg base;
 	struct crypto_engine_op op;
@@ -51,6 +57,8 @@ struct skcipher_engine_alg {
 	struct crypto_engine_op op;
 };
 
+int crypto_transfer_acomp_request_to_engine(struct crypto_engine *engine,
+					    struct acomp_req *req);
 int crypto_transfer_aead_request_to_engine(struct crypto_engine *engine,
 					   struct aead_request *req);
 int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
@@ -61,6 +69,8 @@ int crypto_transfer_kpp_request_to_engine(struct crypto_engine *engine,
 					  struct kpp_request *req);
 int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
 					       struct skcipher_request *req);
+void crypto_finalize_acomp_request(struct crypto_engine *engine,
+				   struct acomp_req *req, int err);
 void crypto_finalize_aead_request(struct crypto_engine *engine,
 				  struct aead_request *req, int err);
 void crypto_finalize_akcipher_request(struct crypto_engine *engine,
@@ -79,6 +89,9 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool rt, int qlen);
 void crypto_engine_exit(struct crypto_engine *engine);
 
+int crypto_engine_register_acomp(struct acomp_engine_alg *alg);
+void crypto_engine_unregister_acomp(struct acomp_engine_alg *alg);
+
 int crypto_engine_register_aead(struct aead_engine_alg *alg);
 void crypto_engine_unregister_aead(struct aead_engine_alg *alg);
 int crypto_engine_register_aeads(struct aead_engine_alg *algs, int count);
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9cd37df32dc4..75580e007c0c 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -23,39 +23,6 @@
         struct acomp_req *name = acomp_fbreq_on_stack_init( \
                 __##name##_req, (req))
 
-/**
- * struct acomp_alg - asynchronous compression algorithm
- *
- * @compress:	Function performs a compress operation
- * @decompress:	Function performs a de-compress operation
- * @init:	Initialize the cryptographic transformation object.
- *		This function is used to initialize the cryptographic
- *		transformation object. This function is called only once at
- *		the instantiation time, right after the transformation context
- *		was allocated. In case the cryptographic hardware has some
- *		special requirements which need to be handled by software, this
- *		function shall check for the precise requirement of the
- *		transformation and put any software fallbacks in place.
- * @exit:	Deinitialize the cryptographic transformation object. This is a
- *		counterpart to @init, used to remove various changes set in
- *		@init.
- *
- * @base:	Common crypto API algorithm data structure
- * @calg:	Cmonn algorithm data structure shared with scomp
- * @COMP_ALG_COMMON: see struct comp_alg_common
- */
-struct acomp_alg {
-	int (*compress)(struct acomp_req *req);
-	int (*decompress)(struct acomp_req *req);
-	int (*init)(struct crypto_acomp *tfm);
-	void (*exit)(struct crypto_acomp *tfm);
-
-	union {
-		struct COMP_ALG_COMMON;
-		struct comp_alg_common calg;
-	};
-};
-
 struct crypto_acomp_stream {
 	spinlock_t lock;
 	void *ctx;
-- 
2.43.0

