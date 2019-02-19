Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FD6C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 12:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC3DD208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 12:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550577691;
	bh=muo6Hu574ZmwlEniKoDp0QryOrZmeRGzIbca19biQ/s=;
	h=From:To:Subject:Date:List-ID:From;
	b=tChlzCBi5dNI5MlHNcdcFXk1o3x0WmYraOTVmTjxd0PtpCnneNSNLWTcY9wj1Bgq9
	 tOER+Jorc8dWhDB8H8bjUNortuVKD9r3fO8M4MCHopA/Hw1TLUi/9x/acnAl5bdIsF
	 sCoS0s4RXYdpc8uW1G3bBHC8K1cM3sKwDPbeDjok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfBSMBU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfBSMBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 07:01:20 -0500
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8972F208E4;
        Tue, 19 Feb 2019 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550577680;
        bh=muo6Hu574ZmwlEniKoDp0QryOrZmeRGzIbca19biQ/s=;
        h=From:To:Subject:Date:From;
        b=qB+ZwLvGJQkwOxTmMzAL5JsVWJYirnuVEIFvS374Sq5TKf3CD1mnCkddTFP1h51G+
         j1FDe7KpsdCivxReFI/A1JW69gLF1xFXlNCIGBvkGN3Vw+KE/ypZaGNMUDHAMYhbXN
         TWp62KUCqVCgI3/CXk6Ihpbq9Epn0YB0js2SQ80Q=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: s5p-sss - Use AES_BLOCK_SIZE define instead of number
Date:   Tue, 19 Feb 2019 13:01:03 +0100
Message-Id: <1550577663-10251-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace hard coded AES block size with define.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0064be0e3941..39fc6942364b 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1819,10 +1819,12 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	void __iomem *keystart;
 
 	if (iv)
-		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv,
+			    AES_BLOCK_SIZE);
 
 	if (ctr)
-		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), ctr, 0x10);
+		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), ctr,
+			    AES_BLOCK_SIZE);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
-- 
2.7.4

