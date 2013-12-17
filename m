From: karl@hiramoto.org
Subject: [PATCH] tcrypt:  add hash speed tests for hmac().
Date: Tue, 17 Dec 2013 11:51:46 +0100
Message-ID: <1387277506-25907-1-git-send-email-karl@hiramoto.org>
Cc: karl@hiramoto.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:60050 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQK42 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Dec 2013 05:56:28 -0500
Received: from homiemail-a109.g.dreamhost.com (mailbigip.dreamhost.com [208.97.132.5])
	by hapkido.dreamhost.com (Postfix) with ESMTP id E0843DC3B0
	for <linux-crypto@vger.kernel.org>; Tue, 17 Dec 2013 02:56:26 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 crypto/tcrypt.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 001f07c..fb57ad7 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1510,6 +1510,37 @@ static int do_test(int m)
 		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 319:
+		test_hash_speed("hmac(md5)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+	case 320:
+		test_hash_speed("hmac(sha1)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+
+	case 321:
+		test_hash_speed("hmac(sha256)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+
+	case 322:
+		test_hash_speed("hmac(sha384)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+	case 323:
+		test_hash_speed("hmac(sha512)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+	case 324:
+		test_hash_speed("hmac(sha224)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+
+	case 325:
+		test_hash_speed("hmac(rmd128)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+	case 326:
+		test_hash_speed("hmac(rmd160)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+	case 327:
+		test_hash_speed("hmac(crc32)", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
-- 
1.8.3.2
