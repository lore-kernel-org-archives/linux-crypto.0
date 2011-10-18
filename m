From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 09/18] crypto: tcrypt: add lrw(twofish) tests
Date: Tue, 18 Oct 2011 13:32:56 +0300
Message-ID: <20111018103255.3074.98253.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43461 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKdA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:00 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9a9e170..0120383 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -990,6 +990,7 @@ static int do_test(int m)
 		ret += tcrypt_test("ecb(twofish)");
 		ret += tcrypt_test("cbc(twofish)");
 		ret += tcrypt_test("ctr(twofish)");
+		ret += tcrypt_test("lrw(twofish)");
 		break;
 
 	case 9:
@@ -1249,6 +1250,10 @@ static int do_test(int m)
 				speed_template_16_24_32);
 		test_cipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
+		test_cipher_speed("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+				speed_template_32_40_48);
+		test_cipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
+				speed_template_32_40_48);
 		break;
 
 	case 203:
