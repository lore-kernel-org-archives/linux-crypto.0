Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961F5C5DF65
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6695A2173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E49WR0tT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKFOUJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:20:09 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44070 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKFOUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:20:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id f2so17100130wrs.11
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8BtBfv1f64XM22OKVAWg9tny4DrS6nBkaS+49knlZDw=;
        b=E49WR0tTA98/K0BeZ6M0oSIbi9GQHW7rjF+kMCUVzHyozP3/lL7cYzcwBrpA9XyEN7
         Za8ZNFOuagrVowQJcxkXIb174OEEKzGEMlYh1vAU6ZQpP9WFv4ipin+8kjFmkoI9OtlN
         L8HWJ/fMxM2iqV68MOxGBgy2o36VGLuQNZ7SFboNd4lvUkF2k+7R3nBBhJwNcEUUpWu0
         qPwioeoDTWgZ27bIvd0MGoAhtZywFrEamwWtLJX2/0IlPNOKwfZM3+uMDAqpwkCH+DKM
         DhoNDWHLWzCoaGjQ6DNr5rJ1NZc602EiYesaOGDIrgNSGKw59hykiNkbrPCBZpc5jrGN
         VHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8BtBfv1f64XM22OKVAWg9tny4DrS6nBkaS+49knlZDw=;
        b=EY4GeJUIwEmlfQtpJZeY5wrreaOcv4eIvZlckeH5V5uhjY76YXix7DngXzDp2bXuyu
         ViDsXMmv3T81gjw+zpdOPY+S9jKgt5wxM2B/qyBWbVuFFozk5syoWDSJa0qPcawxWTTF
         Fs6MYrghS/qDptr/PxnU9QqgAjI9ftpdj6U8yNejfbvygpdEWiJgSIv/hzrjMbbVOEL0
         46Y7uSgcazxrKNLhlwZvdzuRHo1XUKYGechOBRfwqFWt459lv+4TWmaIAeMWv+4mRgQj
         u6lWYYuyrxTuCG2sgTxoBVvnkCbETW2B2aelJCzup7yvugp4Kjot+bmntX6gxKUG1Qvo
         +eTw==
X-Gm-Message-State: APjAAAW5uD0lZOcpLxyZitQG+7yPT7J0uzg6yZJFoxdJrcQhd1XXrdrr
        HzCzyYqCeCjHmKnSlmx5p45hQg==
X-Google-Smtp-Source: APXvYqy6u8LC596fT4iTndVF5NRGlUkwmHxUF4f04mY1HYJ5KLMJh128KkcuYc/QCTLryNllGrpiYQ==
X-Received: by 2002:a5d:4803:: with SMTP id l3mr2913835wrq.381.1573050006556;
        Wed, 06 Nov 2019 06:20:06 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id f13sm24004818wrq.96.2019.11.06.06.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:20:06 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, mark.rutland@arm.com,
        ard.biesheuvel@linaro.org
Subject: [PATCH v4 0/1] arm64: Implement archrandom.h for ARMv8.5-RNG
Date:   Wed,  6 Nov 2019 15:19:53 +0100
Message-Id: <20191106141954.30657-1-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ARMv8.5-RNG extension adds a hardware random number generator.
The plumbing for this is already present in the kernel; we just
have to take advantage of that.

Changes since v2:
  * Keep arch_get_random{,_seed}_long in sync.
  * Use __cpus_have_const_cap before falling back to this_cpu_has_cap.

Changes since v1:
  * Use __mrs_s and fix missing cc clobber (Mark),
  * Log rng failures with pr_warn (Mark),
  * Use __must_check; put RNDR in arch_get_random_long and RNDRRS
    in arch_get_random_seed_long (Ard),
  * Use ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE, and check this_cpu_has_cap
    when reading random data.
  * Move everything out of line, now that there are 5 other function
    calls involved, and to unify the rate limiting on the pr_warn.

Tested with QEMU.  What's not tested is hot plugging cpus with differing
capabilities; QEMU would need some extension to allow that sort of thing.


r~


Richard Henderson (1):
  arm64: Implement archrandom.h for ARMv8.5-RNG

 Documentation/arm64/cpu-feature-registers.rst |  2 +
 arch/arm64/include/asm/archrandom.h           | 35 ++++++++
 arch/arm64/include/asm/cpucaps.h              |  3 +-
 arch/arm64/include/asm/sysreg.h               |  4 +
 arch/arm64/kernel/cpufeature.c                | 13 +++
 arch/arm64/kernel/random.c                    | 79 +++++++++++++++++++
 arch/arm64/Kconfig                            | 12 +++
 arch/arm64/kernel/Makefile                    |  1 +
 drivers/char/Kconfig                          |  4 +-
 9 files changed, 150 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/archrandom.h
 create mode 100644 arch/arm64/kernel/random.c

-- 
2.17.1

