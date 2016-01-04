From: Thomas Egerer <hakke_007@gmx.de>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Mon, 4 Jan 2016 21:43:53 +0100
Message-ID: <568AD989.8060802@gmx.de>
References: <568AC07B.8020605@gmx.de> <4445865.9O5pIU29W2@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63374 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbcADUnZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jan 2016 15:43:25 -0500
In-Reply-To: <4445865.9O5pIU29W2@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Similar to CTR mode selecting CRYPTO_SEQIV, CBC mode requires echainiv
and has to select CRYPTO_ECHAINIV in order to work properly. This solves
the issues caused by a misconfiguration as described in [1].

[1] https://lists.strongswan.org/pipermail/users/2015-December/009074.html

Signed-off-by: Thomas Egerer <hakke_007@gmx.de>
---
crypto/Kconfig | 1 +
1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7240821..893d93f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -284,6 +284,7 @@ comment "Block modes"
config CRYPTO_CBC
tristate "CBC support"
select CRYPTO_BLKCIPHER
+ select CRYPTO_ECHAINIV
select CRYPTO_MANAGER
help
CBC: Cipher Block Chaining mode
-- 
2.6.4
