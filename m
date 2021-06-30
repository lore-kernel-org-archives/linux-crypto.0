Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F432C11F65
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jun 2021 10:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015C3619BE
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jun 2021 10:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhF3Kfd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jun 2021 06:35:33 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:19405 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhF3Kfd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jun 2021 06:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1625049173;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=zrELvurilohi17VMVTv19kjVdyfbFWDqfvMOj6MTPRU=;
    b=Pvsq6rKPcZhmpytH6ZY8J1FlsnG5uaIc1QHQUPMS/4IBGqVxL2P8fSr38kZAU7rhay
    /3vN8YimMXlmSaklR9qUtBhHC3C7QUT5vwTlsarM6qiHRYiI1RIrsKnsgC1xZptoU0qL
    zXIW9s2h6yBf31r09oWHMnGdIThojUeWT2v6ADnv8NIWoSufC2wKAMH0C4o5Ui4tw2kU
    HeB4Us0ZlQtGxOT7N+sXvPCQ4dayOkYs6ysOm/acRPYcHdYmshrM0CkteYv1IGoAT4Ho
    fbbijfjZwcxQWMl+Os19wwC+hs7R9Cu4ONz9td6vYPM8QX4HxTaFtM+/Ra1ZMo3IngWK
    NQ/w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884PCF2aGHC1nvBRG6qaFpQl"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.27.7 AUTH)
    with ESMTPSA id d01c2ax5UAWq0yP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 30 Jun 2021 12:32:52 +0200 (CEST)
Message-ID: <304ee0376383d9ceecddbfd216c035215bbff861.camel@chronox.de>
Subject: [PATCH] crypto: DRBG - select SHA512
From:   Stephan Mueller <smueller@chronox.de>
To:     Sachin Sant <sachinp@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
Date:   Wed, 30 Jun 2021 12:32:52 +0200
In-Reply-To: <73D2DF91-CC7A-46CD-8D48-63FFB1857D24@linux.vnet.ibm.com>
References: <73D2DF91-CC7A-46CD-8D48-63FFB1857D24@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the swtich to use HMAC(SHA-512) as the default DRBG type, the
configuration must now also select SHA-512.

Fixes: 9b7b94683a9b "crypto: DRBG - switch to HMAC SHA512 DRBG as default
DRBG"
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Stephan Mueller <smueller@chronox.com>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ca3b02dcbbfa..64b772c5d1c9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1768,7 +1768,7 @@ config CRYPTO_DRBG_HMAC
 	bool
 	default y
 	select CRYPTO_HMAC
-	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 
 config CRYPTO_DRBG_HASH
 	bool "Enable Hash DRBG"
-- 
2.31.1



