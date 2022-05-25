Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579AAC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 25 May 2022 09:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiEYJD6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 May 2022 05:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241337AbiEYJD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 May 2022 05:03:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE4692D12
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:26 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s68so2104752pgs.10
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zbR0OGunJ12jtd9y7Otuyi7OrZzQGpSepwX41mD/Eec=;
        b=Cp9QP+OuEMgmQ4xfaY7cJn3wzTFF135i0mAIULDYFM2fYuKMxlcoC4cpejVfYjbY2b
         9+3IpnTlc+gbNM0U6IaoT+ERtrq8plRts/nTbDlU3jx3+6vpjHrnR3Qd/8xgjuYKyRaw
         DFGtyx6D7DFyIGYdz5UgC4KqhHgYXgcRo9oIJaAvlEsMpbqwjVMrqic4rSaBpHLSYm/3
         cUGMiBGcaYZaKo34s5RX7iQDdyrWPdGJSY6IsWteUfVSPb86Zga5ovxsztTAN6Pi3jjV
         yaCfyD1QMTLzAz9BCIwFLB3Lk2ZJjWBeqcVztWAFyOlXozuYMIRq+BX201KDq5lvDH+h
         BDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zbR0OGunJ12jtd9y7Otuyi7OrZzQGpSepwX41mD/Eec=;
        b=wIKS6qhpDzCuBLACKvHL3awmg3vzFYRvIgY3A+tw2//VcKUfDYnLEeUMbXbkY2Tz4e
         HwTfzCnMuw2NN/1xmaWtctdvIY8rrBKKsSIA+Xigb8YCqiBYBhqkDvCKuhV9gJNXNNZ5
         FQ5BXub62A50/WOrRqZ1EtLTv+OQRowbrGnmoQ7ZlJcyCK1Cewz/kPXE8uUI288TShVY
         MfwKZ9F5SDrRiIWZjAjNme26+ZEE1Sb5wBwx09KQsrpya+FsiXEBBCcJvgrmK//GpQgl
         3GHnRDn/x2E5QzcCFHBHOy4RyPFrSTOxeuX7F0BVfbeI4KKKm52VSZEGiCu7glM4LNrI
         Vshw==
X-Gm-Message-State: AOAM532UAkF79hFy2rTYdpceYFiGrLatxlCwzDh+FtuyN3+q6ZzfyO/g
        qf/FO1ugAyzM9RTl8bnwX9I+jg==
X-Google-Smtp-Source: ABdhPJz4IxNsAKinZcFzmZIazrPz6nqEdC/iZBNKCuBYCqwaYFBvhrTEARHR0HzNq8gThSgUesTNXA==
X-Received: by 2002:a05:6a00:c85:b0:518:b4a7:cce1 with SMTP id a5-20020a056a000c8500b00518b4a7cce1mr11016160pfv.66.1653469344888;
        Wed, 25 May 2022 02:02:24 -0700 (PDT)
Received: from FVFDK26JP3YV.usts.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a6aca00b001deb92de665sm1015424pjm.46.2022.05.25.02.02.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 May 2022 02:02:24 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com, pizhenwei@bytedance.com,
        helei.sig11@bytedance.com
Subject: [PATCH 5/9] crypto: Implement RSA algorithm by hogweed
Date:   Wed, 25 May 2022 17:01:14 +0800
Message-Id: <20220525090118.43403-6-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220525090118.43403-1-helei.sig11@bytedance.com>
References: <20220525090118.43403-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement RSA algorithm by hogweed from nettle. Thus QEMU supports
a 'real' RSA backend to handle request from guest side. It's
important to test RSA offload case without OS & hardware requirement.

Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 crypto/akcipher-nettle.c.inc | 451 +++++++++++++++++++++++++++++++++++++++++++
 crypto/akcipher.c            |   4 +
 crypto/meson.build           |   4 +
 crypto/rsakey-builtin.c.inc  | 200 +++++++++++++++++++
 crypto/rsakey-nettle.c.inc   | 158 +++++++++++++++
 crypto/rsakey.c              |  44 +++++
 crypto/rsakey.h              |  92 +++++++++
 meson.build                  |  11 ++
 8 files changed, 964 insertions(+)
 create mode 100644 crypto/akcipher-nettle.c.inc
 create mode 100644 crypto/rsakey-builtin.c.inc
 create mode 100644 crypto/rsakey-nettle.c.inc
 create mode 100644 crypto/rsakey.c
 create mode 100644 crypto/rsakey.h

diff --git a/crypto/akcipher-nettle.c.inc b/crypto/akcipher-nettle.c.inc
new file mode 100644
index 0000000000..a7c0c6a1ee
--- /dev/null
+++ b/crypto/akcipher-nettle.c.inc
@@ -0,0 +1,451 @@
+/*
+ * QEMU Crypto akcipher algorithms
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: lei he <helei.sig11@bytedance.com>
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
+#include <nettle/rsa.h>
+
+#include "qemu/osdep.h"
+#include "qemu/host-utils.h"
+#include "crypto/akcipher.h"
+#include "crypto/random.h"
+#include "qapi/error.h"
+#include "sysemu/cryptodev.h"
+#include "rsakey.h"
+
+typedef struct QCryptoNettleRSA {
+    QCryptoAkCipher akcipher;
+    struct rsa_public_key pub;
+    struct rsa_private_key priv;
+    QCryptoRSAPaddingAlgorithm padding_alg;
+    QCryptoHashAlgorithm hash_alg;
+} QCryptoNettleRSA;
+
+static void qcrypto_nettle_rsa_free(QCryptoAkCipher *akcipher)
+{
+    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)akcipher;
+    if (!rsa) {
+        return;
+    }
+
+    rsa_public_key_clear(&rsa->pub);
+    rsa_private_key_clear(&rsa->priv);
+    g_free(rsa);
+}
+
+static QCryptoAkCipher *qcrypto_nettle_rsa_new(
+    const QCryptoAkCipherOptionsRSA *opt,
+    QCryptoAkCipherKeyType type,
+    const uint8_t *key,  size_t keylen,
+    Error **errp);
+
+QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
+                                      QCryptoAkCipherKeyType type,
+                                      const uint8_t *key, size_t keylen,
+                                      Error **errp)
+{
+    switch (opts->alg) {
+    case QCRYPTO_AKCIPHER_ALG_RSA:
+        return qcrypto_nettle_rsa_new(&opts->u.rsa, type, key, keylen, errp);
+
+    default:
+        error_setg(errp, "Unsupported algorithm: %u", opts->alg);
+        return NULL;
+    }
+
+    return NULL;
+}
+
+static void qcrypto_nettle_rsa_set_akcipher_size(QCryptoAkCipher *akcipher,
+                                                 int key_size)
+{
+    akcipher->max_plaintext_len = key_size;
+    akcipher->max_ciphertext_len = key_size;
+    akcipher->max_signature_len = key_size;
+    akcipher->max_dgst_len = key_size;
+}
+
+static int qcrypt_nettle_parse_rsa_private_key(QCryptoNettleRSA *rsa,
+                                               const uint8_t *key,
+                                               size_t keylen,
+                                               Error **errp)
+{
+    g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
+        QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE, key, keylen, errp);
+
+    if (!rsa_key) {
+        return -1;
+    }
+
+    nettle_mpz_init_set_str_256_u(rsa->pub.n, rsa_key->n.len, rsa_key->n.data);
+    nettle_mpz_init_set_str_256_u(rsa->pub.e, rsa_key->e.len, rsa_key->e.data);
+    nettle_mpz_init_set_str_256_u(rsa->priv.d, rsa_key->d.len, rsa_key->d.data);
+    nettle_mpz_init_set_str_256_u(rsa->priv.p, rsa_key->p.len, rsa_key->p.data);
+    nettle_mpz_init_set_str_256_u(rsa->priv.q, rsa_key->q.len, rsa_key->q.data);
+    nettle_mpz_init_set_str_256_u(rsa->priv.a, rsa_key->dp.len,
+                                  rsa_key->dp.data);
+    nettle_mpz_init_set_str_256_u(rsa->priv.b, rsa_key->dq.len,
+                                  rsa_key->dq.data);
+    nettle_mpz_init_set_str_256_u(rsa->priv.c, rsa_key->u.len, rsa_key->u.data);
+
+    if (!rsa_public_key_prepare(&rsa->pub)) {
+        error_setg(errp, "Failed to check RSA key");
+        return -1;
+    }
+
+    /**
+     * Since in the kernel's unit test, the p, q, a, b, c of some
+     * private keys is 0, only the simplest length check is done here
+     */
+    if (rsa_key->p.len > 1 &&
+        rsa_key->q.len > 1 &&
+        rsa_key->dp.len > 1 &&
+        rsa_key->dq.len > 1 &&
+        rsa_key->u.len > 1) {
+        if (!rsa_private_key_prepare(&rsa->priv)) {
+            error_setg(errp, "Failed to check RSA key");
+            return -1;
+        }
+    } else {
+        rsa->priv.size = rsa->pub.size;
+    }
+    qcrypto_nettle_rsa_set_akcipher_size(
+        (QCryptoAkCipher *)rsa, rsa->priv.size);
+
+    return 0;
+}
+
+static int qcrypt_nettle_parse_rsa_public_key(QCryptoNettleRSA *rsa,
+                                              const uint8_t *key,
+                                              size_t keylen,
+                                              Error **errp)
+{
+    g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
+        QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC, key, keylen, errp);
+
+    if (!rsa_key) {
+        return -1;
+    }
+    nettle_mpz_init_set_str_256_u(rsa->pub.n, rsa_key->n.len, rsa_key->n.data);
+    nettle_mpz_init_set_str_256_u(rsa->pub.e, rsa_key->e.len, rsa_key->e.data);
+
+    if (!rsa_public_key_prepare(&rsa->pub)) {
+        error_setg(errp, "Failed to check RSA key");
+        return -1;
+    }
+    qcrypto_nettle_rsa_set_akcipher_size(
+        (QCryptoAkCipher *)rsa, rsa->pub.size);
+
+    return 0;
+}
+
+static void wrap_nettle_random_func(void *ctx, size_t len, uint8_t *out)
+{
+    qcrypto_random_bytes(out, len, &error_abort);
+}
+
+static int qcrypto_nettle_rsa_encrypt(QCryptoAkCipher *akcipher,
+                                      const void *data, size_t data_len,
+                                      void *enc, size_t enc_len,
+                                      Error **errp)
+{
+
+    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)akcipher;
+    mpz_t c;
+    int ret = -1;
+
+    if (data_len > rsa->pub.size) {
+        error_setg(errp, "Plaintext length %zu is greater than key size: %zu"
+                   data_len, rsa->pub.size);
+        return ret;
+    }
+
+    if (enc_len < rsa->pub.size) {
+        error_setg(errp, "Ciphertext buffer length %zu is less than "
+                         "key size: %zu", rsa->pub.size);
+        return ret;
+    }
+
+    /* Nettle do not support RSA encryption without any padding */
+    switch (rsa->padding_alg) {
+    case QCRYPTO_RSA_PADDING_ALG_RAW:
+        error_setg(errp, "RSA with raw padding is not supported");
+        break;
+
+    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
+        mpz_init(c);
+        if (rsa_encrypt(&rsa->pub, NULL, wrap_nettle_random_func,
+                        data_len, (uint8_t *)data, c) != 1) {
+            error_setg(errp, "Failed to encrypt");
+        } else {
+            nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, c);
+            ret = nettle_mpz_sizeinbase_256_u(c);
+        }
+        mpz_clear(c);
+        break;
+
+    default:
+        error_setg(errp, "Unknown padding");
+    }
+
+    return ret;
+}
+
+static int qcrypto_nettle_rsa_decrypt(QCryptoAkCipher *akcipher,
+                                      const void *enc, size_t enc_len,
+                                      void *data, size_t data_len,
+                                      Error **errp)
+{
+    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)akcipher;
+    mpz_t c;
+    int ret = -1;
+
+    if (enc_len > rsa->priv.size) {
+        error_setg(errp, "Ciphertext length %zu is greater than key size: %zu",
+                   rsa->priv.size);
+        return ret;
+    }
+
+    switch (rsa->padding_alg) {
+    case QCRYPTO_RSA_PADDING_ALG_RAW:
+        error_setg(errp, "RSA with raw padding is not supported");
+        break;
+
+    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
+        nettle_mpz_init_set_str_256_u(c, enc_len, enc);
+        if (!rsa_decrypt(&rsa->priv, &data_len, (uint8_t *)data, c)) {
+            error_setg(errp, "Failed to decrypt");
+        } else {
+            ret = data_len;
+        }
+
+        mpz_clear(c);
+        break;
+
+    default:
+        error_setg(errp, "Unknown padding algorithm: %d", rsa->padding_alg);
+    }
+
+    return ret;
+}
+
+static int qcrypto_nettle_rsa_sign(QCryptoAkCipher *akcipher,
+                                   const void *data, size_t data_len,
+                                   void *sig, size_t sig_len, Error **errp)
+{
+    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)akcipher;
+    int ret = -1, rv;
+    mpz_t s;
+
+    /**
+     * The RSA algorithm cannot be used for signature/verification
+     * without padding.
+     */
+    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
+        error_setg(errp, "Try to make signature without padding");
+        return ret;
+    }
+
+    if (data_len > rsa->priv.size) {
+        error_setg(errp, "Data length %zu is greater than key size: %zu",
+                   rsa->priv.size);
+        return ret;
+    }
+
+    if (sig_len < rsa->priv.size) {
+        error_setg(errp, "Signature buffer length %zu is less than "
+                         "key size: %zu", rsa->priv.size);
+        return ret;
+    }
+
+    mpz_init(s);
+    switch (rsa->hash_alg) {
+    case QCRYPTO_HASH_ALG_MD5:
+        rv = rsa_md5_sign_digest(&rsa->priv, data, s);
+        break;
+
+    case QCRYPTO_HASH_ALG_SHA1:
+        rv = rsa_sha1_sign_digest(&rsa->priv, data, s);
+        break;
+
+    case QCRYPTO_HASH_ALG_SHA256:
+        rv = rsa_sha256_sign_digest(&rsa->priv, data, s);
+        break;
+
+    case QCRYPTO_HASH_ALG_SHA512:
+        rv = rsa_sha512_sign_digest(&rsa->priv, data, s);
+        break;
+
+    default:
+        error_setg(errp, "Unknown hash algorithm: %d", rsa->hash_alg);
+        goto cleanup;
+    }
+
+    if (rv != 1) {
+        error_setg(errp, "Failed to make signature");
+        goto cleanup;
+    }
+    nettle_mpz_get_str_256(sig_len, (uint8_t *)sig, s);
+    ret = nettle_mpz_sizeinbase_256_u(s);
+
+cleanup:
+    mpz_clear(s);
+
+    return ret;
+}
+
+static int qcrypto_nettle_rsa_verify(QCryptoAkCipher *akcipher,
+                                     const void *sig, size_t sig_len,
+                                     const void *data, size_t data_len,
+                                     Error **errp)
+{
+    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)akcipher;
+
+    int ret = -1, rv;
+    mpz_t s;
+
+    /**
+     * The RSA algorithm cannot be used for signature/verification
+     * without padding.
+     */
+    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
+        error_setg(errp, "Try to verify signature without padding");
+        return ret;
+    }
+    if (data_len > rsa->pub.size) {
+        error_setg(errp, "Data length %zu is greater than key size: %zu",
+                   rsa->pub.size);
+        return ret;
+    }
+    if (sig_len < rsa->pub.size) {
+        error_setg(errp, "Signature length %zu is greater than key size: %zu",
+                   rsa->pub.size);
+        return ret;
+    }
+
+    nettle_mpz_init_set_str_256_u(s, sig_len, sig);
+    switch (rsa->hash_alg) {
+    case QCRYPTO_HASH_ALG_MD5:
+        rv = rsa_md5_verify_digest(&rsa->pub, data, s);
+        break;
+
+    case QCRYPTO_HASH_ALG_SHA1:
+        rv = rsa_sha1_verify_digest(&rsa->pub, data, s);
+        break;
+
+    case QCRYPTO_HASH_ALG_SHA256:
+        rv = rsa_sha256_verify_digest(&rsa->pub, data, s);
+        break;
+
+    case QCRYPTO_HASH_ALG_SHA512:
+        rv = rsa_sha512_verify_digest(&rsa->pub, data, s);
+        break;
+
+    default:
+        error_setg(errp, "Unsupported hash algorithm: %d", rsa->hash_alg);
+        goto cleanup;
+    }
+
+    if (rv != 1) {
+        error_setg(errp, "Failed to verify signature");
+        goto cleanup;
+    }
+    ret = 0;
+
+cleanup:
+    mpz_clear(s);
+
+    return ret;
+}
+
+QCryptoAkCipherDriver nettle_rsa = {
+    .encrypt = qcrypto_nettle_rsa_encrypt,
+    .decrypt = qcrypto_nettle_rsa_decrypt,
+    .sign = qcrypto_nettle_rsa_sign,
+    .verify = qcrypto_nettle_rsa_verify,
+    .free = qcrypto_nettle_rsa_free,
+};
+
+static QCryptoAkCipher *qcrypto_nettle_rsa_new(
+    const QCryptoAkCipherOptionsRSA *opt,
+    QCryptoAkCipherKeyType type,
+    const uint8_t *key, size_t keylen,
+    Error **errp)
+{
+    QCryptoNettleRSA *rsa = g_new0(QCryptoNettleRSA, 1);
+
+    rsa->padding_alg = opt->padding_alg;
+    rsa->hash_alg = opt->hash_alg;
+    rsa->akcipher.driver = &nettle_rsa;
+    rsa_public_key_init(&rsa->pub);
+    rsa_private_key_init(&rsa->priv);
+
+    switch (type) {
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+        if (qcrypt_nettle_parse_rsa_private_key(rsa, key, keylen, errp) != 0) {
+            goto error;
+        }
+        break;
+
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+        if (qcrypt_nettle_parse_rsa_public_key(rsa, key, keylen, errp) != 0) {
+            goto error;
+        }
+        break;
+
+    default:
+        error_setg(errp, "Unknown akcipher key type %d", type);
+        goto error;
+    }
+
+    return (QCryptoAkCipher *)rsa;
+
+error:
+    qcrypto_nettle_rsa_free((QCryptoAkCipher *)rsa);
+    return NULL;
+}
+
+
+bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
+{
+    switch (opts->alg) {
+    case QCRYPTO_AKCIPHER_ALG_RSA:
+        switch (opts->u.rsa.padding_alg) {
+        case QCRYPTO_RSA_PADDING_ALG_PKCS1:
+            switch (opts->u.rsa.hash_alg) {
+            case QCRYPTO_HASH_ALG_MD5:
+            case QCRYPTO_HASH_ALG_SHA1:
+            case QCRYPTO_HASH_ALG_SHA256:
+            case QCRYPTO_HASH_ALG_SHA512:
+                return true;
+
+            default:
+                return false;
+            }
+
+        case QCRYPTO_RSA_PADDING_ALG_RAW:
+        default:
+            return false;
+        }
+        break;
+
+    default:
+        return false;
+    }
+}
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index ab28bf415b..f287083f92 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -23,6 +23,9 @@
 #include "crypto/akcipher.h"
 #include "akcipherpriv.h"
 
+#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
+#include "akcipher-nettle.c.inc"
+#else
 QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
                                       QCryptoAkCipherKeyType type,
                                       const uint8_t *key, size_t keylen,
@@ -37,6 +40,7 @@ bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
 {
     return false;
 }
+#endif
 
 int qcrypto_akcipher_encrypt(QCryptoAkCipher *akcipher,
                              const void *in, size_t in_len,
diff --git a/crypto/meson.build b/crypto/meson.build
index b8152ae7cb..5f03a30d34 100644
--- a/crypto/meson.build
+++ b/crypto/meson.build
@@ -21,10 +21,14 @@ crypto_ss.add(files(
   'tlscredspsk.c',
   'tlscredsx509.c',
   'tlssession.c',
+  'rsakey.c',
 ))
 
 if nettle.found()
   crypto_ss.add(nettle, files('hash-nettle.c', 'hmac-nettle.c', 'pbkdf-nettle.c'))
+  if hogweed.found()
+    crypto_ss.add(gmp, hogweed)
+  endif
   if xts == 'private'
     crypto_ss.add(files('xts.c'))
   endif
diff --git a/crypto/rsakey-builtin.c.inc b/crypto/rsakey-builtin.c.inc
new file mode 100644
index 0000000000..aeeacc8f9b
--- /dev/null
+++ b/crypto/rsakey-builtin.c.inc
@@ -0,0 +1,200 @@
+/*
+ * QEMU Crypto akcipher algorithms
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: lei he <helei.sig11@bytedance.com>
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
+#include "der.h"
+#include "rsakey.h"
+
+static int extract_mpi(void *ctx, const uint8_t *value,
+                       size_t vlen, Error **errp)
+{
+    QCryptoAkCipherMPI *mpi = (QCryptoAkCipherMPI *)ctx;
+    if (vlen == 0) {
+        error_setg(errp, "Empty mpi field");
+        return -1;
+    }
+    mpi->data = g_memdup2(value, vlen);
+    mpi->len = vlen;
+    return 0;
+}
+
+static int extract_version(void *ctx, const uint8_t *value,
+                           size_t vlen, Error **errp)
+{
+    uint8_t *version = (uint8_t *)ctx;
+    if (vlen != 1 || *value > 1) {
+        error_setg(errp, "Invalid rsakey version");
+        return -1;
+    }
+    *version = *value;
+    return 0;
+}
+
+static int extract_seq_content(void *ctx, const uint8_t *value,
+                               size_t vlen, Error **errp)
+{
+    const uint8_t **content = (const uint8_t **)ctx;
+    if (vlen == 0) {
+        error_setg(errp, "Empty sequence");
+        return -1;
+    }
+    *content = value;
+    return 0;
+}
+
+/**
+ *
+ *        RsaPubKey ::= SEQUENCE {
+ *             n           INTEGER
+ *             e           INTEGER
+ *         }
+ */
+static QCryptoAkCipherRSAKey *qcrypto_builtin_rsa_public_key_parse(
+    const uint8_t *key, size_t keylen, Error **errp)
+{
+    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
+    const uint8_t *seq;
+    size_t seq_length;
+    int decode_ret;
+
+    decode_ret = qcrypto_der_decode_seq(&key, &keylen,
+                                        extract_seq_content, &seq, errp);
+    if (decode_ret < 0 || keylen != 0) {
+        goto error;
+    }
+    seq_length = decode_ret;
+
+    if (qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
+                               &rsa->n, errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
+                               &rsa->e, errp) < 0) {
+        goto error;
+    }
+    if (seq_length != 0) {
+        goto error;
+    }
+
+    return rsa;
+
+error:
+    if (errp && !*errp) {
+        error_setg(errp, "Invalid RSA public key");
+    }
+    qcrypto_akcipher_rsakey_free(rsa);
+    return NULL;
+}
+
+/**
+ *        RsaPrivKey ::= SEQUENCE {
+ *             version     INTEGER
+ *             n           INTEGER
+ *             e           INTEGER
+ *             d           INTEGER
+ *             p           INTEGER
+ *             q           INTEGER
+ *             dp          INTEGER
+ *             dq          INTEGER
+ *             u           INTEGER
+ *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
+ *         }
+ */
+static QCryptoAkCipherRSAKey *qcrypto_builtin_rsa_private_key_parse(
+    const uint8_t *key, size_t keylen, Error **errp)
+{
+    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
+    uint8_t version;
+    const uint8_t *seq;
+    int decode_ret;
+    size_t seq_length;
+
+    decode_ret = qcrypto_der_decode_seq(&key, &keylen, extract_seq_content,
+                                        &seq, errp);
+    if (decode_ret < 0 || keylen != 0) {
+        goto error;
+    }
+    seq_length = decode_ret;
+
+    decode_ret = qcrypto_der_decode_int(&seq, &seq_length, extract_version,
+                                        &version, errp);
+
+    if (qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
+                               &rsa->n, errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
+                               &rsa->e, errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
+                               &rsa->d, errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, &rsa->p,
+                               errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, &rsa->q,
+                               errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, &rsa->dp,
+                               errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, &rsa->dq,
+                               errp) < 0 ||
+        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, &rsa->u,
+                               errp) < 0) {
+        goto error;
+    }
+
+    /**
+     * According to the standard, otherPrimeInfos must be present for version 1.
+     * There is no strict verification here, this is to be compatible with
+     * the unit test of the kernel. TODO: remove this until linux kernel's
+     * unit-test is fixed.
+     */
+    if (version == 1 && seq_length != 0) {
+        if (qcrypto_der_decode_seq(&seq, &seq_length, NULL, NULL, errp) < 0) {
+            goto error;
+        }
+        if (seq_length != 0) {
+            goto error;
+        }
+        return rsa;
+    }
+    if (seq_length != 0) {
+        goto error;
+    }
+
+    return rsa;
+
+error:
+    if (errp && !*errp) {
+        error_setg(errp, "Invalid RSA private key");
+    }
+    qcrypto_akcipher_rsakey_free(rsa);
+    return NULL;
+}
+
+QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
+    QCryptoAkCipherKeyType type, const uint8_t *key,
+    size_t keylen, Error **errp)
+{
+    switch (type) {
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+        return qcrypto_builtin_rsa_private_key_parse(key, keylen, errp);
+
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+        return qcrypto_builtin_rsa_public_key_parse(key, keylen, errp);
+
+    default:
+        error_setg(errp, "Unknown key type: %d", type);
+        return NULL;
+    }
+}
diff --git a/crypto/rsakey-nettle.c.inc b/crypto/rsakey-nettle.c.inc
new file mode 100644
index 0000000000..cc49872e78
--- /dev/null
+++ b/crypto/rsakey-nettle.c.inc
@@ -0,0 +1,158 @@
+/*
+ * QEMU Crypto akcipher algorithms
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: lei he <helei.sig11@bytedance.com>
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
+#include <nettle/asn1.h>
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "rsakey.h"
+
+static bool DumpMPI(struct asn1_der_iterator *i, QCryptoAkCipherMPI *mpi)
+{
+    mpi->data = g_memdup2(i->data, i->length);
+    mpi->len = i->length;
+    return true;
+}
+
+static bool GetMPI(struct asn1_der_iterator *i, QCryptoAkCipherMPI *mpi)
+{
+    if (asn1_der_iterator_next(i) != ASN1_ITERATOR_PRIMITIVE ||
+        i->type != ASN1_INTEGER) {
+        return false;
+    }
+    return DumpMPI(i, mpi);
+}
+
+/**
+ *        RsaPrivKey ::= SEQUENCE {
+ *             version     INTEGER
+ *             n           INTEGER
+ *             e           INTEGER
+ *             d           INTEGER
+ *             p           INTEGER
+ *             q           INTEGER
+ *             dp          INTEGER
+ *             dq          INTEGER
+ *             u           INTEGER
+ *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
+ *         }
+ */
+static QCryptoAkCipherRSAKey *qcrypto_nettle_rsa_private_key_parse(
+    const uint8_t *key, size_t keylen, Error **errp)
+{
+    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
+    struct asn1_der_iterator i;
+    uint32_t version;
+    int tag;
+
+    /* Parse entire struct */
+    if (asn1_der_iterator_first(&i, keylen, key) != ASN1_ITERATOR_CONSTRUCTED ||
+        i.type != ASN1_SEQUENCE ||
+        asn1_der_decode_constructed_last(&i) != ASN1_ITERATOR_PRIMITIVE ||
+        i.type != ASN1_INTEGER ||
+        !asn1_der_get_uint32(&i, &version) ||
+        version > 1 ||
+        !GetMPI(&i, &rsa->n) ||
+        !GetMPI(&i, &rsa->e) ||
+        !GetMPI(&i, &rsa->d) ||
+        !GetMPI(&i, &rsa->p) ||
+        !GetMPI(&i, &rsa->q) ||
+        !GetMPI(&i, &rsa->dp) ||
+        !GetMPI(&i, &rsa->dq) ||
+        !GetMPI(&i, &rsa->u)) {
+        goto error;
+    }
+
+    if (version == 1) {
+        tag = asn1_der_iterator_next(&i);
+        /**
+         * According to the standard otherPrimeInfos must be present for
+         * version 1. There is no strict verification here, this is to be
+         * compatible with the unit test of the kernel. TODO: remove this
+         * until linux-kernel's unit-test is fixed;
+         */
+        if (tag == ASN1_ITERATOR_END) {
+            return rsa;
+        }
+        if (tag != ASN1_ITERATOR_CONSTRUCTED ||
+            i.type != ASN1_SEQUENCE) {
+            goto error;
+        }
+    }
+
+    if (asn1_der_iterator_next(&i) != ASN1_ITERATOR_END) {
+        goto error;
+    }
+
+    return rsa;
+
+error:
+    error_setg(errp, "Failed to parse RSA private key");
+    qcrypto_akcipher_rsakey_free(rsa);
+    return NULL;
+}
+
+/**
+ *        RsaPubKey ::= SEQUENCE {
+ *             n           INTEGER
+ *             e           INTEGER
+ *         }
+ */
+static QCryptoAkCipherRSAKey *qcrypto_nettle_rsa_public_key_parse(
+    const uint8_t *key, size_t keylen, Error **errp)
+{
+
+    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
+    struct asn1_der_iterator i;
+
+    if (asn1_der_iterator_first(&i, keylen, key) != ASN1_ITERATOR_CONSTRUCTED ||
+        i.type != ASN1_SEQUENCE ||
+        asn1_der_decode_constructed_last(&i) != ASN1_ITERATOR_PRIMITIVE ||
+        !DumpMPI(&i, &rsa->n) ||
+        !GetMPI(&i, &rsa->e) ||
+        asn1_der_iterator_next(&i) != ASN1_ITERATOR_END) {
+        goto error;
+    }
+
+    return rsa;
+
+error:
+    error_setg(errp, "Failed to parse RSA public key");
+    qcrypto_akcipher_rsakey_free(rsa);
+    return NULL;
+}
+
+QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
+    QCryptoAkCipherKeyType type, const uint8_t *key,
+    size_t keylen, Error **errp)
+{
+    switch (type) {
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+        return qcrypto_nettle_rsa_private_key_parse(key, keylen, errp);
+
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+        return qcrypto_nettle_rsa_public_key_parse(key, keylen, errp);
+
+    default:
+        error_setg(errp, "Unknown key type: %d", type);
+        return NULL;
+    }
+}
diff --git a/crypto/rsakey.c b/crypto/rsakey.c
new file mode 100644
index 0000000000..cc40e072f0
--- /dev/null
+++ b/crypto/rsakey.c
@@ -0,0 +1,44 @@
+/*
+ * QEMU Crypto RSA key parser
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: lei he <helei.sig11@bytedance.com>
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
+#include "rsakey.h"
+
+void qcrypto_akcipher_rsakey_free(QCryptoAkCipherRSAKey *rsa_key)
+{
+    if (!rsa_key) {
+        return;
+    }
+    g_free(rsa_key->n.data);
+    g_free(rsa_key->e.data);
+    g_free(rsa_key->d.data);
+    g_free(rsa_key->p.data);
+    g_free(rsa_key->q.data);
+    g_free(rsa_key->dp.data);
+    g_free(rsa_key->dq.data);
+    g_free(rsa_key->u.data);
+    g_free(rsa_key);
+}
+
+#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
+#include "rsakey-nettle.c.inc"
+#else
+#include "rsakey-builtin.c.inc"
+#endif
diff --git a/crypto/rsakey.h b/crypto/rsakey.h
new file mode 100644
index 0000000000..974b76f659
--- /dev/null
+++ b/crypto/rsakey.h
@@ -0,0 +1,92 @@
+/*
+ * QEMU Crypto RSA key parser
+ *
+ * Copyright (c) 2022 Bytedance
+ * Author: lei he <helei.sig11@bytedance.com>
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
+#ifndef QCRYPTO_RSAKEY_H
+#define QCRYPTO_RSAKEY_H
+
+#include "qemu/osdep.h"
+#include "qemu/host-utils.h"
+#include "crypto/akcipher.h"
+
+typedef struct QCryptoAkCipherRSAKey QCryptoAkCipherRSAKey;
+typedef struct QCryptoAkCipherMPI QCryptoAkCipherMPI;
+
+/**
+ * Multiple precious integer, encoded as two' complement,
+ * copied directly from DER encoded ASN.1 structures.
+ */
+struct QCryptoAkCipherMPI {
+    uint8_t *data;
+    size_t len;
+};
+
+/* See rfc2437: https://datatracker.ietf.org/doc/html/rfc2437 */
+struct QCryptoAkCipherRSAKey {
+    /* The modulus */
+    QCryptoAkCipherMPI n;
+    /* The public exponent */
+    QCryptoAkCipherMPI e;
+    /* The private exponent */
+    QCryptoAkCipherMPI d;
+    /* The first factor */
+    QCryptoAkCipherMPI p;
+    /* The second factor */
+    QCryptoAkCipherMPI q;
+    /* The first factor's exponent */
+    QCryptoAkCipherMPI dp;
+    /* The second factor's exponent */
+    QCryptoAkCipherMPI dq;
+    /* The CRT coefficient */
+    QCryptoAkCipherMPI u;
+};
+
+/**
+ * Parse DER encoded ASN.1 RSA keys, expected ASN.1 schemas:
+ *        RsaPrivKey ::= SEQUENCE {
+ *             version     INTEGER
+ *             n           INTEGER
+ *             e           INTEGER
+ *             d           INTEGER
+ *             p           INTEGER
+ *             q           INTEGER
+ *             dp          INTEGER
+ *             dq          INTEGER
+ *             u           INTEGER
+ *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
+ *         }
+ *
+ *        RsaPubKey ::= SEQUENCE {
+ *             n           INTEGER
+ *             e           INTEGER
+ *         }
+ *
+ * Returns: On success QCryptoAkCipherRSAKey is returned, otherwise returns NULL
+ */
+QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
+    QCryptoAkCipherKeyType type,
+    const uint8_t *key, size_t keylen, Error **errp);
+
+void qcrypto_akcipher_rsakey_free(QCryptoAkCipherRSAKey *key);
+
+G_DEFINE_AUTOPTR_CLEANUP_FUNC(QCryptoAkCipherRSAKey,
+                              qcrypto_akcipher_rsakey_free);
+
+#endif
diff --git a/meson.build b/meson.build
index 40132b4804..68bd083189 100644
--- a/meson.build
+++ b/meson.build
@@ -1098,6 +1098,7 @@ endif
 # gcrypt over nettle for performance reasons.
 gcrypt = not_found
 nettle = not_found
+hogweed = not_found
 xts = 'none'
 
 if get_option('nettle').enabled() and get_option('gcrypt').enabled()
@@ -1135,6 +1136,15 @@ if not gnutls_crypto.found()
   endif
 endif
 
+gmp = dependency('gmp', required: false, method: 'pkg-config', kwargs: static_kwargs)
+if nettle.found() and gmp.found()
+  hogweed = dependency('hogweed', version: '>=3.4',
+                       method: 'pkg-config',
+                       required: get_option('nettle'),
+                       kwargs: static_kwargs)
+endif
+
+
 gtk = not_found
 gtkx11 = not_found
 vte = not_found
@@ -1744,6 +1754,7 @@ config_host_data.set('CONFIG_GNUTLS', gnutls.found())
 config_host_data.set('CONFIG_GNUTLS_CRYPTO', gnutls_crypto.found())
 config_host_data.set('CONFIG_GCRYPT', gcrypt.found())
 config_host_data.set('CONFIG_NETTLE', nettle.found())
+config_host_data.set('CONFIG_HOGWEED', hogweed.found())
 config_host_data.set('CONFIG_QEMU_PRIVATE_XTS', xts == 'private')
 config_host_data.set('CONFIG_MALLOC_TRIM', has_malloc_trim)
 config_host_data.set('CONFIG_STATX', has_statx)
-- 
2.11.0

