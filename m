Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02198C43141
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16D00206F0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gAWOwtuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfKMSZX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:25:23 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41392 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfKMSZW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 13:25:22 -0500
Received: by mail-pl1-f193.google.com with SMTP id d29so1407365plj.8
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 10:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pwxLXS3yTtk2YEMUUCjQyP203hwLsDnQtk6QOIH+hQ=;
        b=gAWOwtuF3lIquOQlfbbubJi3yzRbCWqpkHyHpURP0xiyYdIGDhL2M6a0HVtr6b0Nee
         iacrhyDyGnXJrOQU5Ea08GGqdbt5SzT6nFBJ478ifj6tfAWTrf9E2dhS4CHCo0FG8GrC
         H4ilLZIILSpwzFdlRVRfzIEJreuOREzxlUFVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pwxLXS3yTtk2YEMUUCjQyP203hwLsDnQtk6QOIH+hQ=;
        b=bLToLewGS5MF5dx8Hdq+L6xEhr+kvuNb1Is1q+VT6iWBE8XifudJnh2a32BQT765DY
         eRtJby+GqOFHps8njVMn0rY3ISJ2rywDsi2BB1PKi0q2wjBVpXeqo/kxN5Sc0waRcID1
         OX8NBco2vf2HzVkqw+QFOs4rXOndc3Ab1BDWOTVosO1a5lzMEicmrecI1S4WVl4z3mnD
         stD4OBGEl39hE+Hgt6ekom/MI1fNp6xBQKyTLYiYwT4/PA904W4Rb2iAQkPwVW8WYbgt
         uxeYKuuQS60jOpMtB0aypLugtp96NR4pxacU7c0JbwDMY0vBTCrZTPIVNG5TgaTnS6CN
         pXHg==
X-Gm-Message-State: APjAAAXgEsNs93DlS1iEeDhAu6NKwHO01vD+LoiQsqV746oKYKCsVLrC
        jION5vOY3IgC3/yLx1CofxVuWG84dWo=
X-Google-Smtp-Source: APXvYqzFyWMtneWFouUDOfR0m5QsWLsUNEWASLVCp8b8qDMIjhCm38Rrg4qYd8K/ZGfuwpWmWeHLcw==
X-Received: by 2002:a17:902:8a8b:: with SMTP id p11mr5284252plo.152.1573669521942;
        Wed, 13 Nov 2019 10:25:21 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r13sm4130991pfg.3.2019.11.13.10.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 10:25:21 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v5 0/8] crypto: x86: Fix indirect function call casts
Date:   Wed, 13 Nov 2019 10:25:08 -0800
Message-Id: <20191113182516.13545-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v5:
- remove macros entirely and switch to declarations with common prototypes
v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org

Hi,

Now that Clang's CFI has been fixed to do the right thing with extern
asm functions, this patch series is much simplified. Repeating patch
1's commit log here:

    The crypto glue performed function prototype casting to make indirect
    calls to assembly routines. Instead of performing casts at the call
    sites (which trips Control Flow Integrity prototype checking), switch
    each prototype to a common standard set of arguments which allows the
    incremental removal of the existing macros. In order to keep pointer
    math unchanged, internal casting between u128 pointers and u8 pointers
    is added.

With this series (and the Clang LTO+CFI series) I am able to boot x86
with all crytpo selftests enabled without tripping any CFI checks.

Thanks!

-Kees

Kees Cook (8):
  crypto: x86/glue_helper: Regularize function prototypes
  crypto: x86/serpent: Remove glue function macros usage
  crypto: x86/camellia: Remove glue function macro usage
  crypto: x86/twofish: Remove glue function macro usage
  crypto: x86/cast6: Remove glue function macro usage
  crypto: x86/aesni: Remove glue function macro usage
  crypto: x86/glue_helper: Remove function prototype cast helpers
  crypto, x86/sha: Eliminate casts on asm implementations

 arch/x86/crypto/aesni-intel_glue.c         | 45 ++++++-------
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++-----------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 74 ++++++++++-----------
 arch/x86/crypto/camellia_glue.c            | 45 +++++++------
 arch/x86/crypto/cast6_avx_glue.c           | 70 ++++++++++----------
 arch/x86/crypto/glue_helper.c              | 13 ++--
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++---------
 arch/x86/crypto/serpent_avx_glue.c         | 72 ++++++++++----------
 arch/x86/crypto/serpent_sse2_glue.c        | 31 +++++----
 arch/x86/crypto/sha1_ssse3_glue.c          | 61 +++++++----------
 arch/x86/crypto/sha256_ssse3_glue.c        | 31 ++++-----
 arch/x86/crypto/sha512_ssse3_glue.c        | 28 ++++----
 arch/x86/crypto/twofish_avx_glue.c         | 76 ++++++++++------------
 arch/x86/crypto/twofish_glue_3way.c        | 38 ++++++-----
 arch/x86/include/asm/crypto/camellia.h     | 64 ++++++++----------
 arch/x86/include/asm/crypto/glue_helper.h  | 11 +---
 arch/x86/include/asm/crypto/serpent-avx.h  | 36 +++++-----
 arch/x86/include/asm/crypto/serpent-sse2.h |  6 +-
 arch/x86/include/asm/crypto/twofish.h      | 20 +++---
 crypto/cast6_generic.c                     |  6 +-
 crypto/serpent_generic.c                   |  6 +-
 include/crypto/cast6.h                     |  4 +-
 include/crypto/serpent.h                   |  4 +-
 include/crypto/xts.h                       |  2 -
 24 files changed, 409 insertions(+), 473 deletions(-)

-- 
2.17.1

