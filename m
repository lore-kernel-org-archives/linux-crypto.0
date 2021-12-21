Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84E8C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 00:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhLUAic (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Dec 2021 19:38:32 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:47682 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231365AbhLUAic (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Dec 2021 19:38:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V.Hgmar_1640047109;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V.Hgmar_1640047109)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Dec 2021 08:38:30 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     brijesh.singh@amd.com
Cc:     thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] crypto: ccp: remove unneeded semicolon
Date:   Tue, 21 Dec 2021 08:38:28 +0800
Message-Id: <20211221003828.101022-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/crypto/ccp/sev-dev.c:263:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 991cc5aaaa0f..8fd774a10edc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -260,7 +260,7 @@ static void sev_write_init_ex_file_if_required(int cmd_id)
 		break;
 	default:
 		return;
-	};
+	}
 
 	sev_write_init_ex_file();
 }
-- 
2.20.1.7.g153144c

