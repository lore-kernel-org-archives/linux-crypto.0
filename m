Return-Path: <SRS0=A/Go=3G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2E5C33CB1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 11:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62AD22082F
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 11:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MK10FS0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgAQLBm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jan 2020 06:01:42 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:42201 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgAQLBm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jan 2020 06:01:42 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2f5b5e51;
        Fri, 17 Jan 2020 10:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=nar6Om/idPUqWI6s6Dh3+1Za0d4=; b=MK10FS0MsZcupleeLSd+
        yX3ji/om+3Suo0ZpFjPCjJEKGBM33c6UPHQW/k8Qr2tczrkBb4I4TGhffGX811VN
        3s6jw8Ptq2bLJb2eeMmSjWhDuB/rPryjEtN5TiwQ4HqSMd69SoeQ3H50nNrqN2OH
        3TvToiey6KSk5RG29vnPbpoA+HvlumdhcibiIGusJyHRfT5QLPXgc+hKBe+EMuha
        4W8Hd4CCx4gH3+mCe30D5M5kE+4k+eUXWyzfFGMsQ14o3BfXMD6h+A1i4BiMVptS
        WyYNdACjNLZCC3S4G8/nIr+/6bIFlVV6eoKjiuTuttWU3Xme/4Vr6k7j2g4Rp2WK
        2g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b032fc21 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 17 Jan 2020 10:01:16 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] crypto: allow tests to be disabled when manager is disabled
Date:   Fri, 17 Jan 2020 12:01:36 +0100
Message-Id: <20200117110136.305162-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The library code uses CRYPTO_MANAGER_DISABLE_TESTS to conditionalize its
tests, but the library code can also exist without CRYPTO_MANAGER. That
means on minimal configs, the test code winds up being built with no way
to disable it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5575d48473bd..a335126fa301 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -136,8 +136,6 @@ config CRYPTO_USER
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
-if CRYPTO_MANAGER2
-
 config CRYPTO_MANAGER_DISABLE_TESTS
 	bool "Disable run-time self tests"
 	default y
@@ -155,8 +153,6 @@ config CRYPTO_MANAGER_EXTRA_TESTS
 	  This is intended for developer use only, as these tests take much
 	  longer to run than the normal self tests.
 
-endif	# if CRYPTO_MANAGER2
-
 config CRYPTO_GF128MUL
 	tristate
 
-- 
2.24.1

