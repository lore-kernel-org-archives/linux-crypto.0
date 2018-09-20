From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 3/3] crypto: tcrypt: add OFB functional tests
Date: Thu, 20 Sep 2018 14:18:40 +0100
Message-ID: <1537449521-16182-4-git-send-email-gilad@benyossef.com>
References: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
Cc: ofir.drang@arm.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We already have OFB test vectors and tcrypt OFB speed tests.
Add OFB functional tests to tcrypt as well.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e56c3e1..e64f1df 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1733,6 +1733,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("xts(aes)");
 		ret += tcrypt_test("ctr(aes)");
 		ret += tcrypt_test("rfc3686(ctr(aes))");
+		ret += tcrypt_test("ofb(aes)");
 		break;
 
 	case 11:
-- 
2.7.4
