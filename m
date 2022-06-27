Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB62C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 07:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiF0Hbx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiF0Hbx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 03:31:53 -0400
X-Greylist: delayed 130 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Jun 2022 00:31:50 PDT
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78575FE6
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 00:31:50 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id VDE00033;
        Mon, 27 Jun 2022 15:29:33 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.9; Mon, 27 Jun 2022 15:29:34 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <horia.geanta@nxp.com>, <pankaj.gupta@nxp.com>,
        <gaurav.jain@nxp.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] crypto: Remove the duplicate word
Date:   Mon, 27 Jun 2022 03:29:33 -0400
Message-ID: <20220627072933.1845-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   2022627152933b5b60d11b0f4e5e773352b9c3d62c470
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Delete duplicate word for cnstr_shdsc_ahash.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/crypto/caam/caamhash_desc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash_desc.c b/drivers/crypto/caam/caamhash_desc.c
index 78383d77da99..619564509936 100644
--- a/drivers/crypto/caam/caamhash_desc.c
+++ b/drivers/crypto/caam/caamhash_desc.c
@@ -22,7 +22,7 @@
  * @ctx_len: size of Context Register
  * @import_ctx: true if previous Context Register needs to be restored
  *              must be true for ahash update and final
- *              must be false for for ahash first and digest
+ *              must be false for ahash first and digest
  * @era: SEC Era
  */
 void cnstr_shdsc_ahash(u32 * const desc, struct alginfo *adata, u32 state,
-- 
2.27.0

