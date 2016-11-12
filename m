From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for output
Date: Sat, 12 Nov 2016 03:12:20 +0100
Message-ID: <2741000.3U1U7JnSRh@positron.chronox.de>
References: <3302668.EORF2jai5r@positron.chronox.de> <3506033.FskOdlTquT@positron.chronox.de> <alpine.OSX.2.20.1611111622500.1815@mjmartin-mac01.sea.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50892 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935315AbcKLCMZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 21:12:25 -0500
In-Reply-To: <alpine.OSX.2.20.1611111622500.1815@mjmartin-mac01.sea.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 11. November 2016, 16:26:12 CET schrieb Mat Martineau:

Hi Mat,
> > 
> > With this solution, the caller must not use sendpage with the exact same
> > buffers for input and output. The following rationale applies: When
> > the caller sends the same buffer for input/output to the sendpage
> > operation, the cipher operation now will write the ciphertext to the
> > beginning of the buffer where the AAD used to be. The subsequent tag
> > calculation will now use the data it finds where the AAD is expected.
> > As the cipher operation has already replaced the AAD with the ciphertext,
> > the tag calculation will take the ciphertext as AAD and thus calculate
> > a wrong tag.
> 
> If it's not much overhead, I suggest checking for this condition and
> returning an error.

I can surely look into that. But Herbert's NACK seems to make this patch 
unlikely.
> 
> Other than that, I've done a quick test of the patches using sendmsg() and
> read() and found that they work as expected.
> 
Thanks for testing.

Ciao
Stephan
