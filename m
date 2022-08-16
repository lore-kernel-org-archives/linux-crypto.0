Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804E3C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 19:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiHPTcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 15:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiHPTcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 15:32:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F123887084
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:32:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id h13-20020a056a00000d00b0052de2e258dbso4098524pfk.7
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=lnds6ny2TNE2xsTeBwgr2LZaFGS1qTR6zkBwE36ZPac=;
        b=n6mCgX9AA0fSKZgignFSTauJfNPKQiqQKj5oEO4y/re7xpeWAyuaHIq4jY64/1U4TJ
         d34doOwJgPRR5UnG76B4bPe6tNyDhWvJDVIO8V6uEwqbyNiRePCPPKcpXSomddMnYU4U
         fK+Dz+oRm6wix+ijA4slGOFe51rhYdXcWUsZCE8Mbq9gfoAd8ERCu+paFKuQ+8xZSPmH
         8e3L6UVOpLrEw/PKRzmlxC1UWZQ8d5/RiWuvLRY3zsRgvly4IdminDhZV0t15LIHgfqj
         4BWr13wZFNM5lW2BiCEAyLrjjvvRD9xDGSw71YrdWcBKKk0wx9mZVgUtp2yXgpW2suPw
         0gkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=lnds6ny2TNE2xsTeBwgr2LZaFGS1qTR6zkBwE36ZPac=;
        b=QQsBA7o9sOPDXMoNpg2YaxP8GNIlGUQuvXwAInl3N4HuAFr6nu458dZ156B7XmhOZ6
         SAnAjdNkjh/CDRp0T6ImbPWgsZddFfO8MX3GTwU/nEImoRCoIPKJZFf3Q8a5OiA0/PFL
         i6ajDtH9DiYM4kLgELa5o9jbCHUsRyhfwblJ/egPFpcWU2Drvq3dKasGYIjTCsq+fM49
         c+aDYARibJVpRditdsLptas5u7KC8MCOZjSftkcrxm/wlxoyVXVEePTAubfKPj3DBCR3
         Ga2vRWofQ8Yudzy000LowVzsucMMQg5lWTkKo75nCrPTsvqycrh2EUt5lXA2n7fLW1YE
         GMCA==
X-Gm-Message-State: ACgBeo36eMvuwLcRoAfWKUqO8P07K6JejyvyKeuZso+3UTWkrkLgHxSQ
        EwhZu1o0UZNiRy/oBDc4yMUG4Bl0fmo=
X-Google-Smtp-Source: AA6agR4Phdgs3HsIXQvZUmZfFPGRrsUMqjfDu9WtYjkDvvD9fRiG4P0AsOjUwr+M+wjvgodXKT6WNeXe3D9c
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a17:902:f686:b0:172:8c44:8e94 with SMTP id
 l6-20020a170902f68600b001728c448e94mr2806567plg.157.1660678341448; Tue, 16
 Aug 2022 12:32:21 -0700 (PDT)
Date:   Tue, 16 Aug 2022 19:32:07 +0000
Message-Id: <20220816193209.4057566-1-jackyli@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 0/2] Improve error handling during INIT_EX file initialization
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
---
Changelog since v1:
- refactor around __sev_init_ex_locked() and fix format.

Jacky Li (2):
  crypto: ccp - Initialize PSP when reading psp data file failed
  crypto: ccp - Fail the PSP initialization when writing psp data file
    failed

 .../virt/kvm/x86/amd-memory-encryption.rst    |  5 +-
 drivers/crypto/ccp/sev-dev.c                  | 62 +++++++++++--------
 2 files changed, 39 insertions(+), 28 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

