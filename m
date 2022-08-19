Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0CBC25B0E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 06:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346548AbiHSGJE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 02:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346458AbiHSGIf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 02:08:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487472E687
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 23:08:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z20so4421671edb.9
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 23:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=yl5HiiR2MPe2XyH1/doPUo0B2YDbGGjz3okpkZe5cBw=;
        b=Pum09WMTwwxEjt2KUmuHdzsnw7jsrL2CGGbZKHZtJltod/goEUD2MgIyKf/4WJV/T1
         cQz+JQmSIefTBwgyBfj5ouRMUurR9EDpUbMaGkIvzowZYpIf2JJ+KaD/CFkT7p1XtUmF
         w6FA9YMnMGjmaO+g5lfrO6RSNhpxTXzwncFD7ZQs9lQ7hKOU03Uu3zlKw907272MIrTO
         sZOoeR2QMYVYCRsXW5Ba2ThEarlsMGTpqqpg2NaXx+6oyk79f3Sdib9TaK6yMfKinuwU
         z7D8O8/Nu0ARAFM1SVr8uFuwVGQk+DM0+9q+UCuiGnS5rKb1qp3HX3GYi2vptAUb3gpg
         meJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yl5HiiR2MPe2XyH1/doPUo0B2YDbGGjz3okpkZe5cBw=;
        b=mMazIhMf9SLbLCtV9+Js/ICPVbXrVayXyPyarl4vc4tZuGrGI+xo92irFYuLnHgEQh
         JEUaTunUbQ/FqqLEZfXpahdh2nBoHVCHk5qtbDQ/Hfs9woj8wIlWcQzRGAgK8iTVK4HA
         lgO+BH8zJ7YTuWziX1+b+mSSa2nvv3fwyrYkA6hflc9tzAwL/QFAqEW/RYC5k03FZWRe
         /wjQDMC5BNSQLHjDKEJ8xNUEbXOj1EoGtUOGVLyR9tj3PYzhlu3QEju0cAu0Yt1k+sl0
         pxxKwnF2sZBlIJ/gC+h7IJvPDQPRHbq2BJhNNht68NsZ79HzWxqW+nlM5J0kARKK+v0e
         UV4w==
X-Gm-Message-State: ACgBeo1I6Xy6go9rbjwOjfz90AVt3tjcnvDQn3oF2htdX7ovw6Un224s
        ELZSc+DNJYnO35LDvX5HBSyFsJqnW8TwJRnp
X-Google-Smtp-Source: AA6agR6owE29frw+Rwu3yMsFrK1lO2my17nU39OeqLDkxjzvWeYJxzu4oKmOGSnitPmZDiyCB61g2A==
X-Received: by 2002:a05:6402:1d4e:b0:43d:9822:b4d1 with SMTP id dz14-20020a0564021d4e00b0043d9822b4d1mr4910403edb.212.1660889302387;
        Thu, 18 Aug 2022 23:08:22 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:143b:fd00:5207:8c7f:747a:b80d])
        by smtp.gmail.com with ESMTPSA id y14-20020a1709063a8e00b0073a644ef803sm1809660ejd.101.2022.08.18.23.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 23:08:21 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-kernel@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 12/19] crypto: ccree: Fix dma_map_sg error check
Date:   Fri, 19 Aug 2022 08:07:54 +0200
Message-Id: <20220819060801.10443-13-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819060801.10443-1-jinpu.wang@ionos.com>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dma_map_sg return 0 on error, and dma_map_error is not supposed to use
here.

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 6140e4927322..9efd88f871d1 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -274,7 +274,7 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 	}
 
 	ret = dma_map_sg(dev, sg, *nents, direction);
-	if (dma_mapping_error(dev, ret)) {
+	if (!ret) {
 		*nents = 0;
 		dev_err(dev, "dma_map_sg() sg buffer failed %d\n", ret);
 		return -ENOMEM;
-- 
2.34.1

