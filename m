From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/2] crypto: user - fix empty string test in report API
Date: Sun,  3 Feb 2013 12:09:01 +0100
Message-ID: <1359889741-23335-3-git-send-email-minipli@googlemail.com>
References: <1359889741-23335-1-git-send-email-minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:61584 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3BCLJO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Feb 2013 06:09:14 -0500
Received: by mail-we0-f179.google.com with SMTP id x43so4132474wey.24
        for <linux-crypto@vger.kernel.org>; Sun, 03 Feb 2013 03:09:13 -0800 (PST)
In-Reply-To: <1359889741-23335-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current test for empty strings fails because it is testing the
address of a field, not a pointer. So the test will always be true.
Test for the string length instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index f6d9baf..1b9a9a1 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -196,7 +196,7 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	struct crypto_dump_info info;
 	int err;
 
-	if (!p->cru_driver_name)
+	if (!strlen(p->cru_driver_name))
 		return -EINVAL;
 
 	alg = crypto_alg_match(p, 1);
-- 
1.7.10.4
