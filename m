Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B926CA9ECF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 14:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 134082085B
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 14:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0G3CKeV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKAOhv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 10:37:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42051 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOhv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 10:37:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id a15so9857738wrf.9;
        Fri, 01 Nov 2019 07:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iDATA8UWRvuERkVCUo3sHEhaiMy110+5RvXbe9baKYQ=;
        b=a0G3CKeV4eMZvWvCK5eajXp9N4sKVrGEqIPZIYw5GZOswevSnjtindYVUVrXWrfMRI
         JMacgwry7FiP4VCmUhiWGkaZ7f5bYkxpt6lmdx9etuDNCo+14TpcACqzVVa4/DNbA2Cc
         u2HwS6yoKafmZPP1oXL3o/PX4qHIUjL7lD57BUhUCBW1+5XV7+xsRBMAWZxdRR0YRnlr
         Ozd0YULIoCcc2kgF/ro8ZBKfFyYnMIVVPc1E2T9lHoD9OmA5SEpxixOZNTeZuE40uNmv
         nSLJTGmRLeaDjfJKZsAtEiEQ3MwLZ5m5vD+RDVHJTHeHw3tQyaVNAma4+kpQ4ijcIdga
         aCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iDATA8UWRvuERkVCUo3sHEhaiMy110+5RvXbe9baKYQ=;
        b=QBumv39ek7fAScvDwQV2PSW1W7X9CEU3RXeKNSVaBDxeO0O/DK29rNPVbtZZsd0Agh
         6t0hT4ORdP/HLm5ikCw1E7AAY3lFu1M35QwQzDrp+5/SWv/K/KU5MZwOFPc1/9PaLnGB
         VGS/NGhnjUS5xbiQUG0eZAvtbr5vgqzkkI/+SydpXXmKjBPmMLlEV6VeEjDzeZYsojDq
         TScZOHi7JXxQQK9SfpwpNBIkjSU6X17Rf1osi9Glq3KX8fkf7PgwQZ2W/Mo5APcx1A34
         DJu0RXhqgLgtJYHVqF1rexy+JBC63sijK4GpQiXOWMugqVHx8ldV4fdMT52xGbfKnLlP
         GNxQ==
X-Gm-Message-State: APjAAAWjAI/rKW9lOWu42XKZFxEQL0Ke9JbI4CJouxrreKlUDnqhXk9I
        kwLxIryKfI9n/fkIIABwR2o=
X-Google-Smtp-Source: APXvYqxloXtQEEYKf1fFRXMPDxsO+UU37rFFsC09iEeQtHTMIAJRov+wc8xL1bAUgPxg3x3FNI77aA==
X-Received: by 2002:a5d:4409:: with SMTP id z9mr6610626wrq.22.1572619069481;
        Fri, 01 Nov 2019 07:37:49 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id q9sm1824816wru.83.2019.11.01.07.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 07:37:49 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] crypto: inside-secure - Add missed clk_disable_unprepare
Date:   Fri,  1 Nov 2019 22:37:15 +0800
Message-Id: <20191101143715.17708-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

safexcel_remove misses disabling priv->reg_clk like what is done when
probe fails.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/crypto/inside-secure/safexcel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4ab1bde8dd9b..24c0f2404ec6 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1623,6 +1623,7 @@ static int safexcel_remove(struct platform_device *pdev)
 	safexcel_unregister_algorithms(priv);
 	safexcel_hw_reset_rings(priv);
 
+	clk_disable_unprepare(priv->reg_clk);
 	clk_disable_unprepare(priv->clk);
 
 	for (i = 0; i < priv->config.rings; i++)
-- 
2.23.0

