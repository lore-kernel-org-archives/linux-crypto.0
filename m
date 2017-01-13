From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 11:58:24 +0100
Message-ID: <9279288.fr5DIlfFLr@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <3463059.TVfkfLOfNf@tauon.atsec.com> <20170113102339.GB23349@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55522 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdAMK62 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 05:58:28 -0500
In-Reply-To: <20170113102339.GB23349@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 18:23:39 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 05:37:33PM +0100, Stephan Müller wrote:
> > I would not understand that statement.
> > 
> > With the patch mentioned above that I provided some weeks ago, we have the
> > following scenario for an encryption (in case of decryption, it is almost
> > identical, just the tag location is reversed):
> > 
> > user calls sendmsg with data buffer/IOVEC: AAD || PT
> > 
> > 	-> algif_aead turns this into the src SGL
> > 
> > user calls recvmsg with data buffer/IOVEC: CT || Tag
> > 
> > 	-> algif_aead creates the first SG entry in the dst SGL pointing to the
> > 
> > AAD from the src SGL
> > 
> > 	-> algif_aead appends the user buffers to the dst SGL
> > 	
> > 	-> algif_aead performs its operation and during that operation, only the
> > 
> > CT and Tag parts are changed
> > 
> > I.e. with the pre-pending of the SG pointing to the AAD from the src SGL
> > to
> > the dst SGL we have a clean invocation of the kernel API.
> 
> But that means you can never invoke the in-place path of the kernel
> API, which is the most optimised code path.

May I ask how the in-place code path can be invoked by algif_aead or 
algif_skcipher? As far as I understand, this code path is only invoked when 
the cipher implementation sees that the src and dst SGLs are identical.

However, both algif interfaces maintain separate src and dst SGLs and always 
invoke the cipher operation with these dissimilar SGLs. Thus, I would infer 
that even when the user invokes zerocopy, the src/dst SGLs are not identical 
and therefore the cipher implementations would not use the in-place code path.

Ciao
Stephan
