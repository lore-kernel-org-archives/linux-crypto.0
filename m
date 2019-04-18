Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F60EC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47C6C20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbfDRNlV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:21 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33664 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRNlV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BE451688;
        Thu, 18 Apr 2019 06:41:21 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D47323F5AF;
        Thu, 18 Apr 2019 06:41:19 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/35] crypto: ccree: remove unused defines
Date:   Thu, 18 Apr 2019 16:38:56 +0300
Message-Id: <20190418133913.9122-22-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unused definitions from AEAD driver code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 0e8d2381c175..f9e410de66a8 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -23,12 +23,8 @@
 #define MAX_HMAC_DIGEST_SIZE (SHA256_DIGEST_SIZE)
 #define MAX_HMAC_BLOCK_SIZE (SHA256_BLOCK_SIZE)
 
-#define AES_CCM_RFC4309_NONCE_SIZE 3
 #define MAX_NONCE_SIZE CTR_RFC3686_NONCE_SIZE
 
-/* Value of each ICV_CMP byte (of 8) in case of success */
-#define ICV_VERIF_OK 0x01
-
 struct cc_aead_handle {
 	cc_sram_addr_t sram_workspace_addr;
 	struct list_head aead_list;
-- 
2.21.0

