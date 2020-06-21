Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72798C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 09:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 582FB24896
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 09:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgFUJIG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 05:08:06 -0400
Received: from foss.arm.com ([217.140.110.172]:47916 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbgFUJID (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 05:08:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20293C0A;
        Sun, 21 Jun 2020 02:08:03 -0700 (PDT)
Received: from e110176-lin.arm.com (E113494.Arm.com [10.50.66.186])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B36F53F6CF;
        Sun, 21 Jun 2020 02:08:01 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: ccree: remove unused field
Date:   Sun, 21 Jun 2020 12:07:48 +0300
Message-Id: <20200621090748.18464-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621090748.18464-1-gilad@benyossef.com>
References: <20200621090748.18464-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove yet another unused field left over from times gone by.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 6575e216262b..79cfb47c759c 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -49,7 +49,6 @@ enum cc_key_type {
 struct cc_cipher_ctx {
 	struct cc_drvdata *drvdata;
 	int keylen;
-	int key_round_number;
 	int cipher_mode;
 	int flow_mode;
 	unsigned int flags;
-- 
2.27.0

