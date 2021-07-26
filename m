Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7A9C4320A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 16:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46CAC60E08
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 16:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhGZQRZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 12:17:25 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:50223 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240800AbhGZQOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 12:14:51 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2021 12:14:49 EDT
Received: from MTA-12-3.privateemail.com (mta-12-1.privateemail.com [198.54.122.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 6028B80890;
        Mon, 26 Jul 2021 12:45:47 -0400 (EDT)
Received: from mta-12.privateemail.com (localhost [127.0.0.1])
        by mta-12.privateemail.com (Postfix) with ESMTP id EAC0D18000B7;
        Mon, 26 Jul 2021 12:45:44 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.242])
        by mta-12.privateemail.com (Postfix) with ESMTPA id 64C3C18000A1;
        Mon, 26 Jul 2021 12:45:43 -0400 (EDT)
From:   Jordy Zomer <jordy@pwning.systems>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: avoid negative wrapping of integers 
Date:   Mon, 26 Jul 2021 18:45:01 +0200
Message-Id: <20210726164501.410524-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set csize to unsigned int to avoid it from wrapping as a negative number (since format input sends an unsigned integer to this function). This would also result in undefined behavior in the left shift when msg len is checked, potentially resulting in a buffer overflow in the memcpy call.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 crypto/ccm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 6b815ece51c6..e14201edf9db 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -66,7 +66,7 @@ static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
 	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
 }
 
-static int set_msg_len(u8 *block, unsigned int msglen, int csize)
+static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
 {
 	__be32 data;
 
-- 
2.27.0

