Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EDAC07E9B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0AB26121E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhGTIRB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:01 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41167 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbhGTIPX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771361; x=1658307361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hMQlggUrirVIcSbH7jafoxnVILBXmaSZMhuayGiT/58=;
  b=xfhFUbE7CFwJL3k3JVuP6jvPixbIXoeVI3k2r8zf5/vAd4AtLd0ezAy8
   2qSdAy2elpXhjHdsgCTBbskij56FsaaTckccuQJcFp5N3xB3uoq6hhlV+
   VApDW/toLnLUcRHmykfhSFaZxgXwY+x3AVnDTdka51MBxi2tLNQ6awgDB
   /hKVd8QniFP2DbF9qwUiwFvOsUOXVl4RHVMugURq+EHRC6xHyF7Sb+95Q
   FjICLctxkdMjY0MyDmeKIwj+lw/85oa2O4sRvZyh7fucsveraXpFcMc0P
   1XceV1DdjuaYcLUut3dNMioGKtG/LFbA9vh8r+RdpxoxzSclDDpsVvvkI
   g==;
IronPort-SDR: 6zlPvAO0PXHEnOgBYb5IhEiV4a84h/kTVO6NUlwikapZKe+zPAJoSrZdkIjJm5LI/aZQ8+0PCj
 m1iAPQowDoX1yteEBc0FeT2K7DqyT5nm5MFizGdje/NU7vKbNjRv3W4QpOJ0yfKf8XsSD6Na3d
 yWdqKvLTsq6LXUJSE06xWaGoTkczRToaKMx58bmLIPSab6eDzSTEhalA4+UhTYo/Y5JHSGrPxp
 WFwCePewssEORB1jeCLIr/JXoJQubjwqL0mUkISjhAmRMfqZD64EkPgltw4EppwGNNgqM/zuWd
 Y20Mlxy1fwJ37wGxfttjf84Q
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="122687352"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:56:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:54 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:51 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 6/9] crypto: atmel-tdes: Add FIPS81's zero length cryptlen constraint
Date:   Tue, 20 Jul 2021 11:55:32 +0300
Message-ID: <20210720085535.141486-7-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

FIPS81 requires for the ECB, CBC, CFB, and OFB modes that the
plaintext and ciphertext to have a positive integer length.
Add this constraint and just return 0 for a zero length cryptlen.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index abbf1b7a75ab..8380e0ab149a 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -682,6 +682,9 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(req);
 	struct device *dev = ctx->dd->dev;
 
+	if (!req->cryptlen)
+		return 0;
+
 	switch (mode & TDES_FLAGS_OPMODE_MASK) {
 	case TDES_FLAGS_CFB8:
 		if (!IS_ALIGNED(req->cryptlen, CFB8_BLOCK_SIZE)) {
-- 
2.25.1

