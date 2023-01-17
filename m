Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178BFC677F1
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Jan 2023 17:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjAQRXX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Jan 2023 12:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbjAQRWc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2023 12:22:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145B64B77D
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2023 09:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673976037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1PRuX+JN7wqNln+FW4J1BUr8fMYCnc6M3GNZOEvdC2c=;
        b=bnLXJs/CS30vUyvdjLw/E+CIA4UFLaSHSY9KJ8jtcLjFb8ct8AMcDe+KmGpasElkomc1GE
        jtx99DasnJ425X/TW8bAeOiZVC3Z1ZMlvJHewFayfdvlgOHzPmmxaWzvxn7Ab3bxBNXUU6
        L9UtcwBN4qrMDkzIFSZg/F252hCEMgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-zoROmHHFNWi7Yx2HUGpmQQ-1; Tue, 17 Jan 2023 12:20:32 -0500
X-MC-Unique: zoROmHHFNWi7Yx2HUGpmQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A44619705C0;
        Tue, 17 Jan 2023 17:20:32 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-27.brq.redhat.com [10.40.208.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3B5C140EBF5;
        Tue, 17 Jan 2023 17:20:29 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] crypto: testmgr - disallow certain DRBG hash functions in FIPS mode
Date:   Tue, 17 Jan 2023 18:20:06 +0100
Message-Id: <20230117172006.8912-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to FIPS 140-3 IG, section D.R "Hash Functions Acceptable for
Use in the SP 800-90A DRBGs", modules certified after May 16th, 2023
must not support the use of: SHA-224, SHA-384, SHA512-224, SHA512-256,
SHA3-224, SHA3-384. Disallow HMAC and HASH DRBGs using SHA-384 in FIPS
mode.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
Some details:

The following DRBG algos are defined in testmgr.c as of now:

drbg_{no,}pr_ctr_aes128
drbg_{no,}pr_ctr_aes192
drbg_{no,}pr_ctr_aes256

drbg_{no,}pr_hmac_sha1
drbg_{no,}pr_hmac_sha256
drbg_{no,}pr_hmac_sha384 (disallow)
drbg_{no,}pr_hmac_sha512

drbg_{no,}pr_sha1
drbg_{no,}pr_sha256
drbg_{no,}pr_sha384 (disallow)
drbg_{no,}pr_sha512

Marked DRBGs should be disallowed in FIPS mode according to
the requirements above.
---
 crypto/testmgr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4476ac97baa5..fbb53d961ea9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4782,7 +4782,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		/* covered by drbg_nopr_hmac_sha256 test */
 		.alg = "drbg_nopr_hmac_sha384",
-		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_nopr_hmac_sha512",
@@ -4805,7 +4804,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		/* covered by drbg_nopr_sha256 test */
 		.alg = "drbg_nopr_sha384",
-		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_nopr_sha512",
@@ -4841,7 +4839,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		/* covered by drbg_pr_hmac_sha256 test */
 		.alg = "drbg_pr_hmac_sha384",
-		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_hmac_sha512",
@@ -4861,7 +4858,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		/* covered by drbg_pr_sha256 test */
 		.alg = "drbg_pr_sha384",
-		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_sha512",
-- 
2.39.0

