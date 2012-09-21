From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: tcrypt - add missing tests for camellia and ghash
Date: Fri, 21 Sep 2012 10:27:10 +0300
Message-ID: <20120921072710.11930.17414.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:41422 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2IUH1M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2012 03:27:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add missing tests for ctr(camellia), lrw(camellia), xts(camellia) and ghash,
as these have test vectors available.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 871076b..6e8874b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1118,6 +1118,9 @@ static int do_test(int m)
 	case 32:
 		ret += tcrypt_test("ecb(camellia)");
 		ret += tcrypt_test("cbc(camellia)");
+		ret += tcrypt_test("ctr(camellia)");
+		ret += tcrypt_test("lrw(camellia)");
+		ret += tcrypt_test("xts(camellia)");
 		break;
 	case 33:
 		ret += tcrypt_test("sha224");
@@ -1171,6 +1174,10 @@ static int do_test(int m)
 		ret += tcrypt_test("rfc4309(ccm(aes))");
 		break;
 
+	case 46:
+		ret += tcrypt_test("ghash");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
