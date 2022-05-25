Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7753C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 25 May 2022 09:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240966AbiEYJEP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 May 2022 05:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242154AbiEYJDs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 May 2022 05:03:48 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E64078930
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so18027664plg.7
        for <linux-crypto@vger.kernel.org>; Wed, 25 May 2022 02:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9nL17M+CZv6yqyF7EK/uJ1Kl84Fr8B9TyJZP1l6AEsg=;
        b=gLmmjQUiRlFKsa/TJiIH9XwzpyI9jw64J9//GzdnWdElvQZocUeajiXIMGcV7O56ti
         WXIYVUD/Am6dQHn8FpZfOksowQzUCzUED9cgAvY7QTzsyWrzMLlbDgnWZoemKIkuecNU
         jJIROfHXoExurnPviOO6zP9pcGiTNB8xjHTT6b0WTfi6l5QssaW0lirf/8yllCw7NU1J
         2XY6Htw1eAEY6lh2A3zO+NjFQtffOJ4X/7cbTHJ7pe8ndFdD+mc2zkvLiDTLFcBSQYy/
         +sHgwelVXk31vBUcxD4f+wIIK5QrwzR5l+6yxvTrpWjvqXzLoJDfhiAbreAHGHLVGfTk
         efmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9nL17M+CZv6yqyF7EK/uJ1Kl84Fr8B9TyJZP1l6AEsg=;
        b=PDd7ergraEUgvz76ml04aw9X/Resh5XEOZwjNLm1iPtv5JeyobJXlWQG8eirzmAQvA
         cdWgIHQaR9Jbb27k0WZEZ8fJM75Mc3YyMvY4ZLGUcoZGmvT1jy2lW5bFN3sxxksAl28g
         +GAIZSoM8syq3S/vSJYcNtA04Ox+sklnOuO2CWfF2VSvyaWUB6y0+9QHqmynwrCNVDOF
         4STzVB4apK9GlizvfP69J+twwYXUfaLKlwUf7gjWvzOq/r0G/Hbeb1tAfk3CRF3txv2Q
         uXyYbMO/pgGHnMQYnqHXAlFqs+JAkoJdhB6qYp5/Z+Pf9mrzpe4jhMaCKMKutaoqbVF1
         70FA==
X-Gm-Message-State: AOAM530mCFQkPmSNCb0ORqrfX3cASGKOt1+PS5+saShWSakALM7bHXNG
        sadV7BFVjrvkOtGssyy7HizQeQ==
X-Google-Smtp-Source: ABdhPJzBDDXtnK0eSwgjh2PR2JtDNBECoYS472ICH2t4lu56F4iWQXjHh7Gjg8SrHFYv/8mwySQw+A==
X-Received: by 2002:a17:903:44f:b0:161:5ef:2ea7 with SMTP id iw15-20020a170903044f00b0016105ef2ea7mr31650366plb.74.1653469366362;
        Wed, 25 May 2022 02:02:46 -0700 (PDT)
Received: from FVFDK26JP3YV.usts.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a6aca00b001deb92de665sm1015424pjm.46.2022.05.25.02.02.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 May 2022 02:02:45 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com, pizhenwei@bytedance.com,
        helei.sig11@bytedance.com
Subject: [PATCH 9/9] crypto: Introduce RSA algorithm
Date:   Wed, 25 May 2022 17:01:18 +0800
Message-Id: <20220525090118.43403-10-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220525090118.43403-1-helei.sig11@bytedance.com>
References: <20220525090118.43403-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: zhenwei pi <pizhenwei@bytedance.com>

There are two parts in this patch:
1, support akcipher service by cryptodev-builtin driver
2, virtio-crypto driver supports akcipher service

In principle, we should separate this into two patches, to avoid
compiling error, merge them into one.

Then virtio-crypto gets request from guest side, and forwards the
request to builtin driver to handle it.

Test with a guest linux:
1, The self-test framework of crypto layer works fine in guest kernel
2, Test with Linux guest(with asym support), the following script
test(note that pkey_XXX is supported only in a newer version of keyutils):
  - both public key & private key
  - create/close session
  - encrypt/decrypt/sign/verify basic driver operation
  - also test with kernel crypto layer(pkey add/query)

All the cases work fine.

Run script in guest:
rm -rf *.der *.pem *.pfx
modprobe pkcs8_key_parser # if CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
rm -rf /tmp/data
dd if=/dev/random of=/tmp/data count=1 bs=20

openssl req -nodes -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/C=CN/ST=BJ/L=HD/O=qemu/OU=dev/CN=qemu/emailAddress=qemu@qemu.org"
openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER -out key.der
openssl x509 -in cert.pem -inform PEM -outform DER -out cert.der

PRIV_KEY_ID=`cat key.der | keyctl padd asymmetric test_priv_key @s`
echo "priv key id = "$PRIV_KEY_ID
PUB_KEY_ID=`cat cert.der | keyctl padd asymmetric test_pub_key @s`
echo "pub key id = "$PUB_KEY_ID

keyctl pkey_query $PRIV_KEY_ID 0
keyctl pkey_query $PUB_KEY_ID 0

echo "Enc with priv key..."
keyctl pkey_encrypt $PRIV_KEY_ID 0 /tmp/data enc=pkcs1 >/tmp/enc.priv
echo "Dec with pub key..."
keyctl pkey_decrypt $PRIV_KEY_ID 0 /tmp/enc.priv enc=pkcs1 >/tmp/dec
cmp /tmp/data /tmp/dec

echo "Sign with priv key..."
keyctl pkey_sign $PRIV_KEY_ID 0 /tmp/data enc=pkcs1 hash=sha1 > /tmp/sig
echo "Verify with pub key..."
keyctl pkey_verify $PRIV_KEY_ID 0 /tmp/data /tmp/sig enc=pkcs1 hash=sha1

echo "Enc with pub key..."
keyctl pkey_encrypt $PUB_KEY_ID 0 /tmp/data enc=pkcs1 >/tmp/enc.pub
echo "Dec with priv key..."
keyctl pkey_decrypt $PRIV_KEY_ID 0 /tmp/enc.pub enc=pkcs1 >/tmp/dec
cmp /tmp/data /tmp/dec

echo "Verify with pub key..."
keyctl pkey_verify $PUB_KEY_ID 0 /tmp/data /tmp/sig enc=pkcs1 hash=sha1

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: lei he <helei.sig11@bytedance.com
---
 backends/cryptodev-builtin.c      | 272 +++++++++++++++++++++++++++-----
 backends/cryptodev-vhost-user.c   |  34 +++-
 backends/cryptodev.c              |  32 ++--
 hw/virtio/virtio-crypto.c         | 323 ++++++++++++++++++++++++++++++--------
 include/hw/virtio/virtio-crypto.h |   5 +-
 include/sysemu/cryptodev.h        |  83 ++++++++--
 6 files changed, 604 insertions(+), 145 deletions(-)

diff --git a/backends/cryptodev-builtin.c b/backends/cryptodev-builtin.c
index 0671bf9f3e..388aedd8df 100644
--- a/backends/cryptodev-builtin.c
+++ b/backends/cryptodev-builtin.c
@@ -26,6 +26,7 @@
 #include "qapi/error.h"
 #include "standard-headers/linux/virtio_crypto.h"
 #include "crypto/cipher.h"
+#include "crypto/akcipher.h"
 #include "qom/object.h"
 
 
@@ -41,11 +42,12 @@ OBJECT_DECLARE_SIMPLE_TYPE(CryptoDevBackendBuiltin, CRYPTODEV_BACKEND_BUILTIN)
 typedef struct CryptoDevBackendBuiltinSession {
     QCryptoCipher *cipher;
     uint8_t direction; /* encryption or decryption */
-    uint8_t type; /* cipher? hash? aead? */
+    uint8_t type; /* cipher? hash? aead? akcipher? */
+    QCryptoAkCipher *akcipher;
     QTAILQ_ENTRY(CryptoDevBackendBuiltinSession) next;
 } CryptoDevBackendBuiltinSession;
 
-/* Max number of symmetric sessions */
+/* Max number of symmetric/asymmetric sessions */
 #define MAX_NUM_SESSIONS 256
 
 #define CRYPTODEV_BUITLIN_MAX_AUTH_KEY_LEN    512
@@ -80,15 +82,17 @@ static void cryptodev_builtin_init(
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
 
@@ -148,6 +152,53 @@ err:
    return -1;
 }
 
+static int cryptodev_builtin_get_rsa_hash_algo(
+    int virtio_rsa_hash, Error **errp)
+{
+    switch (virtio_rsa_hash) {
+    case VIRTIO_CRYPTO_RSA_MD5:
+        return QCRYPTO_HASH_ALG_MD5;
+
+    case VIRTIO_CRYPTO_RSA_SHA1:
+        return QCRYPTO_HASH_ALG_SHA1;
+
+    case VIRTIO_CRYPTO_RSA_SHA256:
+        return QCRYPTO_HASH_ALG_SHA256;
+
+    case VIRTIO_CRYPTO_RSA_SHA512:
+        return QCRYPTO_HASH_ALG_SHA512;
+
+    default:
+        error_setg(errp, "Unsupported rsa hash algo: %d", virtio_rsa_hash);
+        return -1;
+    }
+}
+
+static int cryptodev_builtin_set_rsa_options(
+                    int virtio_padding_algo,
+                    int virtio_hash_algo,
+                    QCryptoAkCipherOptionsRSA *opt,
+                    Error **errp)
+{
+    if (virtio_padding_algo == VIRTIO_CRYPTO_RSA_PKCS1_PADDING) {
+        opt->padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1;
+        opt->hash_alg =
+            cryptodev_builtin_get_rsa_hash_algo(virtio_hash_algo, errp);
+        if (opt->hash_alg < 0) {
+            return -1;
+        }
+        return 0;
+    }
+
+    if (virtio_padding_algo == VIRTIO_CRYPTO_RSA_RAW_PADDING) {
+        opt->padding_alg = QCRYPTO_RSA_PADDING_ALG_RAW;
+        return 0;
+    }
+
+    error_setg(errp, "Unsupported rsa padding algo: %d", virtio_padding_algo);
+    return -1;
+}
+
 static int cryptodev_builtin_create_cipher_session(
                     CryptoDevBackendBuiltin *builtin,
                     CryptoDevBackendSymSessionInfo *sess_info,
@@ -240,26 +291,89 @@ static int cryptodev_builtin_create_cipher_session(
     return index;
 }
 
-static int64_t cryptodev_builtin_sym_create_session(
+static int cryptodev_builtin_create_akcipher_session(
+                    CryptoDevBackendBuiltin *builtin,
+                    CryptoDevBackendAsymSessionInfo *sess_info,
+                    Error **errp)
+{
+    CryptoDevBackendBuiltinSession *sess;
+    QCryptoAkCipher *akcipher;
+    int index;
+    QCryptoAkCipherKeyType type;
+    QCryptoAkCipherOptions opts;
+
+    switch (sess_info->algo) {
+    case VIRTIO_CRYPTO_AKCIPHER_RSA:
+        opts.alg = QCRYPTO_AKCIPHER_ALG_RSA;
+        if (cryptodev_builtin_set_rsa_options(sess_info->u.rsa.padding_algo,
+            sess_info->u.rsa.hash_algo, &opts.u.rsa, errp) != 0) {
+            return -1;
+        }
+        break;
+
+    /* TODO support DSA&ECDSA until qemu crypto framework support these */
+
+    default:
+        error_setg(errp, "Unsupported akcipher alg %u", sess_info->algo);
+        return -1;
+    }
+
+    switch (sess_info->keytype) {
+    case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
+        type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC;
+        break;
+
+    case VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
+        type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
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
+    akcipher = qcrypto_akcipher_new(&opts, type, sess_info->key,
+                                    sess_info->keylen, errp);
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
@@ -268,50 +382,44 @@ static int64_t cryptodev_builtin_sym_create_session(
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
 {
     CryptoDevBackendBuiltin *builtin =
                       CRYPTODEV_BACKEND_BUILTIN(backend);
+    CryptoDevBackendBuiltinSession *session;
 
     assert(session_id < MAX_NUM_SESSIONS && builtin->sessions[session_id]);
 
-    qcrypto_cipher_free(builtin->sessions[session_id]->cipher);
-    g_free(builtin->sessions[session_id]);
+    session = builtin->sessions[session_id];
+    if (session->cipher) {
+        qcrypto_cipher_free(session->cipher);
+    } else if (session->akcipher) {
+        qcrypto_akcipher_free(session->akcipher);
+    }
+
+    g_free(session);
     builtin->sessions[session_id] = NULL;
     return 0;
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
@@ -333,9 +441,95 @@ static int cryptodev_builtin_sym_operation(
             return -VIRTIO_CRYPTO_ERR;
         }
     }
+
+    return VIRTIO_CRYPTO_OK;
+}
+
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
+        ret = qcrypto_akcipher_verify(sess->akcipher,
+                                      op_info->src, op_info->src_len,
+                                      op_info->dst, op_info->dst_len, errp);
+    break;
+
+    default:
+        return -VIRTIO_CRYPTO_ERR;
+    }
+
+    if (ret < 0) {
+        if (op_code == VIRTIO_CRYPTO_AKCIPHER_VERIFY) {
+            return -VIRTIO_CRYPTO_KEY_REJECTED;
+        }
+        return -VIRTIO_CRYPTO_ERR;
+    }
+
+    /* Buffer is too short */
+    if (unlikely(ret > op_info->dst_len)) {
+        return -VIRTIO_CRYPTO_ERR;
+    }
+
+    op_info->dst_len = ret;
+
     return VIRTIO_CRYPTO_OK;
 }
 
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
@@ -348,7 +542,7 @@ static void cryptodev_builtin_cleanup(
 
     for (i = 0; i < MAX_NUM_SESSIONS; i++) {
         if (builtin->sessions[i] != NULL) {
-            cryptodev_builtin_sym_close_session(backend, i, 0, &error_abort);
+            cryptodev_builtin_close_session(backend, i, 0, &error_abort);
         }
     }
 
@@ -370,9 +564,9 @@ cryptodev_builtin_class_init(ObjectClass *oc, void *data)
 
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
index 2b105e433c..33eb4e1a70 100644
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
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index dcd80b904d..a98105d9e9 100644
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
@@ -177,11 +177,78 @@ virtio_crypto_create_sym_session(VirtIOCrypto *vcrypto,
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
+    g_autofree uint8_t *key = NULL;
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
+    /* TODO DSA&ECDSA handling */
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
@@ -195,7 +262,7 @@ virtio_crypto_handle_close_session(VirtIOCrypto *vcrypto,
     session_id = ldq_le_p(&close_sess_req->session_id);
     DPRINTF("close session, id=%" PRIu64 "\n", session_id);
 
-    ret = cryptodev_backend_sym_close_session(
+    ret = cryptodev_backend_close_session(
               vcrypto->cryptodev, session_id, queue_id, &local_err);
     if (ret == 0) {
         status = VIRTIO_CRYPTO_OK;
@@ -260,13 +327,22 @@ static void virtio_crypto_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
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
@@ -290,10 +366,12 @@ static void virtio_crypto_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
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
@@ -311,7 +389,6 @@ static void virtio_crypto_handle_ctrl(VirtIODevice *vdev, VirtQueue *vq)
         case VIRTIO_CRYPTO_AEAD_CREATE_SESSION:
         default:
             error_report("virtio-crypto unsupported ctrl opcode: %d", opcode);
-            memset(&input, 0, sizeof(input));
             stl_le_p(&input.status, VIRTIO_CRYPTO_NOTSUPP);
             s = iov_from_buf(in_iov, in_num, 0, &input, sizeof(input));
             if (unlikely(s != sizeof(input))) {
@@ -339,28 +416,39 @@ static void virtio_crypto_init_request(VirtIOCrypto *vcrypto, VirtQueue *vq,
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
+            g_free(op_info->src);
+            g_free(op_info->dst);
+            memset(op_info, 0, sizeof(*op_info));
             g_free(op_info);
         }
-        g_free(req);
     }
+
+    g_free(req);
 }
 
 static void
@@ -397,6 +485,35 @@ virtio_crypto_sym_input_data_helper(VirtIODevice *vdev,
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
+
+    /* For akcipher, dst_len may be changed after operation */
+    req->in_len = sizeof(struct virtio_crypto_inhdr) + asym_op_info->dst_len;
+}
+
+
 static void virtio_crypto_req_complete(VirtIOCryptoReq *req, uint8_t status)
 {
     VirtIOCrypto *vcrypto = req->vcrypto;
@@ -404,7 +521,10 @@ static void virtio_crypto_req_complete(VirtIOCryptoReq *req, uint8_t status)
 
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
@@ -543,42 +663,101 @@ err:
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
 
     return 0;
 }
 
 static int
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
+
+    return 0;
+
+ err:
+    g_free(asym_op_info);
+    g_free(src);
+    g_free(dst);
+
+    return -EFAULT;
+}
+
+static int
 virtio_crypto_handle_request(VirtIOCryptoReq *request)
 {
     VirtIOCrypto *vcrypto = request->vcrypto;
@@ -595,8 +774,7 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
     unsigned out_num;
     uint32_t opcode;
     uint8_t status = VIRTIO_CRYPTO_ERR;
-    uint64_t session_id;
-    CryptoDevBackendSymOpInfo *sym_op_info = NULL;
+    CryptoDevBackendOpInfo *op_info = &request->op_info;
     Error *local_err = NULL;
 
     if (elem->out_num < 1 || elem->in_num < 1) {
@@ -639,15 +817,28 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
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
+                         out_iov, out_num);
+        goto check_result;
+
+    case VIRTIO_CRYPTO_AKCIPHER_ENCRYPT:
+    case VIRTIO_CRYPTO_AKCIPHER_DECRYPT:
+    case VIRTIO_CRYPTO_AKCIPHER_SIGN:
+    case VIRTIO_CRYPTO_AKCIPHER_VERIFY:
+        op_info->algtype = request->flags = CRYPTODEV_BACKEND_ALG_ASYM;
+        ret = virtio_crypto_handle_asym_req(vcrypto,
+                         &req.u.akcipher_req, op_info,
                          out_iov, out_num);
+
+check_result:
         /* Serious errors, need to reset virtio crypto device */
         if (ret == -EFAULT) {
             return -1;
@@ -655,11 +846,8 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
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
@@ -674,6 +862,7 @@ virtio_crypto_handle_request(VirtIOCryptoReq *request)
             virtio_crypto_free_request(request);
         }
         break;
+
     case VIRTIO_CRYPTO_HASH:
     case VIRTIO_CRYPTO_MAC:
     case VIRTIO_CRYPTO_AEAD_ENCRYPT:
@@ -779,6 +968,7 @@ static void virtio_crypto_init_config(VirtIODevice *vdev)
     vcrypto->conf.mac_algo_l = vcrypto->conf.cryptodev->conf.mac_algo_l;
     vcrypto->conf.mac_algo_h = vcrypto->conf.cryptodev->conf.mac_algo_h;
     vcrypto->conf.aead_algo = vcrypto->conf.cryptodev->conf.aead_algo;
+    vcrypto->conf.akcipher_algo = vcrypto->conf.cryptodev->conf.akcipher_algo;
     vcrypto->conf.max_cipher_key_len =
                   vcrypto->conf.cryptodev->conf.max_cipher_key_len;
     vcrypto->conf.max_auth_key_len =
@@ -891,6 +1081,7 @@ static void virtio_crypto_get_config(VirtIODevice *vdev, uint8_t *config)
     stl_le_p(&crypto_cfg.max_cipher_key_len, c->conf.max_cipher_key_len);
     stl_le_p(&crypto_cfg.max_auth_key_len, c->conf.max_auth_key_len);
     stq_le_p(&crypto_cfg.max_size, c->conf.max_size);
+    stl_le_p(&crypto_cfg.akcipher_algo, c->conf.akcipher_algo);
 
     memcpy(config, &crypto_cfg, c->config_size);
 }
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
index f4d4057d4d..37c3a360fd 100644
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
@@ -90,10 +89,35 @@ typedef struct CryptoDevBackendSymSessionInfo {
 } CryptoDevBackendSymSessionInfo;
 
 /**
+ * CryptoDevBackendAsymSessionInfo:
+ */
+typedef struct CryptoDevBackendRsaPara {
+    uint32_t padding_algo;
+    uint32_t hash_algo;
+} CryptoDevBackendRsaPara;
+
+typedef struct CryptoDevBackendAsymSessionInfo {
+    /* corresponding with virtio crypto spec */
+    uint32_t algo;
+    uint32_t keytype;
+    uint32_t keylen;
+    uint8_t *key;
+    union {
+        CryptoDevBackendRsaPara rsa;
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
+/**
  * CryptoDevBackendSymOpInfo:
  *
- * @session_id: session index which was previously
- *              created by cryptodev_backend_sym_create_session()
  * @aad_len: byte length of additional authenticated data
  * @iv_len: byte length of initialization vector or counter
  * @src_len: byte length of source data
@@ -119,7 +143,6 @@ typedef struct CryptoDevBackendSymSessionInfo {
  *
  */
 typedef struct CryptoDevBackendSymOpInfo {
-    uint64_t session_id;
     uint32_t aad_len;
     uint32_t iv_len;
     uint32_t src_len;
@@ -138,6 +161,33 @@ typedef struct CryptoDevBackendSymOpInfo {
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
 
@@ -145,13 +195,13 @@ struct CryptoDevBackendClass {
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
 
@@ -190,6 +240,7 @@ struct CryptoDevBackendConf {
     uint32_t mac_algo_l;
     uint32_t mac_algo_h;
     uint32_t aead_algo;
+    uint32_t akcipher_algo;
     /* Maximum length of cipher key */
     uint32_t max_cipher_key_len;
     /* Maximum length of authenticated key */
@@ -247,34 +298,34 @@ void cryptodev_backend_cleanup(
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
2.11.0

