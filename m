Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95A4C00140
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Aug 2022 18:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiHBSz7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiHBSzr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Aug 2022 14:55:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C44140F3
        for <linux-crypto@vger.kernel.org>; Tue,  2 Aug 2022 11:55:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso6516679pjh.6
        for <linux-crypto@vger.kernel.org>; Tue, 02 Aug 2022 11:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=z6YOAbeOZEs1MBBf+w9QW4hYsp3caV69mYkSKHQ/2TQ=;
        b=ZTUncLsSJVThOeuuCQW326smIKVVrW1Fa/gxz87xVQmlkUAR2mqql9vnUDMX7T0Pbu
         AxFA3I6qwAzNHmrHlsCzMChD5TJt1CVI+CGhlHmK+GvvnjtAe5qHNm7ucZNgpoT6eOn5
         4ZC8/ruhVXEbs7a/1hI5943gZOAM93FT1XUkdSn0+E10TdhLc3Omaq//W8YwjfOaXJ7h
         D2aOCtERQ40RdTcf1X8MZYjr/ZvPVVHQ95sQHQ555KOthe0rb9Z0iSjaS3uhB0xIVcm1
         MfG4vgdWtMQMrDrjpikQSgyKXmxyNEmfNYh+UKnVvN++tjYFAUEAdrmyz4M9uYYlxKVu
         Vk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=z6YOAbeOZEs1MBBf+w9QW4hYsp3caV69mYkSKHQ/2TQ=;
        b=yK/czsWp/n5dIU2IV3indzuQQ3RfWprThzZh0ALdXLh+nFzMIG7rEOsRUR8KK4iCUE
         hCdq6rUNO2p4xNdC2rPHGVNrYqaaE0wtW9KtKeW1VP8Su6oWx6+w1WY5WA/hKW5v79AZ
         GVNzRsN74hdHr1rrGqBmXRbWHCPd3cg+r457Z48QpGJZ4z4+u+DQwiaKlkRZt4s7E2ax
         MGZ6lr/+bODCB+VHgaK/TkxO/NENAxUaV3dSFygyBRnSH7IzDigFr1H30EJrza5/IlIw
         /bKQ8//l3Phd1G+iFKIqYCoXBs2YqV/QAHU+eQ7zyWwZn2pHEBc6QOL/IUPNtoPdMJN/
         viSQ==
X-Gm-Message-State: AJIora8SElpZLfo8UHUW9XtTB8+lEYHmbz74IwbtvRLlx/6Im5qTNgJN
        773sVWJ6+Mw0VxabC5WAgB3u9ISs42g=
X-Google-Smtp-Source: AGRyM1t6fClii7zpegnV02vPW+r4wyiAPzq9rJA8TINHaXWJZhY3vSYkv3E75sTG2cFO2YcaZim0tu2J85rf
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a05:6a00:8cc:b0:52c:7ab5:2ce7 with SMTP id
 s12-20020a056a0008cc00b0052c7ab52ce7mr21578935pfu.28.1659466543879; Tue, 02
 Aug 2022 11:55:43 -0700 (PDT)
Date:   Tue,  2 Aug 2022 18:55:32 +0000
Message-Id: <20220802185534.735338-1-jackyli@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 0/2] Improve error handling during INIT_EX file initialization
From:   Jacky Li <jackyli@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the PSP initialization fails when the INIT_EX file is missing
or invalid, while the initialization continues when the OS fails to
write the INIT_EX file. This series handles both cases in a more robust
way by resolving the file read error as well as throwing the write error
to the caller.

Jacky Li (2):
  crypto: ccp - Initialize PSP when reading psp data file failed
  crypto: ccp - Fail the PSP initialization when writing psp data file
    failed

 .../virt/kvm/x86/amd-memory-encryption.rst    |  5 +-
 drivers/crypto/ccp/sev-dev.c                  | 52 ++++++++++++-------
 2 files changed, 35 insertions(+), 22 deletions(-)

-- 
2.37.1.455.g008518b4e5-goog

