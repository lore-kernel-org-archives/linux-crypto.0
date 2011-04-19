From: jang@linux.vnet.ibm.com
Subject: [PATCH 7/8] tcrypt: disable 384 bit key XTS test
Date: Tue, 19 Apr 2011 21:29:20 +0200
Message-ID: <20110419193250.074519442@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:37845 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DSTeB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:01 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJY0Ej018875
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:34:00 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYuos1839332
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:56 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJY0C5028628
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:34:00 -0600
Content-Disposition: inline; filename=crypto-disable_xts_wrong_key_test.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jan Glauber <jang@linux.vnet.ibm.com>

XTS mode is only defined for 256 and 512 bit key lengths. s390 only
implements these two modes and running the test with a 384 bit key
will stop the speed test with an error. Remove the superfluous key
lenght.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 crypto/tcrypt.c |    4 ++--
 crypto/tcrypt.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1006,9 +1006,9 @@ static int do_test(int m)
 		test_cipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
 		test_cipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
-				speed_template_32_48_64);
+				speed_template_32_64);
 		test_cipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
-				speed_template_32_48_64);
+				speed_template_32_64);
 		break;
 
 	case 201:
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -51,7 +51,7 @@ static u8 speed_template_8_32[] = {8, 32
 static u8 speed_template_16_32[] = {16, 32, 0};
 static u8 speed_template_16_24_32[] = {16, 24, 32, 0};
 static u8 speed_template_32_40_48[] = {32, 40, 48, 0};
-static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
+static u8 speed_template_32_64[] = {32, 64, 0};
 
 /*
  * Digest speed tests

-- 
