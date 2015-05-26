From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: echainiv - Add encrypted chain IV generator
Date: Tue, 26 May 2015 12:36:45 +0300
Message-ID: <20150526093645.GA2233@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:46693 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbbEZOOl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 10:14:41 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t4Q9c0jw018671
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2015 09:38:01 GMT
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert Xu,

The patch a10f554fa7e0: "crypto: echainiv - Add encrypted chain IV
generator" from May 21, 2015, leads to the following static checker
warning:

	crypto/echainiv.c:492 echainiv_alloc()
	warn: 'inst' isn't an ERR_PTR

crypto/echainiv.c
   435  static struct crypto_instance *echainiv_aead_alloc(struct rtattr **tb)
   436  {
   437          struct aead_instance *inst;
   438          struct crypto_aead_spawn *spawn;
   439          struct aead_alg *alg;
   440  
   441          inst = aead_geniv_alloc(&echainiv_tmpl, tb, 0, 0);
   442  
   443          if (IS_ERR(inst))
   444                  goto out;
   445  
   446          if (inst->alg.ivsize < sizeof(u64) ||
   447              inst->alg.ivsize & (sizeof(u32) - 1) ||
   448              inst->alg.ivsize > MAX_IV_SIZE) {
   449                  aead_geniv_free(inst);
   450                  inst = ERR_PTR(-EINVAL);
   451                  goto out;
                        ^^^^^^^^
Goto out here means return the container_of() an error pointer.  This
is a class of bugs called a "one err bug" because all the error paths
go to the same error label.

   452          }
   453  

regards,
dan carpenter
