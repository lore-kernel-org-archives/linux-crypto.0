Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7221BC388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E2C21582
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753946AbgJWTWG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 15:22:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45052 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbgJWTWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 15:22:06 -0400
Received: by mail-qk1-f196.google.com with SMTP id s14so2226351qkg.11;
        Fri, 23 Oct 2020 12:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t6coSryefsb3ak8Nuc7NVKsRwzzU7GO9O3ZnHo7ZcNg=;
        b=h+AxWE8yWqy23u2MIbIDNUNm/7HuECev6jaeoKKWrTqVrmYUuaJvQBjQgLfHiScRtP
         2XtWyuRiI4JmWe1VMhhV/dyTJN/EPVl80v8Md64312hgUJqj1zBHQB+OwmPlqK5Lrf5M
         IuUHnhyMLHqIiurnzfPWWCnBEAW+WRURjV5aYaX0BlrhmMNDuSMxl44RzLQElhI3Ille
         OdPBXbCZ0+gVojZHrvX1tEKMaD9IfDO6hxuZe4BKDURIiSqxINXPxyXAd94SKXm1xU6n
         iGKo72KTqExXzH7Ldk1TPmAvNH/un8JH7MFR1RTGwA9tscWyAvWErySN90lHrSkdtNWY
         l6Ag==
X-Gm-Message-State: AOAM533QAgKfN1zN/B2Khv78RH6nhpDDSApxcURyf1J8Lw9AN1FYiuyR
        vvN0HNjpWfQcmYTRGQWMf9+VMzE1Ihhhcg==
X-Google-Smtp-Source: ABdhPJwWpHtO1IsK1G/zRxMYsmViv/Vym8k2zV/eJh+ZHvp/S6mBwvs2KzoQROOCukQdYyDLyqkrQg==
X-Received: by 2002:a37:67c3:: with SMTP id b186mr3721945qkc.26.1603480924992;
        Fri, 23 Oct 2020 12:22:04 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id n199sm1398493qkn.77.2020.10.23.12.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 12:22:04 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] crypto: lib/sha256 - cleanup/optimization
Date:   Fri, 23 Oct 2020 15:21:58 -0400
Message-Id: <20201023192203.400040-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch 1 -- Use memzero_explicit() instead of structure assignment/plain
memset() to clear sensitive state.

Patch 2 -- Currently the temporary variables used in the generic sha256
implementation are cleared, but the clearing is optimized away due to
lack of compiler barriers. Drop the clearing.

The last three patches are optimizations for generic sha256.

v3:
- Add some more files to patch 1
- Reword commit message for patch 2
- Reformat SHA256_K array
- Drop v2 patch combining K and W arrays

v2:
- Add patch to combine K and W arrays, suggested by David
- Reformat SHA256_ROUND() macro a little

Arvind Sankar (5):
  crypto: Use memzero_explicit() for clearing state
  crypto: lib/sha256 - Don't clear temporary variables
  crypto: lib/sha256 - Clear W[] in sha256_update() instead of
    sha256_transform()
  crypto: lib/sha256 - Unroll SHA256 loop 8 times intead of 64
  crypto: lib/sha256 - Unroll LOAD and BLEND loops

 arch/arm64/crypto/ghash-ce-glue.c |   2 +-
 arch/arm64/crypto/poly1305-glue.c |   2 +-
 arch/arm64/crypto/sha3-ce-glue.c  |   2 +-
 arch/x86/crypto/poly1305_glue.c   |   2 +-
 include/crypto/sha1_base.h        |   3 +-
 include/crypto/sha256_base.h      |   3 +-
 include/crypto/sha512_base.h      |   3 +-
 include/crypto/sm3_base.h         |   3 +-
 lib/crypto/sha256.c               | 212 +++++++++---------------------
 9 files changed, 76 insertions(+), 156 deletions(-)

-- 
2.26.2

