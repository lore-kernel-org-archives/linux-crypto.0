From: weiyj_lk@163.com
Subject: [PATCH -next] crypto: algif_rng - fix sparse non static symbol warning
Date: Wed, 14 Jan 2015 09:14:41 +0800
Message-ID: <1421198081-16766-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:58749 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbbANBPQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 20:15:16 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

crypto/algif_rng.c:185:13: warning:
 symbol 'rng_exit' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 crypto/algif_rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 91c06f5..67f612c 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -182,7 +182,7 @@ static int __init rng_init(void)
 	return af_alg_register_type(&algif_type_rng);
 }
 
-void __exit rng_exit(void)
+static void __exit rng_exit(void)
 {
 	int err = af_alg_unregister_type(&algif_type_rng);
 	BUG_ON(err);
