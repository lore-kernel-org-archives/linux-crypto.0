Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06B6C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 08:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 879A46144E
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 08:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhEJI6T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 04:58:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2737 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhEJI6Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 04:58:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fdvwt125fzqV0R;
        Mon, 10 May 2021 16:53:50 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 16:57:04 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: testmgr - fix initialization of 'secret_size'
Date:   Mon, 10 May 2021 16:54:08 +0800
Message-ID: <1620636848-38909-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Actual data length of the 'secret' is not equal to the 'secret_size'.

Since the 'curve_id' has removed in the 'secret', the 'secret_size'
should subtract the length of the 'curve_id'.

Fixes: 6763f5ea2d9a(crypto: ecdh - move curve_id of ECDH from ...)

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 crypto/testmgr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 34e4a3d..aead75d 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2719,7 +2719,7 @@ static const struct kpp_testvec ecdh_p192_tv_template[] = {
 	"\xf4\x57\xcc\x4f\x1f\x4e\x31\xcc"
 	"\xe3\x40\x60\xc8\x06\x93\xc6\x2e"
 	"\x99\x80\x81\x28\xaf\xc5\x51\x74",
-	.secret_size = 32,
+	.secret_size = 30,
 	.b_public_size = 48,
 	.expected_a_public_size = 48,
 	.expected_ss_size = 24
@@ -2766,7 +2766,7 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	"\x9f\x4a\x38\xcc\xc0\x2c\x49\x2f"
 	"\xb1\x32\xbb\xaf\x22\x61\xda\xcb"
 	"\x6f\xdb\xa9\xaa\xfc\x77\x81\xf3",
-	.secret_size = 40,
+	.secret_size = 38,
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32
@@ -2804,8 +2804,8 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	"\x37\x08\xcc\x40\x5e\x7a\xfd\x6a"
 	"\x6a\x02\x6e\x41\x87\x68\x38\x77"
 	"\xfa\xa9\x44\x43\x2d\xef\x09\xdf",
-	.secret_size = 8,
-	.b_secret_size = 40,
+	.secret_size = 6,
+	.b_secret_size = 38,
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32,
--
2.8.1

