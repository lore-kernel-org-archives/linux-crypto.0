Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3FCC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 19:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241788AbhLUTbw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:31:52 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:18216 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhLUTbv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 14:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1640115104;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=M0q74DCcFhSiIDIbUThxOakoXiY0Z4XdjeBd1kCFXz0=;
    b=Rky4G1LNJiyoYtnJnY9291va8FtjSVCJSivtSjgZuhRYxOQOTL2UeA+NuJmZjUKxiT
    wZK7RL7Cy9r3BzkBxK3s3EpR7jdbWjvBWTsM+HCevjXdBkWr03l1BS7Kx91mDQS869Ci
    TlsFqz6VC3UNRnpy/rd/QKRH7ZTvmxYxwpFSOPlXNSspt26VrsunDHPfPMtYH7/GTxba
    AY9jh/VJVOe0+7pwY8EIq4mMcw8AUmkBYpWJ/Ed0BqwZDZwSjiXGlvrCRX3LNimIQs2+
    SZt40oYmxePR9SPHQaHKfOZnn+MrEtQh4hekJQPMs3bok4beWD1blksm3fKmwEpwTWKO
    UQbA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJfSZtjc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.35.3 DYNA|AUTH)
    with ESMTPSA id h03d91xBLJVhWbD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 21 Dec 2021 20:31:43 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com
Subject: [PATCH] crypto: KDF - select SHA-256 required for self-test
Date:   Tue, 21 Dec 2021 20:31:42 +0100
Message-ID: <2576506.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The self test of the KDF is based on SHA-256. Thus, this algorithm must
be present as otherwise a warning is issued.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 01b9ca0836a5..649ee1df05c6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1847,7 +1847,7 @@ config CRYPTO_JITTERENTROPY
 
 config CRYPTO_KDF800108_CTR
 	tristate
-	select CRYPTO_HASH
+	select CRYPTO_SHA256
 
 config CRYPTO_USER_API
 	tristate
-- 
2.33.1




