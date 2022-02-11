Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C76C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 08:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348100AbiBKIpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:45:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243970AbiBKIpS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 03:45:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE4BE6B
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:45:15 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p6so3927086plf.10
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DC9N+cges7kKMJu3ppnlwZw3bOvBosSHYog6A3uieg0=;
        b=tSS6ti9B7d7mRPP2fe06Vgt3XIILz6J8+OuO+1TzYK14WKpjLMJQSU6V0sYEsCLnoB
         EZB+eLib6qofpGSQWBJLbXsXSS61mtP+vaCoxURqdDw+ACkyu9DLMV/tIgvYUQnVP3r0
         9IO5S28b0nbqFZGzlh7xKn93d6bHHopbyiywDFMa02bwvKaLsL3lXBtzNURmVXrdUgxp
         vq/ZIvzbvyugNM8Wafh+NcfnFkVIus/utotUUgfWnvIUwKz42kyI+YPmLolBnpW8rDY8
         n6gXa0ueF9HXYtXQVUlaMOGJv6MVGjKoG54QBEZtjFnXIuYlja+X29hmQSqOy3TA2tHc
         MR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DC9N+cges7kKMJu3ppnlwZw3bOvBosSHYog6A3uieg0=;
        b=IqfufNmfzLmCmSLmvjgqvZevrzUqdytsm13RgySm5ycFjFqn3b/z9QocawTDrOnjpe
         n/ppGsVv/kQwWd/XSt6rHOLPq8RZlJBGjU7Ik1Nd/mup1bYmJ/IL22T9NEBF0zGNy+FE
         sCyaAj/B8v7WFnNwZ6CLvbNj0BfHSn9ZvJSGLGXuMLN79i32w5a7fDO2XaiARR3qjCd5
         a26fkyQrvS2zg97WHd4TLPTBQiDGN1gDOnxkPJkpx3KaZZlNq7FHkUimcEY/7AfW7lvS
         BzQ7fz9S/R5oXjpQ+AVZmxSbiGlGWQLWx3HCkft60AvO3cR1An3zlqIEtPUHNQneziEk
         QOfA==
X-Gm-Message-State: AOAM531k5CmB35OPrJsOjvL/lI1vXup4SMgDYZCVIdIfOh/A2vf68zJe
        B+hF7roy67bzrreRPCPH2kED8g==
X-Google-Smtp-Source: ABdhPJxr0VaWXY3rkSpuc2nEhPvPeduwv0IdTKj3bhWMZYv9r4WuDF9XPAQesAAuKh4GhUt8urpYVA==
X-Received: by 2002:a17:903:11c3:: with SMTP id q3mr461966plh.15.1644569115164;
        Fri, 11 Feb 2022 00:45:15 -0800 (PST)
Received: from libai.bytedance.net ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id u7sm3832686pgc.93.2022.02.11.00.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 00:45:14 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        helei.sig11@bytedance.com, herbert@gondor.apana.org.au,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 2/3] virtio_crypto: Support virtio crypto asym operation
Date:   Fri, 11 Feb 2022 16:43:34 +0800
Message-Id: <20220211084335.1254281-3-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220211084335.1254281-1-pizhenwei@bytedance.com>
References: <20220211084335.1254281-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Several changes in this patch:
 - Add support for virtio crypto asymmetric handling, include:
     create/close session
     encrypt/decrypt/sign/verify guest data

 - Modify crypto backend to compat sym&asym operation.

 - Introduce akcipher class without any implementation.

Then QEMU can provide asymmetric support for guest, but the asymmetric
request from guest shoule always fail until an available asymmetric
backend gets supported.

Co-developed-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 backends/cryptodev-builtin.c      | 201 ++++++++++++++----
 backends/cryptodev-vhost-user.c   |  34 +++-
 backends/cryptodev.c              |  32 ++-
 crypto/akcipher.c                 |  78 +++++++
 crypto/meson.build                |   1 +
 hw/virtio/virtio-crypto.c         | 328 ++++++++++++++++++++++++------
 include/crypto/akcipher.h         |  77 +++++++
 include/hw/virtio/virtio-crypto.h |   5 +-
 include/sysemu/cryptodev.h        |  88 ++++++--
 9 files changed, 697 insertions(+), 147 deletions(-)
 create mode 100644 crypto/akcipher.c
 create mode 100644 include/crypto/akcipher.h

diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 0671bf9f3e..b3344d230c 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -26,9 +26,9 @@
 #include "qapi/error.h"
 #include "standard-headers/linux/virtio_crypto.h"
 #include "crypto/cipher.h"
+#include "crypto/akcipher.h"
 #include "qom/object.h"
 
-
 /**
  * @TYPE_CRYPTODEV_BACKEND_BUILTIN:
  * name of backend that uses QEMU cipher API
@@ -37,15 +37,15 @@
 
 OBJECT_DECLARE_SIMPLE_TYPE(CryptoDevBackendBuiltin, CRYPTODEV_BACKEND_BUILTIN)
 
-
 typedef struct CryptoDevBackendBuiltinSession {
     QCryptoCipher *cipher;
     uint8_t direction; /* encryption or decryption */
-    uint8_t type; /* cipher? hash? aead? */
+    uint8_t type; /* cipher? hash? aead? akcipher? */
+    QCryptoAkcipher *akcipher;
     QTAILQ_ENTRY(CryptoDevBackendBuiltinSession) next;
 } CryptoDevBackendBuiltinSession;
 
-/* Max number of symmetric sessions */
+/* Max number of symmetric/asymmetric sessions */
 #define MAX_NUM_SESSIONS 256
 
 #define CRYPTODEV_BUITLIN_MAX_AUTH_KEY_LEN    512
@@ -80,15 +80,17 @@ static void cryptodev_builtin_init(
     backend->conf.crypto_services =
                          1u << VIRTIO_CRYPTO_SERVICE_CIPHER |
                          1u << VIRTIO_CRYPTO_SERVICE_HASH |
-                         1u << VIRTIO_CRYPTO_SERVICE_MAC;
+                         1u << VIRTIO_CRYPTO_SERVICE_MAC |
+                         1u << VIRTIO_CRYPTO_SERVICE_AKCIPHER;
     backend->conf.cipher_algo_l = 1u << VIRTIO_CRYPTO_CIPHER_AES_CBC;
     backend->conf.hash_algo = 1u << VIRTIO_CRYPTO_HASH_SHA1;
+    backend->conf.akcipher_algo = 1u << VIRTIO_CRYPTO_AKCIPHER_RSA;
     /*
      * Set the Maximum length of crypto request.
      * Why this value? Just avoid to overflow when
      * memory allocation for each crypto request.
      */
-    backend->conf.max_size = LONG_MAX - sizeof(CryptoDevBackendSymOpInfo);
+    backend->conf.max_size = LONG_MAX - sizeof(CryptoDevBackendOpInfo);
     backend->conf.max_cipher_key_len = CRYPTODEV_BUITLIN_MAX_CIPHER_KEY_LEN;
     backend->conf.max_auth_key_len = CRYPTODEV_BUITLIN_MAX_AUTH_KEY_LEN;
 
@@ -167,7 +169,7 @@ static int cryptodev_builtin_create_cipher_session(
     index = cryptodev_builtin_get_unused_session_index(builtin);
     if (index < 0) {
         error_setg(errp, "Total number of sessions created exceeds %u",
-                  MAX_NUM_SESSIONS);
+                   MAX_NUM_SESSIONS);
         return -1;
     }
 
@@ -240,26 +242,82 @@ static int cryptodev_builtin_create_cipher_session(
     return index;
 }
 
-static int64_t cryptodev_builtin_sym_create_session(
+static int cryptodev_builtin_create_akcipher_session(
+                    CryptoDevBackendBuiltin *builtin,
+                    CryptoDevBackendAsymSessionInfo *sess_info,
+                    Error **errp)
+{
+    CryptoDevBackendBuiltinSession *sess;
+    QCryptoAkcipher *akcipher;
+    int index;
+    bool private;
+
+    switch (sess_info->algo) {
+    case VIRTIO_CRYPTO_AKCIPHER_RSA:
+        break;
+
+    default:
+        error_setg(errp, "Unsupported akcipher alg %u", sess_info->algo);
+        return -1;
+    }
+
+    switch (sess_info->keytype) {
+    case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+        private = false;
+        break;
+
+    case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+        private = true;
+        break;
+
+    default:
+        error_setg(errp, "Unsupported akcipher keytype %u", sess_info->keytype);
+        return -1;
+    }
+
+    index = cryptodev_builtin_get_unused_session_index(builtin);
+    if (index < 0) {
+        error_setg(errp, "Total number of sessions created exceeds %u",
+                   MAX_NUM_SESSIONS);
+        return -1;
+    }
+
+    akcipher = qcrypto_akcipher_new(sess_info->algo, private, sess_info->key,
+                                    sess_info->keylen, (void *)&sess_info->u,
+                                    index, errp);
+    if (!akcipher) {
+        return -1;
+    }
+
+    sess = g_new0(CryptoDevBackendBuiltinSession, 1);
+    sess->akcipher = akcipher;
+
+    builtin->sessions[index] = sess;
+
+    return index;
+}
+
+static int64_t cryptodev_builtin_create_session(
            CryptoDevBackend *backend,
-           CryptoDevBackendSymSessionInfo *sess_info,
+           CryptoDevBackendSessionInfo *sess_info,
            uint32_t queue_index, Error **errp)
 {
     CryptoDevBackendBuiltin *builtin =
                       CRYPTODEV_BACKEND_BUILTIN(backend);
-    int64_t session_id = -1;
-    int ret;
+    CryptoDevBackendSymSessionInfo *sym_sess_info;
+    CryptoDevBackendAsymSessionInfo *asym_sess_info;
 
     switch (sess_info->op_code) {
     case VIRTIO_CRYPTO_CIPHER_CREATE_SESSION:
-        ret = cryptodev_builtin_create_cipher_session(
-                           builtin, sess_info, errp);
-        if (ret < 0) {
-            return ret;
-        } else {
-            session_id = ret;
-        }
-        break;
+        sym_sess_info = &sess_info->u.sym_sess_info;
+        return cryptodev_builtin_create_cipher_session(
+                           builtin, sym_sess_info, errp);
+
+    case VIRTIO_CRYPTO_AKCIPHER_CREATE_SESSION:
+        asym_sess_info = &sess_info->u.asym_sess_info;
+        return cryptodev_builtin_create_akcipher_session(
+                           builtin, asym_sess_info, errp);
+
     case VIRTIO_CRYPTO_HASH_CREATE_SESSION:
     case VIRTIO_CRYPTO_MAC_CREATE_SESSION:
     default:
@@ -268,10 +326,10 @@ static int64_t cryptodev_builtin_sym_create_session(
         return -1;
     }
 
-    return session_id;
+    return -1;
 }
 
-static int cryptodev_builtin_sym_close_session(
+static int cryptodev_builtin_close_session(
            CryptoDevBackend *backend,
            uint64_t session_id,
            uint32_t queue_index, Error **errp)
@@ -288,30 +346,17 @@ static int cryptodev_builtin_sym_close_session(
 }
 
 static int cryptodev_builtin_sym_operation(
-                 CryptoDevBackend *backend,
-                 CryptoDevBackendSymOpInfo *op_info,
-                 uint32_t queue_index, Error **errp)
+                 CryptoDevBackendBuiltinSession *sess,
+                 CryptoDevBackendSymOpInfo *op_info, Error **errp)
 {
-    CryptoDevBackendBuiltin *builtin =
-                      CRYPTODEV_BACKEND_BUILTIN(backend);
-    CryptoDevBackendBuiltinSession *sess;
     int ret;
 
-    if (op_info->session_id >= MAX_NUM_SESSIONS ||
-              builtin->sessions[op_info->session_id] == NULL) {
-        error_setg(errp, "Cannot find a valid session id: %" PRIu64 "",
-                   op_info->session_id);
-        return -VIRTIO_CRYPTO_INVSESS;
-    }
-
     if (op_info->op_type == VIRTIO_CRYPTO_SYM_OP_ALGORITHM_CHAINING) {
         error_setg(errp,
                "Algorithm chain is unsupported for cryptdoev-builtin");
         return -VIRTIO_CRYPTO_NOTSUPP;
     }
 
-    sess = builtin->sessions[op_info->session_id];
-
     if (op_info->iv_len > 0) {
         ret = qcrypto_cipher_setiv(sess->cipher, op_info->iv,
                                    op_info->iv_len, errp);
@@ -333,9 +378,85 @@ static int cryptodev_builtin_sym_operation(
             return -VIRTIO_CRYPTO_ERR;
         }
     }
+
     return VIRTIO_CRYPTO_OK;
 }
 
+static int cryptodev_builtin_asym_operation(
+                 CryptoDevBackendBuiltinSession *sess, uint32_t op_code,
+                 CryptoDevBackendAsymOpInfo *op_info, Error **errp)
+{
+    int ret;
+
+    switch (op_code) {
+    case VIRTIO_CRYPTO_AKCIPHER_ENCRYPT:
+        ret = qcrypto_akcipher_encrypt(sess->akcipher,
+                                       op_info->src, op_info->src_len,
+                                       op_info->dst, op_info->dst_len, errp);
+        break;
+
+    case VIRTIO_CRYPTO_AKCIPHER_DECRYPT:
+        ret = qcrypto_akcipher_decrypt(sess->akcipher,
+                                       op_info->src, op_info->src_len,
+                                       op_info->dst, op_info->dst_len, errp);
+        break;
+
+    case VIRTIO_CRYPTO_AKCIPHER_SIGN:
+        ret = qcrypto_akcipher_sign(sess->akcipher,
+                                    op_info->src, op_info->src_len,
+                                    op_info->dst, op_info->dst_len, errp);
+        break;
+
+    case VIRTIO_CRYPTO_AKCIPHER_VERIFY:
+    ret = qcrypto_akcipher_verify(sess->akcipher,
+                      op_info->src, op_info->src_len,
+                      op_info->dst, op_info->dst_len, errp);
+    break;
+
+    default:
+        return -VIRTIO_CRYPTO_ERR;
+    }
+
+    if (ret) {
+        return ret;
+    }
+
+    return VIRTIO_CRYPTO_OK;
+}
+
+static int cryptodev_builtin_operation(
+                 CryptoDevBackend *backend,
+                 CryptoDevBackendOpInfo *op_info,
+                 uint32_t queue_index, Error **errp)
+{
+    CryptoDevBackendBuiltin *builtin =
+                      CRYPTODEV_BACKEND_BUILTIN(backend);
+    CryptoDevBackendBuiltinSession *sess;
+    CryptoDevBackendSymOpInfo *sym_op_info;
+    CryptoDevBackendAsymOpInfo *asym_op_info;
+    enum CryptoDevBackendAlgType algtype = op_info->algtype;
+    int ret = -VIRTIO_CRYPTO_ERR;
+
+    if (op_info->session_id >= MAX_NUM_SESSIONS ||
+              builtin->sessions[op_info->session_id] == NULL) {
+        error_setg(errp, "Cannot find a valid session id: %" PRIu64 "",
+                   op_info->session_id);
+        return -VIRTIO_CRYPTO_INVSESS;
+    }
+
+    sess = builtin->sessions[op_info->session_id];
+    if (algtype == CRYPTODEV_BACKEND_ALG_SYM) {
+        sym_op_info = op_info->u.sym_op_info;
+        ret = cryptodev_builtin_sym_operation(sess, sym_op_info, errp);
+    } else if (algtype == CRYPTODEV_BACKEND_ALG_ASYM) {
+        asym_op_info = op_info->u.asym_op_info;
+        ret = cryptodev_builtin_asym_operation(sess, op_info->op_code,
+                                               asym_op_info, errp);
+    }
+
+    return ret;
+}
+
 static void cryptodev_builtin_cleanup(
              CryptoDevBackend *backend,
              Error **errp)
@@ -348,7 +469,7 @@ static void cryptodev_builtin_cleanup(
 
     for (i = 0; i < MAX_NUM_SESSIONS; i++) {
         if (builtin->sessions[i] != NULL) {
-            cryptodev_builtin_sym_close_session(backend, i, 0, &error_abort);
+            cryptodev_builtin_close_session(backend, i, 0, &error_abort);
         }
     }
 
@@ -370,9 +491,9 @@ cryptodev_builtin_class_init(ObjectClass *oc, void *data)
 
     bc->init = cryptodev_builtin_init;
     bc->cleanup = cryptodev_builtin_cleanup;
-    bc->create_session = cryptodev_builtin_sym_create_session;
-    bc->close_session = cryptodev_builtin_sym_close_session;
-    bc->do_sym_op = cryptodev_builtin_sym_operation;
+    bc->create_session = cryptodev_builtin_create_session;
+    bc->close_session = cryptodev_builtin_close_session;
+    bc->do_op = cryptodev_builtin_operation;
 }
 
 static const TypeInfo cryptodev_builtin_info = {
diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
index bedb452474..5443a59153 100644
--- a/backends/cryptodev-vhost-user.c
+++ b/backends/cryptodev-vhost-user.c
@@ -259,7 +259,33 @@ static int64_t cryptodev_vhost_user_sym_create_session(
     return -1;
 }
 
-static int cryptodev_vhost_user_sym_close_session(
+static int64_t cryptodev_vhost_user_create_session(
+           CryptoDevBackend *backend,
+           CryptoDevBackendSessionInfo *sess_info,
+           uint32_t queue_index, Error **errp)
+{
+    uint32_t op_code = sess_info->op_code;
+    CryptoDevBackendSymSessionInfo *sym_sess_info;
+
+    switch (op_code) {
+    case VIRTIO_CRYPTO_CIPHER_CREATE_SESSION:
+    case VIRTIO_CRYPTO_HASH_CREATE_SESSION:
+    case VIRTIO_CRYPTO_MAC_CREATE_SESSION:
+    case VIRTIO_CRYPTO_AEAD_CREATE_SESSION:
+        sym_sess_info = &sess_info->u.sym_sess_info;
+        return cryptodev_vhost_user_sym_create_session(backend, sym_sess_info,
+                   queue_index, errp);
+    default:
+        error_setg(errp, "Unsupported opcode :%" PRIu32 "",
+                   sess_info->op_code);
+        return -1;
+
+    }
+
+    return -1;
+}
+
+static int cryptodev_vhost_user_close_session(
            CryptoDevBackend *backend,
            uint64_t session_id,
            uint32_t queue_index, Error **errp)
@@ -351,9 +377,9 @@ cryptodev_vhost_user_class_init(ObjectClass *oc, void *data)
 
     bc->init = cryptodev_vhost_user_init;
     bc->cleanup = cryptodev_vhost_user_cleanup;
-    bc->create_session = cryptodev_vhost_user_sym_create_session;
-    bc->close_session = cryptodev_vhost_user_sym_close_session;
-    bc->do_sym_op = NULL;
+    bc->create_session = cryptodev_vhost_user_create_session;
+    bc->close_session = cryptodev_vhost_user_close_session;
+    bc->do_op = NULL;
 
     object_class_property_add_str(oc, "chardev",
                                   cryptodev_vhost_user_get_chardev,
diff --git a/backends/cryptodev.c b/backends/cryptodev.c
index bf52476166..f3d6e338c5 100644
--- a/backends/cryptodev.c
+++ b/backends/cryptodev.c
@@ -72,9 +72,9 @@ void cryptodev_backend_cleanup(
     }
 }
 
-int64_t cryptodev_backend_sym_create_session(
+int64_t cryptodev_backend_create_session(
            CryptoDevBackend *backend,
-           CryptoDevBackendSymSessionInfo *sess_info,
+           CryptoDevBackendSessionInfo *sess_info,
            uint32_t queue_index, Error **errp)
 {
     CryptoDevBackendClass *bc =
@@ -87,7 +87,7 @@ int64_t cryptodev_backend_sym_create_session(
     return -1;
 }
 
-int cryptodev_backend_sym_close_session(
+int cryptodev_backend_close_session(
            CryptoDevBackend *backend,
            uint64_t session_id,
            uint32_t queue_index, Error **errp)
@@ -102,16 +102,16 @@ int cryptodev_backend_sym_close_session(
     return -1;
 }
 
-static int cryptodev_backend_sym_operation(
+static int cryptodev_backend_operation(
                  CryptoDevBackend *backend,
-                 CryptoDevBackendSymOpInfo *op_info,
+                 CryptoDevBackendOpInfo *op_info,
                  uint32_t queue_index, Error **errp)
 {
     CryptoDevBackendClass *bc =
                       CRYPTODEV_BACKEND_GET_CLASS(backend);
 
-    if (bc->do_sym_op) {
-        return bc->do_sym_op(backend, op_info, queue_index, errp);
+    if (bc->do_op) {
+        return bc->do_op(backend, op_info, queue_index, errp);
     }
 
     return -VIRTIO_CRYPTO_ERR;
@@ -123,20 +123,18 @@ int cryptodev_backend_crypto_operation(
                  uint32_t queue_index, Error **errp)
 {
     VirtIOCryptoReq *req = opaque;
+    CryptoDevBackendOpInfo *op_info = &req->op_info;
+    enum CryptoDevBackendAlgType algtype = req->flags;
 
-    if (req->flags == CRYPTODEV_BACKEND_ALG_SYM) {
-        CryptoDevBackendSymOpInfo *op_info;
-        op_info = req->u.sym_op_info;
-
-        return cryptodev_backend_sym_operation(backend,
-                         op_info, queue_index, errp);
-    } else {
+    if ((algtype != CRYPTODEV_BACKEND_ALG_SYM)
+        && (algtype != CRYPTODEV_BACKEND_ALG_ASYM)) {
         error_setg(errp, "Unsupported cryptodev alg type: %" PRIu32 "",
-                   req->flags);
-       return -VIRTIO_CRYPTO_NOTSUPP;
+                   algtype);
+
+        return -VIRTIO_CRYPTO_NOTSUPP;
     }
 
-    return -VIRTIO_CRYPTO_ERR;
+    return cryptodev_backend_operation(backend, op_info, queue_index, errp);
 }
 
 static void
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
new file mode 100644
index 0000000000..ac8d1c9bf1
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
+QCryptoAkcipher *qcrypto_akcipher_new(uint32_t alg, bool private,
+                                      const uint8_t *key, size_t keylen,
+                                      void *para,
+                                      int index, Error **errp)
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
index 95a6a83504..72b36f450a 100644
--- a/crypto/meson.build
+++ b/crypto/meson.build
@@ -19,6 +19,7 @@ crypto_ss.add(files(
   'tlscredspsk.c',
   'tlscredsx509.c',
   'tlssession.c',
+  'akcipher.c',
 ))
 
 if nettle.found()
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 54f9bbb789..3bb79a100b 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -83,7 +83,8 @@ virtio_crypto_create_sym_session(VirtIOCrypto *vcrypto,
                struct iovec *iov, unsigned int out_num)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(vcrypto);
-    CryptoDevBackendSymSessionInfo info;
+    CryptoDevBackendSessionInfo info;
+    CryptoDevBackendSymSessionInfo *sym_info;
     int64_t session_id;
     int queue_index;
     uint32_t op_type;
@@ -92,11 +93,13 @@ virtio_crypto_create_sym_session(VirtIOCrypto *vcrypto,
 
     memset(&info, 0, sizeof(info));
     op_type = ldl_le_p(&sess_req->op_type);
-    info.op_type = op_type;
     info.op_code = opcode;
 
+    sym_info = &info.u.sym_sess_info;
+    sym_info->op_type = op_type;
+
     if (op_type == VIRTIO_CRYPTO_SYM_OP_CIPHER) {
-        ret = virtio_crypto_cipher_session_helper(vdev, &info,
+        ret = virtio_crypto_cipher_session_helper(vdev, sym_info,
                            &sess_req->u.cipher.para,
                            &iov, &out_num);
         if (ret < 0) {
@@ -105,47 +108,47 @@ virtio_crypto_create_sym_session(VirtIOCrypto *vcrypto,
     } else if (op_type == VIRTIO_CRYPTO_SYM_OP_ALGORITHM_CHAINING) {
         size_t s;
         /* cipher part */
-        ret = virtio_crypto_cipher_session_helper(vdev, &info,
+        ret = virtio_crypto_cipher_session_helper(vdev, sym_info,
                            &sess_req->u.chain.para.cipher_param,
                            &iov, &out_num);
         if (ret < 0) {
             goto err;
         }
         /* hash part */
-        info.alg_chain_order = ldl_le_p(
+        sym_info->alg_chain_order = ldl_le_p(
                                      &sess_req->u.chain.para.alg_chain_order);
-        info.add_len = ldl_le_p(&sess_req->u.chain.para.aad_len);
-        info.hash_mode = ldl_le_p(&sess_req->u.chain.para.hash_mode);
-        if (info.hash_mode == VIRTIO_CRYPTO_SYM_HASH_MODE_AUTH) {
-            info.hash_alg = ldl_le_p(&sess_req->u.chain.para.u.mac_param.algo);
-            info.auth_key_len = ldl_le_p(
+        sym_info->add_len = ldl_le_p(&sess_req->u.chain.para.aad_len);
+        sym_info->hash_mode = ldl_le_p(&sess_req->u.chain.para.hash_mode);
+        if (sym_info->hash_mode == VIRTIO_CRYPTO_SYM_HASH_MODE_AUTH) {
+            sym_info->hash_alg =
+                ldl_le_p(&sess_req->u.chain.para.u.mac_param.algo);
+            sym_info->auth_key_len = ldl_le_p(
                              &sess_req->u.chain.para.u.mac_param.auth_key_len);
-            info.hash_result_len = ldl_le_p(
+            sym_info->hash_result_len = ldl_le_p(
                            &sess_req->u.chain.para.u.mac_param.hash_result_len);
-            if (info.auth_key_len > vcrypto->conf.max_auth_key_len) {
+            if (sym_info->auth_key_len > vcrypto->conf.max_auth_key_len) {
                 error_report("virtio-crypto length of auth key is too big: %u",
-                             info.auth_key_len);
+                             sym_info->auth_key_len);
                 ret = -VIRTIO_CRYPTO_ERR;
                 goto err;
             }
             /* get auth key */
-            if (info.auth_key_len > 0) {
-                DPRINTF("auth_keylen=%" PRIu32 "\n", info.auth_key_len);
-                info.auth_key = g_malloc(info.auth_key_len);
-                s = iov_to_buf(iov, out_num, 0, info.auth_key,
-                               info.auth_key_len);
-                if (unlikely(s != info.auth_key_len)) {
+            if (sym_info->auth_key_len > 0) {
+                sym_info->auth_key = g_malloc(sym_info->auth_key_len);
+                s = iov_to_buf(iov, out_num, 0, sym_info->auth_key,
+                               sym_info->auth_key_len);
+                if (unlikely(s != sym_info->auth_key_len)) {
                     virtio_error(vdev,
                           "virtio-crypto authenticated key incorrect");
                     ret = -EFAULT;
                     goto err;
                 }
-                iov_discard_front(&iov, &out_num, info.auth_key_len);
+                iov_discard_front(&iov, &out_num, sym_info->auth_key_len);
             }
-        } else if (info.hash_mode == VIRTIO_CRYPTO_SYM_HASH_MODE_PLAIN) {
-            info.hash_alg = ldl_le_p(
+        } else if (sym_info->hash_mode == VIRTIO_CRYPTO_SYM_HASH_MODE_PLAIN) {
+            sym_info->hash_alg = ldl_le_p(
                              &sess_req->u.chain.para.u.hash_param.algo);
-            info.hash_result_len = ldl_le_p(
+            sym_info->hash_result_len = ldl_le_p(
                         &sess_req->u.chain.para.u.hash_param.hash_result_len);
         } else {
             /* VIRTIO_CRYPTO_SYM_HASH_MODE_NESTED */
@@ -161,13 +164,10 @@ virtio_crypto_create_sym_session(VirtIOCrypto *vcrypto,
     }
 
     queue_index = virtio_crypto_vq2q(queue_id);
-    session_id = cryptodev_backend_sym_create_session(
+    session_id = cryptodev_backend_create_session(
                                      vcrypto->cryptodev,
                                      &info, queue_index, &local_err);
     if (session_id >= 0) {
-        DPRINTF("create session_id=%" PRIu64 " successfully\n",
-                session_id);
-
         ret = session_id;
     } else {
         if (local_err) {
@@ -177,11 +177,82 @@ virtio_crypto_create_sym_session(VirtIOCrypto *vcrypto,
     }
 
 err:
-    g_free(info.cipher_key);
-    g_free(info.auth_key);
+    g_free(sym_info->cipher_key);
+    g_free(sym_info->auth_key);
     return ret;
 }
 
+static int64_t
+virtio_crypto_create_asym_session(VirtIOCrypto *vcrypto,
+               struct virtio_crypto_akcipher_create_session_req *sess_req,
+               uint32_t queue_id, uint32_t opcode,
+               struct iovec *iov, unsigned int out_num)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(vcrypto);
+    CryptoDevBackendSessionInfo info = {0};
+    CryptoDevBackendAsymSessionInfo *asym_info;
+    int64_t session_id;
+    int queue_index;
+    uint32_t algo, keytype, keylen;
+    uint8_t *key = NULL;
+    Error *local_err = NULL;
+
+    algo = ldl_le_p(&sess_req->para.algo);
+    keytype = ldl_le_p(&sess_req->para.keytype);
+    keylen = ldl_le_p(&sess_req->para.keylen);
+
+    if ((keytype != VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC)
+         && (keytype != VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE)) {
+        error_report("unsupported asym keytype: %d", keytype);
+        return -VIRTIO_CRYPTO_NOTSUPP;
+    }
+
+    if (keylen) {
+        key = g_malloc(keylen);
+        if (iov_to_buf(iov, out_num, 0, key, keylen) != keylen) {
+            virtio_error(vdev, "virtio-crypto asym key incorrect");
+            g_free(key);
+            return -EFAULT;
+        }
+        iov_discard_front(&iov, &out_num, keylen);
+    }
+
+    info.op_code = opcode;
+    asym_info = &info.u.asym_sess_info;
+    asym_info->algo = algo;
+    asym_info->keytype = keytype;
+    asym_info->keylen = keylen;
+    asym_info->key = key;
+    switch (asym_info->algo) {
+    case VIRTIO_CRYPTO_AKCIPHER_RSA:
+        asym_info->u.rsa.padding_algo =
+            ldl_le_p(&sess_req->para.u.rsa.padding_algo);
+        asym_info->u.rsa.hash_algo =
+            ldl_le_p(&sess_req->para.u.rsa.hash_algo);
+        break;
+
+    case VIRTIO_CRYPTO_AKCIPHER_ECDSA:
+        asym_info->u.ecdsa.curve_id =
+            ldl_le_p(&sess_req->para.u.ecdsa.curve_id);
+        break;
+
+    default:
+        return -VIRTIO_CRYPTO_ERR;
+    }
+
+    queue_index = virtio_crypto_vq2q(queue_id);
+    session_id = cryptodev_backend_create_session(vcrypto->cryptodev, &info,
+                     queue_index, &local_err);
+    if (session_id < 0) {
+        if (local_err) {
+            error_report_err(local_err);
+        }
+        return -VIRTIO_CRYPTO_ERR;
+    }
+
+    return session_id;
+}
+
 static uint8_t
 virtio_crypto_handle_close_session(VirtIOCrypto *vcrypto,
          struct virtio_crypto_destroy_session_req *close_sess_req,
@@ -193,9 +264,8 @@ virtio_crypto_handle_close_session(VirtIOCrypto *vcrypto,
     Error *local_err = NULL;
 
     session_id = ldq_le_p(&close_sess_req->session_id);
-    DPRINTF("close session, id=%" PRIu64 "\n", session_id);
 
-    ret = cryptodev_backend_sym_close_session(
+    ret = cryptodev_backend_close_session(
               vcrypto->cryptodev, session_id, queue_id, &local_err);
     if (ret == 0) {
         status = VIRTIO_CRYPTO_OK;
@@ -260,13 +330,22 @@ static void virtio_crypto_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
         opcode = ldl_le_p(&ctrl.header.opcode);
         queue_id = ldl_le_p(&ctrl.header.queue_id);
 
+        memset(&input, 0, sizeof(input));
         switch (opcode) {
         case VIRTIO_CRYPTO_CIPHER_CREATE_SESSION:
-            memset(&input, 0, sizeof(input));
             session_id = virtio_crypto_create_sym_session(vcrypto,
                              &ctrl.u.sym_create_session,
                              queue_id, opcode,
                              out_iov, out_num);
+            goto check_session;
+
+        case VIRTIO_CRYPTO_AKCIPHER_CREATE_SESSION:
+            session_id = virtio_crypto_create_asym_session(vcrypto,
+                             &ctrl.u.akcipher_create_session,
+                             queue_id, opcode,
+                             out_iov, out_num);
+
+check_session:
             /* Serious errors, need to reset virtio crypto device */
             if (session_id == -EFAULT) {
                 virtqueue_detach_element(vq, elem, 0);
@@ -290,10 +369,12 @@ static void virtio_crypto_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
             virtqueue_push(vq, elem, sizeof(input));
             virtio_notify(vdev, vq);
             break;
+
         case VIRTIO_CRYPTO_CIPHER_DESTROY_SESSION:
         case VIRTIO_CRYPTO_HASH_DESTROY_SESSION:
         case VIRTIO_CRYPTO_MAC_DESTROY_SESSION:
         case VIRTIO_CRYPTO_AEAD_DESTROY_SESSION:
+        case VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION:
             status = virtio_crypto_handle_close_session(vcrypto,
                    &ctrl.u.destroy_session, queue_id);
             /* The status only occupy one byte, we can directly use it */
@@ -311,7 +392,6 @@ static void virtio_crypto_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
         case VIRTIO_CRYPTO_AEAD_CREATE_SESSION:
         default:
             error_report("virtio-crypto unsupported ctrl opcode: %d", opcode);
-            memset(&input, 0, sizeof(input));
             stl_le_p(&input.status, VIRTIO_CRYPTO_NOTSUPP);
             s = iov_from_buf(in_iov, in_num, 0, &input, sizeof(input));
             if (unlikely(s != sizeof(input))) {
@@ -339,28 +419,37 @@ static void virtio_crypto_init_request(VirtIOCrypto *vcrypto, VirtQueue *vq,
     req->in_num = 0;
     req->in_len = 0;
     req->flags = CRYPTODEV_BACKEND_ALG__MAX;
-    req->u.sym_op_info = NULL;
+    memset(&req->op_info, 0x00, sizeof(req->op_info));
 }
 
 static void virtio_crypto_free_request(VirtIOCryptoReq *req)
 {
-    if (req) {
-        if (req->flags == CRYPTODEV_BACKEND_ALG_SYM) {
-            size_t max_len;
-            CryptoDevBackendSymOpInfo *op_info = req->u.sym_op_info;
-
-            max_len = op_info->iv_len +
-                      op_info->aad_len +
-                      op_info->src_len +
-                      op_info->dst_len +
-                      op_info->digest_result_len;
-
-            /* Zeroize and free request data structure */
-            memset(op_info, 0, sizeof(*op_info) + max_len);
+    if (!req) {
+        return;
+    }
+
+    if (req->flags == CRYPTODEV_BACKEND_ALG_SYM) {
+        size_t max_len;
+        CryptoDevBackendSymOpInfo *op_info = req->op_info.u.sym_op_info;
+
+        max_len = op_info->iv_len +
+                  op_info->aad_len +
+                  op_info->src_len +
+                  op_info->dst_len +
+                  op_info->digest_result_len;
+
+        /* Zeroize and free request data structure */
+        memset(op_info, 0, sizeof(*op_info) + max_len);
+        g_free(op_info);
+    } else if (req->flags == CRYPTODEV_BACKEND_ALG_ASYM) {
+        CryptoDevBackendAsymOpInfo *op_info = req->op_info.u.asym_op_info;
+        if (op_info) {
+            memset(op_info, 0, sizeof(*op_info));
             g_free(op_info);
         }
-        g_free(req);
     }
+
+    g_free(req);
 }
 
 static void
@@ -397,6 +486,37 @@ virtio_crypto_sym_input_data_helper(VirtIODevice *vdev,
     }
 }
 
+static void
+virtio_crypto_akcipher_input_data_helper(VirtIODevice *vdev,
+        VirtIOCryptoReq *req, int32_t status,
+        CryptoDevBackendAsymOpInfo *asym_op_info)
+{
+    size_t s, len;
+
+    if (status != VIRTIO_CRYPTO_OK) {
+        return;
+    }
+
+    /* For verify, we don't need write anything back */
+    if (req->op_info.op_code == VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
+        return;
+    }
+
+    len = asym_op_info->dst_len;
+    if (!len) {
+        return;
+    }
+
+    s = iov_from_buf(req->in_iov, req->in_num, 0, asym_op_info->dst, len);
+    if (s != len) {
+        virtio_error(vdev, "virtio-crypto asym dest data incorrect");
+        return;
+    }
+
+    iov_discard_front(&req->in_iov, &req->in_num, len);
+}
+
+
 static void virtio_crypto_req_complete(VirtIOCryptoReq *req, uint8_t status)
 {
     VirtIOCrypto *vcrypto = req->vcrypto;
@@ -404,7 +524,10 @@ static void virtio_crypto_req_complete(VirtIOCryptoReq *req, uint8_t status)
 
     if (req->flags == CRYPTODEV_BACKEND_ALG_SYM) {
         virtio_crypto_sym_input_data_helper(vdev, req, status,
-                                            req->u.sym_op_info);
+                                            req->op_info.u.sym_op_info);
+    } else if (req->flags == CRYPTODEV_BACKEND_ALG_ASYM) {
+        virtio_crypto_akcipher_input_data_helper(vdev, req, status,
+                                             req->op_info.u.asym_op_info);
     }
     stb_p(&req->in->status, status);
     virtqueue_push(req->vq, &req->elem, req->in_len);
@@ -543,39 +666,98 @@ err:
 static int
 virtio_crypto_handle_sym_req(VirtIOCrypto *vcrypto,
                struct virtio_crypto_sym_data_req *req,
-               CryptoDevBackendSymOpInfo **sym_op_info,
+               CryptoDevBackendOpInfo *op_info,
                struct iovec *iov, unsigned int out_num)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(vcrypto);
+    CryptoDevBackendSymOpInfo *sym_op_info;
     uint32_t op_type;
-    CryptoDevBackendSymOpInfo *op_info;
 
     op_type = ldl_le_p(&req->op_type);
-
     if (op_type == VIRTIO_CRYPTO_SYM_OP_CIPHER) {
-        op_info = virtio_crypto_sym_op_helper(vdev, &req->u.cipher.para,
+        sym_op_info = virtio_crypto_sym_op_helper(vdev, &req->u.cipher.para,
                                               NULL, iov, out_num);
-        if (!op_info) {
+        if (!sym_op_info) {
             return -EFAULT;
         }
-        op_info->op_type = op_type;
     } else if (op_type == VIRTIO_CRYPTO_SYM_OP_ALGORITHM_CHAINING) {
-        op_info = virtio_crypto_sym_op_helper(vdev, NULL,
+        sym_op_info = virtio_crypto_sym_op_helper(vdev, NULL,
                                               &req->u.chain.para,
                                               iov, out_num);
-        if (!op_info) {
+        if (!sym_op_info) {
             return -EFAULT;
         }
-        op_info->op_type = op_type;
     } else {
         /* VIRTIO_CRYPTO_SYM_OP_NONE */
         error_report("virtio-crypto unsupported cipher type");
         return -VIRTIO_CRYPTO_NOTSUPP;
     }
 
-    *sym_op_info = op_info;
+    sym_op_info->op_type = op_type;
+    op_info->u.sym_op_info = sym_op_info;
+
+    return 0;
+}
+
+static int
+virtio_crypto_handle_asym_req(VirtIOCrypto *vcrypto,
+               struct virtio_crypto_akcipher_data_req *req,
+               CryptoDevBackendOpInfo *op_info,
+               struct iovec *iov, unsigned int out_num)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(vcrypto);
+    CryptoDevBackendAsymOpInfo *asym_op_info;
+    uint32_t src_len;
+    uint32_t dst_len;
+    uint32_t len;
+    uint8_t *src = NULL;
+    uint8_t *dst = NULL;
+
+    asym_op_info = g_malloc0(sizeof(CryptoDevBackendAsymOpInfo));
+    src_len = ldl_le_p(&req->para.src_data_len);
+    dst_len = ldl_le_p(&req->para.dst_data_len);
+
+    if (src_len > 0) {
+        src = g_malloc0(src_len);
+        len = iov_to_buf(iov, out_num, 0, src, src_len);
+        if (unlikely(len != src_len)) {
+            virtio_error(vdev, "virtio-crypto asym src data incorrect"
+                         "expected %u, actual %u", src_len, len);
+            goto err;
+        }
+
+        iov_discard_front(&iov, &out_num, src_len);
+    }
+
+    if (dst_len > 0) {
+        dst = g_malloc0(dst_len);
+
+        if (op_info->op_code == VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
+            len = iov_to_buf(iov, out_num, 0, dst, dst_len);
+            if (unlikely(len != dst_len)) {
+                virtio_error(vdev, "virtio-crypto asym dst data incorrect"
+                             "expected %u, actual %u", dst_len, len);
+                goto err;
+            }
+
+            iov_discard_front(&iov, &out_num, dst_len);
+        }
+    }
+
+    asym_op_info->src_len = src_len;
+    asym_op_info->dst_len = dst_len;
+    asym_op_info->src = src;
+    asym_op_info->dst = dst;
+    op_info->u.asym_op_info = asym_op_info;
 
     return 0;
+
+ err:
+    g_free(asym_op_info);
+    g_free(src);
+    g_free(dst);
+
+    return -EFAULT;
 }
 
 static int
@@ -595,8 +777,7 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
     unsigned out_num;
     uint32_t opcode;
     uint8_t status = VIRTIO_CRYPTO_ERR;
-    uint64_t session_id;
-    CryptoDevBackendSymOpInfo *sym_op_info = NULL;
+    CryptoDevBackendOpInfo *op_info = &request->op_info;
     Error *local_err = NULL;
 
     if (elem->out_num < 1 || elem->in_num < 1) {
@@ -639,15 +820,28 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
     request->in_iov = in_iov;
 
     opcode = ldl_le_p(&req.header.opcode);
-    session_id = ldq_le_p(&req.header.session_id);
+    op_info->session_id = ldq_le_p(&req.header.session_id);
+    op_info->op_code = opcode;
 
     switch (opcode) {
     case VIRTIO_CRYPTO_CIPHER_ENCRYPT:
     case VIRTIO_CRYPTO_CIPHER_DECRYPT:
+        op_info->algtype = request->flags = CRYPTODEV_BACKEND_ALG_SYM;
         ret = virtio_crypto_handle_sym_req(vcrypto,
-                         &req.u.sym_req,
-                         &sym_op_info,
+                         &req.u.sym_req, op_info,
                          out_iov, out_num);
+        goto check_result;
+
+    case VIRTIO_CRYPTO_AKCIPHER_ENCRYPT:
+    case VIRTIO_CRYPTO_AKCIPHER_DECRYPT:
+    case VIRTIO_CRYPTO_AKCIPHER_SIGN:
+    case VIRTIO_CRYPTO_AKCIPHER_VERIFY:
+        op_info->algtype = request->flags = CRYPTODEV_BACKEND_ALG_ASYM;
+        ret = virtio_crypto_handle_asym_req(vcrypto,
+                         &req.u.akcipher_req, op_info,
+                         out_iov, out_num);
+
+check_result:
         /* Serious errors, need to reset virtio crypto device */
         if (ret == -EFAULT) {
             return -1;
@@ -655,11 +849,8 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
             virtio_crypto_req_complete(request, VIRTIO_CRYPTO_NOTSUPP);
             virtio_crypto_free_request(request);
         } else {
-            sym_op_info->session_id = session_id;
 
             /* Set request's parameter */
-            request->flags = CRYPTODEV_BACKEND_ALG_SYM;
-            request->u.sym_op_info = sym_op_info;
             ret = cryptodev_backend_crypto_operation(vcrypto->cryptodev,
                                     request, queue_index, &local_err);
             if (ret < 0) {
@@ -674,6 +865,7 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
             virtio_crypto_free_request(request);
         }
         break;
+
     case VIRTIO_CRYPTO_HASH:
     case VIRTIO_CRYPTO_MAC:
     case VIRTIO_CRYPTO_AEAD_ENCRYPT:
@@ -779,6 +971,7 @@ static void virtio_crypto_init_config(VirtIODevice *vdev)
     vcrypto->conf.mac_algo_l = vcrypto->conf.cryptodev->conf.mac_algo_l;
     vcrypto->conf.mac_algo_h = vcrypto->conf.cryptodev->conf.mac_algo_h;
     vcrypto->conf.aead_algo = vcrypto->conf.cryptodev->conf.aead_algo;
+    vcrypto->conf.akcipher_algo = vcrypto->conf.cryptodev->conf.akcipher_algo;
     vcrypto->conf.max_cipher_key_len =
                   vcrypto->conf.cryptodev->conf.max_cipher_key_len;
     vcrypto->conf.max_auth_key_len =
@@ -891,6 +1084,7 @@ static void virtio_crypto_get_config(VirtIODevice *vdev, uint8_t *config)
     stl_le_p(&crypto_cfg.max_cipher_key_len, c->conf.max_cipher_key_len);
     stl_le_p(&crypto_cfg.max_auth_key_len, c->conf.max_auth_key_len);
     stq_le_p(&crypto_cfg.max_size, c->conf.max_size);
+    stl_le_p(&crypto_cfg.akcipher_algo, c->conf.akcipher_algo);
 
     memcpy(config, &crypto_cfg, c->config_size);
 }
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
new file mode 100644
index 0000000000..8c3aae9b6c
--- /dev/null
+++ b/include/crypto/akcipher.h
@@ -0,0 +1,77 @@
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
+    uint32_t alg;
+    bool private;
+    uint8_t *key;
+    size_t keylen;
+    QCryptoAkcipherDriver *driver;
+};
+
+QCryptoAkcipher *qcrypto_akcipher_new(uint32_t alg, bool private,
+                                      const uint8_t *key, size_t keylen,
+                                      void *para, int index, Error **errp);
+
+int qcrypto_akcipher_encrypt(QCryptoAkcipher *akcipher,
+                             const void *data, size_t data_len,
+                             void *enc, size_t enc_len, Error **errp);
+
+int qcrypto_akcipher_decrypt(struct QCryptoAkcipher *akcipher,
+                             const void *enc, size_t enc_len,
+                             void *data, size_t data_len, Error **errp);
+
+int qcrypto_akcipher_sign(struct QCryptoAkcipher *akcipher,
+                          const void *data, size_t data_len,
+                          void *sig, size_t sig_len, Error **errp);
+
+int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,
+                            const void *sig, size_t sig_len,
+                            const void *data, size_t data_len, Error **errp);
+
+int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp);
+
+
+#endif /* QCRYPTO_AKCIPHER_H */
diff --git a/include/hw/virtio/virtio-crypto.h b/include/hw/virtio/virtio-crypto.h
index a2228d7b2e..348749f5d5 100644
--- a/include/hw/virtio/virtio-crypto.h
+++ b/include/hw/virtio/virtio-crypto.h
@@ -50,6 +50,7 @@ typedef struct VirtIOCryptoConf {
     uint32_t mac_algo_l;
     uint32_t mac_algo_h;
     uint32_t aead_algo;
+    uint32_t akcipher_algo;
 
     /* Maximum length of cipher key */
     uint32_t max_cipher_key_len;
@@ -71,9 +72,7 @@ typedef struct VirtIOCryptoReq {
     size_t in_len;
     VirtQueue *vq;
     struct VirtIOCrypto *vcrypto;
-    union {
-        CryptoDevBackendSymOpInfo *sym_op_info;
-    } u;
+    CryptoDevBackendOpInfo op_info;
 } VirtIOCryptoReq;
 
 typedef struct VirtIOCryptoQueue {
diff --git a/include/sysemu/cryptodev.h b/include/sysemu/cryptodev.h
index f4d4057d4d..b306775849 100644
--- a/include/sysemu/cryptodev.h
+++ b/include/sysemu/cryptodev.h
@@ -50,13 +50,13 @@ typedef struct CryptoDevBackendClient
 
 enum CryptoDevBackendAlgType {
     CRYPTODEV_BACKEND_ALG_SYM,
+    CRYPTODEV_BACKEND_ALG_ASYM,
     CRYPTODEV_BACKEND_ALG__MAX,
 };
 
 /**
  * CryptoDevBackendSymSessionInfo:
  *
- * @op_code: operation code (refer to virtio_crypto.h)
  * @cipher_alg: algorithm type of CIPHER
  * @key_len: byte length of cipher key
  * @hash_alg: algorithm type of HASH/MAC
@@ -74,7 +74,6 @@ enum CryptoDevBackendAlgType {
  */
 typedef struct CryptoDevBackendSymSessionInfo {
     /* corresponding with virtio crypto spec */
-    uint32_t op_code;
     uint32_t cipher_alg;
     uint32_t key_len;
     uint32_t hash_alg;
@@ -89,11 +88,41 @@ typedef struct CryptoDevBackendSymSessionInfo {
     uint8_t *auth_key;
 } CryptoDevBackendSymSessionInfo;
 
+/**
+ * CryptoDevBackendAsymSessionInfo:
+ */
+typedef struct CryptoDevBackendRsaPara {
+    uint32_t padding_algo;
+    uint32_t hash_algo;
+} CryptoDevBackendRsaPara;
+
+typedef struct CryptoDevBackendEcdsaPara {
+    uint32_t curve_id;
+} CryptoDevBackendEcdsaPara;
+
+typedef struct CryptoDevBackendAsymSessionInfo {
+    /* corresponding with virtio crypto spec */
+    uint32_t algo;
+    uint32_t keytype;
+    uint32_t keylen;
+    uint8_t *key;
+    union {
+        CryptoDevBackendRsaPara rsa;
+        CryptoDevBackendEcdsaPara ecdsa;
+    } u;
+} CryptoDevBackendAsymSessionInfo;
+
+typedef struct CryptoDevBackendSessionInfo {
+    uint32_t op_code;
+    union {
+        CryptoDevBackendSymSessionInfo sym_sess_info;
+        CryptoDevBackendAsymSessionInfo asym_sess_info;
+    } u;
+} CryptoDevBackendSessionInfo;
+
 /**
  * CryptoDevBackendSymOpInfo:
  *
- * @session_id: session index which was previously
- *              created by cryptodev_backend_sym_create_session()
  * @aad_len: byte length of additional authenticated data
  * @iv_len: byte length of initialization vector or counter
  * @src_len: byte length of source data
@@ -119,7 +148,6 @@ typedef struct CryptoDevBackendSymSessionInfo {
  *
  */
 typedef struct CryptoDevBackendSymOpInfo {
-    uint64_t session_id;
     uint32_t aad_len;
     uint32_t iv_len;
     uint32_t src_len;
@@ -138,6 +166,33 @@ typedef struct CryptoDevBackendSymOpInfo {
     uint8_t data[];
 } CryptoDevBackendSymOpInfo;
 
+
+/**
+ * CryptoDevBackendAsymOpInfo:
+ *
+ * @src_len: byte length of source data
+ * @dst_len: byte length of destination data
+ * @src: point to the source data
+ * @dst: point to the destination data
+ *
+ */
+typedef struct CryptoDevBackendAsymOpInfo {
+    uint32_t src_len;
+    uint32_t dst_len;
+    uint8_t *src;
+    uint8_t *dst;
+} CryptoDevBackendAsymOpInfo;
+
+typedef struct CryptoDevBackendOpInfo {
+    enum CryptoDevBackendAlgType algtype;
+    uint32_t op_code;
+    uint64_t session_id;
+    union {
+        CryptoDevBackendSymOpInfo *sym_op_info;
+        CryptoDevBackendAsymOpInfo *asym_op_info;
+    } u;
+} CryptoDevBackendOpInfo;
+
 struct CryptoDevBackendClass {
     ObjectClass parent_class;
 
@@ -145,13 +200,13 @@ struct CryptoDevBackendClass {
     void (*cleanup)(CryptoDevBackend *backend, Error **errp);
 
     int64_t (*create_session)(CryptoDevBackend *backend,
-                       CryptoDevBackendSymSessionInfo *sess_info,
+                       CryptoDevBackendSessionInfo *sess_info,
                        uint32_t queue_index, Error **errp);
     int (*close_session)(CryptoDevBackend *backend,
                            uint64_t session_id,
                            uint32_t queue_index, Error **errp);
-    int (*do_sym_op)(CryptoDevBackend *backend,
-                     CryptoDevBackendSymOpInfo *op_info,
+    int (*do_op)(CryptoDevBackend *backend,
+                     CryptoDevBackendOpInfo *op_info,
                      uint32_t queue_index, Error **errp);
 };
 
@@ -190,6 +245,7 @@ struct CryptoDevBackendConf {
     uint32_t mac_algo_l;
     uint32_t mac_algo_h;
     uint32_t aead_algo;
+    uint32_t akcipher_algo;
     /* Maximum length of cipher key */
     uint32_t max_cipher_key_len;
     /* Maximum length of authenticated key */
@@ -247,34 +303,34 @@ void cryptodev_backend_cleanup(
            Error **errp);
 
 /**
- * cryptodev_backend_sym_create_session:
+ * cryptodev_backend_create_session:
  * @backend: the cryptodev backend object
  * @sess_info: parameters needed by session creating
  * @queue_index: queue index of cryptodev backend client
  * @errp: pointer to a NULL-initialized error object
  *
- * Create a session for symmetric algorithms
+ * Create a session for symmetric/symmetric algorithms
  *
  * Returns: session id on success, or -1 on error
  */
-int64_t cryptodev_backend_sym_create_session(
+int64_t cryptodev_backend_create_session(
            CryptoDevBackend *backend,
-           CryptoDevBackendSymSessionInfo *sess_info,
+           CryptoDevBackendSessionInfo *sess_info,
            uint32_t queue_index, Error **errp);
 
 /**
- * cryptodev_backend_sym_close_session:
+ * cryptodev_backend_close_session:
  * @backend: the cryptodev backend object
  * @session_id: the session id
  * @queue_index: queue index of cryptodev backend client
  * @errp: pointer to a NULL-initialized error object
  *
- * Close a session for symmetric algorithms which was previously
- * created by cryptodev_backend_sym_create_session()
+ * Close a session for which was previously
+ * created by cryptodev_backend_create_session()
  *
  * Returns: 0 on success, or Negative on error
  */
-int cryptodev_backend_sym_close_session(
+int cryptodev_backend_close_session(
            CryptoDevBackend *backend,
            uint64_t session_id,
            uint32_t queue_index, Error **errp);
-- 
2.20.1

