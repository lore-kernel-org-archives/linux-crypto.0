Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994C1C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 06:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F86611C9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 06:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDGWA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 02:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhKDGV7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 02:21:59 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E24C061714;
        Wed,  3 Nov 2021 23:19:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p18so5505313plf.13;
        Wed, 03 Nov 2021 23:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/7yWa9TJnaSeRyI/HPqifrDsWRJ3du7nMikT4cHRgc=;
        b=i0bqzK23wAuVTAvxivcIjUs5QJ5W51FYUAqolWFzGQHXH7f7jvcJJxGFjSZHo08JBE
         EQXvBCNVi9Ui8o2zEWtgSIpgSmCGjPtVD2KELXP7JMH08TOshe6pjRAERpKavq1U+DTR
         kmJE98pQiVrDwglZj5KflNamJIvnI8WtPnx5bF1wZDbXrJmjPT5n1utYnqarZYHOPSXc
         yPsBpIwKF76MIR1Phw0WX2k7tjIuloKGbqlm96FnB4DQNrMoKR1+c1JslUgti3MtcwBZ
         u2xRRRYMRd1iqP/pyWLev/MfozauLev/Bk+8xuF/a4JZdmjb5P7J0LtaRV1pf2zJumGm
         neIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/7yWa9TJnaSeRyI/HPqifrDsWRJ3du7nMikT4cHRgc=;
        b=jn3m1W0MWb2oVEQNyfhms1kNCFIfyzI7qlQboOpFMITOQvBjKAqK1np577gcyBOxTX
         95NEw19U5/gdhA7Sez7G0xIkqIq/wJVKk5ryKvJFd4pxO/tWA4Y6IT99rqyHwpgFniVO
         lZ7VIYWIAp2sfBQKOzYcT317d2jehGLzZNc7lOei5huMg/7y8V2aqppgzKeh8WVS0P+o
         YbP5Sa0GWc4j+MLRM0f9yWKhSJPns+gQaz+XnKUZhsDmrj1gfd6hfrHV3el3mhkkeYWO
         VWBUtZeggpfR/fuWtw1sBvJlQ0vjDYTFsifvlo59jBpsmOr+xrFbhfOs6nTi41s3WUks
         skmA==
X-Gm-Message-State: AOAM531/DpJVfDeMZJtCbtbCnMDj2hnBlYrAuSBbEr219OddS5cjti4Q
        P97/urg/44WDD5JlpbEPkLA=
X-Google-Smtp-Source: ABdhPJxb8DxHTfIf0CGlkUjUIP0a+fO0BK/QvPiyhQ29jLhC1bArOGeK5zBXU0vqt51tk3V7nQ+myg==
X-Received: by 2002:a17:902:900c:b0:13f:974c:19b0 with SMTP id a12-20020a170902900c00b0013f974c19b0mr42386170plp.12.1636006761921;
        Wed, 03 Nov 2021 23:19:21 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id n14sm3212646pgd.68.2021.11.03.23.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:19:21 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     xuzaibo@huawei.com
Cc:     davidcomponentone@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] crypto: hisilicon/hpre -  use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 14:19:10 +0800
Message-Id: <20211104061910.1505738-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a032c192ef1d..0f1724d355b8 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1177,13 +1177,10 @@ static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
 static void hpre_key_to_big_end(u8 *data, int len)
 {
 	int i, j;
-	u8 tmp;
 
 	for (i = 0; i < len / 2; i++) {
 		j = len - i - 1;
-		tmp = data[j];
-		data[j] = data[i];
-		data[i] = tmp;
+		swap(data[j], data[i]);
 	}
 }
 
-- 
2.30.2

