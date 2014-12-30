From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Date: Tue, 30 Dec 2014 22:03:33 +0100
Message-ID: <2836726.omC5yx5ZyR@tachyon.chronox.de>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de> <29582980.qoHS2EjmLy@tachyon.chronox.de> <20141229173340.GA15790@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Daniel Borkmann <dborkman@redhat.com>,
	'Quentin Gouchet' <quentin.gouchet@gmail.com>,
	'LKML' <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51094 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaL3VDx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Dec 2014 16:03:53 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SDE24> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 30 Dec 2014 22:03:33 +0100
In-Reply-To: <20141229173340.GA15790@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 30. Dezember 2014, 04:33:41 schrieb Herbert Xu:

Hi Herbert,

> 
> > > PS we should add a length check for missing/partial auth tags
> > > to crypto_aead_decrypt.  We can then remove such checks from
> > > individual implementations.
> > 
> > I agree in full here. Shall I create such a patch together with the AEAD
> > AF_ALG interface, or can we merge the AEAD without that patch now and
> > create a separate patch later?
> 
> We should at least add a check in crypto_aead_decrypt first so as
> to guarantee nothing slips through.

I have prepared a patch for this which I will release shortly. IMHO that patch 
should not have any significant performance penalty. I will also remove the 
respective check from the algif_aead implementation.

In addition, I would suggest to add a similar check for the encryption 
operation to verify that the ciphertext buffer is at least as large as the 
blocks needed for plaintext plus the memory needed for the auth tag (note, my 
first attempts working with AEAD lead to days of debugging of kernel crashers 
as I did not understand I had too little memory allocated for the ciphertext 
buffer). However, such check needs to traverse all plaintext scatterlist 
entries which may have a noticeable performance hit.

Do you see the need for such check? If yes, do you see a way to avoid 
traversing all plaintext scatterlist entries?

Thanks
-- 
Ciao
Stephan
