From: "Mcloughlin, Conor" <conor.mcloughlin@intel.com>
Subject: [PATCH] crypto: Fix incorrect values in PKCS#1 test vector
Date: Tue, 13 Feb 2018 08:29:56 +0000
Message-ID: <CE2E46B8F68C4948A08D2E78E3D946C152762D35@IRSMSX104.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63322 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933584AbeBMIaA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:00 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The RSA private key for the first form should have
version, prime1, prime2, exponent1, exponent2, coefficient
values 0.
With non-zero values for prime1,2, exponent 1,2 and coefficient
the Intel QAT driver will assume that values are provided for the
private key second form. This will result in signature verification
failures for modules where QAT device is present and the modules
are signed with rsa,sha256.

Cc: <stable@vger.kernel.org>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
---
 crypto/testmgr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6044f69..69fb51e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -548,7 +548,7 @@ struct kpp_testvec {
 static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
 	{
 	.key =
-	"\x30\x82\x03\x1f\x02\x01\x10\x02\x82\x01\x01\x00\xd7\x1e\x77\x82"
+	"\x30\x82\x03\x1f\x02\x01\x00\x02\x82\x01\x01\x00\xd7\x1e\x77\x82"
 	"\x8c\x92\x31\xe7\x69\x02\xa2\xd5\x5c\x78\xde\xa2\x0c\x8f\xfe\x28"
 	"\x59\x31\xdf\x40\x9c\x60\x61\x06\xb9\x2f\x62\x40\x80\x76\xcb\x67"
 	"\x4a\xb5\x59\x56\x69\x17\x07\xfa\xf9\x4c\xbd\x6c\x37\x7a\x46\x7d"
@@ -597,8 +597,8 @@ struct kpp_testvec {
 	"\xfe\xf8\x27\x1b\xd6\x55\x60\x5e\x48\xb7\x6d\x9a\xa8\x37\xf9\x7a"
 	"\xde\x1b\xcd\x5d\x1a\x30\xd4\xe9\x9e\x5b\x3c\x15\xf8\x9c\x1f\xda"
 	"\xd1\x86\x48\x55\xce\x83\xee\x8e\x51\xc7\xde\x32\x12\x47\x7d\x46"
-	"\xb8\x35\xdf\x41\x02\x01\x30\x02\x01\x30\x02\x01\x30\x02\x01\x30"
-	"\x02\x01\x30",
+	"\xb8\x35\xdf\x41\x02\x01\x00\x02\x01\x00\x02\x01\x00\x02\x01\x00"
+	"\x02\x01\x00",
 	.key_len = 804,
 	/*
 	 * m is SHA256 hash of following message:
-- 
1.9.1


--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.
