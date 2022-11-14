Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989ABC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 00:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiKNANQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 19:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiKNANO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 19:13:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3D663BF
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 16:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7044B80C69
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D3DC433B5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668384791;
        bh=BfFXqC1bkD9LGgv1kUjTDncw5VucjsU3M+CVl04dWmA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UFbIKq9O0XZco3CXRhm7Y/M/+Gyr2wLUISthCmYP8e0gKYEAolbhw6alnuL6D5zOK
         f80wh1kgB0NMdLw9rE5aFdqsKaKcGxHd8NuD9Cjj9DBRMt3WXBrFwwzLSNalzkHGQM
         22iYeeVAgIpWZkjxC0ojfnBjYTiTezdYSCId0IiWFtVnfIi8JsVKweeFq/zVWUCpBP
         IFMfaH4s+uw8EjyLdmSE/Z1WoSqCRDzH55lAbF2uctbegmogFTf0xq/QAD4d3TXiM3
         7dykYx+RXt794CZS8G4d7B3ACKAFLv/KOp+mfOvAYgcVtsP0Rp2BoTtA3PS81JCQL4
         codFeK7rpASXA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v3 4/6] crypto: skip kdf_sp800108 self-test when tests disabled
Date:   Sun, 13 Nov 2022 16:12:36 -0800
Message-Id: <20221114001238.163209-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114001238.163209-1-ebiggers@kernel.org>
References: <20221114001238.163209-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make kdf_sp800108 honor the CONFIG_CRYPTO_MANAGER_DISABLE_TESTS kconfig
option, so that it doesn't always waste time running its self-test.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/kdf_sp800108.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/kdf_sp800108.c b/crypto/kdf_sp800108.c
index 58edf7797abfb..c6e3ad82d5f7a 100644
--- a/crypto/kdf_sp800108.c
+++ b/crypto/kdf_sp800108.c
@@ -125,9 +125,13 @@ static const struct kdf_testvec kdf_ctr_hmac_sha256_tv_template[] = {
 
 static int __init crypto_kdf108_init(void)
 {
-	int ret = kdf_test(&kdf_ctr_hmac_sha256_tv_template[0], "hmac(sha256)",
-			   crypto_kdf108_setkey, crypto_kdf108_ctr_generate);
+	int ret;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+		return 0;
+
+	ret = kdf_test(&kdf_ctr_hmac_sha256_tv_template[0], "hmac(sha256)",
+		       crypto_kdf108_setkey, crypto_kdf108_ctr_generate);
 	if (ret) {
 		if (fips_enabled)
 			panic("alg: self-tests for CTR-KDF (hmac(sha256)) failed (rc=%d)\n",
-- 
2.38.1

