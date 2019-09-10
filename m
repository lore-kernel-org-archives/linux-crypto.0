Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79048C49ED9
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 23:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4323B21A4C
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 23:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d1fze8HN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfIJXTa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 19:19:30 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:46323 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfIJXTa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 19:19:30 -0400
Received: by mail-wr1-f50.google.com with SMTP id d17so9614778wrq.13
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 16:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SXqvufRx22Snq4CxB9/c8WHZDNZ5MvJ2HzCzsXJqgHM=;
        b=d1fze8HNJ26w372C7MOYSl0YeOaaQILdmYBO7wYoFgSxcXpHBbR34WKtDC+CZBA8oW
         hzVUtpxkmbGLc+gVz/0BJkN6I5oHEKF4b0hJh6xD2qRuSxqBU5d4Tme9MnewwhIYSgYY
         ICTkBMjee+VVdvZKRhEEs4q28XXfEwca/0PJn4eRKJmFo9F5u2u8sLW5m9jP8gZTND6Q
         zo2soetshVnRVzSSOZ4fMMx0yNOVovfVWSBWsehLNJdeuezamtQaXKscWkAvrP0/7ukr
         6KrJvq3hptbx+97kXW8IYpaNqsZdeAhsZWTDbKUW4I2F0wgVueb5FavMUrh1QfVGVdnj
         iFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SXqvufRx22Snq4CxB9/c8WHZDNZ5MvJ2HzCzsXJqgHM=;
        b=szxoasXflbuqQ/5DvdfFAFSKVgjM3aOyVItCWNqsTGkXp0Zuuy2LLHN0AbP5HFCbWs
         7EE//ZmKqQv5v1vaAkjB/lSSHvSPlGcEgtF8HAcTKuCDk5OErgCBptJNyXIsWgt0B69z
         CkJEepcHnMNricPGcVa7ltYCxcf2YRkxcAqMFqwBzKtMbI2FOmO0C4F7zIPX2PRAZL4R
         FT3+yTtfSxrfsqKUtLnqJ9a6Qw5NRK2zaVUV+ogvcUYOxUPEZNbVyZNaVgZSx0Bj4SXh
         Vv+rSYVunXF6aJHuFK0nxjv6hrDaCpKNgLps4xznXXj2bk6bbsqDmz+IEnVPzBU4x8rl
         UaRQ==
X-Gm-Message-State: APjAAAXXfEP1RqTn/1fmVrr18Dvf/3mT1RcASYA61t4P/WWx2h0ww+IP
        IaqdQ2C/9ROOkfL3NYqPEPviqwRUzabXznSl
X-Google-Smtp-Source: APXvYqyWtnl6Kb4GtaRJecmKRxkjIVDfunGlWD24PiMglBNoCWz0IXGtn1ox7W76gE/Y95a5RlizNg==
X-Received: by 2002:adf:ef05:: with SMTP id e5mr27760313wro.127.1568157567583;
        Tue, 10 Sep 2019 16:19:27 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id y186sm2137846wmb.41.2019.09.10.16.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 16:19:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@google.com, marc.zyngier@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto: faster GCM-AES for arm64
Date:   Wed, 11 Sep 2019 00:18:58 +0100
Message-Id: <20190910231900.25445-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series reimplements gcm(aes) for arm64 systems that support the
AES and 64x64->128 PMULL/PMULL2 instructions. Patch #1 adds a test
case and patch #2 updates the driver.

Ard Biesheuvel (2):
  crypto: testmgr - add another gcm(aes) testcase
  crypto: arm64/gcm-ce - implement 4 way interleave

 arch/arm64/crypto/ghash-ce-core.S | 501 ++++++++++++++------
 arch/arm64/crypto/ghash-ce-glue.c | 293 +++++-------
 crypto/testmgr.h                  | 192 ++++++++
 3 files changed, 659 insertions(+), 327 deletions(-)

-- 
2.17.1

