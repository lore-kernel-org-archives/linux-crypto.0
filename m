From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC] crypto: testmgr - Document struct cipher_testvec
Date: Fri, 5 Jun 2015 11:39:22 +0200
Message-ID: <20150605093922.GA16806@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38616 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbFEJj3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2015 05:39:29 -0400
Received: by wibdq8 with SMTP id dq8so12873628wib.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jun 2015 02:39:28 -0700 (PDT)
Received: from Red ([2a01:240:fe00:142::2])
        by mx.google.com with ESMTPSA id ef10sm9738818wjd.49.2015.06.05.02.39.26
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2015 02:39:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello                                                                           
                                                                                
I was adding a test to testmgr for cbc(aes) but I hesitate on the cipher_testvec parameter also_non_np.
                                                                                
Since its functions is not trivial, I propose a patch for documenting the struture.
                                                                                
So does I have well understand the purpose of also_non_np ?                      
And if yes what it is the interest of doing a test twice (one with and one without SG splitting) ?
                                                                                
Regards

>From 0156e32be7dd7ffd0a4fdad8d0a3eaf3c0bf92c7 Mon Sep 17 00:00:00 2001
From: LABBE Corentin <clabbe.montjoie@gmail.com>
Date: Wed, 3 Jun 2015 09:09:13 +0200
Subject: [PATCH 02/11] crypto: testmgr - Document struct cipher_testvec

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/testmgr.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 8a31e9a..ab2019e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -46,6 +46,24 @@ struct hash_testvec {
 	unsigned char ksize;
 };
 
+/*
+ * cipher_testvec:	structure to describe a cipher test
+ * @key:	A pointer to a key used by the test
+ * @klen:	The length of @key
+ * @iv:		A pointer to the IV used by the test
+ * @input:	A pointer to data used as input
+ * @ilen	The length of data in @input
+ * @result:	A pointer to what the test need to produce
+ * @rlen:	The length of data in @result
+ * @fail:	If set to one, the test need to fail
+ * @wk:		Does the test need CRYPTO_TFM_REQ_WEAK_KEY
+ * 		( e.g. test needs to fail due to a weak key )
+ * @np: 	numbers of SG to distribute data in (from 1 to MAX_TAP)
+ * @tap:	How to distribute data in @np SGs
+ * @also_non_np: 	if set to 1, the test will be also done without
+ * 			splitting data in @np SGs
+ */
+
 struct cipher_testvec {
 	char *key;
 	char *iv;
-- 
2.3.6
