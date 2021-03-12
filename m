Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1106EC433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 14:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD66064FC3
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 14:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCLOTa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 09:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhCLOTW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 09:19:22 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D305EC061574;
        Fri, 12 Mar 2021 06:19:21 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id z190so24324269qka.9;
        Fri, 12 Mar 2021 06:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2lLjuJgP8lOK4MI5nLO2L65shA5V/1M4EFdiOtepY2U=;
        b=dbboIclKftDQQTUV64Ype0fTVNQSoWsc2CCCIKnGeVz4hX5Po5hJS9Lf7OLndh9OdP
         aX1y2+yc8bJOb5xd6DC13Q97qo2G9AkikrN6RjWJABDIf5FZpGDuaHVsinsT/kZvejbU
         2P84h4E9ZpT4ARDcucD86gCfsS4QPazUzJIEnVvl4LZSnh8L98JOIHgkVwJ/kL5TG2oO
         PAsySDCxfU4xTxIKQ1gAgVk2rKB30hQdoi8e2zRPs08uEAOkmmDYJMS0oBpJCSp0AV1M
         9IBMer8HeofzreJlBaf+2NF4ZJ+m2l0V4Zh2UJ3HPAAPxnYWWG4htVZnUA3mrdK39rag
         qLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2lLjuJgP8lOK4MI5nLO2L65shA5V/1M4EFdiOtepY2U=;
        b=SgjEjrYcWcdjQ6H2dhmWEwhlPXiHkRPW65cc10EquPqtCecN+myKOt7HtdS+rmp5YN
         gWyBgxnf/4tLyw757CZYTutbHVqmEVCH9V8fhY1/bKHGW9SHnCYNpGn/ibJoaG+uJXpw
         0FdC7b0hrm7A5UAe0mLj+9W0GRB4G1cJuGJfUJR8XyYDQmIbzqjKUyQC9ppF/FeuqOtY
         an7bbMBm16mTPpPz9LcDajhCOapbQBFB3TxychDlEGUGypuQwOql9YkdWhyAiUQhSD7d
         PTuWLyzzZlC/p1zXhazUw+ourS6WKrBWUsrSbk1nq+gaATRoumcArjJ0fT2MJlwXZePN
         RC3g==
X-Gm-Message-State: AOAM531NAUZEsYt6gdcH+aozrhoBOVbDHhaZo7VlrPHd9jA9ksJECRQa
        4wwDMmefJtHgPup9aJTXu8w2T2mkkEaUUA==
X-Google-Smtp-Source: ABdhPJz62sN32HWPH2JjMurHUzuRlequ2y8GjBVkqx6qESWAGt+TmqEKFDKa2zez84rrsvxfQakQ3Q==
X-Received: by 2002:a05:620a:108f:: with SMTP id g15mr13001896qkk.298.1615558761015;
        Fri, 12 Mar 2021 06:19:21 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id v2sm3979478qti.94.2021.03.12.06.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:19:20 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/2] crypto: qat: fix couple crashes duing error handling
Date:   Fri, 12 Mar 2021 09:19:06 -0500
Message-Id: <20210312141908.2388121-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are a couple of issues in qat error handling. Those drivers tries to
release resources that is not initialized. This patch series tries to fix
crashes caused by incorrect error handling.

v2: removed excessive dump in commit log

Tong Zhang (2):
  crypto: qat - dont release uninitialized resources
  crypto: qat: ADF_STATUS_PF_RUNNING should be set after adf_dev_init

 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    |  4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     |  4 ++--
 drivers/crypto/qat/qat_common/adf_vf_isr.c  | 17 +++++++++++++----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c |  4 ++--
 4 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.25.1

