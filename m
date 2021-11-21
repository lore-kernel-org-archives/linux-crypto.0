Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3DBC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 14:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbhKUOef (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 09:34:35 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:12529 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbhKUOef (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 09:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637505089;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ez2Prdw7KuCOY/aGCgym2e+KxYrzxMjBRE3JiLVVeWo=;
    b=qd3mOOwGGcE8VtyqsvRneaDR4cWPozIFTRGHNF/S4kN7YI+1fFoPgM0mqCT+49PvKB
    gI2mNbvbonsc/xzoki89unF0EgB64fM8gCjOnEXWLvILlQ5jNLTSgs8S4zLHwvYdlh9V
    Gq6ajW6sPs/cuJCNZejV/YyJFZkseSSYupOPfr6nilPbhxnOXdtyEoB4u77f0//7DoCs
    kxd26NqIjYB24F+N4tR67xSVSCpgpnlNTyGvlvl1ep+mIXk1zGGExWA5dLdf1j0gJXHA
    7OUlHeJVJ/KG+uw5e/eM0qLmNjufr2VJdnG9KFlmEEs413KEwJDadXua4Qr85CsVQJ/v
    SpoA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfE+K2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxALEVS3GB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 21 Nov 2021 15:31:28 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: RSA - limit key size to 2048 in FIPS mode
Date:   Sun, 21 Nov 2021 15:31:27 +0100
Message-ID: <25197881.1r3eYUQgxm@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

FIPS disallows RSA with keys < 2048 bits. Thus, the kernel should
consider the enforcement of this limit.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/rsa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4cdbec95d077..39e04176b04b 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -5,6 +5,7 @@
  * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
  */
 
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/mpi.h>
 #include <crypto/internal/rsa.h>
@@ -144,6 +145,9 @@ static int rsa_check_key_length(unsigned int len)
 	case 512:
 	case 1024:
 	case 1536:
+		if (fips_enabled)
+			return -EINVAL;
+		fallthrough;
 	case 2048:
 	case 3072:
 	case 4096:
-- 
2.33.1




