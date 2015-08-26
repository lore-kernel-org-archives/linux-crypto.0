From: Stephan Mueller <smueller@chronox.de>
Subject: akcipher API: plans
Date: Wed, 26 Aug 2015 10:38:24 +0200
Message-ID: <8426933.kyc3qjWJkc@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33762 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbbHZIi1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Aug 2015 04:38:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, Tadeusz,

in various emails, I think I have seen several concerns or change requests 
regarding the akcipher API. As all of those apply to the AF_ALG interface for 
akcipher too (which I try to get straight), I would like to ask for potential 
plans of the discussed areas if there are any. If there is no plan, may I ask 
for a discussion on what would be the best way forward.

Also, considering the conversion of the module signing code to use akcipher, I 
feel, we should get the API sorted out to avoid much transition work in 
"users" of the API as well as cipher implementations.

For the following areas, I saw discussions (if I have overlooked an item, 
please add it):

- Type of input data: currently, the akcipher API uses linear buffers. The 
question was raised to convert it to scatter lists. Linear buffers were seen 
as appropriate as the data to be operated on is usually quite small. However, 
some hardware seems to support scatter lists (CAAM was mentioned). 

- Split of setkey into public/private setkey function. The current 
implementation provides ASN.1 structure that allows setting all three 
components forming a public and private key. However, considering the next 
bullet, a split int pub/priv key may need to be considered.

- Structure of keys: The current ASN.1 structure is used solely in the kernel. 
Thus, DER keys generated in user space (like by OpenSSL) can only be loaded 
after a conversion. To support such DER keys out of the box, I think only the 
ASN.1 definition must be changed. In addition, the setkey function must be 
split as the ASN.1 structures of a DER pub and private key are completely 
different.

Ciao
Stephan
