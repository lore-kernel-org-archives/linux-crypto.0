Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD8AC2D0E4
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 15:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD0B20870
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 15:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=novek.ru header.i=@novek.ru header.b="et6z/Qlb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389728AbgKXPdH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:33:07 -0500
Received: from novek.ru ([213.148.174.62]:47464 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389078AbgKXPdH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Nov 2020 10:33:07 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 0652E5030CB;
        Tue, 24 Nov 2020 18:25:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 0652E5030CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606231536; bh=ffxa9N9sKvJdo/h06u5PPtuH3qxWyZQ9hwY4Rd25ZW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=et6z/QlbXR9j4uQvR80W45g8X+yNgU066wrkgUczodExVQABuAVaI1BT8mklP716v
         B83I5sf30BqGhxCg4YNNCiJuKDSRWRxmbaA2FYiUoiBQfVNxPuxS6AMSlskiGhw0aq
         7W2fxnhzJ4Ng9wFSddVqbx46fV8AXuPgwwIEK4Pc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [net-next v2 5/5] selftests/tls: add CHACHA20-POLY1305 to tls selftests
Date:   Tue, 24 Nov 2020 18:24:50 +0300
Message-Id: <1606231490-653-6-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
References: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new cipher as a variant of standard tls selftests

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/tls.c | 40 ++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index b599f1f..cb0d189 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -103,32 +103,58 @@
 
 FIXTURE_VARIANT(tls)
 {
-	unsigned int tls_version;
+	u16 tls_version;
+	u16 cipher_type;
 };
 
-FIXTURE_VARIANT_ADD(tls, 12)
+FIXTURE_VARIANT_ADD(tls, 12_gcm)
 {
 	.tls_version = TLS_1_2_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_128,
 };
 
-FIXTURE_VARIANT_ADD(tls, 13)
+FIXTURE_VARIANT_ADD(tls, 13_gcm)
 {
 	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_128,
+};
+
+FIXTURE_VARIANT_ADD(tls, 12_chacha)
+{
+	.tls_version = TLS_1_2_VERSION,
+	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
+};
+
+FIXTURE_VARIANT_ADD(tls, 13_chacha)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
 };
 
 FIXTURE_SETUP(tls)
 {
-	struct tls12_crypto_info_aes_gcm_128 tls12;
+	union tls_crypto_context tls12;
 	struct sockaddr_in addr;
 	socklen_t len;
 	int sfd, ret;
+	size_t tls12_sz;
 
 	self->notls = false;
 	len = sizeof(addr);
 
 	memset(&tls12, 0, sizeof(tls12));
 	tls12.info.version = variant->tls_version;
-	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	tls12.info.cipher_type = variant->cipher_type;
+	switch (variant->cipher_type) {
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
+		break;
+	case TLS_CIPHER_AES_GCM_128:
+		tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
+		break;
+	default:
+		tls12_sz = 0;
+	}
 
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = htonl(INADDR_ANY);
@@ -156,7 +182,7 @@
 
 	if (!self->notls) {
 		ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12,
-				 sizeof(tls12));
+				 tls12_sz);
 		ASSERT_EQ(ret, 0);
 	}
 
@@ -169,7 +195,7 @@
 		ASSERT_EQ(ret, 0);
 
 		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12,
-				 sizeof(tls12));
+				 tls12_sz);
 		ASSERT_EQ(ret, 0);
 	}
 
-- 
1.8.3.1

