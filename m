From: Stephan Mueller <smueller@chronox.de>
Subject: module ref count
Date: Tue, 21 Apr 2015 14:35:47 +0200
Message-ID: <1513971.JRWYZvf2T6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34228 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbbDUMfw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 08:35:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I am currently working on the template for SP800-38F key wrapping. The module 
is operational and calculates what I want.

However, I have one problem I am having difficulties to track down and I am 
wondering whether you could point me to the right direction.

When a caller calls

	crypto_alloc_aead("kw(aes)", 0, 0);

somehow the refcount of the kernel module implementing the keywrapping is not 
increased. Once can see that in lsmod where the "Used by" value remains 0.

Then when the caller deallocates the cipher handle, the refcount is -1 
according to lsmod. With that, a second invocation of crypto_alloc_aead will 
fail and I even cannot remove the module from the kernel.

Who increases the refcount on the kernel crypto API side?

Thanks a lot

-- 
Ciao
Stephan
