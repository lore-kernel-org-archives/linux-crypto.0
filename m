Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB95C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 25 May 2022 09:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiEYJDd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 May 2022 05:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiEYJDZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 May 2022 05:03:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CDC8FF9B
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i18so1078287pfk.7
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J27HSN/26l4mSe0p+wDKY9IBQUhfByuvjVoRLZxLcjI=;
        b=r8C2sqybRZ85zRdPy0UpZ2G3M+8IXSfaQ4+0erFZkD17BmvYSv10eA7VUYBQ8WcIMS
         GnD1hruaUDuDtaP+Jt6Ia1faUiFi9i9SIPHOd9C3fxwvgBAnMPwta6mAvbVe/cX84lJH
         J4stlASB6sCdtKZZJ0HNa2k3dj2Mla5ZNjVlkUmVMYOEOE9DsmNzH24ICvBDMkURdmhO
         /bOvq6ClCe41RpThT5Qrvucl7Hg19jYtjyztBNn6gYchfsQPQWB+3wgBILGpw6YI9RGv
         fPnu5Us9PMqmWITlX4fVnfLlX7Q2x+qO13xcZOernpYCtpvr1awFmI79OwmCQ5a5h8qe
         8R0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J27HSN/26l4mSe0p+wDKY9IBQUhfByuvjVoRLZxLcjI=;
        b=WqtwcMazH+yLcW/yfwHaQbpb+xj3m6rsamH51moTZ6+u8wek1Yi2wNImMNLHEv0ZbK
         m6iy3AUjRr3UV6fex16FwV21Gbr/x7KoTjTouDfdtEjgnTyCqlzwn5MqEdLGtifXG8aX
         8ascxI0FTwYOCALjA5V41p8gB8azrki+jwBIj3bBIAGbdJ7Uhm4+5k75VSAyxRMY2J12
         u8jD0f455Y7OVypC4QuLStK/8r0wvQg2NTCASN2TIWWm16oanbvTAY0S+IQVA/dJjNo8
         hvagK9Lsppasz7KHriofnjPepNKlAK5tEi0EG0efdxoT3q2NDRBhOpP56uc0EOoGI5vp
         +oYA==
X-Gm-Message-State: AOAM530AhAWnaorni3RpbPFCCAWQbqtd+yl78seHxKWV1rwZ46hSUQvM
        I3pkGtlqpNNicjpgjKdJ0Py1VA==
X-Google-Smtp-Source: ABdhPJxDuPdYJaOrXuKjt5o5A0dFiIbGHKrNYtMSvfmr9z0u9vD4BRBgbIoZsAzXz1QUHHBuzUM6sw==
X-Received: by 2002:a63:80c7:0:b0:3fa:a80c:aefd with SMTP id j190-20020a6380c7000000b003faa80caefdmr6265707pgd.351.1653469334567;
        Wed, 25 May 2022 02:02:14 -0700 (PDT)
Received: from FVFDK26JP3YV.usts.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a6aca00b001deb92de665sm1015424pjm.46.2022.05.25.02.02.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 May 2022 02:02:14 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com, pizhenwei@bytedance.com,
        helei.sig11@bytedance.com
Subject: [PATCH 3/9] crypto: Introduce akcipher crypto class
Date:   Wed, 25 May 2022 17:01:12 +0800
Message-Id: <20220525090118.43403-4-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220525090118.43403-1-helei.sig11@bytedance.com>
References: <20220525090118.43403-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: zhenwei pi <pizhenwei@bytedance.com>

Introduce new akcipher crypto class 'QCryptoAkCIpher', which supports
basic asymmetric operations: encrypt, decrypt, sign and verify.

Suggested by Daniel P. Berrangé, also add autoptr cleanup for the new
class. Thanks to Daniel!

Co-developed-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
---
 crypto/akcipher.c         | 102 ++++++++++++++++++++++++++++++
 crypto/akcipherpriv.h     |  55 ++++++++++++++++
 crypto/meson.build        |   1 +
 include/crypto/akcipher.h | 158 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 316 insertions(+)
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/akcipherpriv.h
 create mode 100644 include/crypto/akcipher.h

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
new file mode 100644
index 0000000000..ab28bf415b
--- /dev/null
+++ b/crypto/akcipher.c
@@ -0,0 +1,102 @@
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
+#include "crypto/akcipher.h"
+#include "akcipherpriv.h"
+
+QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
+                                      QCryptoAkCipherKeyType type,
+                                      const uint8_t *key, size_t keylen,
+                                      Error **errp)
+{
+    QCryptoAkCipher *akcipher = NULL;
+
+    return akcipher;
+}
+
+bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
+{
+    return false;
+}
+
+int qcrypto_akcipher_encrypt(QCryptoAkCipher *akcipher,
+                             const void *in, size_t in_len,
+                             void *out, size_t out_len, Error **errp)
+{
+    const QCryptoAkCipherDriver *drv = akcipher->driver;
+
+    return drv->encrypt(akcipher, in, in_len, out, out_len, errp);
+}
+
+int qcrypto_akcipher_decrypt(QCryptoAkCipher *akcipher,
+                             const void *in, size_t in_len,
+                             void *out, size_t out_len, Error **errp)
+{
+    const QCryptoAkCipherDriver *drv = akcipher->driver;
+
+    return drv->decrypt(akcipher, in, in_len, out, out_len, errp);
+}
+
+int qcrypto_akcipher_sign(QCryptoAkCipher *akcipher,
+                          const void *in, size_t in_len,
+                          void *out, size_t out_len, Error **errp)
+{
+    const QCryptoAkCipherDriver *drv = akcipher->driver;
+
+    return drv->sign(akcipher, in, in_len, out, out_len, errp);
+}
+
+int qcrypto_akcipher_verify(QCryptoAkCipher *akcipher,
+                            const void *in, size_t in_len,
+                            const void *in2, size_t in2_len, Error **errp)
+{
+    const QCryptoAkCipherDriver *drv = akcipher->driver;
+
+    return drv->verify(akcipher, in, in_len, in2, in2_len, errp);
+}
+
+int qcrypto_akcipher_max_plaintext_len(QCryptoAkCipher *akcipher)
+{
+    return akcipher->max_plaintext_len;
+}
+
+int qcrypto_akcipher_max_ciphertext_len(QCryptoAkCipher *akcipher)
+{
+    return akcipher->max_ciphertext_len;
+}
+
+int qcrypto_akcipher_max_signature_len(QCryptoAkCipher *akcipher)
+{
+    return akcipher->max_signature_len;
+}
+
+int qcrypto_akcipher_max_dgst_len(QCryptoAkCipher *akcipher)
+{
+    return akcipher->max_dgst_len;
+}
+
+void qcrypto_akcipher_free(QCryptoAkCipher *akcipher)
+{
+    const QCryptoAkCipherDriver *drv = akcipher->driver;
+
+    drv->free(akcipher);
+}
diff --git a/crypto/akcipherpriv.h b/crypto/akcipherpriv.h
new file mode 100644
index 0000000000..739f639bcf
--- /dev/null
+++ b/crypto/akcipherpriv.h
@@ -0,0 +1,55 @@
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
+#ifndef QCRYPTO_AKCIPHERPRIV_H
+#define QCRYPTO_AKCIPHERPRIV_H
+
+#include "qapi/qapi-types-crypto.h"
+
+typedef struct QCryptoAkCipherDriver QCryptoAkCipherDriver;
+
+struct QCryptoAkCipher {
+    QCryptoAkCipherAlgorithm alg;
+    QCryptoAkCipherKeyType type;
+    int max_plaintext_len;
+    int max_ciphertext_len;
+    int max_signature_len;
+    int max_dgst_len;
+    QCryptoAkCipherDriver *driver;
+};
+
+struct QCryptoAkCipherDriver {
+    int (*encrypt)(QCryptoAkCipher *akcipher,
+                   const void *in, size_t in_len,
+                   void *out, size_t out_len, Error **errp);
+    int (*decrypt)(QCryptoAkCipher *akcipher,
+                   const void *out, size_t out_len,
+                   void *in, size_t in_len, Error **errp);
+    int (*sign)(QCryptoAkCipher *akcipher,
+                const void *in, size_t in_len,
+                void *out, size_t out_len, Error **errp);
+    int (*verify)(QCryptoAkCipher *akcipher,
+                  const void *in, size_t in_len,
+                  const void *in2, size_t in2_len, Error **errp);
+    void (*free)(QCryptoAkCipher *akcipher);
+};
+
+#endif /* QCRYPTO_AKCIPHER_H */
diff --git a/crypto/meson.build b/crypto/meson.build
index 685fb37097..313f935f27 100644
--- a/crypto/meson.build
+++ b/crypto/meson.build
@@ -1,6 +1,7 @@
 crypto_ss.add(genh)
 crypto_ss.add(files(
   'afsplit.c',
+  'akcipher.c',
   'block-luks.c',
   'block-qcow.c',
   'block.c',
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
new file mode 100644
index 0000000000..51f5fa2774
--- /dev/null
+++ b/include/crypto/akcipher.h
@@ -0,0 +1,158 @@
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
+#include "qapi/qapi-types-crypto.h"
+
+typedef struct QCryptoAkCipher QCryptoAkCipher;
+
+/**
+ * qcrypto_akcipher_supports:
+ * @opts: the asymmetric key algorithm and related options
+ *
+ * Determine if asymmetric key cipher decribed with @opts is
+ * supported by the current configured build
+ *
+ * Returns: true if it is supported, false otherwise.
+ */
+bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts);
+
+/**
+ * qcrypto_akcipher_new:
+ * @opts: specify the algorithm and the related arguments
+ * @type: private or public key type
+ * @key: buffer to store the key
+ * @key_len: the length of key buffer
+ * @errp: error pointer
+ *
+ * Create akcipher context
+ *
+ * Returns: On success, a new QCryptoAkCipher initialized with @opt
+ * is created and returned, otherwise NULL is returned.
+ */
+
+QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
+                                      QCryptoAkCipherKeyType type,
+                                      const uint8_t *key, size_t key_len,
+                                      Error **errp);
+
+/**
+ * qcrypto_akcipher_encrypt:
+ * @akcipher: akcipher context
+ * @in: plaintext pending to be encrypted
+ * @in_len: length of plaintext, less or equal to the size reported
+ *          by a call to qcrypto_akcipher_max_plaintext_len()
+ * @out: buffer to store the ciphertext
+ * @out_len: length of ciphertext, less or equal to the size reported
+ *           by a call to qcrypto_akcipher_max_ciphertext_len()
+ * @errp: error pointer
+ *
+ * Encrypt @in and write ciphertext into @out
+ *
+ * Returns: length of ciphertext if encrypt succeed,
+ *          otherwise -1 is returned
+ */
+int qcrypto_akcipher_encrypt(QCryptoAkCipher *akcipher,
+                             const void *in, size_t in_len,
+                             void *out, size_t out_len, Error **errp);
+
+/**
+ * qcrypto_akcipher_decrypt:
+ * @akcipher: akcipher context
+ * @in: ciphertext to be decrypted
+ * @in_len: the length of ciphertext, less or equal to the size reported
+ *          by a call to qcrypto_akcipher_max_ciphertext_len()
+ * @out: buffer to store the plaintext
+ * @out_len: length of the plaintext buffer, less or equal to the size
+ *           reported by a call to qcrypto_akcipher_max_plaintext_len()
+ * @errp: error pointer
+ *
+ * Decrypt @in and write plaintext into @out
+ *
+ * Returns: length of plaintext if decrypt succeed,
+ *          otherwise -1 is returned
+ */
+int qcrypto_akcipher_decrypt(QCryptoAkCipher *akcipher,
+                             const void *in, size_t in_len,
+                             void *out, size_t out_len, Error **errp);
+
+/**
+ * qcrypto_akcipher_sign:
+ * @akcipher: akcipher context
+ * @in: data to be signed
+ * @in_len: the length of data, less or equal to the size reported
+ *          by a call to qcrypto_akcipher_max_dgst_len()
+ * @out: buffer to store the signature
+ * @out_len: length of the signature buffer, less or equal to the size
+ *           by a call to qcrypto_akcipher_max_signature_len()
+ * @errp: error pointer
+ *
+ * Generate signature for @in, write into @out
+ *
+ * Returns: length of signature if succeed,
+ *          otherwise -1 is returned
+ */
+int qcrypto_akcipher_sign(QCryptoAkCipher *akcipher,
+                          const void *in, size_t in_len,
+                          void *out, size_t out_len, Error **errp);
+
+/**
+ * qcrypto_akcipher_verify:
+ * @akcipher: akcipher context
+ * @in: pointer to the signature
+ * @in_len: length of signature, ess or equal to the size reported
+ *          by a call to qcrypto_akcipher_max_signature_len()
+ * @in2: pointer to original data
+ * @in2_len: the length of original data, less or equal to the size
+ *           by a call to qcrypto_akcipher_max_dgst_len()
+ * @errp: error pointer
+ *
+ * Verify @in and @in2 match or not
+ *
+ * Returns: 0 for succeed,
+ *          otherwise -1 is returned
+ */
+int qcrypto_akcipher_verify(QCryptoAkCipher *akcipher,
+                            const void *in, size_t in_len,
+                            const void *in2, size_t in2_len, Error **errp);
+
+int qcrypto_akcipher_max_plaintext_len(QCryptoAkCipher *akcipher);
+
+int qcrypto_akcipher_max_ciphertext_len(QCryptoAkCipher *akcipher);
+
+int qcrypto_akcipher_max_signature_len(QCryptoAkCipher *akcipher);
+
+int qcrypto_akcipher_max_dgst_len(QCryptoAkCipher *akcipher);
+
+/**
+ * qcrypto_akcipher_free:
+ * @akcipher: akcipher context
+ *
+ * Free the akcipher context
+ *
+ */
+void qcrypto_akcipher_free(QCryptoAkCipher *akcipher);
+
+G_DEFINE_AUTOPTR_CLEANUP_FUNC(QCryptoAkCipher, qcrypto_akcipher_free)
+
+#endif /* QCRYPTO_AKCIPHER_H */
-- 
2.11.0

