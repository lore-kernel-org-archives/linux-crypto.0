Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B36DC4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 18:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E430E2070A
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 18:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BUS46J51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgCSSB0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 14:01:26 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:43285 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgCSSBZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 14:01:25 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 65755e04;
        Thu, 19 Mar 2020 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=r5YCFkjH5K/WHH6A+nClokGcoZE=; b=BUS46J51EbO/nxA0siD7
        HgEy2JvQmC9Ikysv/V1kPut9M7HKV5X3wKTtUoX7uikwpIMLYkuCeaeUSKqSsXMH
        DNumxUXL90uKXfRi0DRKnMuRoqFfcibcuO489jFBl2vIg8z4QhmSSOIn35+FWzrU
        KvAhjov67IXkvStWATNtFxOljGZS6hKClssgr3s4Ce7IJQXBoXuERGckMJvsDJvy
        ZZLN7Zwa/TV2FJxbcMn3omn6n8Dj/7JPPD3kyYO08yL3I5PSW55hdw0uSLBGG9QF
        2ShSj9ae8kmIXeU/sLiyx82ekp2G27ibfeDfmApOEuxyljLlmS6B/xvznirxaQqM
        bg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c84480ef (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 17:54:53 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH crypto] crypto: arm[64]/poly1305 - add artifact to .gitignore files
Date:   Thu, 19 Mar 2020 12:01:14 -0600
Message-Id: <20200319180114.6437-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The .S_shipped yields a .S, and the pattern in these directories is to
add that to .gitignore so that git-status doesn't raise a fuss.

Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Reported-by: Emil Renner Berthing <kernel@esmil.dk>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm/crypto/.gitignore   | 1 +
 arch/arm64/crypto/.gitignore | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/crypto/.gitignore b/arch/arm/crypto/.gitignore
index 31e1f538df7d..a3c7ad52a469 100644
--- a/arch/arm/crypto/.gitignore
+++ b/arch/arm/crypto/.gitignore
@@ -1,3 +1,4 @@
 aesbs-core.S
 sha256-core.S
 sha512-core.S
+poly1305-core.S
diff --git a/arch/arm64/crypto/.gitignore b/arch/arm64/crypto/.gitignore
index 879df8781ed5..e403b1343328 100644
--- a/arch/arm64/crypto/.gitignore
+++ b/arch/arm64/crypto/.gitignore
@@ -1,2 +1,3 @@
 sha256-core.S
 sha512-core.S
+poly1305-core.S
-- 
2.25.1

