Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A078CC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 08:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F9D64F4D
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 08:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhCSIib (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Mar 2021 04:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbhCSIiA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Mar 2021 04:38:00 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BABC06174A;
        Fri, 19 Mar 2021 01:38:00 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r14so6133782qtt.7;
        Fri, 19 Mar 2021 01:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yKlBzjsmalMxagUcPn6gsX8yhtux5LQjhfJg4k1uWCE=;
        b=MxPfUiOMlgGwzyRGjACs17Xc/m+IE9g9ox1iPwTdJkyjTQvIt8V3Kn3qNddiSsmVCs
         wjhnGUiIT2NiwbYaCTwaqAqKhLz0tW4HPc96Hae3BMOucoT5TQUNzIj1h53KEpabVSam
         FktDVFYxfnP/hlHrOiECiXimoIxQUX+L6k9inpYIEdXMvK0/dofniPnzhwj566vJ6Oxv
         cSZH2xNiAmULEqlHCsAJO+INd3IuBMYI/h+hdIf2+TS9TijK0iRNi0n2Ok3vSKs4fBFM
         hXicccjN9yJl4L4aS9+EFxIpVlsFe069+zMiYMJPuWqBRTW42DgW8RsM8KNeenHyHBSn
         3ysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yKlBzjsmalMxagUcPn6gsX8yhtux5LQjhfJg4k1uWCE=;
        b=f8XTf10fLDDpiWYahxQCLYyz88mVKOSZYQZtwo2yRcauQ7388+75xEuuXOttLoxwjA
         T+CKv8eIvMKtnyKj2C/Z73t8e96V2hXvWMfb0ouJvihPOT7cx5ppPD0u313syN5vDlnP
         gy62rb3W5XNOp5nat4jHagg6VguDqg34/ZCmuIGV0NavZyNDKDkKwVZZXqANwc5hXMS6
         QgSHM4YbZIz6IzDjZkBmwqlKVMaQ003VLRu0ZrPSbvGQ2L72cH9m4qhZTiwE6FM2DWJI
         94joTEmNdaeyv/eOfMmMXse0ZoRpL0iDLczYT5ZmQi9W5M8cTli1bZAd8u56s2xumDA6
         +Dcw==
X-Gm-Message-State: AOAM530S1yzikbQM66j289o5NT6CmAbu6LtGjYJ/45IPW7CRWO+4siyg
        dvuDnobP9/2OmFrq+31OPMA=
X-Google-Smtp-Source: ABdhPJwzMoQb6Hgb62zWAt6JnRmK+l7JVchkRRJf9mTlxmUBgV+4Jcjm1KKkP7UNGJsOiXOaWj7t+w==
X-Received: by 2002:ac8:3984:: with SMTP id v4mr7488944qte.90.1616143079830;
        Fri, 19 Mar 2021 01:37:59 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.87])
        by smtp.gmail.com with ESMTPSA id c73sm4092270qkg.6.2021.03.19.01.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 01:37:59 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     dan.j.williams@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yuyufen@huawei.com, songliubraving@fb.com,
        unixbhaskar@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] md/raid6:  Couple of typo fixes
Date:   Fri, 19 Mar 2021 14:05:40 +0530
Message-Id: <20210319083540.31016-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


s/boudary/boundary/
s/compliled/compiled/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 crypto/async_tx/raid6test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 66db82e5a3b1..c9d218e53bcb 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -217,7 +217,7 @@ static int raid6_test(void)
 		err += test(12, &tests);
 	}

-	/* the 24 disk case is special for ioatdma as it is the boudary point
+	/* the 24 disk case is special for ioatdma as it is the boundary point
 	 * at which it needs to switch from 8-source ops to 16-source
 	 * ops for continuation (assumes DMA_HAS_PQ_CONTINUE is not set)
 	 */
@@ -241,7 +241,7 @@ static void raid6_test_exit(void)
 }

 /* when compiled-in wait for drivers to load first (assumes dma drivers
- * are also compliled-in)
+ * are also compiled-in)
  */
 late_initcall(raid6_test);
 module_exit(raid6_test_exit);
--
2.26.2

