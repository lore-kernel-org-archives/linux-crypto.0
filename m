Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E435C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Apr 2022 08:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiDXIxi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Apr 2022 04:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbiDXIxh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Apr 2022 04:53:37 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6121EAF5;
        Sun, 24 Apr 2022 01:50:35 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 24 Apr
 2022 16:50:38 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Sun, 24 Apr
 2022 16:50:32 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Haowen Bai <baihaowen@meizu.com>, <qat-linux@intel.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: qat - Fix unsigned function returning negative constant
Date:   Sun, 24 Apr 2022 16:50:31 +0800
Message-ID: <1650790231-16894-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function qat_uclo_check_image_compat has an unsigned return type, but
returns a negative constant to indicate an error condition. So we change
unsigned to int.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 6356402a2c9e..4b6f37d6e85b 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -519,7 +519,7 @@ qat_uclo_map_chunk(char *buf, struct icp_qat_uof_filehdr *file_hdr,
 	return NULL;
 }
 
-static unsigned int
+static int
 qat_uclo_check_image_compat(struct icp_qat_uof_encap_obj *encap_uof_obj,
 			    struct icp_qat_uof_image *image)
 {
-- 
2.7.4

