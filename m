Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B513C64E75
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 15:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA7452087C
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 15:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=novek.ru header.i=@novek.ru header.b="OiMJ8Cnb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgKXPdI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:33:08 -0500
Received: from novek.ru ([213.148.174.62]:47468 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388503AbgKXPdI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Nov 2020 10:33:08 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 610CB5030C6;
        Tue, 24 Nov 2020 18:25:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 610CB5030C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606231531; bh=Bv+hdH7fjyTLoJNNDryt7IIuhMR66vzunJw2y57lQdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiMJ8CnbKkMDoEv74Wq96NFHvrraa4oBJLtDgr0OE09Z7I+ShfCnr6dPMQKkqOBGo
         tK1cTN/2qzUPOpwc1mzXjq7Og96GyKDhwstCrQ/zV/zVJonw+SoMnbe/mjhZnhOzuE
         ekIZRGh9ag3uMVIJ0916Yq2FE6ZhL7IOaHfCR3C8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [net-next v2 2/5] net/tls: add CHACHA20-POLY1305 specific defines and structures
Date:   Tue, 24 Nov 2020 18:24:47 +0300
Message-Id: <1606231490-653-3-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
References: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To provide support for ChaCha-Poly cipher we need to define
specific constants and structures.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/tls.h        |  1 +
 include/uapi/linux/tls.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index d04ce73..e4e9c2a 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -211,6 +211,7 @@ struct cipher_context {
 	union {
 		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
 		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
+		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
 	};
 };
 
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index bcd2869..0d54bae 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -77,6 +77,13 @@
 #define TLS_CIPHER_AES_CCM_128_TAG_SIZE		16
 #define TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE		8
 
+#define TLS_CIPHER_CHACHA20_POLY1305			54
+#define TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE		12
+#define TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE	32
+#define TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE		0
+#define TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE	16
+#define TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE	8
+
 #define TLS_SET_RECORD_TYPE	1
 #define TLS_GET_RECORD_TYPE	2
 
@@ -109,6 +116,14 @@ struct tls12_crypto_info_aes_ccm_128 {
 	unsigned char rec_seq[TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE];
 };
 
+struct tls12_crypto_info_chacha20_poly1305 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE];
+	unsigned char key[TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE];
+};
+
 enum {
 	TLS_INFO_UNSPEC,
 	TLS_INFO_VERSION,
-- 
1.8.3.1

