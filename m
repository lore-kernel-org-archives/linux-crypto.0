Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF8DC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 17:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E5521655
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 17:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="j1POZeWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfLLRd1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:33:27 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:37805 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbfLLRd1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 12:33:27 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9033b94b;
        Thu, 12 Dec 2019 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=Os7qTnEKiPL6WvUkdr4L/buUy
        Aw=; b=j1POZeWxWP3q3dMF9s9sUvdPCxO7ydL156CoZpjpv9VcD1qOfKYrO1j3P
        yIs7rKsjodVMn8lgZXaItyGoExtuRIW/modsrSume66RqagZkLEDo3iL0QEjMXAT
        bYheWhqP8119/9WuF+eaqtLchjlN1Et2+wbPn1c+9aafiGSfKX94qkY21Uk78nfZ
        4uoqC9nBWuKGrO+T6zTUurLedpPLoo0E9530LEhIl5vjq3DMZ8RZa6+1xgZXXmyv
        Lh8eCPd7mokrhO7dBr7yDJsn74oQInqd6y3dXT3/L+dILhO8KbHu50mTME23RNaj
        2yZhDcUGAosinGqCCYotPrSLnOwUg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ebd79066 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 12 Dec 2019 16:37:36 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH crypto-next v3 0/3] crypto: poly1305 improvements
Date:   Thu, 12 Dec 2019 18:32:55 +0100
Message-Id: <20191212173258.13358-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These are some improvements to the Poly1305 code that I think should be fairly
uncontroversial. The first part, the new C implementations, adds cleaner code
in two forms that can easily be compared and reviewed, and also results in
modest performance speedups. The second part, the new x86_64 implementation,
replaces an slow unvetted implementation with an extremely fast implementation
that has received many eyeballs. Finally, we fix up some deadcode.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Jason A. Donenfeld (3):
  crypto: poly1305 - add new 32 and 64-bit generic versions
  crypto: x86_64/poly1305 - add faster implementations
  crypto: arm/arm64/mips/poly1305 - remove redundant non-reduction from
    emit

 arch/arm/crypto/poly1305-glue.c        |   18 +-
 arch/arm64/crypto/poly1305-glue.c      |   18 +-
 arch/mips/crypto/poly1305-glue.c       |   18 +-
 arch/x86/crypto/Makefile               |   11 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S |  390 ---
 arch/x86/crypto/poly1305-sse2-x86_64.S |  590 ----
 arch/x86/crypto/poly1305-x86_64.pl     | 4266 ++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        |  308 +-
 crypto/adiantum.c                      |   10 +-
 crypto/nhpoly1305.c                    |    6 +-
 crypto/poly1305_generic.c              |   23 +
 include/crypto/internal/poly1305.h     |   39 +-
 include/crypto/nhpoly1305.h            |    2 +-
 include/crypto/poly1305.h              |   16 +-
 lib/crypto/Kconfig                     |    4 +-
 lib/crypto/Makefile                    |    4 +-
 lib/crypto/poly1305-donna32.c          |  204 ++
 lib/crypto/poly1305-donna64.c          |  185 +
 lib/crypto/poly1305.c                  |  160 +-
 19 files changed, 4910 insertions(+), 1362 deletions(-)
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-x86_64.pl
 create mode 100644 lib/crypto/poly1305-donna32.c
 create mode 100644 lib/crypto/poly1305-donna64.c

-- 
2.24.1

