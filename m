From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] X.509: remove always false comparison
Date: Thu, 17 Sep 2015 13:12:51 +0530
Message-ID: <1442475771-15570-1-git-send-email-sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33629 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbIQHnP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2015 03:43:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

hour, min and sec are unsigned int and they can never be less than zero.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index af71878..3000ea3 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -546,9 +546,9 @@ int x509_decode_time(time64_t *_t,  size_t hdrlen,
 	if (year < 1970 ||
 	    mon < 1 || mon > 12 ||
 	    day < 1 || day > mon_len ||
-	    hour < 0 || hour > 23 ||
-	    min < 0 || min > 59 ||
-	    sec < 0 || sec > 59)
+	    hour > 23 ||
+	    min > 59 ||
+	    sec > 59)
 		goto invalid_time;
 	
 	*_t = mktime64(year, mon, day, hour, min, sec);
-- 
1.9.1
