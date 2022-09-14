Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D51C43217
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Oct 2022 22:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJTWpS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Oct 2022 18:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJTWoz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2022 18:44:55 -0400
Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD8D53D1C;
        Thu, 20 Oct 2022 15:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=angband.pl;
        s=tartarus; h=In-Reply-To:Subject:Date:To:From:Resent-To:Resent-Message-ID:
        Resent-Date:Resent-From:Sender:Reply-To:Message-ID:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Sender:Resent-Cc:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dW9mkBx9jLRsimZLAz0B3bLaKX0xCXq7JSRZy/CFr/g=; b=LtubnEUXBrLfo9M+fvEypOjH/q
        aFj6Yt6rXv5vShEP9wvMFv4WGyguqiqsxuIkPLbLlL6GgTnX65VqHkZWUoTTaufbO1GDgCI5/iKY7
        LPeT14gSNwRWHjMa22OSJlS/uIoEufdngAkx/LgWEHyzwqsYt0RjAasfJYUE7s4rzfkw=;
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1oleHI-009OZY-DT; Fri, 21 Oct 2022 00:44:40 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 14 Sep 2022 22:13:43 +0200
Subject: [PATCH 2/6] certs: fips test: fix build failure with
 PKCS7_MESSAGE_PARSER=m
In-Reply-To: <S229853AbiJTWkg/20221020224036Z+12888@vger.kernel.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-Id: <S230100AbiJTWpS/20221020224519Z+12903@vger.kernel.org>

ld: crypto/asymmetric_keys/selftest.o: in function `fips_signature_selftest':
selftest.c:(.init.text+0xcd): undefined reference to `pkcs7_parse_message'
ld: selftest.c:(.init.text+0x103): undefined reference to `pkcs7_supply_detached_data'
ld: selftest.c:(.init.text+0x10d): undefined reference to `pkcs7_verify'
ld: selftest.c:(.init.text+0x135): undefined reference to `pkcs7_validate_trust'
ld: selftest.c:(.init.text+0x157): undefined reference to `pkcs7_free_message'

Fixes: 3cde3174eb910513d32a9ec8a9b95ea59be833df
Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 crypto/asymmetric_keys/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 3df3fe4ed95f..fe007db96c69 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -83,6 +83,6 @@ config FIPS_SIGNATURE_SELFTEST
 	  for FIPS.
 	depends on KEYS
 	depends on ASYMMETRIC_KEY_TYPE
-	depends on PKCS7_MESSAGE_PARSER
+	depends on PKCS7_MESSAGE_PARSER=y
 
 endif # ASYMMETRIC_KEY_TYPE
-- 
2.37.2.609.g9ff673ca1a

