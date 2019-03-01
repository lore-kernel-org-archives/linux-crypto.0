Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1216EC4360F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 17:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D847F2085A
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 17:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389763AbfCAR72 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:59:28 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:40160 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389759AbfCAR72 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 12:59:28 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 8855D72CC53;
        Fri,  1 Mar 2019 20:59:25 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 5252D4A4AE7;
        Fri,  1 Mar 2019 20:59:25 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 01/11] KEYS: report to keyctl only actually supported key ops
Date:   Fri,  1 Mar 2019 20:59:08 +0300
Message-Id: <20190301175918.29694-2-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190301175918.29694-1-vt@altlinux.org>
References: <20190301175918.29694-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because with the introduction of EC-RDSA and change in workings of RSA
in regard to sign/verify, akcipher may have not all callbacks defined,
report to keyctl only actually supported ops determined by the presence
of the akcipher callbacks.

Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/asymmetric_keys/public_key.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index f5d85b47fcc6..c2e4e73fcf06 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -130,11 +130,17 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	info->max_sig_size = len;
 	info->max_enc_size = len;
 	info->max_dec_size = len;
-	info->supported_ops = (KEYCTL_SUPPORTS_ENCRYPT |
-			       KEYCTL_SUPPORTS_VERIFY);
-	if (pkey->key_is_private)
-		info->supported_ops |= (KEYCTL_SUPPORTS_DECRYPT |
-					KEYCTL_SUPPORTS_SIGN);
+	info->supported_ops = 0;
+	if (crypto_akcipher_alg(tfm)->verify)
+		info->supported_ops |= KEYCTL_SUPPORTS_VERIFY;
+	if (crypto_akcipher_alg(tfm)->encrypt)
+		info->supported_ops |= KEYCTL_SUPPORTS_ENCRYPT;
+	if (pkey->key_is_private) {
+		if (crypto_akcipher_alg(tfm)->decrypt)
+			info->supported_ops |= KEYCTL_SUPPORTS_DECRYPT;
+		if (crypto_akcipher_alg(tfm)->sign)
+			info->supported_ops |= KEYCTL_SUPPORTS_SIGN;
+	}
 	ret = 0;
 
 error_free_tfm:
-- 
2.11.0

