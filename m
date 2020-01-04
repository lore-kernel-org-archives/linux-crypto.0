Return-Path: <SRS0=+ioq=2Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2559C32767
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jan 2020 23:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7687D21734
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Jan 2020 23:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hvFTcPLc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgADXlx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Jan 2020 18:41:53 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54611 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgADXlx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Jan 2020 18:41:53 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0e78eb3e;
        Sat, 4 Jan 2020 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=6G9hU+h/1mvB0tk0YUS7G3DTS
        0o=; b=hvFTcPLcyM36ynaQJBNZofjQAEpiwQA7QSji9rCLR5BCrDGBVufuH99ba
        fYXRjN3Cfk8/qM5QaVC4K1tb5lS28tD25YkZ4yKxCCngDaUpn7j9lN2pduzETCM6
        EZrjMMULdTO9hwvTzik9g4uGQw+zFEK03ZjEw1WKNXhGbGNkRcYgIa6XtOA1Bi+X
        0ggiyY/yoblobXgg83eMz/HjROru++zAMcE5wgoC3nfpmc29kfyTwRCHvGTI8cb2
        G/eJdy2/3v11nLivrcL30els9vzUA3suR5IKtbQ4imdzfiJspRzgQDA+3qv28gl8
        453k8lypeYev2zpiAjiPloo432uwA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a31169a8 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sat, 4 Jan 2020 22:43:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v7 0/4] crypto: poly1305 improvements
Date:   Sat,  4 Jan 2020 18:41:37 -0500
Message-Id: <20200104234141.4624-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Version 7 incorporates suggestions from the mailing list on version 6.
We now use a union type to handle the poly1305_core_key, per suggestion.
And now the changes to the cryptogams code are nicely split out into its
own commit, with detail on the (limited) scope of the changes. I believe
this should address the last of issues brought up.

####

These are some improvements to the Poly1305 code that I think should be
fairly uncontroversial. The first part, the new C implementations, adds
cleaner code in two forms that can easily be compared and reviewed, and
also results in performance speedups. The second part, the new x86_64
implementation, replaces an slow unvetted implementation with an
extremely fast implementation that has received many eyeballs. Finally,
we fix up some deadcode.

Jason A. Donenfeld (4):
  crypto: poly1305 - add new 32 and 64-bit generic versions
  crypto: x86_64/poly1305 - import unmodified cryptogams implementation
  crypto: x86_64/poly1305 - wire up faster implementations for kernel
  crypto: arm/arm64/mips/poly1305 - remove redundant non-reduction from
    emit

 arch/arm/crypto/poly1305-glue.c        |   18 +-
 arch/arm64/crypto/poly1305-glue.c      |   18 +-
 arch/mips/crypto/poly1305-glue.c       |   18 +-
 arch/x86/crypto/.gitignore             |    1 +
 arch/x86/crypto/Makefile               |   11 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S |  390 ---
 arch/x86/crypto/poly1305-sse2-x86_64.S |  590 ----
 arch/x86/crypto/poly1305-x86_64.pl     | 4265 ++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        |  308 +-
 crypto/adiantum.c                      |    4 +-
 crypto/nhpoly1305.c                    |    2 +-
 crypto/poly1305_generic.c              |   25 +-
 include/crypto/internal/poly1305.h     |   45 +-
 include/crypto/nhpoly1305.h            |    4 +-
 include/crypto/poly1305.h              |   26 +-
 lib/crypto/Kconfig                     |    2 +-
 lib/crypto/Makefile                    |    4 +-
 lib/crypto/poly1305-donna32.c          |  204 ++
 lib/crypto/poly1305-donna64.c          |  185 +
 lib/crypto/poly1305.c                  |  169 +-
 20 files changed, 4924 insertions(+), 1365 deletions(-)
 create mode 100644 arch/x86/crypto/.gitignore
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-x86_64.pl
 create mode 100644 lib/crypto/poly1305-donna32.c
 create mode 100644 lib/crypto/poly1305-donna64.c

-- 
2.24.1

