Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D199FC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jun 2022 16:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbiFTQll (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiFTQlg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jun 2022 12:41:36 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D16BE15
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jun 2022 09:41:35 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d129so10722163pgc.9
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jun 2022 09:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jkTNHHPNDGGLKc5xuzfd0bMYE5EZ7uFugnebxElHYkE=;
        b=lJfjRX54AwFeXLoGhQeV9HX45cEL1KaeT7uV6LpXwJa8LjpzJDZREV7rpz58VumB3j
         1yV4RYy8IZ0C0fXRRYOtJlso19RbP398lUNAYzoCn09nU/2MDjToktqfvVazznQYAI71
         Z5wLXkfWxB1posbAXHdMcWfCMnlvLZf+Fs9R5Ld13wO0+vtlSgDCyBFt5bvXAA/kNhzc
         PlbUip1nA+TLz8B4UrCh4GGYft5mflPEm5CrMEjCK3YkeDMFkifXyQeXnMCFSRx2HhEG
         F1K7KT9vL8IzPDRszGfYrEqMNzmVXfOEL30qz1qmi2P4hIz+B8cBarQQqb9ZFrwNgs/2
         aiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jkTNHHPNDGGLKc5xuzfd0bMYE5EZ7uFugnebxElHYkE=;
        b=saFlXGPoByA+JLVe8c+lRGggbLLJpydyWLh8eDeskqKhVHfzkDfZRkgDJN+S9DG/7q
         vJdtBlK729Xu1P5RgfaIggO+L9MQ26soAiXBvWT00e7LmUR809HNfmDNI0qIpui2Y+Xv
         3ai0QFzyueHHjSvRImTygT0ULcZR4wOGDkwA6AJ+cvttqh2VquGU3/DS6fQsrNJkazC3
         fdSdxvt9FxhTEEVhwTKUdWHTJYo67BzFHN2/a2AUAHRmnDB6h8hNoqGOuhR/MJ1BJw+D
         RJBVoj+nA7Eom0nHfdC9F/wPW0Kc9Fwhd5ByDK8PZ9eehNjC/+IJQAQpcRWxRPdX3Hli
         H2+A==
X-Gm-Message-State: AJIora9T5IKijt/gZRXbvLwhGohQKhpLpKj1Hw8kM5F3r3RCB3GKTqZ2
        D3DpaZEJs+KrH/9MW/gt65lC9vqqIK4=
X-Google-Smtp-Source: AGRyM1vViETO+yovezSx9wuYvllzoy/kW085ifKs+wzWPXb3BqO/qc2/6wAy5SdTa+RFS8cHOVeO8A==
X-Received: by 2002:a05:6a00:9a2:b0:505:974f:9fd6 with SMTP id u34-20020a056a0009a200b00505974f9fd6mr25189864pfg.12.1655743294207;
        Mon, 20 Jun 2022 09:41:34 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c11-20020a17090a1d0b00b001e6a230c2f5sm10677469pjd.34.2022.06.20.09.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 09:41:33 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     ap420073@gmail.com
Subject: [PATCH 0/2] crypto: Introduce ARIA symmetric cipher algorithm
Date:   Mon, 20 Jun 2022 16:41:25 +0000
Message-Id: <20220620164127.6380-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.

Like SEED, the ARIA is a standard cipher algorithm in South Korea.
Especially Government and Banking industry have been using this algorithm.
So the implementation of ARIA will be useful for them and network vendors.

Usecases of this algorithm are TLS[1], and IPSec.
It would be very useful for them if it implements kTLS for ARIA.

It is tested in x86 and MIPS with the tcrypt module.

The first patch is an implementation of ARIA algorithm.
The second patch adds tests for ARIA.

[1] https://datatracker.ietf.org/doc/html/rfc6209

Taehee Yoo (2):
  crypto: Implement ARIA symmetric cipher algorithm
  crypto: add ARIA testmgr tests

 crypto/Kconfig        |   15 +
 crypto/Makefile       |    1 +
 crypto/aria.c         |  288 +++++
 crypto/tcrypt.c       |   38 +-
 crypto/testmgr.c      |   31 +
 crypto/testmgr.h      | 2860 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/aria.h |  461 +++++++
 7 files changed, 3693 insertions(+), 1 deletion(-)
 create mode 100644 crypto/aria.c
 create mode 100644 include/crypto/aria.h

-- 
2.17.1

