Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF2AC43381
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4902087F
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244531;
	bh=2qjoZUucQR1GiJMI+IGFfAGz9POJZkZ9Afqy402kP2c=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=SIL8zUTWYTWEdYjE1JE1AqveD00tkB6a3T/m6FRgsF5sUbYHlSwAxPIu4m7vV3rRM
	 ZVFbMdaozQJEQDcRv4eT9G32XgTJd9VCEAkF3SYbNFw9igGlRIY9PZsYFlQfNZr7uS
	 z8cHOo9ptDTm+0f6XHBD9rlJYvWexAY4F2TJwDVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfCJTCK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbfCJTCK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:10 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2723F20657;
        Sun, 10 Mar 2019 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244529;
        bh=2qjoZUucQR1GiJMI+IGFfAGz9POJZkZ9Afqy402kP2c=;
        h=From:To:Cc:Subject:Date:From;
        b=PGEhHuFfzujeutaAAJga5BwbXQbLWASHRRA5yd1wldT4i8uVXPF16dRh7DntS+4Kj
         C6oMRj+QSjUVHVK9qQY6DamdXrsS8X+4trnjZ0yCrFnlpWoPkqhSA5NzUxGowsHUfk
         C8PwGssq2ZpPFGdOI6XxRHjBQABFGUhhxYjIkgIA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 0/9] crypto: add SIMD helpers for AEADs
Date:   Sun, 10 Mar 2019 12:00:49 -0700
Message-Id: <20190310190058.4912-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series updates crypto_simd to support wrapping AEADs, then makes
all AEADs that implement the same functionality use crypto_simd instead.

This simplifies the code, and it also fixes the bug where these
algorithms modify the user-provided aead_request.  This was a problem
because users may expect to be able to use the same aead_request for
another encryption/decryption without reinitializing everything.  The
last patch removes the test workaround now that this bug is fixed.

Eric Biggers (9):
  crypto: simd - support wrapping AEAD algorithms
  crypto: x86/aesni - convert to use skcipher SIMD bulk registration
  crypto: x86/aesni - convert to use AEAD SIMD helpers
  crypto: x86/aegis128 - convert to use AEAD SIMD helpers
  crypto: x86/aegis128l - convert to use AEAD SIMD helpers
  crypto: x86/aegis256 - convert to use AEAD SIMD helpers
  crypto: x86/morus640 - convert to use AEAD SIMD helpers
  crypto: x86/morus1280 - convert to use AEAD SIMD helpers
  crypto: testmgr - remove workaround for AEADs that modify aead_request

 arch/x86/crypto/aegis128-aesni-glue.c  | 157 +++------------
 arch/x86/crypto/aegis128l-aesni-glue.c | 157 +++------------
 arch/x86/crypto/aegis256-aesni-glue.c  | 157 +++------------
 arch/x86/crypto/aesni-intel_glue.c     | 204 ++-----------------
 arch/x86/crypto/morus1280-avx2-glue.c  |  12 +-
 arch/x86/crypto/morus1280-sse2-glue.c  |  12 +-
 arch/x86/crypto/morus1280_glue.c       |  85 --------
 arch/x86/crypto/morus640-sse2-glue.c   |  12 +-
 arch/x86/crypto/morus640_glue.c        |  85 --------
 crypto/Kconfig                         |  10 +-
 crypto/simd.c                          | 269 +++++++++++++++++++++++++
 crypto/testmgr.c                       |   3 -
 include/crypto/internal/simd.h         |  20 ++
 include/crypto/morus1280_glue.h        |  79 ++------
 include/crypto/morus640_glue.h         |  79 ++------
 15 files changed, 471 insertions(+), 870 deletions(-)

-- 
2.21.0

