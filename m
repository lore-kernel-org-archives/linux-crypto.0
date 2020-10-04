Return-Path: <SRS0=YnP8=DL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F10C4363C
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Oct 2020 18:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF012068D
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Oct 2020 18:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="nPs7V0/F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgJDSsI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Oct 2020 14:48:08 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:16199 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgJDSsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Oct 2020 14:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1601837284;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=jb55CfmhnQCfrQYMa+E0GB6f9VItN2e0JBTcCBghgCo=;
        b=nPs7V0/Fw1a7ovo1gu8+SDX28z/N4shbCN9/U/LNEoa8P8sS7sh6zoORlyQXRN56Pc
        Bc4NjqlVkVsRQsBTimeVGf9IFeaKNejMlguMmfm17pah59lWaeNwufqdcfY7JeOdCYbF
        GWX3ZTPCjZZb5mpk/ZB+HP0c4SMBXHVXlyaLXqdzggls7M+lyREk6D4++MazVna814to
        r6Vd7rmR9o+8g6SbJ4samu7/9Oi62qvW5ARF3ZFQ/mYO3mTTwNF2ghlvGTVgHstuim3/
        FQ9GeUZd+MVXfNMXr8uKDsfrRSQLitrxCBtyJyrH8VNsLemqm4V3s9CuKI1AXa9SI4RK
        COLA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJfSYkOI="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id C0b627w94Im39EY
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 4 Oct 2020 20:48:03 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-riscv@lists.infradead.org, kernel-team@android.com,
        kernel test robot <lkp@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: jitterentropy - bind statically into kernel
Date:   Sun, 04 Oct 2020 20:48:06 +0200
Message-ID: <5692716.lOV4Wx5bFT@positron.chronox.de>
In-Reply-To: <20201002064905.GA27115@infradead.org>
References: <20200930065617.934638-1-palmerdabbelt@google.com> <20201002064905.GA27115@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RISC-V architecture is about to implement the callback
random_get_entropy with a function that is not exported to modules.
Thus, the Jitter RNG is changed to be only bound statically into the
kernel removing the option to compile it as module.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..5b20087b117f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1853,7 +1853,7 @@ config CRYPTO_DRBG
 endif	# if CRYPTO_DRBG_MENU
 
 config CRYPTO_JITTERENTROPY
-	tristate "Jitterentropy Non-Deterministic Random Number Generator"
+	bool "Jitterentropy Non-Deterministic Random Number Generator"
 	select CRYPTO_RNG
 	help
 	  The Jitterentropy RNG is a noise that is intended
-- 
2.26.2




