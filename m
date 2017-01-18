From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCH] crypto: tcrypt - Add mode to test specified algs
Date: Wed, 18 Jan 2017 17:25:00 +0100
Message-ID: <1484756700-10019-1-git-send-email-rabin.vincent@axis.com>
Cc: linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:54576 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbdARQZH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 11:25:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rabin Vincent <rabinv@axis.com>

tcrypt offers a bunch of mode= values to test various (groups of)
algorithms, but there is no way provided to test a subset of the
algorithms.  This adds a new mode=2000 which interprets alg= as a
colon-separated list of algorithms to test with alg_test().  Colon is
used since the names may contain commas.

This is useful during driver development and also for regression testing
to avoid the errors that are otherwise generated when attempting to test
non-enabled algorithms.

 # insmod tcrypt.ko dyndbg mode=2000 alg="cbc(aes):ecb(aes):hmac(sha256):sha256:xts(aes)"
 [  649.418569] tcrypt: testing cbc(aes)
 [  649.420809] tcrypt: testing ecb(aes)
 [  649.422627] tcrypt: testing hmac(sha256)
 [  649.424861] tcrypt: testing sha256
 [  649.426368] tcrypt: testing xts(aes)
 [  649.430014] tcrypt: all tests passed

Signed-off-by: Rabin Vincent <rabinv@axis.com>
---
 crypto/tcrypt.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9a11f3c..fe5adf6 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1021,7 +1021,7 @@ static inline int tcrypt_test(const char *alg)
 	return ret;
 }
 
-static int do_test(const char *alg, u32 type, u32 mask, int m)
+static int do_test(char *alg, u32 type, u32 mask, int m)
 {
 	int i;
 	int ret = 0;
@@ -2042,6 +2042,17 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 	case 1000:
 		test_available();
 		break;
+
+	case 2000:
+		while (alg) {
+			char *tmp = strsep(&alg, ":");
+
+			if (!tmp || !*tmp)
+				break;
+
+			ret += tcrypt_test(tmp);
+		}
+		break;
 	}
 
 	return ret;
-- 
2.1.4
