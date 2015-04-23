From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 6/6] crypto: add jitterentropy RNG
Date: Thu, 23 Apr 2015 16:08:14 +0200
Message-ID: <3179693.vMYTrm5f8Q@myon.chronox.de>
References: <5054521.el7mZro33c@myon.chronox.de> <5676005.EdpjbaV0S3@myon.chronox.de> <1429797908.2927.5.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34295 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167AbbDWOIV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 10:08:21 -0400
In-Reply-To: <1429797908.2927.5.camel@x220>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. April 2015, 16:05:08 schrieb Paul Bolle:

Hi Paul,

> A nit only, I'm afraid: this patch adds a license mismatch.
> 
> On Wed, 2015-04-22 at 21:25 +0200, Stephan Mueller wrote:
> > --- /dev/null
> > +++ b/crypto/jitterentropy.c
> > 
> > + * License
> > + * =======
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions
> > + * are met:
> > + * 1. Redistributions of source code must retain the above copyright
> > + *    notice, and the entire permission notice in its entirety,
> > + *    including the disclaimer of warranties.
> > + * 2. Redistributions in binary form must reproduce the above copyright
> > + *    notice, this list of conditions and the following disclaimer in the
> > + *    documentation and/or other materials provided with the
> > distribution.
> > + * 3. The name of the author may not be used to endorse or promote
> > + *    products derived from this software without specific prior
> > + *    written permission.
> > + *
> > + * ALTERNATIVELY, this product may be distributed under the terms of
> > + * the GNU General Public License, in which case the provisions of the
> > GPL2 are + * required INSTEAD OF the above restrictions.  (This clause is
> > + * necessary due to a potential bad interaction between the GPL and
> > + * the restrictions contained in a BSD-style copyright.)
> > + *
> > + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
> > + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
> > + * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
> > + * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
> > + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
> > + * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> > + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> > + * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
> > + * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
> > + * DAMAGE.
> > + */
> 
> This states the license is BSD or GPL v2.
> 
> > +MODULE_LICENSE("GPL");
> 
> And, according to inlude/linux/module.h, using
>     MODULE_LICENSE("Dual BSD/GPL");
> 
> here would match that statement.
> 
Thanks for the hint. Other patches that are in the kernel that I wrote (e.g. 
the crypto/drbg.c) have the same license as above, but use 
MODULE_LICENSE("GPL") -- Thus I would think that leaving it as is should be 
ok.

> 
> Paul Bolle


-- 
Ciao
Stephan
