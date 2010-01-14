From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: vmac test fails on s390
Date: Thu, 14 Jan 2010 15:05:30 +0100
Message-ID: <1263477930.5880.22.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:52526 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab0ANOFp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jan 2010 09:05:45 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id o0EE5iOk022134
	for <linux-crypto@vger.kernel.org>; Thu, 14 Jan 2010 14:05:44 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0EE5iWC1548380
	for <linux-crypto@vger.kernel.org>; Thu, 14 Jan 2010 15:05:44 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o0EE5ixG015842
	for <linux-crypto@vger.kernel.org>; Thu, 14 Jan 2010 15:05:44 +0100
Received: from [9.152.212.26] (dyn-9-152-212-26.boeblingen.de.ibm.com [9.152.212.26])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id o0EE5iCG015835
	for <linux-crypto@vger.kernel.org>; Thu, 14 Jan 2010 15:05:44 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Jan 14 14:47:38 h42lp52 kernel: alg: hash: Test 1 failed for vmac(aes-s390)
Jan 14 14:47:38 h42lp52 kernel: 00000000: e7 79 33 b7 fd 8a d7 cb

Looking at the digest from the failing test vector:

.digest = "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",

the output looks somehow familiar... Maybe a missing endian conversion?
The patch fixes the test for me but it is just a wild guess and maybe
it should be done at another place?

Jan

diff --git a/crypto/vmac.c b/crypto/vmac.c
index 0a9468e..0e23dfb 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -359,7 +359,7 @@ static u64 l3hash(u64 p1, u64 p2,
 	rl += t;
 	rl += (0 - (rl < t)) & 257;
 	rl += (0 - (rl > p64-1)) & 257;
-	return rl;
+	return le64_to_cpup(&rl);
 }
 
 static void vhash_update(const unsigned char *m,


