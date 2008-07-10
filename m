From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH] check for s390 crypto facility availablility
Date: Thu, 10 Jul 2008 15:00:43 +0000
Message-ID: <1215702043.12011.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31422 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYGJNBe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 09:01:34 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id m6AD1JF5247734
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2008 13:01:19 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6AD1JNC2850858
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2008 15:01:19 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6AD1JCj016974
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2008 15:01:19 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

here is a small patch for the s390 crypto detection.

[PATCH] respect STFL bit for s390 crypto

From: <jang@linux.vnet.ibm.com>

For all s390 in-kernel crypto algorithms we check at module
load time whether the CPACF facility bit is on. If the facility
is not enabled we bail out.

Signed-off-by: <jang@linux.vnet.ibm.com>

--- ./arch/s390/crypto/crypt_s390.h.stfle
+++ ./arch/s390/crypto/crypt_s390.h
@@ -294,6 +294,10 @@ static inline int crypt_s390_func_availa
 	unsigned char status[16];
 	int ret;
 
+	/* check if CPACF facility (bit 17) is available */
+	if (!(stfl() & 1ULL << (31 - 17)))
+		return 0;
+
 	switch (func & CRYPT_S390_OP_MASK) {
 	case CRYPT_S390_KM:
 		ret = crypt_s390_km(KM_QUERY, &status, NULL, NULL, 0);


