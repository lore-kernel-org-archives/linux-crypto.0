From: jang@linux.vnet.ibm.com
Subject: [PATCH 8/8] tcrypt: CTR mode speed test for AES
Date: Tue, 19 Apr 2011 21:29:21 +0200
Message-ID: <20110419193250.633841713@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:53585 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1DSTeG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:06 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJY11i022069
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:34:01 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYvHN1671184
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:57 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJY08G028645
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:34:00 -0600
Content-Disposition: inline; filename=crypto-aes_ctr_speed_test.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jan Glauber <jang@linux.vnet.ibm.com>

Add the CTR mode speed test for AES.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 crypto/tcrypt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1009,6 +1009,10 @@ static int do_test(int m)
 				speed_template_32_64);
 		test_cipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_32_64);
+		test_cipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_cipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
 		break;
 
 	case 201:

-- 
