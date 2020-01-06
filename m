Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ADBC32767
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 03:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8073020801
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 03:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="reYvhsj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgAFDlC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Jan 2020 22:41:02 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51991 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbgAFDlB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Jan 2020 22:41:01 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 992d9527;
        Mon, 6 Jan 2020 02:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=CgPF9Yr5DHOTt4RUJ0vMMpPi0
        KE=; b=reYvhsj4U2FgUmmT1espdlzWmAv2E4c35j8K0/8H25i4OasBlSBKQg3ru
        WgjV6qaSoLrjSyoI2xbeyWVAS/VyIT8ShRlk+ERGZCReo0aazA73BVXwildkIY4B
        Bv1ddxEJlc5hbxDZsiqND0K8xz6zvadCgEjhduHQET7bw/xc3Qa7ZG4ddIYJ1q2P
        y8xElAoqOOACjxn4TsXjZNxxJ2mlWRerdtJpiBsgb8VPTXqaW3YeUYeQJDHxyWzN
        dPd0MFbwPQEFDuQLNlAoSggKkyOCksrANmAlX6YS8m/pi0vtb27QqR9FfqbG23/B
        XQZOhMZSpg1Tif5DRWlhsWv4QpMzg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c3e1b1db (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 6 Jan 2020 02:42:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v8 0/4] crypto: poly1305 improvements
Date:   Sun,  5 Jan 2020 22:40:45 -0500
Message-Id: <20200106034049.265162-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sorry for the repost so soon after version 7. Version 8 fixes a build
error spotted by kbuild, due to mixing object file name and module name.
Other than that derp, it's identical to version 7.

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
we fix up some dead code.

Jason A. Donenfeld (4):
  crypto: poly1305 - add new 32 and 64-bit generic versions
  crypto: x86_64/poly1305 - import unmodified cryptogams implementation
  crypto: x86_64/poly1305 - wire up faster implementations for kernel
  crypto: arm/arm64/mips/poly1305 - remove redundant non-reduction from
    emit

 arch/arm/crypto/poly1305-glue.c               |   18 +-
 arch/arm64/crypto/poly1305-glue.c             |   18 +-
 arch/mips/crypto/poly1305-glue.c              |   18 +-
 arch/x86/crypto/.gitignore                    |    1 +
 arch/x86/crypto/Makefile                      |   11 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S        |  390 --
 arch/x86/crypto/poly1305-sse2-x86_64.S        |  590 ---
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 4265 +++++++++++++++++
 arch/x86/crypto/poly1305_glue.c               |  308 +-
 crypto/adiantum.c                             |    4 +-
 crypto/nhpoly1305.c                           |    2 +-
 crypto/poly1305_generic.c                     |   25 +-
 include/crypto/internal/poly1305.h            |   45 +-
 include/crypto/nhpoly1305.h                   |    4 +-
 include/crypto/poly1305.h                     |   26 +-
 lib/crypto/Kconfig                            |    2 +-
 lib/crypto/Makefile                           |    4 +-
 lib/crypto/poly1305-donna32.c                 |  204 +
 lib/crypto/poly1305-donna64.c                 |  185 +
 lib/crypto/poly1305.c                         |  169 +-
 20 files changed, 4924 insertions(+), 1365 deletions(-)
 create mode 100644 arch/x86/crypto/.gitignore
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-x86_64-cryptogams.pl
 create mode 100644 lib/crypto/poly1305-donna32.c
 create mode 100644 lib/crypto/poly1305-donna64.c

-- 
2.24.1

