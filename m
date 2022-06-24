Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEAEC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 14:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiFXOVr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiFXOVq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jun 2022 10:21:46 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7C9562E0
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2022 07:21:44 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id z14so2614678pgh.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2022 07:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gm1rQOK+mtphDI8kcI6bqB/QE5aGOSJgtL/42BhKW1s=;
        b=jUJmsfuxsGmBkBlz8uoOMKBsh5zii0b6kyo4UGtUZtRcVP/eQ62xEqx1yp+p9r2RBb
         u2iemCnlN5ab8kxb5/SqFbREuliur6+AHpIegfg+WDqRPMdn047nR2F7NvlJhsvd1PMD
         Y5WC0N1Lbcblf5BCO/LdQbFvxSpDg+1smsR2CBnsJqNZdMAgEj4e838L8oT8mGOPmTrp
         abBOMbDW5GPx6tR5LeTLMpQw5SPhBt4gz6b1Xf2A1hZj5JKu5TKfU85dfIvDQ2af6wua
         LLQMBgNXpWRRKmKC+cs1pvDP3w5oNoUw37bUO/t020HI4hc/1v4OYMkFXJ5eULRlVHI5
         IYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gm1rQOK+mtphDI8kcI6bqB/QE5aGOSJgtL/42BhKW1s=;
        b=B68Xei0q3AXYzebIdvo+p5f5ZosivZ8Fp9SIcE++iu4otZRsG/MtlZXdeDsCJdsVrI
         jyk4ddzNcraP3wIKHfNV9OmiN8UjsI+jtqTECSuajzWhSMXuG1q8iMMb9Hx60dPRDDL0
         sbk5PmijwjFlAAQW2slS3ANSV5f/ITOf2zr2n+bUEecH2pCfIjQ1jeOdRc+7EC7uCU0I
         NFPzllw++acnFwJEFUVMRNn1ontdMqQwSsoiwpOKpz1dLdDv2cFT1tveufPjv/ui/fsq
         IUWu4Q+uOT0omojbPZLGERgcJZzRwkqw00tSYzm0GAeM4jsSHIy6Z29OsmoN4d3BZgCA
         h/MA==
X-Gm-Message-State: AJIora9kQ0EzyXHIWOfCZVq75vMeM6hQ3maiNYlXgLROEwsRJ3yKP+L3
        QZyH9c4B9BTvLiDDGeorpZqK4g==
X-Google-Smtp-Source: AGRyM1vPxxwcqwbRahhD3wqTdZ41SZk38shzdGTT2AP7tkKnWCBBlZm8B6XghK3eFpJ0wOG6xCzgsg==
X-Received: by 2002:a65:6c10:0:b0:380:437a:c154 with SMTP id y16-20020a656c10000000b00380437ac154mr11854740pgu.549.1656080504253;
        Fri, 24 Jun 2022 07:21:44 -0700 (PDT)
Received: from localhost.localdomain ([199.101.192.196])
        by smtp.gmail.com with ESMTPSA id jd12-20020a170903260c00b0016a15842cf5sm1868877plb.121.2022.06.24.07.21.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jun 2022 07:21:44 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jean-philippe <jean-philippe@linaro.org>,
        Wangzhou <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     acc@openeuler.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux.dev,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v2 0/2] fix uacce concurrency issue of uacce_remove
Date:   Fri, 24 Jun 2022 22:21:20 +0800
Message-Id: <20220624142122.30528-1-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When uacce is working, uacce parent module can be rmmod, parent
device can also be removed anytime, which may cause concurrency issues.
Here solve the concurrency issue.

Jean-Philippe Brucker (1):
  uacce: Handle parent device removal

Zhangfei Gao (1):
  uacce: Handle parent driver module removal

 drivers/misc/uacce/uacce.c | 135 ++++++++++++++++++++++++-------------
 include/linux/uacce.h      |   6 +-
 2 files changed, 92 insertions(+), 49 deletions(-)

-- 
2.36.1

