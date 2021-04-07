Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A6BC43603
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 13:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06745613D5
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 13:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbhDGNmr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 09:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347500AbhDGNmn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 09:42:43 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A7AC06175F;
        Wed,  7 Apr 2021 06:42:32 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t140so13072594pgb.13;
        Wed, 07 Apr 2021 06:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+3FMnnnbczm0LtjuFEdxkJqjc6eO2GZL9/e+HW2to2o=;
        b=Cxl9jEhsZ5kBTHW6vU1+dVh5eMfv/oRrdn9nuFWnLSloy46mjx+e/SPV4rqf8+3WpJ
         yHEimiVPpoffwtbUSHz/kAgckmxHINReKz8wx7kBUn7dVdOtjIg6RU6Azhg1tdADfd08
         IjlxeqtIVfcPhI+3SYR364xKAaCf+zWsk8CYScxfC4/Lu0aQFml8bsnEBi7udH6uDo6+
         L8rGJc+V7eglwdCZOIciegGJbYfF4RL7Xd6GKAQL7HWhjfUtFhXD0/Y0gM9Ks55p7u4X
         g11r4bL1biziLSMaVtYP/b3nZH7BqFDrQ/o+4FpGz6+8DbuWlodwy3LreeKmvl8qsCvE
         0uGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+3FMnnnbczm0LtjuFEdxkJqjc6eO2GZL9/e+HW2to2o=;
        b=YQLl0kunggvKMp3gxJm6hxQwG/Y6BA3/R6Y8a+KvwpRv37wM16B1s1OCBzYDdG7WEg
         ThL5O8V0xgMbP62u/EJOytR8Th97doq/oEg9ne1HHA5mR6u32/nMQ0IjWMBhnRgAnvp0
         14BWfJkRZTybpQkExQtCcxo0cm8fwmNDMO/OrwTmdxzYD+pmMrjL1pkZSbdAL7MXi6Yt
         3wVJCmu0U9JTja0mnZgBSWQ76Gb+hgnh7xTyd8bhXv+3c99lbJGdJDrIXcpc6PWo2coS
         7JQ1A7uhi3X50vZrR+/CtWysWHZO0Bxmejgb8ZzVd4yXw1v6fQydf5DE7J0ZNxOyYzJ/
         Q1xg==
X-Gm-Message-State: AOAM533DQd51EmCsyCEcQAn8OUCTBWu6RjH2ovRJBP9Q14Bf2z0Ntb+M
        jKfQRbmR5UwB8KWu43p7Zg+4tal8LYwdyw==
X-Google-Smtp-Source: ABdhPJzZVtl4WZ+Y7RkEcGl6ld7UyerFKZ5s6nM3tZvmVwjIxsvFJpGt7yhPKhkWPeGh/2T6J5yUjA==
X-Received: by 2002:a65:57cb:: with SMTP id q11mr1674664pgr.183.1617802951868;
        Wed, 07 Apr 2021 06:42:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id t65sm1547350pfd.5.2021.04.07.06.42.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Apr 2021 06:42:31 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, dhowells@redhat.com,
        zohar@linux.ibm.com, jarkko@kernel.org, herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
        herbert.tencent@gmail.com
Subject: [PATCH v4 4/4] ima: add support for rsa pss verification
Date:   Wed,  7 Apr 2021 21:41:46 +0800
Message-Id: <1617802906-30513-5-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617802906-30513-1-git-send-email-herbert.tencent@gmail.com>
References: <1617802906-30513-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for ima verification for rsa with
pss encoding.

And a rsa-pss patch for ima-evm-utils has been sent.

Signed-off-by: Hongbo Li <herbert.tencent@gmail.com>
---
 security/integrity/digsig_asymmetric.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 23240d7..ef7a51a 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -85,6 +85,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	struct public_key_signature pks;
 	struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
 	const struct public_key *pk;
+	struct public_key_signature *cert_sig;
 	struct key *key;
 	int ret;
 
@@ -109,16 +110,21 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	pk = asymmetric_key_public_key(key);
 	pks.pkey_algo = pk->pkey_algo;
-	if (!strcmp(pk->pkey_algo, "rsa"))
-		pks.encoding = "pkcs1";
-	else if (!strncmp(pk->pkey_algo, "ecdsa-", 6))
+	if (!strcmp(pk->pkey_algo, "rsa")) {
+		cert_sig = key->payload.data[asym_auth];
+		if (cert_sig)
+			pks.encoding = cert_sig->encoding;
+		else
+			pks.encoding = "pkcs1";
+	} else if (!strncmp(pk->pkey_algo, "ecdsa-", 6)) {
 		/* edcsa-nist-p192 etc. */
 		pks.encoding = "x962";
-	else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
-		   !strcmp(pk->pkey_algo, "sm2"))
+	} else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
+		   !strcmp(pk->pkey_algo, "sm2")) {
 		pks.encoding = "raw";
-	else
+	} else {
 		return -ENOPKG;
+	}
 
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
-- 
1.8.3.1

