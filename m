From: Stephan Mueller <smueller@chronox.de>
Subject: akcipher: continuous memory for input/output
Date: Wed, 08 Jul 2015 17:27:15 +0200
Message-ID: <4018710.nx8zEmrfD4@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47921 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933653AbbGHP1V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 11:27:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, Tadeusz,

I looked a bit further into the akcipher code to see how we can add an AF_ALG 
there.

What currently wonders me is the akcipher_request_set_crypt function: the 
memory for input/output buffers is *no* scatter list but a plain buffer. I 
think I can understand that for raw RSA operations as the input/output is not 
overly large.

But according to Tadeusz it may be viable to register hybrid asym ciphers with 
the akcipher API. If there is a full blown hybrid asym cipher we have to 
handle potentially large chunks of data. I am now wondering whether a flat 
buffer still makes sense or whether the akcipher should be converted to 
scatter lists as all the other cipher types.

If it shall stay as is, how would we be handling larger buffers?

Thanks
Stephan
