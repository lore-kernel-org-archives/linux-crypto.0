Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B9EC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F331E2083D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbfDRNj1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:39:27 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33416 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733192AbfDRNj1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:39:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 170D91688;
        Thu, 18 Apr 2019 06:39:27 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F32A3F5AF;
        Thu, 18 Apr 2019 06:39:25 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/35] crypto: testmgr: add missing self test entries for protected keys
Date:   Thu, 18 Apr 2019 16:38:36 +0300
Message-Id: <20190418133913.9122-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Mark sm4 and missing aes using protected keys which are indetical to
same algs with no HW protected keys as tested.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f6bfb6ce6a4..d04f75d84fc0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3012,6 +3012,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "cbc(paes)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
+	}, {
+		/* Same as cbc(sm4) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "cbc(psm4)",
+		.test = alg_test_null,
 	}, {
 		.alg = "cbc(serpent)",
 		.test = alg_test_skcipher,
@@ -3147,6 +3153,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+
+		/* Same as ctr(sm4) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "ctr(psm4)",
+		.test = alg_test_null,
+	}, {
 		.alg = "ctr(serpent)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3171,6 +3184,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.cipher = __VECS(cts_mode_tv_template)
 		}
+	}, {
+		/* Same as cts(cbc((aes)) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "cts(cbc(paes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "deflate",
 		.test = alg_test_comp,
-- 
2.21.0

