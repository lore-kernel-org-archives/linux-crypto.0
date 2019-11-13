Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDFCC17447
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 10:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C637C204EC
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 10:12:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tWbstU+F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKMKMI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 05:12:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50217 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKMKMI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 05:12:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id l17so1335537wmh.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 02:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qfsOH+V+FFt5Iv+QrGgZE8TPXjX+qzSLSAGyJ3kwIrE=;
        b=tWbstU+FDUA1HwWfrqONQYhJnptM18pTgDImtEgJRnYbe6cRnq9xn2sqaZoCEupOh3
         d2ttQcZQStn7nW+BP6Ns7HpLcqO6w9QNq5/KHknjlPqTu2/bc2Wsy1tmmPVC18xkq6EE
         2cxG7T1z0gZPO1SniOavy3d0gSW+Qj+nUrRYJJ/tw+G9BAeoN6q46DEnTug+BlCxMYjW
         k6hty9B65FK6crBvzXrWZ6YMdUwaW3Hv9fL5O68URS+kD/IuXdeJrx/ggnWc1o4GLGmp
         m4rZTZQGX02OCafVBuExt12p6K4AAGiIJs9fa/uQxNvUxSs70602RA/zVB34rI9KNLzD
         Z+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qfsOH+V+FFt5Iv+QrGgZE8TPXjX+qzSLSAGyJ3kwIrE=;
        b=OwoDkY3vX8qYUby49nAvmuyyYsuJM3l6WNmJ5j99sZlY33sZQazMsLiijvlJrKTOYd
         vK0qe8MG79eREGael2WnkY6JiQW8CxaKlLj6d0+JYt6S9w0V1OYK5UmAQbRsPdUx+zOY
         lLR4SdgESAMAplT3WvCF2Mdw4FcONDY/h5UXnvkQfLRgDI8i7DFIj/yL2LwELfNbBJwB
         ZMqyDAW7HI2HObn/eceGR46hncScqOn9l9f5JAzKnXU7VovisU5hC+Z54WZJUsxw2oz+
         dWYrEeEgeB7r7UHn8GwlFZht5BvBQR6rCU7MUFDKxUexlKlVsM8zbGTdqivflkFAHq+s
         S4yg==
X-Gm-Message-State: APjAAAVpX5N2QeiFRupcHZIn+hgLgzf/KciWHzrfpxlgNMKLC6rvCvbN
        7WGCHVhCnB5CIT6OffC0brxLTj0bkIHPxw==
X-Google-Smtp-Source: APXvYqxkzPwvpRNUgA8FlpHiQFDd/vZ51nEYdopSz5ykNVi0JX6FBUKuZB3kbQlmjO9NLh+/PsLYAA==
X-Received: by 2002:a7b:c055:: with SMTP id u21mr2046674wmc.55.1573639926058;
        Wed, 13 Nov 2019 02:12:06 -0800 (PST)
Received: from localhost.localdomain (219.red-37-158-56.dynamicip.rima-tde.net. [37.158.56.219])
        by smtp.gmail.com with ESMTPSA id j66sm1488993wma.19.2019.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 02:12:05 -0800 (PST)
From:   richard.henderson@linaro.org
To:     linux-arm-kernel@lists.infradead.org
Cc:     mark.rutland@arm.com, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v6 0/1] arm64: Implement archrandom.h for ARMv8.5-RNG
Date:   Wed, 13 Nov 2019 11:11:50 +0100
Message-Id: <20191113101151.13389-1-richard.henderson@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

Here's v6.  I believe I've collected all of the comments
from both Ard and Mark across v4 and v5, as well as from
the cafe in Lyon.

I had thought about using a simple function pointer for
arch_get_random_seed_long, but didn't see a good place
where I could update that at the end of boot.

Which lead me to ALTERNATIVE_CB, which is way overkill,
but is already part of the update infrastructure.

Tested with qemu -cpu {max,cortex-a57}, which covers both
sides of the alternative.  GDB breakpoints confirm that
boot_get_random_seed_long is what is called from rand_initialize,
and that this_cpu_has_cap returns the correct result.


r~


 Documentation/arm64/cpu-feature-registers.rst |  2 +
 arch/arm64/include/asm/archrandom.h           | 55 +++++++++++++++
 arch/arm64/include/asm/cpucaps.h              |  3 +-
 arch/arm64/include/asm/sysreg.h               |  4 ++
 arch/arm64/kernel/cpufeature.c                | 13 ++++
 arch/arm64/kernel/random.c                    | 67 +++++++++++++++++++
 arch/arm64/Kconfig                            | 12 ++++
 arch/arm64/kernel/Makefile                    |  1 +
 drivers/char/Kconfig                          |  4 +-
 9 files changed, 158 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/archrandom.h
 create mode 100644 arch/arm64/kernel/random.c

-- 
2.17.1

