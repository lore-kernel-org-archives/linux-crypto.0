Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B12C169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 04:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A307218D3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 04:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548909773;
	bh=iCZNpggkgIi1FfGsschHWT+9Cq7wKmMBAMfKVSHa6TY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hnEwf70eWl9bc8ELWxt+CGqdofL/IKkrcfz8doCw3C2N5SyKs/4M9h7ZDNRxvHB+a
	 r2KV/vhJpzAg9ev80BxVfYbr3/EtTLhO8vS+r08i8szWPPGFR6m03JU0dvcHfRMOx6
	 6BrAK/nVmUY1SU3slUCt5xS2fdFRoEYjvfxn3djw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfAaEmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 23:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfAaEmw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 23:42:52 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4E220870;
        Thu, 31 Jan 2019 04:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548909771;
        bh=iCZNpggkgIi1FfGsschHWT+9Cq7wKmMBAMfKVSHa6TY=;
        h=From:To:Cc:Subject:Date:From;
        b=LxtkGGGadrfnUXaZmU/URCr+OTc4dSfhQ55iseH0HNY3H1SMebTg5PGlSgd+EtWwD
         QYlJkFIZEAPjGxhmAgi8oemWfQqzevhjtDIy2vd7nl050BNRLfASYiIHMKSIbHEq5F
         fEw8fZVKvLv7gclaiD6SwR2EqVZbPk6UqRLt4+vY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 0/3] crypto: crct10dif assembly cleanup and optimizations
Date:   Wed, 30 Jan 2019 20:42:39 -0800
Message-Id: <20190131044242.31591-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The x86, arm, and arm64 asm implementations of crct10dif are very
difficult to understand partly because many of the comments, labels, and
macros are named incorrectly: the lengths mentioned are usually off by a
factor of two from the actual code.  Many other things are unnecessarily
convoluted as well, e.g. there are many more fold constants than
actually needed and some aren't fully reduced.

This series therefore cleans up all these implementations to be much
more maintainable.  I also made some small optimizations where I saw
opportunities, resulting in slightly better performance.

This is based on top of the pending patches from Ard Biesheuvel.

These all pass the new extra self-tests.

Changed since v3:
- Added '.arch armv7-a' to arm32 assembly file to fix a build error.
- Removed support for len < 16 from the x86 assembly.

Changed since v2:
- Removed the unnecessary '__LINUX_ARM_ARCH__ < 7' case.
- Added Ard's Acked-by.

Changed since v1:
- Moved constants in arm implementation to .rodata.
- Eliminated a few instructions from the x86 implementation.
- Tweaked a few comments.

Eric Biggers (3):
  crypto: x86/crct10dif-pcl - cleanup and optimizations
  crypto: arm/crct10dif-ce - cleanup and optimizations
  crypto: arm64/crct10dif-ce - cleanup and optimizations

 arch/arm/crypto/crct10dif-ce-core.S     | 553 ++++++++---------
 arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
 arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++--------
 arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S  | 782 +++++++-----------------
 arch/x86/crypto/crct10dif-pclmul_glue.c |  12 +-
 6 files changed, 729 insertions(+), 1120 deletions(-)

-- 
2.20.1

