From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 3/5] KEYS: DH: don't feed uninitialized result memory
 into KDF
Date: Thu, 20 Apr 2017 10:46:02 -0700
Message-ID: <20170420174602.GA103004@gmail.com>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
 <20170420054633.14572-4-ebiggers3@gmail.com>
 <2035658.QVN4rZd2FW@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36120 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032248AbdDTRqK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 13:46:10 -0400
Content-Disposition: inline
In-Reply-To: <2035658.QVN4rZd2FW@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Thu, Apr 20, 2017 at 03:27:17PM +0200, Stephan Müller wrote:
> Am Donnerstag, 20. April 2017, 07:46:31 CEST schrieb Eric Biggers:
> 
> Hi Eric,
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The result of the Diffie-Hellman computation may be shorter than the
> > input prime number.  Only calculate the KDF over the actual result;
> > don't include additional uninitialized memory.
> 
> Thank you for catching that (and all the rest). But I think this patch is not 
> correct. If the DH operation results in a shorter value, the trailing part 
> must be set to null and the KDF calculated over the entire prime length.
> 
> Thus, if the DH result is shorter than the prime, the memory should look like 
> DH result || 0x00 <as often as needed to make it prime length> || otherinfo.
> 
> Thus, instead of this patch, I would think that the kmalloc call should be 
> changed to a kzalloc.
> > 

Is this in the standard?  And is it the user-specified length of the prime
number, or the length after stripping leading zeroes?  Also, note that the
numbers are being represented in big endian format; is that required, or just
coincidental?  With big endian numbers leading zeroes go at the beginning, not
the end, otherwise their value will be changed...

By the way: do we really need this in the kernel at all, given that it's just
doing some math on data which userspace has access to?

- Eric
