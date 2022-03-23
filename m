Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325CDC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 02:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiCWCyo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241402AbiCWCym (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 22:54:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACB421E26
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:53:12 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n18so321053plg.5
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JRZKe62kNAZqIgMCGzGssCPXcTglMZ1LEDhPHI4EgMs=;
        b=IypQpgdPRPpyMzPYiFVdk4SjJxAR6xWFXaL0oi62SvwFsUezMboajpSgICc17w8bmF
         iwWJCN2+PE+V8eqOp9WP74/CU8EkIHQiCm15T7hz/2sZGNK3sR2LMRwRegCdB+Xwy9Lb
         UBVV3N8X0O3jnxZ06BgXhouXUV4rtduRgel36ahQTy7F6nljeYIxTt0ATGVIxr6Mam+Z
         spCc8kjtyWxO5SmApRiucMJTeOfM9rI7r55exrypsKGe2oPmdXeTGcLd75nDDN6dNpe6
         ti2jCqWPC4/pSwj53tB9o6FLuW/a9GoFc1vMgKjpzbzxmhHqtCBdPpYryniXm1vKwBz9
         pI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRZKe62kNAZqIgMCGzGssCPXcTglMZ1LEDhPHI4EgMs=;
        b=K8wfMIV5OtJUKI3p9Y/Rtrh76272UfaMh86pwON1OI0H1C8HmfuUGKn8VSMe7QRkDB
         oQe6dXZdlbf0Cc19IA87lyEkmiCTeYp/JMdzlAHKLzGex6O4UdllPSmpmx8pVzNXw33D
         9SK6Xqe+0rw8bjkP6cCfdtSySkt1pU8AdjUdYYHTLdDjSHy+ss/gW8iWBDwMm/85OAOG
         Jk3jXnirphpcrdVJrL+u82480i79UST5TPUBnU5tFyRWRgQVQP3RHWEYNQXDc19vwx/k
         2OkNPF7Bs7So1CcSYf9bDWN/9txhE/arW1Mtxma9Z9ynN31Q4gY1wPiDmuWt5YLpWPpe
         E5TQ==
X-Gm-Message-State: AOAM532UUiLTlUPX0PJBZ8UKq7/ZQj9tzyN3p8kcpclAmNn1LWuc0sru
        03j84pEFs+G2eXMM6Pq1s/Mrng==
X-Google-Smtp-Source: ABdhPJybYCZl672yipZaMz5UJ1+rO8Iv8eqh45OaimACaRtBPP+R1oTlrtlmMYr+x+hbmyHhm7oVSA==
X-Received: by 2002:a17:902:e5cc:b0:154:1c96:2e5b with SMTP id u12-20020a170902e5cc00b001541c962e5bmr21368585plf.94.1648003992033;
        Tue, 22 Mar 2022 19:53:12 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id t2-20020a63a602000000b0038062a0bc6fsm18104869pge.67.2022.03.22.19.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 19:53:11 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, Lei He <helei.sig11@bytedance.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v3 4/6] crypto: Implement RSA algorithm by hogweed
Date:   Wed, 23 Mar 2022 10:49:10 +0800
Message-Id: <20220323024912.249789-5-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323024912.249789-1-pizhenwei@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Lei He <helei.sig11@bytedance.com>

Introduce ASN.1 decoder, and implement RSA algorithm by hogweed
from nettle. Thus QEMU supports a 'real' RSA backend to handle
request from guest side. It's important to test RSA offload case
without OS & hardware requirement.

Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 crypto/akcipher-nettle.c  | 523 ++++++++++++++++++++++++++++++++++++++
 crypto/akcipher.c         |   3 +
 crypto/asn1_decoder.c     | 185 ++++++++++++++
 crypto/asn1_decoder.h     |  42 +++
 crypto/meson.build        |   3 +
 include/crypto/akcipher.h |  16 ++
 meson.build               |  11 +
 7 files changed, 783 insertions(+)
 create mode 100644 crypto/akcipher-nettle.c
 create mode 100644 crypto/asn1_decoder.c
 create mode 100644 crypto/asn1_decoder.h

diff --git a/crypto/akcipher-nettle.c b/crypto/akcipher-nettle.c
new file mode 100644
index 0000000000..45b93af772
--- /dev/null
+++ b/crypto/akcipher-nettle.c
@@ -0,0 +1,523 @@
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
+#include <stdbool.h>
+
+#include <nettle/rsa.h>
+
+#include "qemu/osdep.h"
+#include "qemu/host-utils.h"
+#include "asn1_decoder.h"
+#include "crypto/akcipher.h"
+#include "crypto/random.h"
+#include "qapi/error.h"
+#include "sysemu/cryptodev.h"
+
+typedef struct QCryptoNettleRsa {
+    QCryptoAkcipher akcipher;
+    struct rsa_public_key pub;
+    struct rsa_private_key priv;
+    QCryptoRsaPaddingAlgorithm padding_algo;
+    QCryptoRsaHashAlgorithm hash_algo;
+} QCryptoNettleRsa;
+
+struct asn1_parse_ctx {
+    const uint8_t *data;
+    size_t dlen;
+};
+
+#define Octet 8
+
+static int extract_value(void *p, const uint8_t *data, size_t dlen)
+{
+    struct asn1_parse_ctx *ctx = (struct asn1_parse_ctx *)p;
+    ctx->data = (uint8_t *)data;
+    ctx->dlen = dlen;
+
+    return 0;
+}
+
+static int extract_mpi(void *p, const uint8_t *data, size_t dlen)
+{
+    mpz_t *target = (mpz_t *)p;
+    nettle_mpz_set_str_256_u(*target, dlen, data);
+
+    return 0;
+}
+
+static QCryptoNettleRsa *qcrypto_nettle_rsa_malloc(void);
+
+static void qcrypto_nettle_rsa_destroy(void *ptr)
+{
+    QCryptoNettleRsa *rsa = (QCryptoNettleRsa *)ptr;
+    if (!rsa) {
+        return;
+    }
+
+    rsa_public_key_clear(&rsa->pub);
+    rsa_private_key_clear(&rsa->priv);
+    g_free(rsa);
+}
+
+static QCryptoAkcipher *qcrypto_nettle_new_rsa(
+    QCryptoAkcipherKeyType type,
+    const uint8_t *key,  size_t keylen,
+    QCryptoRsaOptions *opt, Error **errp);
+
+QCryptoAkcipher *qcrypto_akcipher_nettle_new(QCryptoAkcipherAlgorithm alg,
+                                             QCryptoAkcipherKeyType type,
+                                             const uint8_t *key,
+                                             size_t keylen, void *para,
+                                             Error **errp)
+{
+    switch (alg) {
+    case QCRYPTO_AKCIPHER_ALG_RSA:
+        return qcrypto_nettle_new_rsa(type, key, keylen,
+                                      (QCryptoRsaOptions *)para, errp);
+    default:
+        error_setg(errp, "Unsupported algorithm: %u", alg);
+        return NULL;
+    }
+
+    return NULL;
+}
+
+/**
+ * Parse ber encoded rsa private key, asn1 schema:
+ *        RsaPrivKey ::= SEQUENCE {
+ *             version     INTEGER
+ *             n           INTEGER
+ *             e           INTEGER
+ *             d           INTEGER
+ *             p           INTEGER
+ *             q           INTEGER
+ *             e1          INTEGER
+ *             e2          INTEGER
+ *             u           INTEGER
+ *         }
+ */
+static int parse_rsa_private_key(QCryptoNettleRsa *rsa,
+                                 const uint8_t *key, size_t keylen)
+{
+    struct asn1_parse_ctx ctx;
+
+    if (ber_decode_seq(&key, &keylen, extract_value, &ctx) != 0 ||
+        keylen != 0) {
+        return -1;
+    }
+
+    if (ber_decode_int(&ctx.data, &ctx.dlen, NULL, NULL) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.n) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.e) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.d) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.p) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.q) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.a) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.b) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.c) != 0 ||
+        ctx.dlen != 0) {
+        return -1;
+    }
+
+    if (!rsa_public_key_prepare(&rsa->pub)) {
+        return -1;
+    }
+
+    /**
+     * Since in the kernel's unit test, the p, q, a, b, c of some
+     * private keys is 0, only the simplest length check is done here
+     */
+    rsa->priv.size = rsa->pub.size;
+
+    return 0;
+}
+
+/**
+ * Parse ber encoded rsa pubkey, asn1 schema:
+ *        RsaPrivKey ::= SEQUENCE {
+ *             n           INTEGER
+ *             e           INTEGER
+ *         }
+ */
+static int parse_rsa_public_key(QCryptoNettleRsa *rsa,
+                                const uint8_t *key,
+                                size_t keylen)
+{
+    struct asn1_parse_ctx ctx;
+
+    if (ber_decode_seq(&key, &keylen, extract_value, &ctx) != 0 ||
+        keylen != 0) {
+        return -1;
+    }
+
+    if (ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.n) != 0 ||
+        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.e) != 0 ||
+        ctx.dlen != 0) {
+        return -1;
+    }
+
+    if (!rsa_public_key_prepare(&rsa->pub)) {
+        return -1;
+    }
+
+    return 0;
+}
+
+static void qcrypto_nettle_rsa_set_akcipher_size(QCryptoAkcipher *akcipher,
+                                                 int key_size)
+{
+    akcipher->max_plaintext_len = key_size;
+    akcipher->max_ciphertext_len = key_size;
+    akcipher->max_signature_len = key_size;
+    akcipher->max_dgst_len = key_size;
+}
+
+static QCryptoAkcipher *qcrypto_nettle_new_rsa(
+    QCryptoAkcipherKeyType type,
+    const uint8_t *key, size_t keylen,
+    QCryptoRsaOptions *opt, Error **errp)
+{
+    QCryptoNettleRsa *rsa = qcrypto_nettle_rsa_malloc();
+    rsa->padding_algo = opt->padding_algo;
+    rsa->hash_algo = opt->hash_algo;
+
+    switch (type) {
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+        if (parse_rsa_private_key(rsa, key, keylen) == 0) {
+            qcrypto_nettle_rsa_set_akcipher_size(
+                (QCryptoAkcipher *)rsa, rsa->priv.size);
+            return (QCryptoAkcipher *)rsa;
+        }
+        error_setg(errp, "Failed to parse rsa private key");
+        break;
+
+    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+        if (parse_rsa_public_key(rsa, key, keylen) == 0) {
+            qcrypto_nettle_rsa_set_akcipher_size(
+                (QCryptoAkcipher *)rsa, rsa->pub.size);
+            return (QCryptoAkcipher *)rsa;
+        }
+        error_setg(errp, "Failed to parse rsa public rsa key");
+        break;
+
+    default:
+        error_setg(errp, "Unknown akcipher key type %d", type);
+    }
+
+    qcrypto_nettle_rsa_destroy(rsa);
+    return NULL;
+}
+
+
+/**
+ * nettle does not provide RSA interfaces without padding,
+ * here we implemented rsa algorithm with nettle/mpz.
+ */
+static int _rsa_enc_raw(QCryptoNettleRsa *rsa, const void *data,
+                        size_t data_len, void *enc,
+                        size_t enc_len, Error **errp)
+{
+    mpz_t m;
+    int ret;
+
+    nettle_mpz_init_set_str_256_u(m, data_len, data);
+    /* (1) Validate 0 <= m < n */
+    if (mpz_cmp_ui(m, 0) < 0 || mpz_cmp(m, rsa->pub.n) >= 0) {
+        error_setg(errp, "Failed to validate input data");
+        return -1;
+    }
+
+    /* (2) c = m ^ e mod n */
+    mpz_powm(m, m, rsa->pub.e, rsa->pub.n);
+    if ((mpz_sizeinbase(m, 2) + Octet - 1) / Octet > enc_len) {
+        ret = -1;
+    } else {
+        ret = enc_len;
+        nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, m);
+    }
+
+    mpz_clear(m);
+
+    return ret;
+}
+
+static int _rsa_dec_raw(QCryptoNettleRsa *rsa,
+                        const void *enc,
+                        size_t enc_len,
+                        void *data,
+                        size_t data_len,
+                        Error **errp)
+{
+    mpz_t c;
+    int ret;
+    nettle_mpz_init_set_str_256_u(c, enc_len, enc);
+
+    /* (1) Validate 0 <= c < n */
+    if (mpz_cmp_ui(c, 0) < 0 || mpz_cmp(c, rsa->pub.n) >= 0) {
+        error_setg(errp, "Failed to validate input data");
+        return -1;
+    }
+
+    /* (2) m = c ^ d mod n */
+    mpz_powm(c, c, rsa->priv.d, rsa->pub.n);
+    if ((mpz_sizeinbase(c, 2) + Octet - 1) / Octet > data_len) {
+        ret = -1;
+    } else {
+        ret = data_len;
+        nettle_mpz_get_str_256(data_len, (uint8_t *)data, c);
+    }
+
+    mpz_clear(c);
+
+    return ret;
+}
+
+static void wrap_nettle_random_func(void *ctx, size_t len, uint8_t *out)
+{
+    /* TODO: check result */
+    qcrypto_random_bytes(out, len, NULL);
+}
+
+static int qcrypto_nettle_rsa_encrypt(QCryptoAkcipher *akcipher_driver,
+                                      const void *data, size_t data_len,
+                                      void *enc, size_t enc_len,
+                                      Error **errp)
+{
+
+    QCryptoNettleRsa *rsa =
+        container_of(akcipher_driver, QCryptoNettleRsa, akcipher);
+    mpz_t c;
+    int enc_ret;
+
+    if (data_len > rsa->pub.size || enc_len != rsa->pub.size) {
+        error_setg(errp, "Invalid buffer size");
+        return -1;
+    }
+
+    switch (rsa->padding_algo) {
+    case QCRYPTO_RSA_PADDING_ALG_RAW:
+        return _rsa_enc_raw(rsa, data, data_len, enc, enc_len, errp);
+
+    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
+        mpz_init(c);
+        enc_ret = rsa_encrypt(&rsa->pub, NULL, wrap_nettle_random_func,
+                              data_len, (uint8_t *)data, c);
+        if (enc_ret != 1) {
+            error_setg(errp, "Failed to encrypt");
+            enc_ret = -1;
+        } else {
+            nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, c);
+            enc_ret = enc_len;
+        }
+        mpz_clear(c);
+        return enc_ret;
+
+    default:
+        error_setg(errp, "Unknown padding");
+        return -1;
+    }
+
+    return -1;
+}
+
+static int qcrypto_nettle_rsa_decrypt(QCryptoAkcipher *akcipher,
+                                      const void *enc, size_t enc_len,
+                                      void *data, size_t data_len,
+                                      Error **errp)
+{
+    QCryptoNettleRsa *rsa = container_of(akcipher, QCryptoNettleRsa, akcipher);
+    mpz_t c;
+    int ret;
+    if (enc_len > rsa->priv.size) {
+        error_setg(errp, "Invalid buffer size");
+        return -1;
+    }
+
+    switch (rsa->padding_algo) {
+    case QCRYPTO_RSA_PADDING_ALG_RAW:
+        ret = _rsa_dec_raw(rsa, enc, enc_len, data, data_len, errp);
+        break;
+
+    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
+        nettle_mpz_init_set_str_256_u(c, enc_len, enc);
+        if (!rsa_decrypt(&rsa->priv, &data_len, (uint8_t *)data, c)) {
+            error_setg(errp, "Failed to decrypt");
+            ret = -1;
+        } else {
+            ret = data_len;
+        }
+
+        mpz_clear(c);
+        break;
+
+    default:
+        ret = -1;
+        error_setg(errp, "Unknown padding");
+    }
+
+    return ret;
+}
+
+static int qcrypto_nettle_rsa_sign(QCryptoAkcipher *akcipher,
+                                   const void *data, size_t data_len,
+                                   void *sig, size_t sig_len, Error **errp)
+{
+    QCryptoNettleRsa *rsa = container_of(akcipher, QCryptoNettleRsa, akcipher);
+    int ret;
+    mpz_t s;
+
+    /**
+     * The RSA algorithm cannot be used for signature/verification
+     * without padding.
+     */
+    if (rsa->padding_algo == QCRYPTO_RSA_PADDING_ALG_RAW) {
+        error_setg(errp, "Try to make signature without padding");
+        return -1;
+    }
+
+    if (data_len > rsa->priv.size || sig_len != rsa->priv.size) {
+        error_setg(errp, "Invalid buffer size");
+        return -1;
+    }
+
+    mpz_init(s);
+    switch (rsa->hash_algo) {
+    case QCRYPTO_RSA_HASH_ALG_MD5:
+        ret = rsa_md5_sign_digest(&rsa->priv, data, s);
+        break;
+
+    case QCRYPTO_RSA_HASH_ALG_SHA1:
+        ret = rsa_sha1_sign_digest(&rsa->priv, data, s);
+        break;
+
+    case QCRYPTO_RSA_HASH_ALG_SHA256:
+        ret = rsa_sha256_sign_digest(&rsa->priv, data, s);
+        break;
+
+    case QCRYPTO_RSA_HASH_ALG_SHA512:
+        ret = rsa_sha512_sign_digest(&rsa->priv, data, s);
+        break;
+
+    default:
+        error_setg(errp, "Unknown hash algorithm");
+        ret = -1;
+        goto clear;
+    }
+
+    if (ret != 1) {
+        error_setg(errp, "Failed to make signature");
+        ret = -1;
+        goto clear;
+    }
+    nettle_mpz_get_str_256(sig_len, (uint8_t *)sig, s);
+    ret = sig_len;
+
+clear:
+    mpz_clear(s);
+
+    return ret;
+}
+
+static int qcrypto_nettle_rsa_verify(QCryptoAkcipher *akcipher,
+                                     const void *sig, size_t sig_len,
+                                     const void *data, size_t data_len,
+                                     Error **errp)
+{
+    QCryptoNettleRsa *rsa = container_of(akcipher, QCryptoNettleRsa, akcipher);
+
+    int ret;
+    mpz_t s;
+
+    /**
+     * The RSA algorithm cannot be used for signature/verification
+     * without padding.
+     */
+    if (rsa->padding_algo == QCRYPTO_RSA_PADDING_ALG_RAW) {
+        error_setg(errp, "Operation not supported");
+        return -1;
+    }
+    if (data_len > rsa->pub.size || sig_len < rsa->pub.size) {
+        error_setg(errp, "Invalid buffer size");
+        return -1;
+    }
+
+    nettle_mpz_init_set_str_256_u(s, sig_len, sig);
+    switch (rsa->hash_algo) {
+    case QCRYPTO_RSA_HASH_ALG_MD5:
+        ret = rsa_md5_verify_digest(&rsa->pub, data, s);
+        break;
+
+    case QCRYPTO_RSA_HASH_ALG_SHA1:
+        ret = rsa_sha1_verify_digest(&rsa->pub, data, s);
+        break;
+
+    case QCRYPTO_RSA_HASH_ALG_SHA256:
+        ret = rsa_sha256_verify_digest(&rsa->pub, data, s);
+        break;
+
+    case QCRYPTO_RSA_HASH_ALG_SHA512:
+        ret = rsa_sha512_verify_digest(&rsa->pub, data, s);
+        break;
+
+    default:
+        error_setg(errp, "Unsupported hash algorithm");
+        ret = -1;
+        goto clear;
+    }
+
+    if (ret != 1) {
+        error_setg(errp, "Failed to verify");
+        ret = -1;
+        goto clear;
+    }
+    ret = 0;
+
+clear:
+    mpz_clear(s);
+
+    return ret;
+}
+
+static int qcrypto_nettle_rsa_free(struct QCryptoAkcipher *akcipher,
+                                   Error **errp)
+{
+    qcrypto_nettle_rsa_destroy(akcipher);
+    return 0;
+}
+
+QCryptoAkcipherDriver nettle_rsa = {
+    .encrypt = qcrypto_nettle_rsa_encrypt,
+    .decrypt = qcrypto_nettle_rsa_decrypt,
+    .sign = qcrypto_nettle_rsa_sign,
+    .verify = qcrypto_nettle_rsa_verify,
+    .free = qcrypto_nettle_rsa_free,
+};
+
+static QCryptoNettleRsa *qcrypto_nettle_rsa_malloc(void)
+{
+    QCryptoNettleRsa *rsa = g_malloc0(sizeof(QCryptoNettleRsa));
+    memset(rsa, 0, sizeof(QCryptoNettleRsa));
+    rsa->akcipher.driver = &nettle_rsa;
+    rsa_public_key_init(&rsa->pub);
+    rsa_private_key_init(&rsa->priv);
+
+    return rsa;
+}
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 1e52f2fd76..b5c04e8424 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -31,6 +31,9 @@ QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
 {
     QCryptoAkcipher *akcipher = NULL;
 
+    akcipher = qcrypto_akcipher_nettle_new(alg, type, key, keylen,
+                                           para, errp);
+
     return akcipher;
 }
 
diff --git a/crypto/asn1_decoder.c b/crypto/asn1_decoder.c
new file mode 100644
index 0000000000..bfb145e84e
--- /dev/null
+++ b/crypto/asn1_decoder.c
@@ -0,0 +1,185 @@
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
+#include <stdint.h>
+#include <stddef.h>
+
+#include "crypto/asn1_decoder.h"
+
+enum ber_type_tag {
+    ber_type_tag_bool = 0x1,
+    ber_type_tag_int = 0x2,
+    ber_type_tag_bit_str = 0x3,
+    ber_type_tag_oct_str = 0x4,
+    ber_type_tag_oct_null = 0x5,
+    ber_type_tag_oct_oid = 0x6,
+    ber_type_tag_seq = 0x10,
+    ber_type_tag_set = 0x11,
+};
+
+#define BER_CONSTRUCTED_MASK 0x20
+#define BER_SHORT_LEN_MASK 0x80
+
+static uint8_t ber_peek_byte(const uint8_t **data, size_t *dlen)
+{
+    return **data;
+}
+
+static int invoke_callback(BerDecodeCb cb, void *ctx,
+                           const uint8_t *value, size_t vlen)
+{
+    if (!cb) {
+        return 0;
+    }
+
+    return cb(ctx, value, vlen);
+}
+
+static void ber_cut_nbytes(const uint8_t **data, size_t *dlen,
+                           size_t nbytes)
+{
+    *data += nbytes;
+    *dlen -= nbytes;
+}
+
+static uint8_t ber_cut_byte(const uint8_t **data, size_t *dlen)
+{
+    uint8_t val = ber_peek_byte(data, dlen);
+
+    ber_cut_nbytes(data, dlen, 1);
+
+    return val;
+}
+
+static int ber_extract_definite_data(const uint8_t **data, size_t *dlen,
+                                     BerDecodeCb cb, void *ctx)
+{
+    const uint8_t *value;
+    size_t vlen = 0;
+    uint8_t byte_count = ber_cut_byte(data, dlen);
+
+    /* short format of definite-length */
+    if (!(byte_count & BER_SHORT_LEN_MASK)) {
+        if (byte_count > *dlen) {
+            return -1;
+        }
+
+        value = *data;
+        vlen = byte_count;
+        ber_cut_nbytes(data, dlen, vlen);
+
+        return invoke_callback(cb, ctx, value, vlen);
+    }
+
+    /* Ignore highest bit */
+    byte_count &= ~BER_SHORT_LEN_MASK;
+
+    /*
+     * size_t is enough to express the length, although the ber encoding
+     * standard supports larger length.
+     */
+    if (byte_count > sizeof(size_t)) {
+        return -1;
+    }
+
+    while (byte_count--) {
+        vlen <<= 8;
+        vlen += ber_cut_byte(data, dlen);
+    }
+
+    if (vlen > *dlen) {
+        return -1;
+    }
+
+    value = *data;
+    ber_cut_nbytes(data, dlen, vlen);
+
+    return invoke_callback(cb, ctx, value, vlen);
+}
+
+static int ber_extract_undefinite_data(const uint8_t **data, size_t *dlen,
+                                       BerDecodeCb cb, void *ctx)
+{
+    size_t vlen = 0;
+    const uint8_t *value;
+
+    if (*dlen < 3) {
+        return -1;
+    }
+
+    /* skip undefinite-length-mask 0x80 */
+    ber_cut_nbytes(data, dlen, 1);
+
+    value = *data;
+    while (vlen < *dlen) {
+        if ((*data)[vlen] != 0) {
+            vlen++;
+            continue;
+        }
+
+        if (vlen + 1 < *dlen && (*data[vlen + 1] == 0)) {
+            ber_cut_nbytes(data, dlen, vlen + 2);
+            return invoke_callback(cb, ctx, value, vlen);
+        }
+
+        vlen += 2;
+    }
+
+    return -1;
+}
+
+static int ber_extract_data(const uint8_t **data, size_t *dlen,
+                            BerDecodeCb cb, void *ctx)
+{
+    uint8_t val = ber_peek_byte(data, dlen);
+
+    if (val == BER_SHORT_LEN_MASK) {
+        return ber_extract_undefinite_data(data, dlen, cb, ctx);
+    }
+
+    return ber_extract_definite_data(data, dlen, cb, ctx);
+}
+
+int ber_decode_int(const uint8_t **data, size_t *dlen,
+                   BerDecodeCb cb, void *ctx)
+{
+    uint8_t tag = ber_cut_byte(data, dlen);
+
+    /* INTEGER must encoded in primitive-form */
+    if (tag != ber_type_tag_int) {
+        return -1;
+    }
+
+    return ber_extract_data(data, dlen, cb, ctx);
+}
+
+int ber_decode_seq(const uint8_t **data, size_t *dlen,
+                   BerDecodeCb cb, void *ctx)
+{
+    uint8_t val = ber_cut_byte(data, dlen);
+
+    /* SEQUENCE must use constructed form */
+    if (val != (ber_type_tag_seq | BER_CONSTRUCTED_MASK)) {
+        return -1;
+    }
+
+    return ber_extract_data(data, dlen, cb, ctx);
+}
diff --git a/crypto/asn1_decoder.h b/crypto/asn1_decoder.h
new file mode 100644
index 0000000000..d33a7c81c4
--- /dev/null
+++ b/crypto/asn1_decoder.h
@@ -0,0 +1,42 @@
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
+#ifndef QCRYPTO_ASN1_DECODER_H
+#define QCRYPTO_ASN1_DECODER_H
+
+/*
+ *  ctx: user content.
+ *  value: the starting address of |value| part of 'Tag-Length-Value' pattern.
+ *  vlen: length of the |value|.
+ */
+typedef int (*BerDecodeCb) (void *ctx, const uint8_t *value, size_t vlen);
+
+int ber_decode_int(const uint8_t **data,
+                   size_t *dlen,
+                   BerDecodeCb cb,
+                   void *ctx);
+
+int ber_decode_seq(const uint8_t **data,
+                   size_t *dlen,
+                   BerDecodeCb cb,
+                   void *ctx);
+
+#endif  /* QCRYPTO_ASN1_DECODER_H */
diff --git a/crypto/meson.build b/crypto/meson.build
index c32b57aeda..f398d7abda 100644
--- a/crypto/meson.build
+++ b/crypto/meson.build
@@ -27,6 +27,9 @@ if nettle.found()
   if xts == 'private'
     crypto_ss.add(files('xts.c'))
   endif
+  if hogweed.found()
+    crypto_ss.add(gmp, hogweed, files('akcipher-nettle.c', 'asn1_decoder.c'))
+  endif
 elif gcrypt.found()
   crypto_ss.add(gcrypt, files('hash-gcrypt.c', 'hmac-gcrypt.c', 'pbkdf-gcrypt.c'))
 elif gnutls_crypto.found()
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 03cc3bf46b..2ec7f0f8d7 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -135,5 +135,21 @@ int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,
 
 int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp);
 
+#ifdef CONFIG_HOGWEED
+QCryptoAkcipher *qcrypto_akcipher_nettle_new(QCryptoAkcipherAlgorithm alg,
+                                             QCryptoAkcipherKeyType type,
+                                             const uint8_t *key, size_t keylen,
+                                             void *para, Error **errp);
+#else
+static inline QCryptoAkcipher *qcrypto_akcipher_nettle_new(
+                                             QCryptoAkcipherAlgorithm alg,
+                                             QCryptoAkcipherKeyType type,
+                                             const uint8_t *key, size_t keylen,
+                                             void *para, Error **errp)
+{
+    error_setg(errp, "qcrypto akcipher has no nettle/hogweed support");
+    return NULL;
+}
+#endif
 
 #endif /* QCRYPTO_AKCIPHER_H */
diff --git a/meson.build b/meson.build
index 282e7c4650..ea6b8feb3c 100644
--- a/meson.build
+++ b/meson.build
@@ -1049,6 +1049,7 @@ endif
 # gcrypt over nettle for performance reasons.
 gcrypt = not_found
 nettle = not_found
+hogweed = not_found
 xts = 'none'
 
 if get_option('nettle').enabled() and get_option('gcrypt').enabled()
@@ -1086,6 +1087,14 @@ if not gnutls_crypto.found()
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
 gtk = not_found
 gtkx11 = not_found
 vte = not_found
@@ -1567,6 +1576,7 @@ config_host_data.set('CONFIG_GNUTLS', gnutls.found())
 config_host_data.set('CONFIG_GNUTLS_CRYPTO', gnutls_crypto.found())
 config_host_data.set('CONFIG_GCRYPT', gcrypt.found())
 config_host_data.set('CONFIG_NETTLE', nettle.found())
+config_host_data.set('CONFIG_HOGWEED', hogweed.found())
 config_host_data.set('CONFIG_QEMU_PRIVATE_XTS', xts == 'private')
 config_host_data.set('CONFIG_MALLOC_TRIM', has_malloc_trim)
 config_host_data.set('CONFIG_STATX', has_statx)
@@ -3614,6 +3624,7 @@ summary_info += {'libgcrypt':         gcrypt}
 summary_info += {'nettle':            nettle}
 if nettle.found()
    summary_info += {'  XTS':             xts != 'private'}
+   summary_info += {'  hogweed':         hogweed.found()}
 endif
 summary_info += {'AF_ALG support':    have_afalg}
 summary_info += {'rng-none':          get_option('rng_none')}
-- 
2.25.1

