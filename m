Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4413DC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 14 May 2022 02:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiENCyI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 22:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiENCyC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 22:54:02 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E83D34D81B
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 17:59:54 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p12so9136153pfn.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 17:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PSxLrZH+hc3CYhkDYxfByo2A7hNKKgQ9HR81Av48tec=;
        b=jOZUlETZH5l3+AD7kz+Vb+1pUlWxlU/Mpwp0Ld3SV7OiX4YijJ6BlLR6u2YjqShbrt
         Oz24gRV3ZscQwh2vF301qEWXL5kXjfqWWfF4Jk/0sn4PwFwDp2/MpXsomEJq5fyYT2Pb
         PWdMAc0D3SwBhzJPdN2NPG/ZI0qJ4dsQl/toO4AAgEVn4WR/vW0ZkrtlhDjqUuKoGGlw
         GHmt7d+DxMBbRXHNKr+JqkDW+8fhSu4Iy8T1pjbCI65zNJ7dOfXtcQ2T8OnfZniPD2OT
         aKnZUrEibULlU3R+exeAxfAz89MY7WzLEgazB+BXDORqv3P30uycQrDNaJoSh+RBrkXf
         Mx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PSxLrZH+hc3CYhkDYxfByo2A7hNKKgQ9HR81Av48tec=;
        b=PgCIQOcvO33IaOyjobYWpBk1/TjaS46/NhE0BA9hlZjrduZHEHBL1jrDZSKMo2cL0Q
         bZaz+1zNrtrhYfjkbSDKfowm490o9Dwbkq9+khFXhZg0xdbwNdc9sh71FxELNqeG/LHz
         IckhIUi7q4jX0xjz6i8qjN9qpM2rcKaHU4NnCu5KOe83CywkmAlokU/7dx9c5jyI+IQN
         JvkJnh0u/67tlRPk9gAWQuBtx3W0baIo2WmBPydIeiHEeqv8+8dcYyTmz4vGLYub8j7z
         SqMOkakxH0kW/7bK33PBtaPEblnd0wbUBsMUhUGcp39VTuhpyS2E55SepK72cr3rRBqC
         H+Uw==
X-Gm-Message-State: AOAM533r8GoEAQQy1hpBlIgUifDM9+g2CyPr90TvwULHdegL39HyDiNb
        hAixNVHXjyzpq1I+IUtVVlre5Q==
X-Google-Smtp-Source: ABdhPJwFmzugwEvsIsh3jYonaXN8NBJb0BAw1y9+0Gw7QzkFBAhj0M/o4HTmRemabB+8CiJ83o5asA==
X-Received: by 2002:a65:4cce:0:b0:3c2:6d66:f141 with SMTP id n14-20020a654cce000000b003c26d66f141mr6226159pgt.173.1652489993584;
        Fri, 13 May 2022 17:59:53 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id t24-20020a170902b21800b0015e8d4eb1dbsm2466125plr.37.2022.05.13.17.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 17:59:52 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, pizhenwei@bytedance.com, cohuck@redhat.com
Subject: [PATCH v6 8/9] tests/crypto: Add test suite for RSA keys
Date:   Sat, 14 May 2022 08:55:03 +0800
Message-Id: <20220514005504.1042884-9-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220514005504.1042884-1-pizhenwei@bytedance.com>
References: <20220514005504.1042884-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Lei He <helei.sig11@bytedance.com>

As Daniel suggested, Add tests suite for rsakey, as a way to prove
that we can handle DER errors correctly.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: lei he <helei.sig11@bytedance.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
---
 tests/unit/test-crypto-akcipher.c | 285 +++++++++++++++++++++++++++++-
 1 file changed, 282 insertions(+), 3 deletions(-)

diff --git a/tests/unit/test-crypto-akcipher.c b/tests/unit/test-crypto-akcipher.c
index b5be563884..4f1f4214dd 100644
--- a/tests/unit/test-crypto-akcipher.c
+++ b/tests/unit/test-crypto-akcipher.c
@@ -517,6 +517,158 @@ static const uint8_t exp_ciphertext_rsa2048_pkcs1[] = {
     0xd0, 0x28, 0x03, 0x19, 0xa6, 0x06, 0x13, 0x45,
 };
 
+static const uint8_t rsa_private_key_lack_element[] = {
+    /* RSAPrivateKey, offset: 0, length: 176 */
+    0x30, 0x81, 0xb0,
+    /* version, offset: 4, length: 1 */
+    0x02, 0x01, 0x00,
+    /* n, offset: 7, length: 65 */
+    0x02, 0x41,
+    0x00, 0xb9, 0xe1, 0x22, 0xdb, 0x56, 0x2f, 0xb6,
+    0xf7, 0xf0, 0x0a, 0x87, 0x43, 0x07, 0x12, 0xdb,
+    0x6d, 0xb6, 0x2b, 0x41, 0x8d, 0x2c, 0x3c, 0xa5,
+    0xdd, 0x78, 0x9a, 0x8f, 0xab, 0x8e, 0xf2, 0x4a,
+    0xc8, 0x34, 0x0c, 0x12, 0x4f, 0x11, 0x90, 0xc6,
+    0xc2, 0xa5, 0xd0, 0xcd, 0xfb, 0xfc, 0x2c, 0x95,
+    0x56, 0x82, 0xdf, 0x39, 0xf3, 0x3b, 0x1d, 0x62,
+    0x26, 0x97, 0xb7, 0x93, 0x25, 0xc7, 0xec, 0x7e,
+    0xf7,
+    /* e, offset: 74, length: 3 */
+    0x02, 0x03, 0x01, 0x00, 0x01,
+    /* d, offset: 79, length: 64 */
+    0x02, 0x40,
+    0x1e, 0x80, 0xfe, 0xda, 0x65, 0xdb, 0x70, 0xb8,
+    0x61, 0x91, 0x28, 0xbf, 0x6c, 0x32, 0xc1, 0x05,
+    0xd1, 0x26, 0x6a, 0x1c, 0x83, 0xcc, 0xf4, 0x1f,
+    0x53, 0x42, 0x72, 0x1f, 0x62, 0x57, 0x0a, 0xc4,
+    0x66, 0x76, 0x30, 0x87, 0xb9, 0xb1, 0xb9, 0x6a,
+    0x63, 0xfd, 0x8f, 0x3e, 0xfc, 0x35, 0x3f, 0xd6,
+    0x2e, 0x6c, 0xc8, 0x70, 0x8a, 0x17, 0xc1, 0x28,
+    0x6a, 0xfe, 0x51, 0x56, 0xb3, 0x92, 0x6f, 0x09,
+    /* p, offset: 145, length: 33 */
+    0x02, 0x21,
+    0x00, 0xe3, 0x2e, 0x2d, 0x8d, 0xba, 0x1c, 0x34,
+    0x4c, 0x49, 0x9f, 0xc1, 0xa6, 0xdd, 0xd7, 0x13,
+    0x8d, 0x05, 0x48, 0xdd, 0xff, 0x5c, 0x30, 0xbc,
+    0x6b, 0xc4, 0x18, 0x9d, 0xfc, 0xa2, 0xd0, 0x9b,
+    0x4d,
+    /* q, offset: 180, length: 33 */
+    0x02, 0x21,
+    0x00, 0xd1, 0x75, 0xaf, 0x4b, 0xc6, 0x1a, 0xb0,
+    0x98, 0x14, 0x42, 0xae, 0x33, 0xf3, 0x44, 0xde,
+    0x21, 0xcb, 0x04, 0xda, 0xfb, 0x1e, 0x35, 0x92,
+    0xcd, 0x69, 0xc0, 0x83, 0x06, 0x83, 0x8e, 0x39,
+    0x53,
+    /* lack element: dp, dq, u */
+};
+
+static const uint8_t rsa_public_key_lack_element[] = {
+    /* RSAPublicKey, offset: 0, length: 67 */
+    0x30, 0x81, 0x43,
+    /* n, offset: 7, length: 65 */
+    0x02, 0x41,
+    0x00, 0xb9, 0xe1, 0x22, 0xdb, 0x56, 0x2f, 0xb6,
+    0xf7, 0xf0, 0x0a, 0x87, 0x43, 0x07, 0x12, 0xdb,
+    0x6d, 0xb6, 0x2b, 0x41, 0x8d, 0x2c, 0x3c, 0xa5,
+    0xdd, 0x78, 0x9a, 0x8f, 0xab, 0x8e, 0xf2, 0x4a,
+    0xc8, 0x34, 0x0c, 0x12, 0x4f, 0x11, 0x90, 0xc6,
+    0xc2, 0xa5, 0xd0, 0xcd, 0xfb, 0xfc, 0x2c, 0x95,
+    0x56, 0x82, 0xdf, 0x39, 0xf3, 0x3b, 0x1d, 0x62,
+    0x26, 0x97, 0xb7, 0x93, 0x25, 0xc7, 0xec, 0x7e,
+    0xf7,
+    /* lack element: e */
+};
+
+static const uint8_t rsa_public_key_empty_element[] = {
+    /* RSAPublicKey, offset: 0, length: 69 */
+    0x30, 0x81, 0x45,
+    /* n, offset: 7, length: 65 */
+    0x02, 0x41,
+    0x00, 0xb9, 0xe1, 0x22, 0xdb, 0x56, 0x2f, 0xb6,
+    0xf7, 0xf0, 0x0a, 0x87, 0x43, 0x07, 0x12, 0xdb,
+    0x6d, 0xb6, 0x2b, 0x41, 0x8d, 0x2c, 0x3c, 0xa5,
+    0xdd, 0x78, 0x9a, 0x8f, 0xab, 0x8e, 0xf2, 0x4a,
+    0xc8, 0x34, 0x0c, 0x12, 0x4f, 0x11, 0x90, 0xc6,
+    0xc2, 0xa5, 0xd0, 0xcd, 0xfb, 0xfc, 0x2c, 0x95,
+    0x56, 0x82, 0xdf, 0x39, 0xf3, 0x3b, 0x1d, 0x62,
+    0x26, 0x97, 0xb7, 0x93, 0x25, 0xc7, 0xec, 0x7e,
+    0xf7,
+    /* e: empty element */
+    0x02, 0x00,
+};
+
+static const uint8_t rsa_private_key_empty_element[] = {
+    /* RSAPrivateKey, offset: 0, length: 19 */
+    0x30, 0x81, 0x13,
+    /* version, offset: 4, length: 1 */
+    0x02, 0x01, 0x00,
+    /* n: empty element */
+    0x02, 0x00,
+    /* e: empty element */
+    0x02, 0x00,
+    /* d: empty element */
+    0x02, 0x00,
+    /* p: empty element */
+    0x02, 0x00,
+    /* q: empty element */
+    0x02, 0x00,
+    /* dp: empty element */
+    0x02, 0x00,
+    /* dq: empty element */
+    0x02, 0x00,
+    /* u: empty element */
+    0x02, 0x00,
+};
+
+static const uint8_t rsa_public_key_invalid_length_val[] = {
+    /* RSAPublicKey, INVALID length: 313 */
+    0x30, 0x82, 0x01, 0x39,
+    /* n, offset: 7, length: 65 */
+    0x02, 0x41,
+    0x00, 0xb9, 0xe1, 0x22, 0xdb, 0x56, 0x2f, 0xb6,
+    0xf7, 0xf0, 0x0a, 0x87, 0x43, 0x07, 0x12, 0xdb,
+    0x6d, 0xb6, 0x2b, 0x41, 0x8d, 0x2c, 0x3c, 0xa5,
+    0xdd, 0x78, 0x9a, 0x8f, 0xab, 0x8e, 0xf2, 0x4a,
+    0xc8, 0x34, 0x0c, 0x12, 0x4f, 0x11, 0x90, 0xc6,
+    0xc2, 0xa5, 0xd0, 0xcd, 0xfb, 0xfc, 0x2c, 0x95,
+    0x56, 0x82, 0xdf, 0x39, 0xf3, 0x3b, 0x1d, 0x62,
+    0x26, 0x97, 0xb7, 0x93, 0x25, 0xc7, 0xec, 0x7e,
+    0xf7,
+    /* e, */
+    0x02, 0x03, 0x01, 0x00, 0x01,  /* INTEGER, offset: 74, length: 3 */
+};
+
+static const uint8_t rsa_public_key_extra_elem[] = {
+    /* RSAPublicKey, length: 80 */
+    0x30, 0x81, 0x50,
+    /* n, offset: 7, length: 65 */
+    0x02, 0x41,
+    0x00, 0xb9, 0xe1, 0x22, 0xdb, 0x56, 0x2f, 0xb6,
+    0xf7, 0xf0, 0x0a, 0x87, 0x43, 0x07, 0x12, 0xdb,
+    0x6d, 0xb6, 0x2b, 0x41, 0x8d, 0x2c, 0x3c, 0xa5,
+    0xdd, 0x78, 0x9a, 0x8f, 0xab, 0x8e, 0xf2, 0x4a,
+    0xc8, 0x34, 0x0c, 0x12, 0x4f, 0x11, 0x90, 0xc6,
+    0xc2, 0xa5, 0xd0, 0xcd, 0xfb, 0xfc, 0x2c, 0x95,
+    0x56, 0x82, 0xdf, 0x39, 0xf3, 0x3b, 0x1d, 0x62,
+    0x26, 0x97, 0xb7, 0x93, 0x25, 0xc7, 0xec, 0x7e,
+    0xf7,
+    /* e, offset: 74, length: 3 */
+    0x02, 0x03, 0x01, 0x00, 0x01,
+    /* Additional integer field, length 3 */
+    0x02, 0x06, 0xe1, 0x22, 0xdb, 0xe1, 0x22, 0xdb,
+};
+
+typedef struct QCryptoRSAKeyTestData QCryptoRSAKeyTestData;
+struct QCryptoRSAKeyTestData {
+    const char *path;
+    QCryptoAkCipherKeyType key_type;
+    QCryptoAkCipherOptions opt;
+    const uint8_t *key;
+    size_t keylen;
+    bool is_valid_key;
+    size_t exp_key_len;
+};
+
 typedef struct QCryptoAkCipherTestData QCryptoAkCipherTestData;
 struct QCryptoAkCipherTestData {
     const char *path;
@@ -537,7 +689,98 @@ struct QCryptoAkCipherTestData {
     size_t slen;
 };
 
-static QCryptoAkCipherTestData test_data[] = {
+static QCryptoRSAKeyTestData rsakey_test_data[] = {
+    {
+        .path = "/crypto/akcipher/rsakey-1024-public",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = rsa1024_public_key,
+        .keylen = sizeof(rsa1024_public_key),
+        .is_valid_key = true,
+        .exp_key_len = 128,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-1024-private",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key = rsa1024_private_key,
+        .keylen = sizeof(rsa1024_private_key),
+        .is_valid_key = true,
+        .exp_key_len = 128,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-2048-public",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = rsa2048_public_key,
+        .keylen = sizeof(rsa2048_public_key),
+        .is_valid_key = true,
+        .exp_key_len = 256,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-2048-private",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key = rsa2048_private_key,
+        .keylen = sizeof(rsa2048_private_key),
+        .is_valid_key = true,
+        .exp_key_len = 256,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-public-lack-elem",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = rsa_public_key_lack_element,
+        .keylen = sizeof(rsa_public_key_lack_element),
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-private-lack-elem",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key = rsa_private_key_lack_element,
+        .keylen = sizeof(rsa_private_key_lack_element),
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-public-empty-elem",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = rsa_public_key_empty_element,
+        .keylen = sizeof(rsa_public_key_empty_element),
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-private-empty-elem",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key = rsa_private_key_empty_element,
+        .keylen = sizeof(rsa_private_key_empty_element),
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-public-empty-key",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = NULL,
+        .keylen = 0,
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-private-empty-key",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE,
+        .key = NULL,
+        .keylen = 0,
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-public-invalid-length-val",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = rsa_public_key_invalid_length_val,
+        .keylen = sizeof(rsa_public_key_invalid_length_val),
+        .is_valid_key = false,
+    },
+    {
+        .path = "/crypto/akcipher/rsakey-public-extra-elem",
+        .key_type = QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC,
+        .key = rsa_public_key_extra_elem,
+        .keylen = sizeof(rsa_public_key_extra_elem),
+        .is_valid_key = false,
+    },
+};
+
+static QCryptoAkCipherTestData akcipher_test_data[] = {
     /* rsa1024 with raw padding */
     {
         .path = "/crypto/akcipher/rsa1024-raw",
@@ -697,14 +940,50 @@ static void test_akcipher(const void *opaque)
     qcrypto_akcipher_free(priv_key);
 }
 
+static void test_rsakey(const void *opaque)
+{
+    const QCryptoRSAKeyTestData *data = (const QCryptoRSAKeyTestData *)opaque;
+    QCryptoAkCipherOptions opt = {
+        .alg = QCRYPTO_AKCIPHER_ALG_RSA,
+        .u.rsa = {
+            .padding_alg = QCRYPTO_RSA_PADDING_ALG_PKCS1,
+            .hash_alg = QCRYPTO_HASH_ALG_SHA1,
+        }
+    };
+    g_autoptr(QCryptoAkCipher) key = qcrypto_akcipher_new(
+        &opt, data->key_type, data->key, data->keylen, NULL);
+
+    if (!qcrypto_akcipher_supports(&opt)) {
+        return;
+    }
+
+    if (!data->is_valid_key) {
+        g_assert(key == NULL);
+        return;
+    }
+
+    g_assert(key != NULL);
+    g_assert(qcrypto_akcipher_max_ciphertext_len(key) == data->exp_key_len);
+    g_assert(qcrypto_akcipher_max_plaintext_len(key) == data->exp_key_len);
+    g_assert(qcrypto_akcipher_max_signature_len(key) == data->exp_key_len);
+    g_assert(qcrypto_akcipher_max_dgst_len(key) == data->exp_key_len);
+}
+
 int main(int argc, char **argv)
 {
     size_t i;
     g_test_init(&argc, &argv, NULL);
     g_assert(qcrypto_init(NULL) == 0);
 
-    for (i = 0; i < G_N_ELEMENTS(test_data); i++) {
-        g_test_add_data_func(test_data[i].path, &test_data[i], test_akcipher);
+    for (i = 0; i < G_N_ELEMENTS(akcipher_test_data); i++) {
+        g_test_add_data_func(akcipher_test_data[i].path,
+                             &akcipher_test_data[i],
+                             test_akcipher);
+    }
+    for (i = 0; i < G_N_ELEMENTS(rsakey_test_data); i++) {
+        g_test_add_data_func(rsakey_test_data[i].path,
+                             &rsakey_test_data[i],
+                             test_rsakey);
     }
 
     return g_test_run();
-- 
2.20.1

