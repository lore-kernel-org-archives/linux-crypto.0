Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1DBC433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 22:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A1CF2085B
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 22:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MGN4ecvb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHKW70 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 18:59:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37012 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfHKW7Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 18:59:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so10184432wmf.2
        for <linux-crypto@vger.kernel.org>; Sun, 11 Aug 2019 15:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/tNZwOFvVQgW3Q3LEkFArhFgiZFUVCSFYAfHFcwsvMY=;
        b=MGN4ecvbcpj5SpsE+uvsZTJQgIEL1VaeVc/I3SK5gWS96Mah4Whgg/utWV4jVinjEu
         u7gbnlDqL7meLp4IeUops9LBq3hn0VXLoD1xj8Sd21XvG5Vd6c/qkQD8Emy0D7RnFnhm
         t2FXq/tOb9Dg6Xt2sEt6+Wz4W5g5FWC8ljYKH5A2G6UdRJP6nOK3miln1Ww7lulTmCXQ
         Z42/5D4laLs9MZX1DZSWaE/LTjpG1Js2o0fo1uX74IIAPu1dQlOl570X00t/wd5LRdKi
         huamKsANG1S9kXA5iIw30QWmyd6LQynz2T/himOPcmCIAN0xMRrv/6XRdTh9LhI/DxYm
         Tsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/tNZwOFvVQgW3Q3LEkFArhFgiZFUVCSFYAfHFcwsvMY=;
        b=XwG8CFXm9A2Bns5h6f3mUrMGkr18KrSXwYItxnWN9WHVbyG6yAj9O6U4iNAtQbTJzy
         Zp8OnPDAX7qq893KgCjrV0QNYoRVwciYs7mflP/LIgsvj50/gQpMAEuWqdQfj76qc5JM
         noqWT3jY/Jfo+/a40lzHAUcfjeWNGnXpDoUycm0LekqV2VobBi9N2dES4PEFbn4UR0Lr
         Xtoz1atvRLkzvHQ2CpZD0gFutaswPeH6oAayb8CDpOIfFdLlDAPnimvM2/JSa6FL/oDx
         ZtkAu42P2JRgjgo6f7OkqyIJ0I4pP9B9Fauoj3/hRpoh88V29XIH+vUAeCXHSgLK5/nv
         hqHg==
X-Gm-Message-State: APjAAAXZ9lNG8TNqzpzSW9HYUaQWEw5ogRx6bxr8F1jix1az4d/FRETA
        8jRTb4NufVRLyfqjZGE+GVrQO6QgQWpu+A==
X-Google-Smtp-Source: APXvYqznwY/uZTeoSeceh+sD2Djv7+dWTnJNlomh9LFkwDUmLD/mtxciOewWEbxvUzNnDtqae3DZNQ==
X-Received: by 2002:a1c:1d08:: with SMTP id d8mr23598731wmd.22.1565564363227;
        Sun, 11 Aug 2019 15:59:23 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:5df1:4fcc:7bd1:4860])
        by smtp.gmail.com with ESMTPSA id a17sm5930888wmm.47.2019.08.11.15.59.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 15:59:22 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/3] crypto: aegis128 followup
Date:   Mon, 12 Aug 2019 01:59:09 +0300
Message-Id: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
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

Changes since v1:
- minor tweaks to #2 to drop a memset() invocation from the decrypt path,
  and some temp vars in various places
- update the NEON code in #3 so it builds with Clang as well as GCC (and
  drop the RFC annotation)

Patch #1 reintroduces the changes to the generic code to permit SIMD
routines to be attached to the aegis128 driver. This time, the conditional
check is pulled into a helper function which collapses to 'return false'
if the CONFIG_CRYPTO_AEGIS128_SIMD Kconfig symbol is not set. (This has
been confirmed by one of the reporters of the original issue as sufficient
to address the problem).

Patch #2 is mostly unchanged wrt the version that got reverted, only some
inline annotations were added back.

Patch #3 is new and implements the SIMD routines for arm64 without using
the optional AES instructions, but using plain SIMD arithmetic instead.
This is much slower than AES instructions, but still substantially more
efficient than table based scalar AES on systems where memory accesses are
expensive, such as the Raspberry Pi 3 (which does not implement the AES
instructions)

Ard Biesheuvel (3):
  crypto: aegis128 - add support for SIMD acceleration
  crypto: aegis128 - provide a SIMD implementation based on NEON
    intrinsics
  crypto: arm64/aegis128 - implement plain NEON version

 crypto/Kconfig                         |   5 +
 crypto/Makefile                        |  20 ++
 crypto/{aegis128.c => aegis128-core.c} |  52 ++++-
 crypto/aegis128-neon-inner.c           | 212 ++++++++++++++++++++
 crypto/aegis128-neon.c                 |  49 +++++
 5 files changed, 334 insertions(+), 4 deletions(-)
 rename crypto/{aegis128.c => aegis128-core.c} (89%)
 create mode 100644 crypto/aegis128-neon-inner.c
 create mode 100644 crypto/aegis128-neon.c

-- 
2.17.1

