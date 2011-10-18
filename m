From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 17/18] crypto: tcrypt: add xts(twofish) tests
Date: Tue, 18 Oct 2011 13:33:38 +0300
Message-ID: <20111018103338.3074.11437.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43613 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKdk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:40 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a664595..7736a9f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -991,6 +991,7 @@ static int do_test(int m)
 		ret += tcrypt_test("cbc(twofish)");
 		ret += tcrypt_test("ctr(twofish)");
 		ret += tcrypt_test("lrw(twofish)");
+		ret += tcrypt_test("xts(twofish)");
 		break;
 
 	case 9:
@@ -1255,6 +1256,10 @@ static int do_test(int m)
 				speed_template_32_40_48);
 		test_cipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
+		test_cipher_speed("xts(twofish)", ENCRYPT, sec, NULL, 0,
+				speed_template_32_48_64);
+		test_cipher_speed("xts(twofish)", DECRYPT, sec, NULL, 0,
+				speed_template_32_48_64);
 		break;
 
 	case 203:
