Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CDACA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 14:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3260B20700
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 14:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbfJVO3f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 10:29:35 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49051 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbfJVO3f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 10:29:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M4aA4-1iLGzz0HRu-001liB; Tue, 22 Oct 2019 16:29:17 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
Date:   Tue, 22 Oct 2019 16:28:58 +0200
Message-Id: <20191022142914.1803322-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:00l9iabADIFv0wAIPdDsoqreZmhnf5ZQlT3ow6IK35a8pvNICt8
 XVH66v2tQRNqX6ON0AMdv5CU/eW/AltE68a3R3WzliJTlaum9Q2wYfV6Td0gNvLDoproGUf
 y1Yi8OzafJ8edAWmw2mwJbccaUOg/WB99qxKQo+CvDotisUWUwMVOnkpQnTvFFwrKnWkPWz
 qS4lH5QEcfOo0mXYiXrAA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wALEfJkSU58=:Q1pqyhJ7LK+r/v38AXJ3AR
 NCGwe02DvJxpbujy8KHCT7xkrDMXgNhbHpPbSsDP7OzMKmH/fCtp/1VJXDoEvNMTEZ28nJwE5
 hn31CZMhee5FrRmoQHHzgT4XL5I8EywBclsM0D6gUprTjSvrcQboHUbsX6UwHVTOHOr+oLp5m
 SQk9Q7eY6FU9fUaXfY/mon9c9vUCGNzRrNORvS+VAz65QJxYCJk9+C8Nk9B1HdQ9+lWROq5Vv
 vHtI2K7nYV1vGHJZ2ZUeDNMxq4FhFljwx58bnSJkkYqQ62c2pn5SitgWNlMmpOA7zIWHkvbL7
 o0y8xhc3FkrMcFVjlvfBVQOzcWZcg5b3N+ck/e3H3E8dP7Dj3Bj3gSzzfLfDosn/pftERc4Bo
 8c6JppWHpu6u8VLvIzvVbskv1UbiInrv4WfOmT5XDBP8l8a4qEymOKW9emWHHYChIu2StMiSi
 EmCXgYSfyFQXmzqeYesCYNWXFM21VOt5kwwz8+y3YViBXVtVOz27O/vSaOJDaqRi/mTQxvsch
 RHtkfGrhAth85dTMRufU9YwYUCtwgtptTKYUtt0MRtCDCZMFW0EGoczXahATVSwFYDyaCo2SA
 My7H0hKTEBKx8ZNSKYXM2RDPxVgIeWcNOg4avOESo12r0cnRLtBYSIvv72AYE7GpdBew+1E4Z
 M9rFvW1pUm0r8PrM4tO1tNjhZNDaJc/7V+hEzpcKp8BTzurAkRIWVcbkWZB4jBS2jQ9oQ/moU
 iBz/BxsSYpsJCJ1PU/jLRxCeh5mUqLLv76bNly4KhL01tnO1yZ+Ul/kHA5YcT1zua50tfMieP
 N0fHQ1Omw36fowds5aO2roCPx3co4+krap3w0bpf+8bQkxE009Ciibw65Mr4Q9f21C8bd+sFw
 kqSj0lPUFKBsfEVDWYEg==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Without this symbol, the safexcel driver causes a link error:

drivers/crypto/inside-secure/safexcel_hash.o: In function `safexcel_ahash_final':
safexcel_hash.c:(.text+0x3c4): undefined reference to `sm3_zero_message_hash'

Fixes: 0f2bc13181ce ("crypto: inside-secure - Added support for basic SM3 ahash")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 357e230769c8..1ca8d9a15f2a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -753,6 +753,7 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA512
 	select CRYPTO_CHACHA20POLY1305
 	select CRYPTO_SHA3
+	select CRYPTO_SM3
 	help
 	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
 	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
-- 
2.20.0

