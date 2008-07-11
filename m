From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH] check for s390 crypto facility availablility
Date: Fri, 11 Jul 2008 18:34:40 +0000
Message-ID: <1215801280.9088.12.camel@localhost.localdomain>
References: <1215702043.12011.6.camel@localhost.localdomain>
	 <20080711122938.GA4140@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:24178 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbYGKQkA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2008 12:40:00 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id m6BGdweU161898
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 16:39:58 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6BGdvfx3203306
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 18:39:57 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6BGdvoQ001041
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 18:39:57 +0200
In-Reply-To: <20080711122938.GA4140@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH] respect STFL bit for s390 crypto

From: <jang@linux.vnet.ibm.com>

Bevore issuing any s390 crypto operation check whether the
CPACF facility is enabled in the facility list. That way a
virtualization layer can prevent usage of the CPACF facility
regardless of the availability of the crypto instructions.

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


