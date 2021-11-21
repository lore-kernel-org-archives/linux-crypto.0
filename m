Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16708C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 14:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhKUOyx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 09:54:53 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:31814 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbhKUOyw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 09:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637506305;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=eA1VUrxmeI6Ce25mHd5HKpDYpo3dsw0WHiOZxiOyzvY=;
    b=bXg2nrbsrF9N4UW2HXCk2ObnCOZwSQM1alBsFLgAAGJpk7yo5PsgUKFetBqsbrkAH0
    bVhsf6KPA2s7BkfbyZ4NQNcKstKUTmuBKVuy0R47+puE9S9f4itkrq9mAqi7mtYfm5u6
    J1L9BE+K5bQvxCbccgWiJ5w94YrRRTsizZtpXn9BdXt8yZMmnkrRAZ0OG9cKfW6r8aYn
    HRkifN6tHi4TNwN7SntOOFP1ep++0f9Lk4uEqxPPQQ5HkESDAvmcxzNHolipGsUkb7G1
    SOqTdhBy+kxhEyegVCe3GZC/AmyTMfzKMCbMkjBlu/0vQn2ikCCaZiVcpzjQ7ubWwHM0
    yt+w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfE+K2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxALEpi3Ia
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 21 Nov 2021 15:51:44 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: DH - limit key size to 2048 in FIPS mode
Date:   Sun, 21 Nov 2021 15:51:44 +0100
Message-ID: <2564099.lGaqSPkdTl@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

FIPS disallows DH with keys < 2048 bits. Thus, the kernel should
consider the enforcement of this limit.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/dh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/dh.c b/crypto/dh.c
index cd4f32092e5c..38557e64b4b3 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -5,6 +5,7 @@
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
  */
 
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <crypto/internal/kpp.h>
 #include <crypto/kpp.h>
@@ -47,6 +48,9 @@ static inline struct dh_ctx *dh_get_ctx(struct crypto_kpp *tfm)
 
 static int dh_check_params_length(unsigned int p_len)
 {
+	if (fips_enabled)
+		return (p_len < 2048) ? -EINVAL : 0;
+
 	return (p_len < 1536) ? -EINVAL : 0;
 }
 
-- 
2.33.1




