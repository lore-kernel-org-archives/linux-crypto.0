Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6BEC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 07:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23D0A64F84
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 07:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhCLHoy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbhCLHog (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 02:44:36 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042E4C061574;
        Thu, 11 Mar 2021 23:44:36 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id x10so23404703qkm.8;
        Thu, 11 Mar 2021 23:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rjn0Pz3RzJWBncUJzOzdy1sylD8mz24+3HjRzAckFMA=;
        b=eXstlHf43HalrgSZAtsav0+dbeIzwJwS1gKzNPHjvCvtr/VNzZuSb4Y/HqbPWI7Vk1
         K56hhNxr6xPZpwPR0W6LRFMFCr8bQxYmxEhst48vtR5PlmabL8+U7ftmE3EIFC5CcLx7
         ieL6mOxxytO1Wde2yeMAebMy6wdcT2RrLbDK+bsT6tE4GTRtVxpWnFUHUDRe4EkhIV+l
         uVXI2cyRoxAx5LSNz8pLc0uelADRjVbH7+XUgBcC1TBoyIOiVOfOxq7JzU+iFQk3H1uy
         1t9EPaWb3gh4pD2CisqPltkL4M15fJvUbCs0BEv9rjsGErIZxXlEaPTmn6eMzfc7m4er
         lQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rjn0Pz3RzJWBncUJzOzdy1sylD8mz24+3HjRzAckFMA=;
        b=UEvpofisE1YlFDr+ZjYjyaVByXMGO2IWbPNA3RwNWEpQrb7mFFJG/1r2BhGFssG/xd
         H9M97skxbicv1msuqsUYgS6v9fzA/PpezEv+KIqbgAVv5gG+pYU02Et5AlZVWBOHbIBC
         jcMJ+5sz7fYVlXeqX18ILkedl19P0btaE05oKHa4dCiDKpElMzxjEYJTrel5GFz/WBwN
         FU+gfjNlJR+3LBy7ENm14UWuG78gnwbOkV7uXuHF2ncI+X0p4UFRkTo5ZgwWH3spRPGn
         ePnNrjoTvHDrWrT7P+EARvKS/Hmo1hKku5NtV/Fo+9N/VrYGQyan3XZa6E9Sl+5snqo0
         h0fQ==
X-Gm-Message-State: AOAM5309Rddz2QaQUxt77YR6MgCPI/hzVBYubPToIFDLGIdAAhtrTYDg
        dCFldTPeQSS1On+1xFuwsfA=
X-Google-Smtp-Source: ABdhPJzLOkcNp8XM9H2g2JVp3FDQKKCLP9oVuTUlvW9W8f8onq0zMMHjrNVfONT1asXt42pruf1ZOA==
X-Received: by 2002:a05:620a:45:: with SMTP id t5mr11703161qkt.17.1615535075131;
        Thu, 11 Mar 2021 23:44:35 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id e2sm3434089qto.50.2021.03.11.23.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 23:44:34 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tong Zhang <ztong0001@gmail.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: qat: fix couple crashes duing error handling
Date:   Fri, 12 Mar 2021 02:43:56 -0500
Message-Id: <20210312074357.2384087-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are a couple of issues in qat error handling. Those drivers tries to
release resources that is not initialized. This patch series tries to fix
crashes caused by incorrect error handling.

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

