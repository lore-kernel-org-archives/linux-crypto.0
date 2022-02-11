Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1951CC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 08:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiBKIpL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:45:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244156AbiBKIpL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 03:45:11 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA604E67
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:45:10 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m7so7537099pjk.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1YUUEgbKT5E8ArafBlTdhEpSwGDviZA6oIz5a+XwpPM=;
        b=0oAjqplYNLMWICcrHeQjBdyutmnnlHMmThim5ZJF8kipGWzVHnNCy5Prycxm4OuZvp
         JcNXCx6po3z1kHXAVdEEWRbGBksAMyNwzJoRs04r8PY8NiT+23idoQsS4eEn/z2ORiKv
         6ftzQN5tVH72P81P7NQ3cKgY0tT4SvOguNm9Matwnd5L83k7HsDoyjii35eIwFogbato
         Tc7ZWif6dnotY903l4eu1E0AQqe1T2LNVO4zC7qqT1oNQbDw3I3fvWc+yb/yAU8rmqk4
         13x0u2/ubiVg/GVgontGpRVNdIZ0voPzXb3cJtu2IsqWCxGLDAZW8gs/6J5KEFqUk5Tu
         Vs8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1YUUEgbKT5E8ArafBlTdhEpSwGDviZA6oIz5a+XwpPM=;
        b=GTZnb8z2GEhETXbPc7mx+mjdnhakCKdlvrhNSZtwcd9Re3lVt2EJriaAb1ZwDGqOZP
         TbKSFSF/sH+U95d0wmsanqIXH5bsPB/Nq3vIq8K9dCFj31Ch96WqeY8qtZoxjI1YulWB
         41K0g2BiJ8v6xx2FYjjLU33dffDV9VtmA/CYd3Eud5YtRWWUFGI85pFEFILYgp+HXAl8
         8kH1co2z9TIjuFCYh17IsLZUuzW49ZE/5gqYKvlrjGoSLorjMB2nnuZBCPqzMPuk4iiT
         0ZPtL4JOuk1TkswtSpnyFa/1CQC53gTkfIFjSHJkdGjFWhbFlco5UssITH0oZ7TGAVLX
         pIVA==
X-Gm-Message-State: AOAM533TqEjaktnHoLRNPQsf8oUFKY22WpB3X560L4QqsCtHV1/8V0MD
        +1vsbwtgzo8QTLaOiC19RZ7eqg==
X-Google-Smtp-Source: ABdhPJw0i8CweAp8N3HyYA7GXnJvxBIJPXb8oQ92581c5MIHS9NNqR0ydiY6heLawvan4w9U+B1r5w==
X-Received: by 2002:a17:902:d707:: with SMTP id w7mr450632ply.159.1644569110334;
        Fri, 11 Feb 2022 00:45:10 -0800 (PST)
Received: from libai.bytedance.net ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id u7sm3832686pgc.93.2022.02.11.00.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 00:45:09 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        helei.sig11@bytedance.com, herbert@gondor.apana.org.au,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 1/3] virtio-crypto: header update
Date:   Fri, 11 Feb 2022 16:43:33 +0800
Message-Id: <20220211084335.1254281-2-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220211084335.1254281-1-pizhenwei@bytedance.com>
References: <20220211084335.1254281-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update header from linux, support akcipher service.

Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 .../standard-headers/linux/virtio_crypto.h    | 82 ++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/include/standard-headers/linux/virtio_crypto.h b/include/standard-headers/linux/virtio_crypto.h
index 5ff0b4ee59..68066dafb6 100644
--- a/include/standard-headers/linux/virtio_crypto.h
+++ b/include/standard-headers/linux/virtio_crypto.h
@@ -37,6 +37,7 @@
 #define VIRTIO_CRYPTO_SERVICE_HASH   1
 #define VIRTIO_CRYPTO_SERVICE_MAC    2
 #define VIRTIO_CRYPTO_SERVICE_AEAD   3
+#define VIRTIO_CRYPTO_SERVICE_AKCIPHER 4
 
 #define VIRTIO_CRYPTO_OPCODE(service, op)   (((service) << 8) | (op))
 
@@ -57,6 +58,10 @@ struct virtio_crypto_ctrl_header {
 	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x02)
 #define VIRTIO_CRYPTO_AEAD_DESTROY_SESSION \
 	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x03)
+#define VIRTIO_CRYPTO_AKCIPHER_CREATE_SESSION \
+	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x04)
+#define VIRTIO_CRYPTO_AKCIPHER_DESTROY_SESSION \
+	   VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x05)
 	uint32_t opcode;
 	uint32_t algo;
 	uint32_t flag;
@@ -180,6 +185,58 @@ struct virtio_crypto_aead_create_session_req {
 	uint8_t padding[32];
 };
 
+struct virtio_crypto_rsa_session_para {
+#define VIRTIO_CRYPTO_RSA_RAW_PADDING   0
+#define VIRTIO_CRYPTO_RSA_PKCS1_PADDING 1
+	uint32_t padding_algo;
+
+#define VIRTIO_CRYPTO_RSA_NO_HASH   0
+#define VIRTIO_CRYPTO_RSA_MD2       1
+#define VIRTIO_CRYPTO_RSA_MD3       2
+#define VIRTIO_CRYPTO_RSA_MD4       3
+#define VIRTIO_CRYPTO_RSA_MD5       4
+#define VIRTIO_CRYPTO_RSA_SHA1      5
+#define VIRTIO_CRYPTO_RSA_SHA256    6
+#define VIRTIO_CRYPTO_RSA_SHA384    7
+#define VIRTIO_CRYPTO_RSA_SHA512    8
+#define VIRTIO_CRYPTO_RSA_SHA224    9
+	uint32_t hash_algo;
+};
+
+struct virtio_crypto_ecdsa_session_para {
+#define VIRTIO_CRYPTO_CURVE_UNKNOWN   0
+#define VIRTIO_CRYPTO_CURVE_NIST_P192 1
+#define VIRTIO_CRYPTO_CURVE_NIST_P224 2
+#define VIRTIO_CRYPTO_CURVE_NIST_P256 3
+#define VIRTIO_CRYPTO_CURVE_NIST_P384 4
+#define VIRTIO_CRYPTO_CURVE_NIST_P521 5
+	uint32_t curve_id;
+	uint32_t padding;
+};
+
+struct virtio_crypto_akcipher_session_para {
+#define VIRTIO_CRYPTO_NO_AKCIPHER    0
+#define VIRTIO_CRYPTO_AKCIPHER_RSA   1
+#define VIRTIO_CRYPTO_AKCIPHER_DSA   2
+#define VIRTIO_CRYPTO_AKCIPHER_ECDSA 3
+	uint32_t algo;
+
+#define VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC  1
+#define VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE 2
+	uint32_t keytype;
+	uint32_t keylen;
+
+	union {
+		struct virtio_crypto_rsa_session_para rsa;
+		struct virtio_crypto_ecdsa_session_para ecdsa;
+	} u;
+};
+
+struct virtio_crypto_akcipher_create_session_req {
+	struct virtio_crypto_akcipher_session_para para;
+	uint8_t padding[36];
+};
+
 struct virtio_crypto_alg_chain_session_para {
 #define VIRTIO_CRYPTO_SYM_ALG_CHAIN_ORDER_HASH_THEN_CIPHER  1
 #define VIRTIO_CRYPTO_SYM_ALG_CHAIN_ORDER_CIPHER_THEN_HASH  2
@@ -247,6 +304,8 @@ struct virtio_crypto_op_ctrl_req {
 			mac_create_session;
 		struct virtio_crypto_aead_create_session_req
 			aead_create_session;
+		struct virtio_crypto_akcipher_create_session_req
+			akcipher_create_session;
 		struct virtio_crypto_destroy_session_req
 			destroy_session;
 		uint8_t padding[56];
@@ -266,6 +325,14 @@ struct virtio_crypto_op_header {
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x00)
 #define VIRTIO_CRYPTO_AEAD_DECRYPT \
 	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AEAD, 0x01)
+#define VIRTIO_CRYPTO_AKCIPHER_ENCRYPT \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x00)
+#define VIRTIO_CRYPTO_AKCIPHER_DECRYPT \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x01)
+#define VIRTIO_CRYPTO_AKCIPHER_SIGN \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x02)
+#define VIRTIO_CRYPTO_AKCIPHER_VERIFY \
+	VIRTIO_CRYPTO_OPCODE(VIRTIO_CRYPTO_SERVICE_AKCIPHER, 0x03)
 	uint32_t opcode;
 	/* algo should be service-specific algorithms */
 	uint32_t algo;
@@ -390,6 +457,16 @@ struct virtio_crypto_aead_data_req {
 	uint8_t padding[32];
 };
 
+struct virtio_crypto_akcipher_para {
+	uint32_t src_data_len;
+	uint32_t dst_data_len;
+};
+
+struct virtio_crypto_akcipher_data_req {
+	struct virtio_crypto_akcipher_para para;
+	uint8_t padding[40];
+};
+
 /* The request of the data virtqueue's packet */
 struct virtio_crypto_op_data_req {
 	struct virtio_crypto_op_header header;
@@ -399,6 +476,7 @@ struct virtio_crypto_op_data_req {
 		struct virtio_crypto_hash_data_req hash_req;
 		struct virtio_crypto_mac_data_req mac_req;
 		struct virtio_crypto_aead_data_req aead_req;
+		struct virtio_crypto_akcipher_data_req akcipher_req;
 		uint8_t padding[48];
 	} u;
 };
@@ -408,6 +486,8 @@ struct virtio_crypto_op_data_req {
 #define VIRTIO_CRYPTO_BADMSG    2
 #define VIRTIO_CRYPTO_NOTSUPP   3
 #define VIRTIO_CRYPTO_INVSESS   4 /* Invalid session id */
+#define VIRTIO_CRYPTO_NOSPC     5 /* no free session ID */
+#define VIRTIO_CRYPTO_KEY_REJECTED 6 /* Signature verification failed */
 
 /* The accelerator hardware is ready */
 #define VIRTIO_CRYPTO_S_HW_READY  (1 << 0)
@@ -438,7 +518,7 @@ struct virtio_crypto_config {
 	uint32_t max_cipher_key_len;
 	/* Maximum length of authenticated key */
 	uint32_t max_auth_key_len;
-	uint32_t reserve;
+	uint32_t akcipher_algo;
 	/* Maximum size of each crypto request's content */
 	uint64_t max_size;
 };
-- 
2.20.1

