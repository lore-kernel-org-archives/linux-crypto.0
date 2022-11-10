Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C119C4167B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 08:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiKJIPM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiKJIPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 03:15:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16F1CFD3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 00:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 399B3B8204F
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA573C433D6
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068105;
        bh=BfFXqC1bkD9LGgv1kUjTDncw5VucjsU3M+CVl04dWmA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=e72hJLmUsVpzMwmINzn/eLzFIbqSN7ld3F7gzueYqEEPM3LXx9SPPumsLSOcpAxqJ
         nLDfcLDOzkUUyz/x8KaGvOshYmS1lWHBCdeJIlXxbDST10tKCoWZTkazDql/YHhbc8
         KcB6iilU8p+qEDkASTj2ci9rCxcMcSWBw+etjNJSs//jxnFFCXwxvsDoj8pyRe2zR/
         90P514mX9BTEYyFxpHzvtJ+SIACEn2FzOBgHveU8AvoD+K3OYk5Yi1D/ZJtrI54H6T
         jDGS/mF+501fncDuxdd079je90EbAbDv0LCSpyNwyh53JYKytc1CkgD5gbMJ+6e7Eo
         Bw62o4jyNi4DA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 4/6] crypto: skip kdf_sp800108 self-test when tests disabled
Date:   Thu, 10 Nov 2022 00:13:44 -0800
Message-Id: <20221110081346.336046-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110081346.336046-1-ebiggers@kernel.org>
References: <20221110081346.336046-1-ebiggers@kernel.org>
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

