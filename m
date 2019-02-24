Return-Path: <SRS0=FcWR=Q7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B29C4360F
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5020D204EC
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfBXGJS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Feb 2019 01:09:18 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:44070 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfBXGJS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Feb 2019 01:09:18 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1827B72CCB1;
        Sun, 24 Feb 2019 09:09:16 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id E30B04A4AE7;
        Sun, 24 Feb 2019 09:09:15 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH v5 10/10] integrity: support EC-RDSA signatures for asymmetric_verify
Date:   Sun, 24 Feb 2019 09:08:28 +0300
Message-Id: <20190224060828.2527-11-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190224060828.2527-1-vt@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
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
---
 security/integrity/digsig_asymmetric.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index d775e03fbbcc..c4a3313e0210 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -104,9 +104,14 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	memset(&pks, 0, sizeof(pks));
 
-	pks.pkey_algo = "rsa";
 	pks.hash_algo = hash_algo_name[hdr->hash_algo];
-	pks.encoding = "pkcs1";
+	if (!strncmp(pks.hash_algo, "streebog", 8)) {
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

