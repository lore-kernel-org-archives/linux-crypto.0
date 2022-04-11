Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB7EC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 10:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345738AbiDKKtb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiDKKtY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 06:49:24 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690BB43EE0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 03:47:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a42so7711574pfx.7
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 03:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r1LVHO5sM0sX4Mp/kIWaAI89jNYg4e1hMgC8/TqhpPE=;
        b=rAHRlN8Z3U+Wsnm8Zansh+kRLoYyDYTKUar7GY0xPVd0RV1uDix6qAdG1LZFOijYN+
         TWLVX8cLgmpEW8gqb5A0eJpQa7vBzESJzel6SYxoIIDo1SLcNYJjvs5uUXfUWQ2cnc6h
         CW+lBc4n1yUMLyXeQfmK6Z8JHCJLOB1gZJAjjmTueOqNZ3MXbAUzGzA/iLTUkPCNXJMq
         uF4OYpuo9xghReeZa2zuI2lU2EqCxHyb6U5qZL7DlHrkqNQiytqB4xN4DZ38zw6kpq3C
         4dHdq+quW7RRRMnO53KiozzgI3jOKX90Dsg2KC4NkRvarIfD8pM0sprtB5p7SyGNxlgp
         1sXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r1LVHO5sM0sX4Mp/kIWaAI89jNYg4e1hMgC8/TqhpPE=;
        b=oDQxA3FmOMB3VfzW5TuvEoEsLKFLDlOa2o3SD5Gz35pMG0episIJOziFaRqMLU9UBl
         RV1etS/nmf1VoNo1aRPQmrwIJT7nNEE9X/T9GIUcT1FMAnUrZeevu9b/JAMoCUsrPVVL
         ANVhQrTDH88ZQUy+C/L5mTs51cGSC6VC37obmnDnQGz6JUJYxLI4OL4l1kPunV2z0KDf
         aEwS9CZruv5XPWcDg+93+jHB5zXTCv9PWWLhiuIbtHxYWJ0CoPEtFyrD/fBLRQVxbDCn
         KHoSy3sNmQuiOqE3RRKZodgeoWcfuXRAncCgq1u5CPkyyekiZKx/FEbbevjjHg1u5pJB
         MVrA==
X-Gm-Message-State: AOAM5310oAx/kLty1+5rjY9v/0Md6uYalBGAPjGTi93SJs0Dztv6VrZg
        XpyoYpYLtUMVAPyPiwfKKmqXbg==
X-Google-Smtp-Source: ABdhPJzNWipLLMOZULomAUb8mwqFQAWk9p3wn9uvSu8QAzLJT1bXBY/9CrYAZFu/K3SJo7LMkqm/Yg==
X-Received: by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id b14-20020a056a00114e00b004c855f7faadmr32520337pfm.86.1649674029925;
        Mon, 11 Apr 2022 03:47:09 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id d8-20020a636808000000b00398e9c7049bsm27541649pgc.31.2022.04.11.03.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:47:09 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, berrange@redhat.com, arei.gonglei@huawei.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v4 1/8] virtio-crypto: header update
Date:   Mon, 11 Apr 2022 18:43:20 +0800
Message-Id: <20220411104327.197048-2-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411104327.197048-1-pizhenwei@bytedance.com>
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update header from linux, support akcipher service.

Reviewed-by: Gonglei <arei.gonglei@huawei.com>
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

