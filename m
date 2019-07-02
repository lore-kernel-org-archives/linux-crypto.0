Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF295C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94BB32082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bldMvztj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfGBPmg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38263 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfGBPmf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so27736430edo.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Cx/uSgHKHaLB7EEHdPpDWWga+cj/yJ0xqhYiT2xLbc=;
        b=bldMvztjPDRbNv/CrepGyjJBquy8BHgK1t2gFtFWxlEicsokTphpZF9K4RPZ7KfMzZ
         MvHYuBgFQ+Zt+eY20dPIygyqeZAhulhBbKZvma393CBMuOkuXQb3cQ4qskWMOb83ehIm
         O/VZQsmw0aOk/ypqcNLOH6EIoBcy2cfIOD/Rvugn8gV3DBV65lIlSSQaZuhCeKZz/ZD0
         PZCoM+8etEB3TcMv217hEdGsCQUoG2uNQO45zt6ONCWE6DzfT/BbVr5ezgi06QqZskuK
         7u1dE+xFAl/Tqo0AVQB2MXSjTnLovodEsZDwKn/ZPkiZyn7NMkyQTdHDNM+05PQqGYh9
         qDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Cx/uSgHKHaLB7EEHdPpDWWga+cj/yJ0xqhYiT2xLbc=;
        b=FVmHD8Oc0i1ClnwHIrA+YOMf4qdg8SCUkLXf7sjKNevDLjY5IbyBTppmhWQOzxSf7x
         tJg2MMRXduKN9vIBIEhpV4R696OissAe1sZebdBkDA4dFp++Zjg6TN+FQt5G3TournHA
         rO9yyjuW0I7sCo18Iil3RwGlwL47lf6r8kZLXE0RobDnZZAB+0Q2KEVHa/gxQO2iJ6Ah
         HuEF2DGGrg9Hoq/DYrnI489OSan6ShtN7aoC7WEhc1J47pS9Lh5B4MAm900KmyMNtt3Z
         CXyj9LY3jQPJ2yd4b/VdFzdoCq9jvOywR2/k8aWb5SsEo+Ey31HL2fajOpE0ftZVQyzV
         PPAA==
X-Gm-Message-State: APjAAAW95orGlm15q4AJVZixKjtS6WWqUEswOL/EnphZT31CnTu66RbU
        f/dPa1xHEkWhae2avbKGqMK/IVvk
X-Google-Smtp-Source: APXvYqxvJlw3guAL3/77wajnm/LtWpXfeXkjUTRWIY6T79Z2rYh80/EQT0E3ujixTqVZaFH6xR+LIQ==
X-Received: by 2002:a17:907:2114:: with SMTP id qn20mr739426ejb.138.1562082153988;
        Tue, 02 Jul 2019 08:42:33 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:33 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/9] crypto: inside-secure - keep ivsize for DES ECB modes at 0
Date:   Tue,  2 Jul 2019 16:39:52 +0200
Message-Id: <1562078400-969-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

The driver incorrectly advertised the IV size for DES and 3DES ECB
mode as being the DES blocksize of 8. This is incorrect as ECB mode
does not need any IV.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index ee8a0c3..7977e4c 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1033,7 +1033,6 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
 		.decrypt = safexcel_ecb_des_decrypt,
 		.min_keysize = DES_KEY_SIZE,
 		.max_keysize = DES_KEY_SIZE,
-		.ivsize = DES_BLOCK_SIZE,
 		.base = {
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "safexcel-ecb-des",
@@ -1134,7 +1133,6 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 		.decrypt = safexcel_ecb_des3_ede_decrypt,
 		.min_keysize = DES3_EDE_KEY_SIZE,
 		.max_keysize = DES3_EDE_KEY_SIZE,
-		.ivsize = DES3_EDE_BLOCK_SIZE,
 		.base = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "safexcel-ecb-des3_ede",
-- 
1.8.3.1

