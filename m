Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B93C46467
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Jan 2023 12:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjAOMQC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Jan 2023 07:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjAOMQB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Jan 2023 07:16:01 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83A8EC7F
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:00 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g23so12131028plq.12
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/NNEujWNnfLu7gJyQPC6CcWQitDkF1OWYCczrzsIwSw=;
        b=ZHrqoGXGWtb6s9tSL/bPhC2DIkYS/pkkDqCoFj7yzFvmnzagJPI29nh/6PrrFnr9ZO
         lhuCXq8yjm2pkHe03Gl1OMAIsr3iOXp/sLBq++dgKN2mEPx9pqIvKcMWyhSoDDkL6tit
         kiZ4p+p3n20H8qMFL8oZqkYZxfRR9mPC8zrtFCZmn6vx0Az2xasaxMXI0AkrdAu1vYtL
         GkkwflG+0W4hYp/l/HCa5QN3XFf5i80imP/mGjsXWwo3VJ2DEY4L7YOEKhTW9Iucds3l
         m6996+xTpZX5aUhF+UUAqiCHglNSR4o8TmklnEEcUx6byQTbEy8wt+zALy6PT9rTuwiK
         DDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NNEujWNnfLu7gJyQPC6CcWQitDkF1OWYCczrzsIwSw=;
        b=IYfVTNUdgOZBUYJgBHZtz6KZwg9VMNyp9s+uE3HxVgyOqLZI/+C12dN28ajkytCQKp
         bM2YNV6NBsOICUQULSfsjq4Ar/1dxcBeuwV88I2QSNLeFQdQ6QdDPKZQtvbr/V7MjkWb
         agNDPlhzw7F2rGnawUOCMtdAjGBQuNpPYEX3/Ur7KMwGnawVQmyNYJ8ojjWXnK4ajn2M
         yk5JmkCIa1TkOrcZya0C77kzihkUSx0sd9hZIZ12B5AGdrTXb1++o2gnmj5NC4A+EFgM
         siY+w86BvdP73Krfpzta9fLVkSWJ01T0g+SWGxeo0ysUIBnDlWWmAhnPQUcuNCMbH8n4
         Y85w==
X-Gm-Message-State: AFqh2kprwRMJPZv3cbvqyJuhodfY0BPBHiJjDQ46VEji7G0Z0zQqA0Dz
        QoT51HGO7/M9ZweHmKdkOLL1RRXMfKU=
X-Google-Smtp-Source: AMrXdXvo36zTK+PjuGfgmNqR5rX8WAhZpB0Vg8qlNzL5XTQUbDXi4dgBrsfzxCHPb+qhx4InpgCF/w==
X-Received: by 2002:a17:903:2341:b0:192:fd1e:a968 with SMTP id c1-20020a170903234100b00192fd1ea968mr54602806plh.46.1673784959746;
        Sun, 15 Jan 2023 04:15:59 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e13-20020a63e00d000000b00485cbedd34bsm14361783pgh.89.2023.01.15.04.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 04:15:58 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     jbeulich@suse.com, ap420073@gmail.com
Subject: [PATCH 0/3] crypto: x86/aria - fix build failure with old binutils
Date:   Sun, 15 Jan 2023 12:15:33 +0000
Message-Id: <20230115121536.465367-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is build failure issue when old binutils is used.

The minimum version of binutils to build kernel is 2.23 but it doesn't
support GFNI.
But aria-avx, aria-avx2, and aria-avx512 use GFNI.
So, the build will be failed when old binutils is used.

In order to fix this issue, it checks build environment is using
binutils, which don't support GFNI or not.
In addition, it also checks AVX512 for aria-avx512.

aria-avx and aria-avx2 use GFNI optionally.
So, if binutils doesn't support GFNI, it hides GFNI code.
But aria-avx512 mandatorily requires GFNI and AVX512.
So, if binutils doesn't support GFNI or AVX512, it disallows select to
build.

In order to check whether the using binutils is supporting GFNI, it adds
AS_GFNI.

Taehee Yoo (3):
  crypto: x86/aria-avx - fix build failure with old binutils
  crypto: x86/aria-avx2 - fix build failure with old binutils
  crypto: x86/aria-avx15 - fix build failure with old binutils

 arch/x86/Kconfig.assembler               |  5 +++++
 arch/x86/crypto/Kconfig                  |  2 +-
 arch/x86/crypto/aria-aesni-avx-asm_64.S  | 10 ++++++++++
 arch/x86/crypto/aria-aesni-avx2-asm_64.S | 10 +++++++++-
 arch/x86/crypto/aria_aesni_avx2_glue.c   |  4 +++-
 arch/x86/crypto/aria_aesni_avx_glue.c    |  4 +++-
 6 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.34.1

