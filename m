From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 3/5] KEYS: DH: don't feed uninitialized result memory into KDF
Date: Thu, 20 Apr 2017 20:38:30 +0200
Message-ID: <2707352.sSpDZZo8GT@tauon.chronox.de>
References: <20170420054633.14572-1-ebiggers3@gmail.com> <2035658.QVN4rZd2FW@positron.chronox.de> <20170420174602.GA103004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59064 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941209AbdDTSie (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 14:38:34 -0400
In-Reply-To: <20170420174602.GA103004@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 20. April 2017, 19:46:02 CEST schrieb Eric Biggers:

Hi Eric,

> Hi Stephan,
> 
> On Thu, Apr 20, 2017 at 03:27:17PM +0200, Stephan Müller wrote:
> > Am Donnerstag, 20. April 2017, 07:46:31 CEST schrieb Eric Biggers:
> > 
> > Hi Eric,
> > 
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > The result of the Diffie-Hellman computation may be shorter than the
> > > input prime number.  Only calculate the KDF over the actual result;
> > > don't include additional uninitialized memory.
> > 
> > Thank you for catching that (and all the rest). But I think this patch is
> > not correct. If the DH operation results in a shorter value, the trailing
> > part must be set to null and the KDF calculated over the entire prime
> > length.
> > 
> > Thus, if the DH result is shorter than the prime, the memory should look
> > like DH result || 0x00 <as often as needed to make it prime length> ||
> > otherinfo.
> > 
> > Thus, instead of this patch, I would think that the kmalloc call should be
> > changed to a kzalloc.
> 
> Is this in the standard? 

That is the gotcha that is not explicitly written in the standard. However, 
based on my experience with other implementations and tests like ECDSA and RSA 
CAVS testing, the standards seem to always interpreted to use the full allowed 
length. If the mathematical result is shorter than the defined length, it 
should be zero-padded.

> And is it the user-specified length of the prime
> number, or the length after stripping leading zeroes?

It should be the length of the prime used for the DH operation. As the prime 
is given with the DH parameters, the DH parameter set defines the length of 
the prime.

I cannot say about the stripping of leading zeros of user-provided primes 
because I have no idea where that is defined.

I would need to do some further research on this matter and check with the 
authors of the standard.

> Also, note that the
> numbers are being represented in big endian format; is that required, or
> just coincidental?  With big endian numbers leading zeroes go at the
> beginning, not the end, otherwise their value will be changed...

The numbers are MPI and are therefore big endian formats. Also the counter in 
the KDF is a big endian format which is mandated in the spec.

You are right that the zeros go to the beginning of the number and I made a 
wrong statement in my initial remark regarding the zero value.
> 
> - Ericinning and my initial remark regarding where the zeros are is wrong. 
Yet, IMHO we should not stip the zeros before applying the KDF as this would 
imply that the KDF result is different.
> 
> By the way: do we really need this in the kernel at all, given that it's
> just doing some math on data which userspace has access to?

It is the question about how we want the keys subsystem to operate. The DH 
shared secret shall not be used as a key. But the DH operation is part of the 
key subsystem. If there is never a case where the result of the DH operation 
is used in the kernel, then the KDF can be removed and my patches could be 
reverted. However, in this case, the entire DH business could be questioned as 
this can easily be done in user space as well.

Ciao
Stephan
