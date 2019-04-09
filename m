Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0096CC282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFFE52133D
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfDIQdw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:33:52 -0400
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:49845 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbfDIQdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 12:33:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 217FE180A8140;
        Tue,  9 Apr 2019 16:33:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: goose23_5b7d07c47b113
X-Filterd-Recvd-Size: 1905
Received: from joe-laptop.perches.com (unknown [172.56.41.174])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Apr 2019 16:33:48 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: sahara: Convert IS_ENABLED uses to __is_defined
Date:   Tue,  9 Apr 2019 09:33:13 -0700
Message-Id: <320188162965670a5a0a90f693f8082229b88ee2.1554827560.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <3c15d21d2b6896e76e8801dc07de2bae1dadceb1.1554827560.git.joe@perches.com>
References: <3c15d21d2b6896e76e8801dc07de2bae1dadceb1.1554827560.git.joe@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

IS_ENABLED should be reserved for CONFIG_<FOO> uses so convert
the uses of IS_ENABLED with a #define to __is_defined.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/sahara.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 8c32a3059b4a..fd11162a915e 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -354,7 +354,7 @@ static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 {
 	u8 state;
 
-	if (!IS_ENABLED(DEBUG))
+	if (!__is_defined(DEBUG))
 		return;
 
 	state = SAHARA_STATUS_GET_STATE(status);
@@ -406,7 +406,7 @@ static void sahara_dump_descriptors(struct sahara_dev *dev)
 {
 	int i;
 
-	if (!IS_ENABLED(DEBUG))
+	if (!__is_defined(DEBUG))
 		return;
 
 	for (i = 0; i < SAHARA_MAX_HW_DESC; i++) {
@@ -427,7 +427,7 @@ static void sahara_dump_links(struct sahara_dev *dev)
 {
 	int i;
 
-	if (!IS_ENABLED(DEBUG))
+	if (!__is_defined(DEBUG))
 		return;
 
 	for (i = 0; i < SAHARA_MAX_HW_LINK; i++) {
-- 
2.15.0

