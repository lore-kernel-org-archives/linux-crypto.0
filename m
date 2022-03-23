Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BFEC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 02:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiCWCyh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiCWCyh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 22:54:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F491A3BA
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:53:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so472252pjf.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aXVYcSGYSK+RNRnRnroKXc0xcKJFqJla2O1ErbUFeoI=;
        b=HxHRKe0kYYr+lH0SwF45YGYXi6HgOVn4gufYh7omzrw9uoIbI7WDyJtZZpVO4i7dzi
         Z/9YWwClCV1UpJfrrCSMbtrfXm/gsfRpeD02dnwdSksN0byVD+fPLnVpkloYsSnElGQu
         cgUY/kOqR2vSTj/0JDQ16II2CEvIQ1bwYlp+n6EWqwJ3hVXI4P3yQOzyOCItnbaNN7Q6
         DYD9rKBVhGGPoAm/5VC6X6chv8h7afbQVd9XKdrtnvwd3BEzCfPhUlcH1nrmOUicTO6T
         25FH0DRrZ73TTTQEdcKsyH7QEmU9F5jdrtz6CBGzVRjSdcTiUB24KTy1a543tiK4fBtQ
         UoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aXVYcSGYSK+RNRnRnroKXc0xcKJFqJla2O1ErbUFeoI=;
        b=fTQYYgkRjNkoXoVCfzAMDfVTKJoKdnF31piq5okXFGGr6HTs0ccwY4lUUXqMJtTonM
         BrjiV9Kv1CETB8WRP/LH7kfzFtsjMHY8LkGyDrAlP/aFYd7/oc4Y6n5ICC6EJt9+hHW/
         1dyjBfx3aHlJJLtbC34al4TqEUdtsgecoTagQx9/SEAMbTpxjM5vCgazgJo9r8V2xYU+
         cXh4Ddtrx7aV4JzmAKUA3EIV+F3cKIuuDIXQ9C9fyjtZxiMwRk7XMdByt69wnCBGotnl
         UNRaaC8jvBtfUe+v5Yky8yg7iUhMOWiC/yVD9jTjiry/ON7TTEXotNzFpNIwgXkbkFd7
         XuMA==
X-Gm-Message-State: AOAM533vlL6uOXQKDPgm3GXXZOx6uUFNi5H2sVUSuUAxm/6YfxS3Ir7R
        oR4gIv6qXlCL//RzWf8Vpzza0g==
X-Google-Smtp-Source: ABdhPJzoSG5W/SOtF6DXki9M9fRhP2RPiR8BRwRYWUDs+rRkbIiVX3CMFa4DjlQ0xNGIBJ0qgO95jQ==
X-Received: by 2002:a17:90b:1c83:b0:1b9:caa:8230 with SMTP id oo3-20020a17090b1c8300b001b90caa8230mr8851645pjb.26.1648003987371;
        Tue, 22 Mar 2022 19:53:07 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id t2-20020a63a602000000b0038062a0bc6fsm18104869pge.67.2022.03.22.19.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 19:53:06 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, zhenwei pi <pizhenwei@bytedance.com>,
        lei he <helei.sig11@bytedance.com>
Subject: [PATCH v3 3/6] crypto: Introduce akcipher crypto class
Date:   Wed, 23 Mar 2022 10:49:09 +0800
Message-Id: <20220323024912.249789-4-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323024912.249789-1-pizhenwei@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Support basic asymmetric operations: encrypt, decrypt, sign and
verify.

Co-developed-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 crypto/akcipher.c         |  78 +++++++++++++++++++++
 crypto/meson.build        |   1 +
 include/crypto/akcipher.h | 139 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+)
 create mode 100644 crypto/akcipher.c
 create mode 100644 include/crypto/akcipher.h

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
new file mode 100644
index 0000000000..1e52f2fd76
--- /dev/null
+++ b/crypto/akcipher.c
@@ -0,0 +1,78 @@
+/*
+ * QEMU Crypto akcipher algorithms
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: zhenwei pi <pizhenwei@bytedance.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/host-utils.h"
+#include "qapi/error.h"
+#include "crypto/akcipher.h"
+
+QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
+                                      QCryptoAkcipherKeyType type,
+                                      const uint8_t *key, size_t keylen,
+                                      void *para, Error **errp)
+{
+    QCryptoAkcipher *akcipher = NULL;
+
+    return akcipher;
+}
+
+int qcrypto_akcipher_encrypt(QCryptoAkcipher *akcipher,
+                             const void *data, size_t data_len,
+                             void *enc, size_t enc_len, Error **errp)
+{
+    const QCryptoAkcipherDriver *drv = akcipher->driver;
+
+    return drv->encrypt(akcipher, data, data_len, enc, enc_len, errp);
+}
+
+int qcrypto_akcipher_decrypt(struct QCryptoAkcipher *akcipher,
+                             const void *enc, size_t enc_len,
+                             void *data, size_t data_len, Error **errp)
+{
+    const QCryptoAkcipherDriver *drv = akcipher->driver;
+
+    return drv->decrypt(akcipher, enc, enc_len, data, data_len, errp);
+}
+
+int qcrypto_akcipher_sign(struct QCryptoAkcipher *akcipher,
+                          const void *data, size_t data_len,
+                          void *sig, size_t sig_len, Error **errp)
+{
+    const QCryptoAkcipherDriver *drv = akcipher->driver;
+
+    return drv->sign(akcipher, data, data_len, sig, sig_len, errp);
+}
+
+int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,
+                            const void *sig, size_t sig_len,
+                            const void *data, size_t data_len, Error **errp)
+{
+    const QCryptoAkcipherDriver *drv = akcipher->driver;
+
+    return drv->verify(akcipher, sig, sig_len, data, data_len, errp);
+}
+
+int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp)
+{
+    const QCryptoAkcipherDriver *drv = akcipher->driver;
+
+    return drv->free(akcipher, errp);
+}
diff --git a/crypto/meson.build b/crypto/meson.build
index 19c44bea89..c32b57aeda 100644
--- a/crypto/meson.build
+++ b/crypto/meson.build
@@ -19,6 +19,7 @@ crypto_ss.add(files(
   'tlscredspsk.c',
   'tlscredsx509.c',
   'tlssession.c',
+  'akcipher.c',
 ))
 
 if nettle.found()
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
new file mode 100644
index 0000000000..03cc3bf46b
--- /dev/null
+++ b/include/crypto/akcipher.h
@@ -0,0 +1,139 @@
+/*
+ * QEMU Crypto asymmetric algorithms
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: zhenwei pi <pizhenwei@bytedance.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef QCRYPTO_AKCIPHER_H
+#define QCRYPTO_AKCIPHER_H
+
+#include "qemu/typedefs.h"
+#include "qapi/qapi-types-crypto.h"
+
+typedef struct QCryptoAkcipher QCryptoAkcipher;
+typedef struct QCryptoAkcipherDriver QCryptoAkcipherDriver;
+
+struct QCryptoAkcipherDriver {
+    int (*encrypt)(struct QCryptoAkcipher *akcipher,
+                   const void *data, size_t data_len,
+                   void *enc, size_t enc_len, Error **errp);
+    int (*decrypt)(struct QCryptoAkcipher *akcipher,
+                   const void *enc, size_t enc_len,
+                   void *data, size_t data_len, Error **errp);
+    int (*sign)(struct QCryptoAkcipher *akcipher,
+                const void *data, size_t data_len,
+                void *sig, size_t sig_len, Error **errp);
+    int (*verify)(struct QCryptoAkcipher *akcipher,
+                  const void *sig, size_t sig_len,
+                  const void *data, size_t data_len, Error **errp);
+    int (*free)(struct QCryptoAkcipher *akcipher, Error **errp);
+};
+
+struct QCryptoAkcipher {
+    QCryptoAkcipherAlgorithm alg;
+    QCryptoAkcipherKeyType type;
+    uint8_t *key;
+    size_t keylen;
+    int max_plaintext_len;
+    int max_ciphertext_len;
+    int max_signature_len;
+    int max_dgst_len;
+    QCryptoAkcipherDriver *driver;
+};
+
+QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
+                                      QCryptoAkcipherKeyType type,
+                                      const uint8_t *key, size_t keylen,
+                                      void *para, Error **errp);
+
+/**
+ * qcrypto_akcipher_encrypt:
+ * @akcipher: akcipher used to do encryption
+ * @data: plaintext pending to be encrypted
+ * @data_len: length of the plaintext, MUST less or equal
+ * akcipher->max_plaintext_len
+ * @enc: buffer to store the ciphertext
+ * @enc_len: the length of ciphertext buffer, usually equals to
+ * akcipher->max_ciphertext_len
+ * @errp: error pointer
+ *
+ * Encrypt data and write ciphertext into enc
+ *
+ * Returns: length of ciphertext if encrypt succeed, otherwise -1 is returned
+ */
+int qcrypto_akcipher_encrypt(QCryptoAkcipher *akcipher,
+                             const void *data, size_t data_len,
+                             void *enc, size_t enc_len, Error **errp);
+
+/**
+ * qcrypto_akcipher_decrypt:
+ * @akcipher: akcipher used to do decryption
+ * @enc: ciphertext to be decrypted
+ * @enc_len: the length of ciphertext
+ * @data: buffer to store the plaintext
+ * @data_len: length of the plaintext buffer, usually equals to
+ * akcipher->max_plaintext_len
+ * @errp: error pointer
+ *
+ * Decrypt ciphertext and write plaintext into data
+ *
+ * Returns: length of plaintext if decrypt succeed, otherwise -1 is returned
+ */
+int qcrypto_akcipher_decrypt(struct QCryptoAkcipher *akcipher,
+                             const void *enc, size_t enc_len,
+                             void *data, size_t data_len, Error **errp);
+
+/**
+ * qcrypto_akcipher_sign:
+ * @akcipher: akcipher used to generate signature
+ * @data: data to be signed
+ * @data_len: the length of data
+ * @sig: buffer to store the signature
+ * @sig_len: length of the signature buffer, usually equals to
+ * akcipher->max_signature_len
+ * @errp: error pointer
+ *
+ * Generate signature for data using akcipher
+ *
+ * Returns: length of signature if succeed, otherwise -1 is returned
+ */
+int qcrypto_akcipher_sign(struct QCryptoAkcipher *akcipher,
+                          const void *data, size_t data_len,
+                          void *sig, size_t sig_len, Error **errp);
+
+/**
+ * qcrypto_akcipher_verify:
+ * @akcipher: akcipher used to do verifycation
+ * @sig: pointer to the signature
+ * @sig_len: length of the signature
+ * @data: pointer to original data
+ * @data_len: the length of data
+ * @errp: error pointer
+ *
+ * Verify the signature and the data match or not
+ *
+ * Returns: 0 for succeed, otherwise -1 is returned
+ */
+int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,
+                            const void *sig, size_t sig_len,
+                            const void *data, size_t data_len, Error **errp);
+
+int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp);
+
+
+#endif /* QCRYPTO_AKCIPHER_H */
-- 
2.25.1

