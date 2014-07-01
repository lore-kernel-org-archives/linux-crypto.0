From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 4/4] DRBG: HMAC-SHA1 DRBG has crypto strength of 128 bits
Date: Tue, 01 Jul 2014 17:09:23 +0200
Message-ID: <3541308.zCk9jgdY1p@myon.chronox.de>
References: <36957559.tbJt1gJF6I@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
	Fengguang Wu <fengguang.wu@intel.com>,
	Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
	Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:52679 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaGAPLU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 11:11:20 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S22E> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 1 Jul 2014 17:09:52 +0200
In-Reply-To: <36957559.tbJt1gJF6I@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch corrects the security strength of the HMAC-SHA1 DRBG to 128
bits. This strength defines the size of the seed required for the DRBG.
Thus, the patch lowers the seeding requirement from 256 bits to 128 bits
for HMAC-SHA1.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index c2f02b7..e6c52e0 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -195,7 +195,7 @@ static const struct drbg_core drbg_cores[] = {
 #endif /* CONFIG_CRYPTO_DRBG_HASH */
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
 	{
-		.flags = DRBG_HMAC | DRBG_STRENGTH256,
+		.flags = DRBG_HMAC | DRBG_STRENGTH128,
 		.statelen = 20, /* block length of cipher */
 		.max_addtllen = 35,
 		.max_bits = 19,
-- 
1.9.3
