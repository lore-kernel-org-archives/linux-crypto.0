Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E451C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 15:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E5721726
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 15:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dFTlqhry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733238AbfHBPPg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 11:15:36 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:39566 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbfHBPPg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 11:15:36 -0400
Received: by mail-wm1-f41.google.com with SMTP id u25so56335899wmc.4
        for <linux-crypto@vger.kernel.org>; Fri, 02 Aug 2019 08:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zA2V1McRviwHllhYYcASe0BRgwhy5K7FlqfTLCVepZo=;
        b=dFTlqhryi3vHvBelaj38g1Y8UK6EgVMPnXZ2t2Tr9G+LwZCm0zDIpSRYIrlPUJ8TmV
         TngXhqIo1Io5LHM0RveHpMzT78pZGT2XhvUEqC6AHk6HullFmbZVsVE6w1kfsJBP8whB
         ZzRUBIqMdLwHn4u4hcTsVmAmDKTVGpoBz1djJHl+RT0ANykpg7UkOyjSZdO7BBDkPtTM
         l1gHUKyy80kjuS6T3M0UgZ/R7nvE+39YxS2JtjAeQePrV7v5nsLSjcdRVtPmSljVuiJX
         BHNRDR3cnvAcYOPa6hpyCGh/jQpxPSbSqCfbrgpNwyfcVqIsURMke46Xebi8ZplFQCXn
         Meqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zA2V1McRviwHllhYYcASe0BRgwhy5K7FlqfTLCVepZo=;
        b=R2ELvZukNmxglKC4t146rpNpvduvkXhqXar3PvEZlLAEkJxG+8BBtspnhwfn924848
         QudZhIiQfNiFJJbZzIWgwzBe59hRPYkFpLLEkOTqxLW9fAeO/cSm026NHY/jDULsKhvl
         OOKzMrUxRpKXJiKAPhb3r7KkdHsUqn9Sz44MssGasenEKfMG8BBiNwSAvnG4PoIWuN8l
         V5BNUzAI0LuEspmwrJPDE/qyd1VyvehIvtuRLjnMolLrdjPnm+oSfvl2V9aFOevweAAW
         QV32d8oXNBmtQ7ajTcH1sDG+FJ3GOOrovePdxoTxAOqvcKu0Q0qtrgCt7pQkpXt+HVsb
         zp4Q==
X-Gm-Message-State: APjAAAWd8qfrjm9uzGOi5JFCewakXkBZJ4eqDz5W+S/qbYF2lKEEp66s
        fYfw04MHO5HYB9vuYce+NGo6+sAJEuKsQQ==
X-Google-Smtp-Source: APXvYqylyCsZF+fhYN56JLwYZgL41hqLUtpD4HGEwXZG0H+Gc+4YNb7+oOFQAhCo5P0c9Syp6V1htQ==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr4954487wmu.137.1564758933414;
        Fri, 02 Aug 2019 08:15:33 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a424:b400:cc84:8d83:a434:dd7])
        by smtp.gmail.com with ESMTPSA id o3sm63294321wrs.59.2019.08.02.08.15.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:15:32 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/3] crypto: aegis128 followup
Date:   Fri,  2 Aug 2019 18:15:07 +0300
Message-Id: <20190802151510.17074-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series resubmits the aegis128 SIMD patches that were reverted due to
the fact that the compiler's optimization behavior wrt variables with static
linkage does not turn out to guarantee that function calls that are
conditional on the value of such a variable are optimized away if the value
is a compile time constant and the condition evaluates to false at compile
time as well.

Patch #1 reintroduces the changes to the generic code to permit SIMD
routines to be attached to the aegis128 driver. This time, the conditional
check is pulled into a helper function which collapses to 'return false'
if the CONFIG_CRYPTO_AEGIS128_SIMD Kconfig symbol is not set. (This has
been confirmed by one of the reporters of the original issue as sufficient
to address the problem).

Patch #2 is mostly unchanged wrt the version that got reverted, only some
inline annotations were added back.

Patch #3 is new and is included as an RFC. It implements the SIMD routines
for arm64 without using the optional AES instructions, but using plain SIMD
arithmetic instead. This is much slower than AES instructions, but still
substantially more efficient than table based scalar AES on systems where
memory accesses are expensive, such as the Raspberry Pi 3 (which does not
implement the AES instructions)

Ard Biesheuvel (3):
  crypto: aegis128 - add support for SIMD acceleration
  crypto: aegis128 - provide a SIMD implementation based on NEON
    intrinsics
  crypto: arm64/aegis128 - implement plain NEON version

 crypto/Kconfig                         |   5 +
 crypto/Makefile                        |  18 ++
 crypto/{aegis128.c => aegis128-core.c} |  52 ++++-
 crypto/aegis128-neon-inner.c           | 204 ++++++++++++++++++++
 crypto/aegis128-neon.c                 |  57 ++++++
 5 files changed, 332 insertions(+), 4 deletions(-)
 rename crypto/{aegis128.c => aegis128-core.c} (89%)
 create mode 100644 crypto/aegis128-neon-inner.c
 create mode 100644 crypto/aegis128-neon.c

-- 
2.17.1

