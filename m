Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10820C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C255F65288
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCHUX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhCHUXZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 15:23:25 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D654C06174A;
        Mon,  8 Mar 2021 12:23:25 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c16so5441304ply.0;
        Mon, 08 Mar 2021 12:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qG07t7pQ2BE3mECuc5WgmJ0bVAVK/y04EepdaVjvc2s=;
        b=YJc4KV8b+keQ/bom7xZriile+cxCFaXsxvnGKPsml2OGlmAvdDMHMKTBIHRA2dH8aL
         CJvEt2F4qpsbW3ubKkDbl+T/OR8m1/ZhGJzzS0gP5sFPXDbGNvXBRSe7vPxePHLoaZ9O
         VGgvDFeDjnzXmkiJcLJucZEXJdhwrNSgYe/gqapdXB5smuDO7FVChnNqrGOCQ91AkMDt
         MW1XFUUS4mCtAXCx8OWqOvYQ/UV/FZ7c7h8X9FR/YyXlDbGqq3QnJ6sG2dZssLfwqY1Y
         7hRfeu1JIviDWPK9uVlYlvSNz5oMJ//P2G19cABMPTgJvpLnOZvzKtAMAlgoCwDbxfYF
         jTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qG07t7pQ2BE3mECuc5WgmJ0bVAVK/y04EepdaVjvc2s=;
        b=PWOsD5fPcylNoCSCSgkOQDbQX3rCYb6J8e7TzQQchWQMCkO3RC8/T/yxF+xU9pbcFY
         P0C2Lxp32HR05ShcBW6c0pcgzPVeYErzb97nsap8dOTPKSif9LK6yvCOyQ2HbGTIZr33
         pFWk4f458OnrkJ1FKXt167x+yHYDT8D+xFlmC3zFxRKEbcDiWOkY3CQRgc8LsmKhMFdE
         Pq89IaSVfuglTZ79gnJfJCbZsaQyj2zDMP4mtqkVWA/dSQzusJ8nZ00xWqjU6zP/U8dA
         jK9hj78nkccppH4YbPVON0fwQ2FWgnUEesEIUWQ07aMvaIrDb2sMhzGcS4wcMoE0eae7
         ufVg==
X-Gm-Message-State: AOAM533iJymXmEgEmlgHnYMTbpZ8q2Hqzwyh+ImByqv5K8wz46w/PYsZ
        eXrtP4/pvQaKFoNTE5iGVrg=
X-Google-Smtp-Source: ABdhPJzlgXaEwI72mV6bjB6rAV9vXtWjGHWPWbwF+Tv0h2yYpOjvArMeKvgkyoBjGAnNzFnX9Qe4rQ==
X-Received: by 2002:a17:902:6547:b029:e4:547b:77cb with SMTP id d7-20020a1709026547b02900e4547b77cbmr22316668pln.75.1615235004692;
        Mon, 08 Mar 2021 12:23:24 -0800 (PST)
Received: from varodek.localdomain ([223.233.103.31])
        by smtp.gmail.com with ESMTPSA id m3sm10262962pgk.47.2021.03.08.12.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:23:24 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Kishon Vijay Abraham <kishon@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] Update dt-bindings and sa2ul driver for AM64x SoCs
Date:   Tue,  9 Mar 2021 01:50:02 +0530
Message-Id: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Vaibhav Gupta <v_gupta@ti.com>

This patch series aims to modify necessary files before an entry for sa2ul
can be made in the respective am64 device tree.

Peter Ujfalusi (3):
  dt-bindings: crypto: ti,sa2ul: Add new compatible for AM64
  crypto: sa2ul: Support for per channel coherency
  crypto: sa2ul: Add support for AM64

 .../devicetree/bindings/crypto/ti,sa2ul.yaml  |  40 +++++-
 drivers/crypto/sa2ul.c                        | 133 ++++++++++++------
 drivers/crypto/sa2ul.h                        |   4 +
 3 files changed, 130 insertions(+), 47 deletions(-)

-- 
2.30.1

