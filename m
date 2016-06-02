From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Thu, 02 Jun 2016 14:06:55 +0200
Message-ID: <1580741.tpUX5Z7OKy@tauon.atsec.com>
References: <1664837.3VbqQRUZed@positron.chronox.de> <3243059.jE1At2qco9@tauon.atsec.com> <20160602094211.GA16489@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35708 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbcFBMG7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 08:06:59 -0400
In-Reply-To: <20160602094211.GA16489@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. Juni 2016, 17:42:11 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jun 02, 2016 at 11:31:22AM +0200, Stephan Mueller wrote:
> > The skcipher API, however, wants to encrypt an entire input data stream.
> > That means the skcipher API requires the length of the input data stream
> > to generate an equally sized output data stream. But that is not what we
> > have here -- there is no input data. I.e. the skcipher API invokes the
> > CTR mode for the stream cipher and performs the final XOR of the CTR
> > stream with the input data.
> 
> Just use an input stream of zeros.

I am working on it. During the analysis, I saw, however, that the DRBG 
increments the counter before the encryption whereas the the CTR mode 
increments it after the encryption.

I could of course adjust the handling in the code, but this would be a real 
hack IMHO.

Ciao
Stephan
