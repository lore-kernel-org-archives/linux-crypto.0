Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B12C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02DBD20870
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbfAWMAB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:00:01 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40668 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfAWMAB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 07:00:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id E240A1849C;
        Wed, 23 Jan 2019 12:59:58 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id RpC7LAIewlxf; Wed, 23 Jan 2019 12:59:54 +0100 (CET)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id 5DA3D18530;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D09A1E06A;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 118DC1E064;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id 055531CA2;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id 02609409B9; Wed, 23 Jan 2019 12:59:53 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 6/7] crypto: axis - use a constant time tag compare
Date:   Wed, 23 Jan 2019 12:59:45 +0100
Message-Id: <ccf244b67f651050402c35bd638533a5b43bec65.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Avoid plain memcmp() on the AEAD tag value as this could leak
information through a timing side channel.

Signed-off-by: Lars Persson <larper@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 1be5bdd658a4..71ef9ce68fd8 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2201,9 +2201,9 @@ static void artpec6_crypto_complete_aead(struct crypto_async_request *req)
 				   areq->assoclen + areq->cryptlen -
 				   authsize);
 
-		if (memcmp(req_ctx->decryption_tag,
-			   input_tag,
-			   authsize)) {
+		if (crypto_memneq(req_ctx->decryption_tag,
+				  input_tag,
+				  authsize)) {
 			pr_debug("***EBADMSG:\n");
 			print_hex_dump_debug("ref:", DUMP_PREFIX_ADDRESS, 32, 1,
 					     input_tag, authsize, true);
-- 
2.11.0

