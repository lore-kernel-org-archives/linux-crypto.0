Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1252C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 17:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FA824676
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 17:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="qezczTMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLQRpH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:45:07 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:58961 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfLQRpH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 12:45:07 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6faac496;
        Tue, 17 Dec 2019 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=44FlwhW4PpeUr02PKp+k6qGGR
        gQ=; b=qezczTMWy6NtQqM9SoZ6UV5tsuEm+M+QcSjHdBMiWERu/ippNpX3bQawJ
        YsYYStyBUdE6cHsNbLg4bW1mufwJXzIENpMPXpwsK5JMaZIpDHYGI4Vkb/OcAu11
        iF6HZu2mgHEA5dn3VF9RVWw5Hi/bm9wNpd3kSgyj+XIkJVnAzkEhU55RAzfG+DU+
        7liGyge8eOcmZ5KA8inLKYtJye+3oEIwXA4UNNPIGwgmt5IVnn9z3v5xF+qjzjG5
        qfOPC/UhmeSEj+QSLCxoFRrt8A5tdgVvQyjqR3FPOdaPwEyLQXGfp0pEAzR6SJXw
        snFgHYx70OiHHtR/AKDbJJvp0GQQQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d7ec19b1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 17 Dec 2019 16:48:38 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH crypto-next v6 0/3] crypto: poly1305 improvements
Date:   Tue, 17 Dec 2019 18:44:42 +0100
Message-Id: <20191217174445.188216-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With no feedback on v5 beyond the need for a .gitignore in the second
commit of this v6, I think this series should now be good to go.

These are some improvements to the Poly1305 code that I think should be
fairly uncontroversial. The first part, the new C implementations, adds
cleaner code in two forms that can easily be compared and reviewed, and
also results in performance speedups. The second part, the new x86_64
implementation, replaces an slow unvetted implementation with an
extremely fast implementation that has received many eyeballs. Finally,
we fix up some deadcode.

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
 arch/x86/crypto/.gitignore             |    1 +
 arch/x86/crypto/Makefile               |   11 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S |  390 ---
 arch/x86/crypto/poly1305-sse2-x86_64.S |  590 ----
 arch/x86/crypto/poly1305-x86_64.pl     | 4266 ++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        |  308 +-
 crypto/adiantum.c                      |    4 +-
 crypto/nhpoly1305.c                    |    2 +-
 crypto/poly1305_generic.c              |   27 +-
 include/crypto/internal/poly1305.h     |   50 +-
 include/crypto/nhpoly1305.h            |    4 +-
 include/crypto/poly1305.h              |   16 +-
 lib/crypto/Kconfig                     |    4 +-
 lib/crypto/Makefile                    |    4 +-
 lib/crypto/poly1305-donna32.c          |  204 ++
 lib/crypto/poly1305-donna64.c          |  185 +
 lib/crypto/poly1305.c                  |  174 +-
 20 files changed, 4927 insertions(+), 1367 deletions(-)
 create mode 100644 arch/x86/crypto/.gitignore
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-x86_64.pl
 create mode 100644 lib/crypto/poly1305-donna32.c
 create mode 100644 lib/crypto/poly1305-donna64.c

-- 
2.24.1

