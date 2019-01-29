Return-Path: <SRS0=zJfq=QF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82896C282C7
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 08:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5054C21841
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 08:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548748909;
	bh=g+W7VC6SNl0/DAvQhhsBlOJex6ABF8fMixCYerChMUc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=lr+eIXSG4O8NDSV06N7TPtUFeOZ3Y8ZEUfHMcudxqQlPY34vrjVqxS0IDpMXYtguS
	 vOOEdSnQnLzCLiLFKzfDJ87AngnuXXbDHND8HRRngY7polEskiQBkphu8ANVnLcRL2
	 fx7D8Mf817l9TFAVnkv3j44o3RraqQ2upL4zIRKM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfA2IBs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbfA2IBs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Jan 2019 03:01:48 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6568214DA;
        Tue, 29 Jan 2019 08:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548748907;
        bh=g+W7VC6SNl0/DAvQhhsBlOJex6ABF8fMixCYerChMUc=;
        h=From:To:Cc:Subject:Date:From;
        b=tNpjBlaaGV7UnB+T3jUMTkf3JiWd5ULm2gnMZfGHdZm7bpFXB09Lnll349FPVjHet
         77r5gZ/xGwV45cFElIRXosCesjXuLhSuZpNuH6NcpoSf2wXM/qpCTwV65f9REeT5vH
         42VKlxqdDwno63zKt7BnhP+y4YzV18qcpt4vOKUs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/3] crypto: crct10dif assembly cleanup and optimizations
Date:   Tue, 29 Jan 2019 00:00:26 -0800
Message-Id: <20190129080029.22261-1-ebiggers@kernel.org>
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

Changed since v1:
- Moved constants in arm implementation to .rodata.
- Eliminated a few instructions from the x86 implementation.
- Tweaked a few comments.

Eric Biggers (3):
  crypto: x86/crct10dif-pcl - cleanup and optimizations
  crypto: arm/crct10dif-ce - cleanup and optimizations
  crypto: arm64/crct10dif-ce - cleanup and optimizations

 arch/arm/crypto/crct10dif-ce-core.S     | 554 ++++++++--------
 arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
 arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++-------
 arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S  | 844 +++++++++---------------
 arch/x86/crypto/crct10dif-pclmul_glue.c |   3 +-
 6 files changed, 797 insertions(+), 1106 deletions(-)

-- 
2.20.1

