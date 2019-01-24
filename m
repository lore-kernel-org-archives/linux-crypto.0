Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454B9C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 04:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BFE218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 04:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548305902;
	bh=CM3MfBqhyPgS8cQqNV72kZf/LRJwGiP2WqY2fO6yjTg=;
	h=From:To:Subject:Date:List-ID:From;
	b=zDviC45Tb1EzGKB+s/2qBV8aGEXxciULBKDaTHeNfc+zy6i6u7TuHwVsH8q1EMFN+
	 jZ3yin6hdeSzFkuYfndP5BaCK8e9R34IfIkJ1b7a59qPRK93TAN5QT0A4FV+0/pR+1
	 vwNE1Moo3PIkNK3fiKuunusqQjvPf9xd6WRhSBwM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfAXE6V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 23:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbfAXE6V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 23:58:21 -0500
Received: from sol.localdomain (c-24-23-143-129.hsd1.ca.comcast.net [24.23.143.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35B221872;
        Thu, 24 Jan 2019 04:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548305900;
        bh=CM3MfBqhyPgS8cQqNV72kZf/LRJwGiP2WqY2fO6yjTg=;
        h=From:To:Subject:Date:From;
        b=LYRjgAjkXPipjt5zbjSC70snJf4H5iCR9ZhFscbaxkFava80q1P/lQarGXNvdgE2C
         jDtw3KjlNOWqWQbtRkovg6K3VTFDoZMgwmvpoDx8V0LatYBjKeJoDMhk+9ASq15fbh
         mmNQvjo8bJDsDN9vKVkXoXfCXwQL+n0odYY/QYSU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: testmgr - skip crc32c context test for ahash algorithms
Date:   Wed, 23 Jan 2019 20:57:35 -0800
Message-Id: <20190124045735.331-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instantiating "cryptd(crc32c)" causes a crypto self-test failure because
the crypto_alloc_shash() in alg_test_crc32c() fails.  This is because
cryptd(crc32c) is an ahash algorithm, not a shash algorithm; so it can
only be accessed through the ahash API, unlike shash algorithms which
can be accessed through both the ahash and shash APIs.

As the test is testing the shash descriptor format which is only
applicable to shash algorithms, skip it for ahash algorithms.

(Note that it's still important to fix crypto self-test failures even
 for weird algorithm instantiations like cryptd(crc32c) that no one
 would really use; in fips_enabled mode unprivileged users can use them
 to panic the kernel, and also they prevent treating a crypto self-test
 failure as a bug when fuzzing the kernel.)

Fixes: 8e3ee85e68c5 ("crypto: crc32c - Test descriptor context format")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8e36fa3605d73..45e1c3c61a19d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2156,14 +2156,21 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 
 	err = alg_test_hash(desc, driver, type, mask);
 	if (err)
-		goto out;
+		return err;
 
 	tfm = crypto_alloc_shash(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT) {
+			/*
+			 * This crc32c implementation is only available through
+			 * ahash API, not the shash API, so the remaining part
+			 * of the test is not applicable to it.
+			 */
+			return 0;
+		}
 		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
-		err = PTR_ERR(tfm);
-		goto out;
+		return PTR_ERR(tfm);
 	}
 
 	do {
@@ -2190,7 +2197,6 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 
 	crypto_free_shash(tfm);
 
-out:
 	return err;
 }
 
-- 
2.20.1

