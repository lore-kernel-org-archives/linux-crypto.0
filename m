From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [CRYPTO] blkcipher: Add IV generation
Date: Tue, 2 Oct 2007 00:56:16 -0500
Message-ID: <200710020556.l925uG73011608@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59000 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXJBGAW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Oct 2007 02:00:22 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9260LUU030492
	for <linux-crypto@vger.kernel.org>; Tue, 2 Oct 2007 02:00:21 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9260LGS456562
	for <linux-crypto@vger.kernel.org>; Tue, 2 Oct 2007 00:00:21 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9260Ele030690
	for <linux-crypto@vger.kernel.org>; Tue, 2 Oct 2007 00:00:18 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 {
@@ -434,8 +450,16 @@ static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
 	crt->setkey = async_setkey;
 	crt->encrypt = async_encrypt;
 	crt->decrypt = async_decrypt;
+	crt->geniv = async_geniv;
 	crt->ivsize = alg->ivsize;
 
+	if (!alg->geniv) {
+		if (alg->ivsize)
+			return -EINVAL;
+
+		crt->geniv = async_nogeniv;
+	}
+
 	return 0;
 }
 
@@ -449,6 +473,14 @@ static int crypto_init_blkcipher_ops_sync(struct crypto_tfm *tfm)
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	crt->geniv = alg->geniv;
+
+	if (!alg->geniv) {
+		if (alg->ivsize)
+			return -EINVAL;
+
+		crt->geniv = nogeniv;
+	}

So, I am thinking CTR and some of the other modes,
other than CBC, that use an IV will fail with this 
change since they currently don't have an alg->geniv... 
should they have a geniv similar to that of CBC, which 
is gotten randomly?
 
Regards,
Joy
