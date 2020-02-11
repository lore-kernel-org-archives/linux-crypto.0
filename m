Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78E6C35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9BAE206D6
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgBKS0S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:26:18 -0500
Received: from newton.telenet-ops.be ([195.130.132.45]:36434 "EHLO
        newton.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbgBKS0R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:26:17 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by newton.telenet-ops.be (Postfix) with ESMTPS id 48H9z71Xv9zMrJvf
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2020 19:19:31 +0100 (CET)
Received: from ramsan ([84.195.182.253])
        by albert.telenet-ops.be with bizsmtp
        id 1WKV2200M5USYZQ06WKWPw; Tue, 11 Feb 2020 19:19:31 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a8A-0002or-8o; Tue, 11 Feb 2020 19:19:30 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a8A-0003zH-6t; Tue, 11 Feb 2020 19:19:30 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 25/34] crypto: ccree - improve kerneldoc in cc_buffer_mgr.c
Date:   Tue, 11 Feb 2020 19:19:19 +0100
Message-Id: <20200211181928.15178-26-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211181928.15178-1-geert+renesas@glider.be>
References: <20200211181928.15178-1-geert+renesas@glider.be>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Miscellaneous improvements:
  - Add missing parameter and return value descriptions.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New.

 drivers/crypto/ccree/cc_buffer_mgr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index f2e782d2be155ee4..1ea4812e93549d75 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -73,9 +73,13 @@ static void cc_copy_mac(struct device *dev, struct aead_request *req,
 /**
  * cc_get_sgl_nents() - Get scatterlist number of entries.
  *
+ * @dev: Device object
  * @sg_list: SG list
  * @nbytes: [IN] Total SGL data bytes.
  * @lbytes: [OUT] Returns the amount of bytes at the last entry
+ *
+ * Return:
+ * Number of entries in the scatterlist
  */
 static unsigned int cc_get_sgl_nents(struct device *dev,
 				     struct scatterlist *sg_list,
@@ -102,11 +106,13 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
  * cc_copy_sg_portion() - Copy scatter list data,
  * from to_skip to end, to dest and vice versa
  *
- * @dest:
- * @sg:
- * @to_skip:
- * @end:
- * @direct:
+ * @dev: Device object
+ * @dest: Buffer to copy to/from
+ * @sg: SG list
+ * @to_skip: Number of bytes to skip before copying
+ * @end: Offset of last byte to copy
+ * @direct: Transfer direction (true == from SG list to buffer, false == from
+ *          buffer to SG list)
  */
 void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
 			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct)
-- 
2.17.1

