From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Tue, 27 Oct 2015 13:54:30 +0900
Message-ID: <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE@holtmann.org>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60335 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbJ0Eyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Oct 2015 00:54:41 -0400
In-Reply-To: <1831785.BBs8Hj3CxY@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> This patch set adds the AF_ALG user space API to externalize the
> asymmetric cipher API recently added to the kernel crypto API.
> 
> The patch set is tested with the user space library of libkcapi [1].
> Use [1] test/test.sh for a full test run. The test covers the
> following scenarios:
> 
> 	* sendmsg of one IOVEC
> 
> 	* sendmsg of 16 IOVECs with non-linear buffer
> 
> 	* vmsplice of one IOVEC
> 
> 	* vmsplice of 15 IOVECs with non-linear buffer
> 
> 	* invoking multiple separate cipher operations with one
> 	  open cipher handle
> 
> 	* encryption with private key (using vector from testmgr.h)
> 
> 	* encryption with public key (using vector from testmgr.h)
> 
> 	* decryption with private key (using vector from testmgr.h)

after having discussions with David Howells and David Woodhouse, I don't think we should expose akcipher via AF_ALG at all. I think the akcipher operations for sign/verify/encrypt/decrypt should operate on asymmetric keys in the first place. With akcipher you are pretty much bound to public and private keys and the key is the important part and not the akcipher itself. Especially since we want to support private keys in hardware (like TPM for example).

It seems more appropriate to use keyctl to derive the symmetric session key from your asymmetric key. And then use the symmetric session key id with skcipher via AF_ALG. Especially once symmetric key type has been introduced this seems to be trivial then.

I am not really in favor of having two userspace facing APIs for asymmetric cipher usage. And we need to have an API that is capable to work with hardware keys.

Regards

Marcel
