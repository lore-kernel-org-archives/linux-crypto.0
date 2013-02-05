From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv2 2/3] crypto: user - fix empty string test in report API
Date: Tue,  5 Feb 2013 18:19:14 +0100
Message-ID: <1360084755-11044-3-git-send-email-minipli@googlemail.com>
References: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43402 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3BERTf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 12:19:35 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so208101bkc.10
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2013 09:19:34 -0800 (PST)
In-Reply-To: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current test for empty strings fails because it is testing the
address of a field, not a pointer. So the test will always be true.
Test the first character in the string to not be null instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
v2: - switched to simple character test, as suggested by Herbert Xu

 crypto/crypto_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index f6d9baf..423a267 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -196,7 +196,7 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	struct crypto_dump_info info;
 	int err;
 
-	if (!p->cru_driver_name)
+	if (!p->cru_driver_name[0])
 		return -EINVAL;
 
 	alg = crypto_alg_match(p, 1);
-- 
1.7.10.4
