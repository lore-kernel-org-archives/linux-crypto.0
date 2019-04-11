Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C2EC282DE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C15B217D4
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfDKPwV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:52:21 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:45308 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfDKPwU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 11:52:20 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1EF9672CCAE;
        Thu, 11 Apr 2019 18:52:18 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id E7A764A4A2A;
        Thu, 11 Apr 2019 18:52:17 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/10] integrity: support EC-RDSA signatures for asymmetric_verify
Date:   Thu, 11 Apr 2019 18:51:22 +0300
Message-Id: <20190411155122.13245-11-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190411155122.13245-1-vt@altlinux.org>
References: <20190411155122.13245-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow to use EC-RDSA signatures for IMA by determining signature type by
the hash algorithm name. This works good for EC-RDSA since Streebog and
EC-RDSA should always be used together.

Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-integrity@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/digsig_asymmetric.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index d775e03fbbcc..99080871eb9f 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -104,9 +104,16 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	memset(&pks, 0, sizeof(pks));
 
-	pks.pkey_algo = "rsa";
 	pks.hash_algo = hash_algo_name[hdr->hash_algo];
-	pks.encoding = "pkcs1";
+	if (hdr->hash_algo == HASH_ALGO_STREEBOG_256 ||
+	    hdr->hash_algo == HASH_ALGO_STREEBOG_512) {
+		/* EC-RDSA and Streebog should go together. */
+		pks.pkey_algo = "ecrdsa";
+		pks.encoding = "raw";
+	} else {
+		pks.pkey_algo = "rsa";
+		pks.encoding = "pkcs1";
+	}
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
-- 
2.11.0

